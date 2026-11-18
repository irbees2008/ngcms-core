# SQLite Configuration Examples

## Example 1: SQLite Configuration in config.php

```php
<?php
$config = array (
  // Database Configuration
  'dbtype' => 'pdo',
  'db_driver' => 'sqlite',  // 'sqlite' or 'mysql'
  
  // For SQLite
  'dbpath' => __DIR__ . '/database.sqlite',  // Absolute path
  
  // Common settings
  'prefix' => 'ng',
  
  // ... rest of configuration ...
);
?>
```

## Example 2: MySQL Configuration in config.php

```php
<?php
$config = array (
  // Database Configuration
  'dbtype' => 'pdo',
  'db_driver' => 'mysql',  // 'sqlite' or 'mysql'
  
  // For MySQL
  'dbhost' => 'localhost',
  'dbname' => 'ngcms_db',
  'dbuser' => 'root',
  'dbpasswd' => 'password',
  
  // Common settings
  'prefix' => 'ng',
  
  // ... rest of configuration ...
);
?>
```

## Example 3: Using both configurations with environment variable

```php
<?php
// Determine database type from environment or config
$dbType = getenv('DB_TYPE') ?: 'mysql';

if ($dbType === 'sqlite') {
    $config = array (
        'dbtype' => 'pdo',
        'db_driver' => 'sqlite',
        'dbpath' => dirname(__FILE__) . '/../data/database.sqlite',
        'prefix' => 'ng',
    );
} else {
    $config = array (
        'dbtype' => 'pdo',
        'db_driver' => 'mysql',
        'dbhost' => 'localhost',
        'dbname' => 'ngcms_db',
        'dbuser' => 'root',
        'dbpasswd' => '',
        'prefix' => 'ng',
    );
}
?>
```

## Directory Structure for SQLite

```
project_root/
├── engine/
│   ├── conf/
│   │   ├── config.php
│   │   └── database.sqlite       # Option 1: Store with config
│   └── classes/
├── data/
│   ├── database.sqlite           # Option 2: Store in separate data folder
│   ├── .htaccess                 # Protect from web access
│   └── backups/
│       ├── database.sqlite.2025-01-15
│       └── database.sqlite.2025-01-16
└── uploads/
```

## Security Configuration

### .htaccess for data folder protection

```apache
# Deny direct access to database files
<FilesMatch "\.(sqlite|sqlite3|db|db-wal|db-shm)$">
    <IfModule mod_authz_core.c>
        Require all denied
    </IfModule>
    <IfModule !mod_authz_core.c>
        Deny from all
    </IfModule>
</FilesMatch>

# Disable script execution in this directory
<FilesMatch "\.php$">
    <IfModule mod_authz_core.c>
        Require all denied
    </IfModule>
    <IfModule !mod_authz_core.c>
        Deny from all
    </IfModule>
</FilesMatch>
```

### File permissions

```bash
# SQLite database file should not be executable
chmod 640 data/database.sqlite
chmod 750 data/

# Alternative: readable/writable by web server only
chmod 600 data/database.sqlite
chmod 700 data/
```

## Backup and Restore Examples

### PHP Backup function for SQLite

```php
function backupSQLiteDatabase($dbPath, $backupDir = 'backups') {
    if (!file_exists($dbPath)) {
        return false;
    }
    
    // Create backup directory if not exists
    if (!is_dir($backupDir)) {
        mkdir($backupDir, 0755, true);
    }
    
    // Generate backup filename with timestamp
    $backupFile = $backupDir . '/database.sqlite.' . date('Y-m-d-H-i-s');
    
    // Copy database file
    if (copy($dbPath, $backupFile)) {
        return $backupFile;
    }
    
    return false;
}
```

### Restore function

```php
function restoreSQLiteDatabase($backupFile, $dbPath) {
    if (!file_exists($backupFile)) {
        return false;
    }
    
    // Backup current database
    if (file_exists($dbPath)) {
        copy($dbPath, $dbPath . '.before-restore');
    }
    
    // Restore from backup
    if (copy($backupFile, $dbPath)) {
        // Fix permissions
        chmod($dbPath, 0640);
        return true;
    }
    
    return false;
}
```

### Automated backup via cron

