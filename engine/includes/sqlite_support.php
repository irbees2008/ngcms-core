<?php
/**
 * SQLite Support Functions for NGCMS
 * Provides compatibility layer for SQLite database
 */

class NGSQLiteAdapter
{
    /**
     * Convert MySQL specific SQL to SQLite compatible SQL
     * @param string $sql SQL query
     * @param string $targetType Target database type ('sqlite' or 'mysql')
     * @return string Converted SQL
     */
    public static function convertSQL($sql, $targetType = 'sqlite')
    {
        if ($targetType !== 'sqlite') {
            return $sql;
        }

        // Remove MySQL specific syntax
        $sql = preg_replace('/`/', '"', $sql); // Convert backticks to quotes
        $sql = preg_replace('/\bUSING BTREE\b/i', '', $sql); // Remove USING BTREE
        $sql = preg_replace('/\bENGINE\s*=\s*\w+\b/i', '', $sql); // Remove ENGINE specification
        $sql = preg_replace('/\bDEFAULT CHARSET.*?(?=;|$)/i', '', $sql); // Remove charset
        $sql = preg_replace('/\bCOLLATE\s+\w+\b/i', '', $sql); // Remove COLLATE

        // Convert AUTO_INCREMENT to AUTOINCREMENT
        $sql = preg_replace('/\bAUTO_INCREMENT\b/i', 'AUTOINCREMENT', $sql);

        // Remove UNSIGNED (SQLite doesn't support it)
        $sql = preg_replace('/\b(INT|BIGINT|SMALLINT|TINYINT)\s+UNSIGNED\b/i', '$1', $sql);

        return $sql;
    }

    /**
     * Get last insert ID for SQLite
     * @param PDO $pdo PDO instance
     * @return int Last insert ID
     */
    public static function lastInsertId($pdo)
    {
        return $pdo->lastInsertId();
    }

    /**
     * Check if table exists in SQLite
     * @param PDO $pdo PDO instance
     * @param string $tableName Table name
     * @return bool True if table exists
     */
    public static function tableExists($pdo, $tableName)
    {
        try {
            $result = $pdo->query(
                "SELECT name FROM sqlite_master WHERE type='table' AND name = '" . 
                addslashes($tableName) . "'"
            );
            return $result->rowCount() > 0;
        } catch (Exception $e) {
            return false;
        }
    }

    /**
     * Get table info for SQLite
     * @param PDO $pdo PDO instance
     * @param string $tableName Table name
     * @return array Table columns info
     */
    public static function getTableInfo($pdo, $tableName)
    {
        try {
            $result = $pdo->query("PRAGMA table_info(\"" . addslashes($tableName) . "\")");
            return $result->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            return [];
        }
    }

    /**
     * Get all tables in database
     * @param PDO $pdo PDO instance
     * @return array List of table names
     */
    public static function getTables($pdo)
    {
        try {
            $result = $pdo->query(
                "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
            );
            $tables = [];
            foreach ($result->fetchAll(PDO::FETCH_ASSOC) as $row) {
                $tables[] = $row['name'];
            }
            return $tables;
        } catch (Exception $e) {
            return [];
        }
    }

    /**
     * Enable foreign keys in SQLite
     * @param PDO $pdo PDO instance
     * @return bool Success status
     */
    public static function enableForeignKeys($pdo)
    {
        try {
            $pdo->exec("PRAGMA foreign_keys = ON");
            return true;
        } catch (Exception $e) {
            return false;
        }
    }

    /**
     * Set synchronous mode for performance
     * @param PDO $pdo PDO instance
     * @param string $mode 'OFF' for speed, 'FULL' for safety
     * @return bool Success status
     */
    public static function setSynchronous($pdo, $mode = 'NORMAL')
    {
        try {
            $pdo->exec("PRAGMA synchronous = " . strtoupper($mode));
            return true;
        } catch (Exception $e) {
            return false;
        }
    }

    /**
     * Set journal mode for SQLite
     * @param PDO $pdo PDO instance
     * @param string $mode 'WAL' for better concurrency, 'DELETE' for compatibility
     * @return bool Success status
     */
    public static function setJournalMode($pdo, $mode = 'WAL')
    {
        try {
            $pdo->exec("PRAGMA journal_mode = " . strtoupper($mode));
            return true;
        } catch (Exception $e) {
            return false;
        }
    }

    /**
     * Vacuum database to reclaim space
     * @param PDO $pdo PDO instance
     * @return bool Success status
     */
    public static function vacuum($pdo)
    {
        try {
            $pdo->exec("VACUUM");
            return true;
        } catch (Exception $e) {
            return false;
        }
    }

    /**
     * Enable query results in array format
     * @param PDO $pdo PDO instance
     * @return void
     */
    public static function initializePDO($pdo)
    {
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        
        // Enable foreign keys
        self::enableForeignKeys($pdo);
        
        // Set WAL mode for better performance
        self::setJournalMode($pdo, 'WAL');
        
        // Set normal synchronous mode
        self::setSynchronous($pdo, 'NORMAL');
    }

    /**
     * Create backup of SQLite database
     * @param string $dbPath Full path to SQLite database file
     * @param string $backupPath Full path to backup file
     * @return bool Success status
     */
    public static function createBackup($dbPath, $backupPath)
    {
        try {
            if (!file_exists($dbPath)) {
                return false;
            }
            return copy($dbPath, $backupPath);
        } catch (Exception $e) {
            return false;
        }
    }

    /**
     * Restore SQLite database from backup
     * @param string $backupPath Full path to backup file
     * @param string $dbPath Full path to target database file
     * @return bool Success status
     */
    public static function restoreBackup($backupPath, $dbPath)
    {
        try {
            if (!file_exists($backupPath)) {
                return false;
            }
            return copy($backupPath, $dbPath);
        } catch (Exception $e) {
            return false;
        }
    }
}

/**
 * Enhanced NGPDO connection for SQLite compatibility
 * This class extends the base NGPDO to support SQLite
 */
class NGPDOSQLite
{
    /**
     * Create appropriate DSN string based on database type
     * @param array $params Connection parameters
     * @return string DSN string for PDO
     */
    public static function createDSN($params)
    {
        $dbType = isset($params['dbtype']) ? strtolower($params['dbtype']) : 'mysql';

        if ($dbType === 'sqlite') {
            // SQLite: sqlite:/path/to/database.db
            $dbPath = $params['dbpath'] ?? '';
            if (!$dbPath) {
                throw new Exception('SQLite: dbpath parameter is required');
            }
            return 'sqlite:' . $dbPath;
        } else {
            // MySQL: mysql:host=localhost;dbname=database
            $host = $params['host'] ?? 'localhost';
            $dbName = $params['db'] ?? $params['dbname'] ?? '';
            return 'mysql:host=' . $host . (($dbName) ? ';dbname=' . $dbName : '');
        }
    }

    /**
     * Initialize PDO connection with database-specific settings
     * @param PDO $pdo PDO instance
     * @param array $params Connection parameters
     * @return void
     */
    public static function initializeConnection($pdo, $params)
    {
        $dbType = isset($params['dbtype']) ? strtolower($params['dbtype']) : 'mysql';

        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

        if ($dbType === 'sqlite') {
            NGSQLiteAdapter::initializePDO($pdo);
        } else {
            // MySQL specific initialization
            $charset = $params['charset'] ?? 'utf8mb4';
            $pdo->exec("/*!40101 SET NAMES '" . $charset . "' */");
        }
    }
}
?>
