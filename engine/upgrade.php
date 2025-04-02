<?php
//
// Copyright (C) 2006-2014 Next Generation CMS (http://ngcms.ru/)
// Name: upgrade.php
// Description: General DB upgrade tool
// Author: NGCMS Development Team
//

@include_once 'core.php';

// Upgrade matrix
$upgradeMatrix = [
    1   => [
        'insert into ' . prefix . "_config (name, value) values ('database.engine.revision', '1')",
    ],
    2   => [
        'alter table ' . prefix . '_news add column content_delta text after content',
        'alter table ' . prefix . '_news add column content_source int default 0 after content_delta',
        'update ' . prefix . "_config set value=2 where name='database.engine.revision'",
        'update ' . prefix . "_config set value='" . engineVersion . "' where name='database.engine.version'",
    ],
    3 => [
        // Удаление полей content_delta и content_source
        'safe_alter_table ' . prefix . '_news drop column if exists content_delta',
        'safe_alter_table ' . prefix . '_news drop column if exists content_source',
        'update ' . prefix . "_config set value=3 where name='database.engine.revision'",
    ],
];

// ========== Main Execution ========== //
$cv = getCurrentDBVersion();
if ($cv < minDBVersion) {
    echo '<h2>Database Upgrade Process</h2>';
    echo 'Current version: ' . $cv . '<br>';
    echo 'Target version: ' . minDBVersion . '<br><br>';

    if (BACKUP_BEFORE_UPGRADE) {
        createBackup();
    }

    // Временное отключение строгого режима MySQL
    NGEngine::getInstance()->getDB()->exec("SET SESSION sql_mode = ''");

    doUpgrade($cv + 1, minDBVersion);
} else {
    echo '<div class="alert alert-success">No upgrade needed! Database is up to date.</div>';
}

// ========== Functions ========== //

/**
 * Получает текущую версию БД с обработкой ошибок
 */
function getCurrentDBVersion(): int
{
    $db = NGEngine::getInstance()->getDB();

    try {
        $dbv = $db->record('select * from ' . prefix . '_config where name = "database.engine.revision"');
        return is_array($dbv) ? (int)$dbv['value'] : 0;
    } catch (Exception $e) {
        // Таблица config или запись может не существовать
        return 0;
    }
}

/**
 * Выполняет обновление с улучшенной обработкой ошибок
 */
function doUpgrade($fromVersion, $toVersion)
{
    global $upgradeMatrix;

    $db = NGEngine::getInstance()->getDB();

    for ($i = $fromVersion; $i <= $toVersion; $i++) {
        if (!isset($upgradeMatrix[$i])) {
            echo "<div class='alert alert-warning'>No upgrade path for version $i - skipping</div>";
            continue;
        }

        echo "<div class='version-block'><h3>Upgrading to revision: $i</h3>";

        foreach ($upgradeMatrix[$i] as $query) {
            // Специальная обработка ALTER TABLE
            if (strpos($query, 'safe_alter_table') === 0) {
                $query = str_replace('safe_alter_table', 'alter table', $query);
                $result = safeAlterTable($query);
            } else {
                $result = executeQuery($query);
            }

            if (!$result) {
                echo "<div class='alert alert-danger'><b>Upgrade failed!</b> Manual intervention required.</div>";
                echo "<p>Return back to <a href='admin.php'>admin panel</a></p>";
                return;
            }
        }

        echo "</div>";
    }

    echo "<div class='alert alert-success'><b>Upgrade completed successfully!</b></div>";
    echo "<p>Return back to <a href='admin.php'>admin panel</a></p>";
}

/**
 * Безопасное выполнение ALTER TABLE с проверками
 */
function safeAlterTable($query)
{
    $db = NGEngine::getInstance()->getDB();

    // Извлекаем данные о таблице и столбцах
    preg_match('/alter table (\w+)\s+(add|drop)\s+column\s+(\w+)/i', $query, $matches);

    if (count($matches) >= 4) {
        $table = $matches[1];
        $action = strtolower($matches[2]);
        $column = $matches[3];

        // Проверяем существование таблицы
        if (!$db->tableExists($table)) {
            echo "<div class='alert alert-danger'>Table $table doesn't exist!</div>";
            return false;
        }

        // Проверяем существование столбца
        $columns = $db->record("SHOW COLUMNS FROM $table LIKE '$column'");

        if ($action == 'add' && $columns) {
            echo "<div class='alert alert-warning'>Column $column already exists in $table - skipping</div>";
            return true;
        }

        if ($action == 'drop' && !$columns) {
            echo "<div class='alert alert-warning'>Column $column doesn't exist in $table - skipping</div>";
            return true;
        }
    }

    return executeQuery($query);
}

/**
 * Выполнение SQL-запроса с обработкой ошибок
 */
function executeQuery($query)
{
    $db = NGEngine::getInstance()->getDB();

    echo "<div class='query'>Executing: <code>" . htmlspecialchars($query) . "</code> ... ";

    try {
        $start = microtime(true);
        $result = $db->exec($query);
        $time = round((microtime(true) - $start) * 1000, 2);

        if ($result === false) {
            $error = $db->error();
            echo "<span class='error'>FAILED</span> ({$time}ms)</div>";
            echo "<div class='error-details'>MySQL Error: " . htmlspecialchars($error['message']) . "</div>";
            return false;
        }

        echo "<span class='success'>OK</span> ({$time}ms)</div>";
        return true;
    } catch (Exception $e) {
        echo "<span class='error'>ERROR</span></div>";
        echo "<div class='error-details'>Exception: " . htmlspecialchars($e->getMessage()) . "</div>";
        return false;
    }
}

/**
 * Создание резервной копии БД
 */
function createBackup()
{
    echo "<div class='alert alert-info'>Creating database backup...</div>";

    try {
        $config = NGEngine::getInstance()->getConfig();
        $backupFile = 'backup_' . date('Y-m-d_H-i-s') . '_pre_upgrade.sql';

        // Получаем параметры подключения из конфигурации
        $command = sprintf(
            "mysqldump --user=%s --password=%s --host=%s %s > %s",
            escapeshellarg($config['db_user']),
            escapeshellarg($config['db_pass']),
            escapeshellarg($config['db_host']),
            escapeshellarg($config['db_name']),
            escapeshellarg($backupFile)
        );

        system($command, $result);

        if ($result === 0) {
            echo "<div class='alert alert-success'>Backup created successfully: $backupFile</div>";
        } else {
            echo "<div class='alert alert-warning'>Backup creation failed! Please create backup manually.</div>";
        }
    } catch (Exception $e) {
        echo "<div class='alert alert-warning'>Backup error: " . htmlspecialchars($e->getMessage()) . "</div>";
    }
}

// ========== HTML Styles ========== //
echo <<<HTML
<style>
    .alert { padding: 15px; margin: 10px 0; border-radius: 4px; }
    .alert-success { background: #dff0d8; color: #3c763d; }
    .alert-danger { background: #f2dede; color: #a94442; }
    .alert-warning { background: #fcf8e3; color: #8a6d3b; }
    .alert-info { background: #d9edf7; color: #31708f; }
    .query { font-family: monospace; margin: 5px 0; }
    .success { color: green; font-weight: bold; }
    .error { color: red; font-weight: bold; }
    .error-details { color: #a94442; margin-left: 20px; }
    .version-block { background: #f5f5f5; padding: 15px; margin-bottom: 20px; }
</style>
HTML;