```php
<?php
// backup_sqlite.php
require_once 'engine/core.php';

$dbPath = $config['dbpath'];
$backupDir = 'engine/backups/sqlite';

// Create backup directory
if (!is_dir($backupDir)) {
    mkdir($backupDir, 0755, true);
}

// Create backup
$backupFile = $backupDir . '/database.sqlite.' . date('Y-m-d-H-i-s');
if (copy($dbPath, $backupFile)) {
    echo "Backup created: " . $backupFile . "\n";
    
    // Keep only last 10 backups
    $files = glob($backupDir . '/database.sqlite.*');
    if (count($files) > 10) {
        usort($files, function($a, $b) {
            return filemtime($a) - filemtime($b);
        });
        
        // Delete old backups
        for ($i = 0; $i < count($files) - 10; $i++) {
            unlink($files[$i]);
        }
    }
} else {
    echo "Backup failed!\n";
}
?>
```

## Performance Tuning for SQLite

```php
// After PDO connection is established
$pdo->exec('PRAGMA journal_mode = WAL');        // Write-Ahead Logging for better concurrency
$pdo->exec('PRAGMA synchronous = NORMAL');      // Balanced speed vs safety
$pdo->exec('PRAGMA cache_size = 10000');        // Increase page cache
$pdo->exec('PRAGMA temp_store = MEMORY');       // Use RAM for temp storage
$pdo->exec('PRAGMA mmap_size = 30000000');      // Memory-mapped I/O (30MB)
$pdo->exec('PRAGMA foreign_keys = ON');         // Enable foreign key constraints
```

## Maintenance for SQLite

```php
// Optimize database (run periodically)
$pdo->exec('VACUUM');                           // Reclaim unused space
$pdo->exec('ANALYZE');                          // Update query optimizer statistics
$pdo->exec('REINDEX');                          // Rebuild all indexes

// Check integrity
$result = $pdo->query('PRAGMA integrity_check');
$rows = $result->fetchAll();
if ($rows[0]['integrity_check'] === 'ok') {
    echo "Database is healthy\n";
} else {
    echo "Database corruption detected!\n";
}
```

## Migration Script: MySQL to SQLite

```php
<?php
/**
 * Migrate from MySQL to SQLite
 */

require_once 'engine/core.php';

// Source: MySQL
$mysqlConn = new NGPDO([
    'dbtype' => 'mysql',
    'host' => 'localhost',
    'db' => 'old_database',
    'user' => 'root',
    'pass' => ''
]);

// Target: SQLite
$sqliteConn = new NGPDO([
    'dbtype' => 'sqlite',
    'dbpath' => __DIR__ . '/database.sqlite'
]);

// Get all tables from MySQL
$tables = $mysqlConn->query("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE()");

foreach ($tables as $table) {
    $tableName = $table['TABLE_NAME'];
    
    // Get table structure
    $structure = $mysqlConn->query("DESCRIBE `$tableName`");
    
    // Get table data
    $data = $mysqlConn->query("SELECT * FROM `$tableName`");
    
    // Create table in SQLite (adapt SQL syntax)
    $createSQL = $mysqlConn->query("SHOW CREATE TABLE `$tableName`")[0]['Create Table'];
    $createSQL = adaptSQLForSQLite($createSQL);
    $sqliteConn->query($createSQL);
    
    // Insert data
    foreach ($data as $row) {
        $columns = implode(', ', array_keys($row));
        $values = implode(', ', array_map(function($v) {
            return $v === null ? 'NULL' : "'" . addslashes($v) . "'";
        }, array_values($row)));
        
        $insertSQL = "INSERT INTO `$tableName` ($columns) VALUES ($values)";
        $sqliteConn->query($insertSQL);
    }
}

echo "Migration completed!\n";

function adaptSQLForSQLite($sql) {
    // Remove MySQL specific syntax
    $sql = str_replace('`', '"', $sql);
    $sql = preg_replace('/\s+USING BTREE/i', '', $sql);
    $sql = preg_replace('/\s+ENGINE\s*=\s*\w+/i', '', $sql);
    $sql = preg_replace('/\s+DEFAULT CHARSET[^;]*/i', '', $sql);
    $sql = preg_replace('/(INT|BIGINT)\s+UNSIGNED/i', '$1', $sql);
    $sql = str_ireplace('AUTO_INCREMENT', 'AUTOINCREMENT', $sql);
    return $sql;
}
?>
```

## Troubleshooting

### Problem: "database is locked"
**Solution:** Use WAL mode and increase timeout
```php
$pdo->setAttribute(PDO::ATTR_TIMEOUT, 5000);  // 5 second timeout
$pdo->exec('PRAGMA journal_mode = WAL');      // Better concurrency
```

### Problem: Slow queries with large datasets
**Solution:** Add indexes and optimize
```php
$pdo->exec('CREATE INDEX idx_name ON table_name(column_name)');
$pdo->exec('ANALYZE');
```

### Problem: File size growing too large
**Solution:** Use VACUUM to reclaim space
```php
$pdo->exec('VACUUM');
```
