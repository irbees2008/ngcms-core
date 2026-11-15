<?php
/**
 * NGPDO Enhanced Version - SQLite and MySQL Support
 * This is a reference implementation showing how to modify NGPDO.class.php
 * to support both MySQL and SQLite databases
 * 
 * Key modifications:
 * 1. Added dbtype parameter to determine database type
 * 2. Dynamic DSN creation based on database type
 * 3. Conditional initialization based on database driver
 * 4. Unified query method for both databases
 */

class NGPDO_ENHANCED
{
    protected $db = null;
    protected $qCount = 0;
    protected $qList = [];
    protected $softErrors = false;
    protected $errorSecurity = 0;
    protected $eventLogger = null;
    protected $errorHandler = null;
    protected $dbCharset = 'utf8mb4';
    protected $dbType = 'mysql'; // 'mysql' or 'sqlite'
    protected $connectionParams = [];
    protected $reconnectAttempts = 0;
    protected $maxReconnectAttempts = 3;
    protected $queryLoggingEnabled = true;

    public function __construct(array $params)
    {
        // Save connection params for potential reconnection
        $this->connectionParams = $params;

        // Determine database type
        $this->dbType = isset($params['dbtype']) ? strtolower($params['dbtype']) : 'mysql';

        // Init common params
        if (isset($params['softErrors'])) {
            $this->softErrors = $params['softErrors'];
        }
        if (isset($params['errorSecurity'])) {
            $this->errorSecurity = $params['errorSecurity'];
        }

        // For SQLite, dbpath is required; for MySQL, host, user, pass are required
        if ($this->dbType === 'sqlite') {
            if (!isset($params['dbpath'])) {
                throw new Exception('NG_PDO (SQLite): dbpath parameter is required');
            }
        } else {
            if (!isset($params['user'])) {
                throw new Exception('NG_PDO: User is not specified');
            }
            if (!isset($params['pass'])) {
                throw new Exception('NG_PDO: Password is not specified');
            }
            if (!isset($params['host'])) {
                throw new Exception('NG_PDO: Host is not specified');
            }
        }

        // Set up event logger and error handler
        if (isset($params['eventLogger'])) {
            if (!($params['eventLogger'] instanceof NGEvents)) {
                throw new Exception('NGPDO: Passed eventLogger is not an instance of NGEvents class');
            }
            $this->eventLogger = $params['eventLogger'];
        } else {
            $this->eventLogger = NGEngine::getInstance()->getEvents();
        }

        if (isset($params['errorHandler'])) {
            if (!($params['errorHandler'] instanceof NGErrorHandler)) {
                throw new Exception('NGPDO: Passed errorHandler is not an instance of NGErrorHandler class');
            }
            $this->errorHandler = $params['errorHandler'];
        } else {
            $this->errorHandler = NGEngine::getInstance()->getErrorHandler();
        }

        if (isset($params['charset'])) {
            $this->dbCharset = strtolower($params['charset']) == 'utf8' ? 'utf8mb4' : $params['charset'];
        }

        // Mark start of DB connection procedure
        $tStart = $this->eventLogger->tickStart();

        try {
            // Create appropriate DSN based on database type
            $dsn = $this->createDSN($params);
            
            if ($this->dbType === 'sqlite') {
                // SQLite: no user/password required
                $this->db = new PDO($dsn);
            } else {
                // MySQL: user/password required
                $this->db = new PDO($dsn, $params['user'], $params['pass']);
            }

            $this->db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $this->db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

            // Database-specific initialization
            $this->initializeDatabase();

            $this->eventLogger->registerEvent(
                'NG_PDO',
                '',
                '* DB Connection established (' . strtoupper($this->dbType) . ')',
                $this->eventLogger->tickStop($tStart)
            );
        } catch (PDOException $e) {
            throw new Exception(
                'NG_PDO: Error connecting to DB (' . $e->getCode() . ') [' . $e->getMessage() . ']',
                $e->getCode()
            );
        }
    }

    /**
     * Create DSN string based on database type
     * @param array $params Connection parameters
     * @return string PDO DSN string
     */
    protected function createDSN($params)
    {
        if ($this->dbType === 'sqlite') {
            // SQLite: sqlite:/path/to/db.sqlite
            return 'sqlite:' . $params['dbpath'];
        } else {
            // MySQL: mysql:host=localhost;dbname=database
            $host = isset($params['host']) ? $params['host'] : 'localhost';
            $db = isset($params['db']) ? $params['db'] : '';
            $dsn = 'mysql:host=' . $host;
            if ($db) {
                $dsn .= ';dbname=' . $db;
            }
            return $dsn;
        }
    }

