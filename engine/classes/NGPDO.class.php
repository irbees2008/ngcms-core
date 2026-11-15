<?php
class NGPDO
{
    protected $db = null;
    protected $qCount = 0;
    protected $qList = [];
    protected $softErrors = false;
    protected $errorSecurity = 0;
    protected $eventLogger = null;
    protected $errorHandler = null;
    protected $dbCharset = 'utf8mb4';
    protected $dbType = 'mysql';
    protected $connectionParams = [];
    protected $reconnectAttempts = 0;
    protected $maxReconnectAttempts = 3;
    protected $queryLoggingEnabled = true;
    protected function resolveDbType(array $params): string
    {
        if (isset($params['dbtype'])) {
            $dbType = strtolower((string) $params['dbtype']);
            if (in_array($dbType, ['mysql', 'sqlite'], true)) {
                return $dbType;
            }
        }
        return (!empty($params['dbpath']) || !empty($params['sqlite'])) ? 'sqlite' : 'mysql';
    }
    protected function buildDsn(array $params): string
    {
        $this->dbType = $this->resolveDbType($params);
        if ($this->dbType === 'sqlite') {
            $dbPath = $params['dbpath'] ?? $params['sqlite'] ?? null;
            if (empty($dbPath)) {
                throw new Exception('NG_PDO (SQLite): dbpath parameter is required');
            }
            return 'sqlite:' . $dbPath;
        }
        return 'mysql:host=' . ($params['host'] ?? 'localhost') . (isset($params['db']) ? ';dbname=' . $params['db'] : '');
    }
    protected function initializeSqliteFunctions(): void
    {
        $registerFunction = [$this->db, method_exists($this->db, 'createFunction') ? 'createFunction' : 'sqliteCreateFunction'];
        $registerFunction('LAST_INSERT_ID', function () {
            return (int) $this->db->lastInsertId();
        }, 0);
        $registerFunction('NOW', function () {
            return date('Y-m-d H:i:s');
        }, 0);
        $registerFunction('UNIX_TIMESTAMP', function ($value = null) {
            if ($value === null) {
                return time();
            }
            $timestamp = strtotime((string) $value);
            return $timestamp === false ? null : $timestamp;
        }, -1);
        $formatDate = static function ($value, $format) {
            $timestamp = is_numeric($value) ? (int) $value : strtotime((string) $value);
            if ($timestamp === false) {
                return null;
            }
            $format = strtr((string) $format, [
                '%%' => "\0",
                '%Y' => 'Y',
                '%y' => 'y',
                '%m' => 'm',
                '%c' => 'n',
                '%d' => 'd',
                '%e' => 'j',
                '%H' => 'H',
                '%h' => 'h',
                '%I' => 'h',
                '%i' => 'i',
                '%s' => 's',
                '%p' => 'A',
            ]);
            return str_replace("\0", '%', date($format, $timestamp));
        };
        $registerFunction('FROM_UNIXTIME', function ($value) {
            return $value === null ? null : date('Y-m-d H:i:s', (int) $value);
        }, 1);
        $registerFunction('FROM_UNIXTIME', static function ($value, $format) use ($formatDate) {
            return $value === null || $format === null ? null : $formatDate((int) $value, $format);
        }, 2);
        $registerFunction('DATE_FORMAT', $formatDate, 2);
        $registerFunction('MONTH', function ($value) {
            $timestamp = strtotime((string) $value);
            return $timestamp === false ? null : (int) date('n', $timestamp);
        }, 1);
        $registerFunction('YEAR', function ($value) {
            $timestamp = strtotime((string) $value);
            return $timestamp === false ? null : (int) date('Y', $timestamp);
        }, 1);
        $registerFunction('IF', function ($condition, $whenTrue, $whenFalse) {
            return $condition ? $whenTrue : $whenFalse;
        }, 3);
        $registerFunction('CONCAT', function (...$values) {
            return implode('', array_map(static function ($value) {
                return $value === null ? '' : (string) $value;
            }, $values));
        }, -1);
        $registerFunction('FIND_IN_SET', function ($needle, $haystack) {
            $values = explode(',', (string) $haystack);
            $position = array_search((string) $needle, $values, true);
            return $position === false ? 0 : $position + 1;
        }, 2);
    }
    protected function adaptSql(string $sql): string
    {
        if ($this->dbType !== 'sqlite') {
            return $sql;
        }
        $sql = preg_replace('/^\s*SHOW\s+(?:(?:SESSION|GLOBAL)\s+)?VARIABLES(?:\s+LIKE\s+.+)?\s*;?\s*$/i', "SELECT '' AS Variable_name, '' AS Value WHERE 0", $sql);
        if (preg_match('/^\s*(?:DESCRIBE|DESC)\s+`?([^`\s;]+)`?\s*;?\s*$/i', $sql, $match)) {
            $tableName = str_replace("'", "''", $match[1]);
            return "SELECT name AS Field, type AS Type, CASE \"notnull\" WHEN 1 THEN 'NO' ELSE 'YES' END AS `Null`, CASE pk WHEN 1 THEN 'PRI' ELSE '' END AS `Key`, dflt_value AS `Default`, CASE WHEN pk = 1 AND upper(type) = 'INTEGER' THEN 'auto_increment' ELSE '' END AS Extra FROM pragma_table_info('$tableName') ORDER BY cid";
        }
        if (preg_match('/^\s*CREATE\s+TABLE\b/i', $sql)) {
            $sql = preg_replace('/(`[^`]+`|[A-Za-z_][A-Za-z0-9_]*)\s+int(?:\s*\(\s*\d+\s*\))?\s+(?:UNSIGNED\s+)?NOT\s+NULL\s+AUTO_INCREMENT\b/i', '$1 INTEGER NOT NULL', $sql);
            $sql = preg_replace('/\bUNSIGNED\b/i', '', $sql);
            $sql = preg_replace('/\s+AUTO_INCREMENT\b/i', '', $sql);
            $sql = preg_replace('/,\s*(?:UNIQUE\s+)?KEY\s+`?[^`(\s]+`?\s*\([^)]*\)/i', '', $sql);
            $sql = preg_replace('/\s+DEFAULT\s+CHARSET\s*=\s*[A-Za-z0-9_]+/i', '', $sql);
            $sql = preg_replace('/\s+ENGINE\s*=\s*[A-Za-z0-9_]+/i', '', $sql);
        } elseif (preg_match('/^\s*ALTER\s+TABLE\b.+\bADD\s+COLUMN\b/i', $sql)) {
            $sql = preg_replace('/\bUNSIGNED\b/i', '', $sql);
            $sql = preg_replace('/\s+AUTO_INCREMENT\b/i', '', $sql);
        }
        $sql = preg_replace('/^\s*SHOW\s+TABLES(?:\s+FROM\s+`[^`]+`)?\s*$/i', "SELECT name AS 'Tables_in_sqlite' FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%' ORDER BY name", $sql);
        $sql = preg_replace('/^\s*SHOW\s+TABLES(?:\s+FROM\s+`[^`]+`)?\s+LIKE\s+(.+)$/i', "SELECT name AS 'Tables_in_sqlite' FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%' AND name LIKE $1 ORDER BY name", $sql);
        if (preg_match('/^\s*SHOW\s+CREATE\s+TABLE\s+`([^`]+)`\s*$/i', $sql, $match)) {
            $tableName = str_replace("'", "''", $match[1]);
            return "SELECT name AS 'Table', sql AS 'Create Table' FROM sqlite_master WHERE type = 'table' AND name = '$tableName'";
        }
        if (preg_match('/^\s*SHOW\s+(?:COLUMNS|FIELDS)\s+FROM\s+`?([^`\s;]+)`?\s*$/i', $sql, $match)) {
            $tableName = str_replace("'", "''", $match[1]);
            return "SELECT name AS Field, type AS Type, CASE \"notnull\" WHEN 1 THEN 'NO' ELSE 'YES' END AS `Null`, dflt_value AS `Default`, CASE pk WHEN 1 THEN 'PRI' ELSE '' END AS `Key` FROM pragma_table_info('$tableName')";
        }
        if (preg_match('/^\s*SHOW\s+TABLE\s+STATUS(?:\s+FROM\s+`[^`]+`)?(?:\s+(LIKE\s+.+|WHERE\s+.+))?\s*$/i', $sql, $match)) {
            $where = $match[1] ?? '';
            if (stripos($where, 'LIKE') === 0) {
                $where = ' AND name LIKE ' . substr($where, 4);
            } elseif (stripos($where, 'WHERE') === 0) {
                $where = ' AND ' . preg_replace('/\bName\b/i', 'name', substr($where, 5));
            }
            return 'SELECT name AS Name, 0 AS Rows, 0 AS Data_length, 0 AS Index_length, 0 AS Data_free FROM sqlite_master WHERE type = \'table\' AND name NOT LIKE \'sqlite_%\'' . $where;
        }
        return preg_replace('/\s+ON\s+DUPLICATE\s+KEY\s+UPDATE\s+/i', ' ON CONFLICT DO UPDATE SET ', $sql);
    }
    public function __construct(array $params)
    {
        // Save connection params for potential reconnection
        $this->connectionParams = $params;
        $this->dbType = $this->resolveDbType($params);
        // Init params
        if (isset($params['softErrors'])) {
            $this->softErrors = $params['softErrors'];
        }
        if (isset($params['errorSecurity'])) {
            $this->errorSecurity = $params['errorSecurity'];
        }
        if ($this->dbType === 'sqlite') {
            if (empty($params['dbpath']) && empty($params['sqlite'])) {
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
                throw new Exception('NGPDO: Passed eventLogger is not an instance of NGErrorHandler class');
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
            $dsn = $this->buildDsn($params);
            if ($this->dbType === 'sqlite') {
                $this->db = class_exists('Pdo\\Sqlite') ? new \Pdo\Sqlite($dsn) : new PDO($dsn);
            } else {
                $this->db = new PDO($dsn, $params['user'], $params['pass']);
            }
            $this->db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $this->db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw new Exception('NG_PDO: Error connecting to DB (' . $e->getCode() . ') [' . $e->getMessage() . ']', $e->getCode());
        }
        // Database-specific initialization
        try {
            if ($this->dbType === 'sqlite') {
                $this->db->exec('PRAGMA foreign_keys = ON');
                $this->db->exec('PRAGMA journal_mode = WAL');
                $this->initializeSqliteFunctions();
            } else {
                $this->db->exec("/*!40101 SET NAMES '" . $this->dbCharset . "' */");
            }
        } catch (PDOException $e) {
            throw new Exception("NG_PDO: Error switching to charset '" . $this->dbCharset . "' (" . $e->getCode() . ') [' . $e->getMessage() . ']');
        }
        $this->eventLogger->registerEvent('NG_PDO', '', '* DB Connection established (' . strtoupper($this->dbType) . ')', $this->eventLogger->tickStop($tStart));
    }
    /**
     * Check if error is "MySQL server has gone away" and attempt to reconnect
     * @param PDOException $e
     * @return bool True if reconnected successfully
     */
    protected function handleGoneAwayError(PDOException $e)
    {
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
                    $dsn = $this->buildDsn($params);
                    $this->db = new PDO($dsn, $params['user'], $params['pass']);
                    $this->db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                    $this->db->exec("/*!40101 SET NAMES '" . $this->dbCharset . "' */");
                    // Reset reconnect counter on success
                    $this->reconnectAttempts = 0;
                    return true;
                } catch (PDOException $reconnectException) {
                    // Reconnection failed, will return false
                }
            }
        }
        return false;
    }
    public function query(string $sql, array $params = [])
    {
        $sql = $this->adaptSql($sql);
        $tStart = $this->eventLogger->tickStart();
        $this->qCount++;
        $maxAttempts = 2;
        $attempt = 0;
        while ($attempt < $maxAttempts) {
            try {
                // Check if we should prepare
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
    public function record(string $sql, array $params = [])
    {
        $sql = $this->adaptSql($sql);
        $tStart = $this->eventLogger->tickStart();
        $this->qCount++;
        $maxAttempts = 2;
        $attempt = 0;
        while ($attempt < $maxAttempts) {
            try {
                // Check if we should prepare
                if (is_array($params) && count($params)) {
                    $st = $this->db->prepare($sql);
                    $st->execute($params);
                    $r = $st->fetch(PDO::FETCH_ASSOC);
                    $st->closeCursor();
                } else {
                    $r = $this->db->query($sql)->fetch(PDO::FETCH_ASSOC);
                }
                break; // Success, exit loop
            } catch (PDOException $e) {
                if ($attempt === 0 && $this->handleGoneAwayError($e)) {
                    // Reconnected successfully, retry query
                    $attempt++;
                    continue;
                }
                // Failed or not a reconnectable error
                $this->errorReport('record', $sql, $e);
                $r = null;
                break;
            }
        }
        $duration = $this->eventLogger->tickStop($tStart);
        if ($this->queryLoggingEnabled) {
            $this->eventLogger->registerEvent('NG_PDO', 'RECORD', $sql, $duration);
            $this->qList[] = ['query' => $sql, 'duration' => $duration];
        }
        return $r;
    }
    public function exec(string $sql, array $params = [])
    {
        $sql = $this->adaptSql($sql);
        $tStart = $this->eventLogger->tickStart();
        $this->qCount++;
        $r = null;
        $maxAttempts = 2;
        $attempt = 0;
        while ($attempt < $maxAttempts) {
            try {
                // Check if we should prepare
                if (is_array($params) && count($params)) {
                    $st = $this->db->prepare($sql);
                    $st->execute($params);
                    $st->closeCursor();
                } else {
                    $r = $this->db->query($sql);
                }
                break; // Success, exit loop
            } catch (PDOException $e) {
                if ($attempt === 0 && $this->handleGoneAwayError($e)) {
                    // Reconnected successfully, retry query
                    $attempt++;
                    continue;
                }
                // Failed or not a reconnectable error
                $this->errorReport('exec', $sql, $e);
                $r = null;
                break;
            }
        }
        $duration = $this->eventLogger->tickStop($tStart);
        if ($this->queryLoggingEnabled) {
            $this->eventLogger->registerEvent('NG_PDO', 'EXEC', $sql, $duration);
            $this->qList[] = ['query' => $sql, 'duration' => $duration];
        }
        return $r;
    }
    public function result(string $sql, array $params = [])
    {
        $sql = $this->adaptSql($sql);
        $tStart = $this->eventLogger->tickStart();
        $this->qCount++;
        $maxAttempts = 2;
        $attempt = 0;
        while ($attempt < $maxAttempts) {
            try {
                // Check if we should prepare
                if (is_array($params) && count($params)) {
                    $st = $this->db->prepare($sql);
                    $st->execute($params);
                    $r = $st->fetch(PDO::FETCH_ASSOC);
                    $st->closeCursor();
                } else {
                    $r = $this->db->query($sql)->fetch(PDO::FETCH_ASSOC);
                }
                break; // Success, exit loop
            } catch (PDOException $e) {
                if ($attempt === 0 && $this->handleGoneAwayError($e)) {
                    // Reconnected successfully, retry query
                    $attempt++;
                    continue;
                }
                // Failed or not a reconnectable error
                $this->errorReport('result', $sql, $e);
                $r = null;
                break;
            }
        }
        $duration = $this->eventLogger->tickStop($tStart);
        if ($this->queryLoggingEnabled) {
            $this->eventLogger->registerEvent('NG_PDO', 'RESULT', $sql, $duration);
            $this->qList[] = ['query' => $sql, 'duration' => $duration];
        }
        if ($r !== null && count($r)) {
            return reset($r);
        }
        return null;
    }
    public function num_rows(?PDOStatement $st)
    {
        if ($st === null) {
            return 0;
        }
        try {
            $r = $st->fetchColumn();
        } catch (PDOException $e) {
            $this->errorReport('num_rows', $st->queryString, $e);
            $r = null;
        }
        return $r;
    }
    public function fetch_row(?PDOStatement $st)
    {
        if ($st === null) {
            return false;
        }
        try {
            $r = $st->fetch(PDO::FETCH_NUM);
        } catch (PDOException $e) {
            $this->errorReport('fetch_row', $st->queryString, $e);
            $r = false;
        }
        return $r;
    }
    public function lastid(string $table = '')
    {
        try {
            if ($this->dbType === 'sqlite') {
                return $this->db->lastInsertId();
            }
            if (empty($table)) {
                return $this->db->lastInsertId();
            } else {
                $r = $this->record('SHOW TABLE STATUS LIKE \'' . prefix . '_' . $table . '\'');
                return $r['Auto_increment'] - 1;
            }
        } catch (PDOException $e) {
            $this->errorReport('lastid', 'lastid', $e);
        }
    }
    public function affected_rows(?PDOStatement $st)
    {
        if ($st === null) {
            return 0;
        }
        try {
            $r = $st->rowCount();
        } catch (PDOException $e) {
            $this->errorReport('affected_rows', 'affected_rows', $e);
            $r = 0;
        }
        return $r;
    }
    public function close()
    {
        try {
            if ($this->db != null) {
                $this->db = null;
            }
        } catch (PDOException $e) {
            $this->errorReport('close', 'close', $e);
        }
    }
    public function db_errno()
    {
        try {
            $this->db->errorInfo()[0];
        } catch (PDOException $e) {
            $this->errorReport('db_errno', 'db_errno', $e);
        }
    }
    /**
     * @param $string
     *
     * @return string
     */
    public function quote(string $string)
    {
        return mb_substr($this->db->quote($string), 1, -1);
    }
    /**
     * @return string
     */
    public function getEngineType()
    {
        return 'PDO';
    }
    public function getDbType()
    {
        return $this->dbType;
    }
    /**
     * @return PDO Instance of PDO driver for low level access
     */
    public function getDriver()
    {
        return $this->db;
    }
    /**
     * @return string
     */
    public function getVersion()
    {
        if ($this->dbType === 'sqlite') {
            try {
                return $this->db->query('SELECT sqlite_version()')->fetchColumn();
            } catch (PDOException $e) {
                return 'sqlite';
            }
        }
        return $this->getDriver()->getAttribute(constant('PDO::ATTR_SERVER_VERSION'));
    }
    /**
     * // Report an SQL error.
     *
     * @param $type string Query type
     * @param $query string Query content
     * @param PDOException $e
     */
    public function errorReport(string $type, string $query, PDOException $e)
    {
        $errNo = 'n/a';
        $errMsg = 'n/a';
        if ($e instanceof \PDOException) {
            $errNo = $e->getCode();
            $errMsg = $e->getMessage();
        }
        $this->errorHandler->throwError('SQL', ['errNo' => $errNo, 'errMsg' => $errMsg, 'type' => $type, 'query' => $query], $e);
    }
    public function getQueryCount()
    {
        return $this->qCount;
    }
    public function setQueryLogging(bool $enabled): void
    {
        $this->queryLoggingEnabled = $enabled;
    }
    public function getQueryList()
    {
        return $this->qList;
    }
    // Cursor based operations
    /**
     * @param $query
     * @param array $params
     *
     * @return PDOStatement
     */
    public function createCursor(string $query, array $params = [])
    {
        $query = $this->adaptSql($query);
        $cursor = $this->db->prepare($query);
        if (is_array($params)) {
            foreach ($params as $key => $value) {
                $cursor->bindParam(':' . $key, $value, is_int($value) ? PDO::PARAM_INT : PDO::PARAM_STR);
            }
        }
        $cursor->execute();
        return $cursor;
    }
    /**
     * @param PDOStatement $cursor
     *
     * @return mixed
     */
    public function fetchCursor(PDOStatement $cursor)
    {
        return $cursor->fetch(PDO::FETCH_ASSOC);
    }
    public function closeCursor(PDOStatement $cursor)
    {
        return $cursor->closeCursor();
    }
    public function tableExists(string $name)
    {
        if ($this->dbType === 'sqlite') {
            $escaped = str_replace("'", "''", $name);
            $stmt = $this->db->query("SELECT name FROM sqlite_master WHERE type='table' AND name = '$escaped'");
            return $stmt !== false && $stmt->fetch(PDO::FETCH_ASSOC) !== false;
        }
        return is_array($this->record('show tables like :name', ['name' => $name]));
    }
}