    /**
     * Initialize database with type-specific settings
     */
    protected function initializeDatabase()
    {
        if ($this->dbType === 'sqlite') {
            // Enable foreign keys for SQLite
            $this->db->exec('PRAGMA foreign_keys = ON');
            
            // Use WAL mode for better concurrency
            $this->db->exec('PRAGMA journal_mode = WAL');
            
            // Set normal synchronization
            $this->db->exec('PRAGMA synchronous = NORMAL');
        } else {
            // MySQL charset initialization
            try {
                $this->db->exec("/*!40101 SET NAMES '" . $this->dbCharset . "' */");
            } catch (PDOException $e) {
                throw new Exception(
                    "NG_PDO: Error switching to charset '" . $this->dbCharset . 
                    "' (" . $e->getCode() . ') [' . $e->getMessage() . ']'
                );
            }
        }
    }

    /**
     * Check if error is "MySQL server has gone away" and attempt to reconnect
     * @param PDOException $e
     * @return bool True if reconnected successfully
     */
    protected function handleGoneAwayError(PDOException $e)
    {
        // Only applicable for MySQL
        if ($this->dbType !== 'mysql') {
            return false;
        }

        $errorInfo = $e->getMessage();
        $errorCode = $e->getCode();

        // Check for "server has gone away" errors (2006 or 2013)
        if (
            strpos($errorInfo, 'server has gone away') !== false ||
            strpos($errorInfo, 'MySQL server has gone away') !== false ||
            in_array($errorCode, ['2006', '2013', 'HY000'])
        ) {
            if ($this->reconnectAttempts < $this->maxReconnectAttempts) {
                $this->reconnectAttempts++;
                try {
                    // Close existing connection
                    $this->db = null;

                    // Attempt to reconnect
                    $params = $this->connectionParams;
                    $dsn = $this->createDSN($params);
                    $this->db = new PDO($dsn, $params['user'], $params['pass']);
                    $this->db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                    $this->db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
                    $this->initializeDatabase();

                    // Reset reconnect counter on success
                    $this->reconnectAttempts = 0;
                    return true;
                } catch (PDOException $reconnectException) {
                    // Reconnection failed
                }
            }
        }
        return false;
    }

    /**
     * Execute query with support for both MySQL and SQLite
     * @param string $sql SQL query
     * @param array $params Query parameters for prepared statements
     * @return array|null Query result
     */
    public function query(string $sql, array $params = [])
    {
        $tStart = $this->eventLogger->tickStart();
        $this->qCount++;
        $maxAttempts = 2;
        $attempt = 0;

        while ($attempt < $maxAttempts) {
            try {
                // Convert SQL syntax if needed for SQLite
                if ($this->dbType === 'sqlite') {
                    $sql = $this->convertSQLForSQLite($sql);
                }

                // Execute query with parameters
                if (is_array($params) && count($params)) {
                    $st = $this->db->prepare($sql);
                    $st->execute($params);
                    $r = $st->fetchAll(PDO::FETCH_ASSOC);
                } else {
                    $r = $this->db->query($sql)->fetchAll(PDO::FETCH_ASSOC);
                }
                break; // Success, exit loop
            } catch (PDOException $e) {
                if ($attempt === 0 && $this->handleGoneAwayError($e)) {
                    // Reconnected successfully, retry query
                    $attempt++;
                    continue;
                }
                // Failed or not a reconnectable error
                $this->errorReport('query', $sql, $e);
                $r = null;
                break;
            }
        }

        $duration = $this->eventLogger->tickStop($tStart);
        if ($this->queryLoggingEnabled) {
            $this->eventLogger->registerEvent('NG_PDO', 'QUERY', $sql, $duration);
            $this->qList[] = ['query' => $sql, 'duration' => $duration, 'start' => $tStart];
        }
        return $r;
    }

    /**
     * Convert MySQL specific SQL syntax to SQLite compatible format
     * @param string $sql SQL query
     * @return string Converted SQL
     */
    protected function convertSQLForSQLite($sql)
    {
        // Convert backticks to double quotes
        $sql = str_replace('`', '"', $sql);

        // Remove MySQL specific clauses
        $sql = preg_replace('/\s+USING BTREE/i', '', $sql);
        $sql = preg_replace('/\s+ENGINE\s*=\s*\w+/i', '', $sql);
        $sql = preg_replace('/\s+DEFAULT CHARSET[^;]*/i', '', $sql);
        $sql = preg_replace('/\s+COLLATE\s+\w+/i', '', $sql);

        // AUTO_INCREMENT -> AUTOINCREMENT
        $sql = str_ireplace('AUTO_INCREMENT', 'AUTOINCREMENT', $sql);

        // Remove UNSIGNED from integer types
        $sql = preg_replace('/(INT|BIGINT|SMALLINT|TINYINT)\s+UNSIGNED/i', '$1', $sql);

        return $sql;
    }

    /**
     * Get database type (mysql or sqlite)
     * @return string Database type
     */
    public function getDbType()
    {
        return $this->dbType;
    }

    /**
     * Get last insert ID (works for both MySQL and SQLite)
     * @return int Last insert ID
     */
    public function getLastInsertId()
    {
        return $this->db->lastInsertId();
    }

    // ... rest of the original NGPDO methods remain the same ...
    // (record, update, insert, delete, query count, etc.)
}

?>
