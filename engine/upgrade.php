<?php

/**
 * Инструмент обновления базы данных NGCMS
 * 
 * @copyright Copyright (C) 2006-2014 Next Generation CMS (http://ngcms.ru/)
 * @license MIT
 */

@include_once 'core.php';

// Матрица обновлений
$upgradeMatrix = [
    1 => [
        "INSERT IGNORE INTO " . prefix . "_config (name, value) VALUES ('database.engine.revision', '1')",
    ],
    2 => [
        "ALTER TABLE " . prefix . "_news ADD COLUMN content_delta TEXT AFTER content",
        "ALTER TABLE " . prefix . "_news ADD COLUMN content_source INT DEFAULT 0 AFTER content_delta",
        "UPDATE " . prefix . "_config SET value = 2 WHERE name = 'database.engine.revision'",
        "UPDATE " . prefix . "_config SET value = '" . engineVersion . "' WHERE name = 'database.engine.version'",
    ],
    3 => [
        "ALTER TABLE " . prefix . "_news DROP COLUMN content_delta",
        "ALTER TABLE " . prefix . "_news DROP COLUMN content_source",
        "UPDATE " . prefix . "_config SET value = 3 WHERE name = 'database.engine.revision'",
    ],
    4 => [
        "UPDATE " . prefix . "_config SET value = 4 WHERE name = 'database.engine.revision'",
    ],
    5 => [
        "UPDATE " . prefix . "_config SET value = 5 WHERE name = 'database.engine.revision'",
    ],
];

// Получаем текущую версию БД
$currentVersion = getCurrentDBVersion();

// Проверяем необходимость обновления
if ($currentVersion < minDBVersion) {
    echo renderUpgradeHeader($currentVersion, minDBVersion);
    doUpgrade($currentVersion + 1, minDBVersion);
} else {
    echo renderNoUpgradeNeeded();
}

/**
 * Получает текущую версию БД
 */
function getCurrentDBVersion(): int
{
    $db = NGEngine::getInstance()->getDB();
    $versionRecord = $db->record(
        "SELECT * FROM " . prefix . "_config WHERE name = 'database.engine.revision'"
    );

    return is_array($versionRecord) ? (int)$versionRecord['value'] : 0;
}

/**
 * Выполняет обновление БД
 */
function doUpgrade(int $fromVersion, int $toVersion): void
{
    global $upgradeMatrix;
    $db = NGEngine::getInstance()->getDB();

    // Временное разрешение проблемных дат
    $db->exec("SET SQL_MODE='ALLOW_INVALID_DATES'");

    for ($version = $fromVersion; $version <= $toVersion; $version++) {
        echo "<div class='upgrade-step'>";
        echo "<h3><i class='icon-version'></i> Обновление до версии {$version}</h3>";
        echo "<div class='step-actions'>";

        if ($version == 5) {
            // Выполняем конвертацию кодировки
            echo "<h4>Конвертация базы данных в UTF-8 (utf8mb4)</h4>";
            convertDatabaseEncodingToUtf8mb4($db);
        } else {
            // Стандартная обработка для других версий
            foreach ($upgradeMatrix[$version] as $sql) {
                executeSqlWithReporting($db, $sql);
            }
        }

        echo "</div></div>";
    }

    // Восстановление стандартного режима SQL
    $db->exec("SET SQL_MODE=''");

    echo renderSuccessMessage();
    renderFooter();
}

/**
 * Конвертирует кодировку базы данных в utf8mb4
 */
function convertDatabaseEncodingToUtf8mb4($db): void
{
    echo "<div class='action'><div class='status'>Начало конвертации в utf8mb4...</div></div>";

    // 1. Отключаем строгий режим MySQL
    executeSqlWithReporting($db, "SET SESSION sql_mode = 'NO_ENGINE_SUBSTITUTION'");

    try {
        // 2. Получаем имя базы данных
        $dbName = '';
        $result = $db->query("SELECT DATABASE() AS dbname");
        if (is_array($result)) {
            $dbName = $result[0]['dbname'] ?? '';
        } else {
            $row = $result->fetch(PDO::FETCH_ASSOC);
            $dbName = $row['dbname'] ?? '';
        }

        if (empty($dbName)) {
            throw new Exception("Не удалось определить имя базы данных");
        }

        echo "<div class='action'><div class='status'>Обнаружена база: {$dbName}</div></div>";

        // 3. Изменяем кодировку всей базы
        executeSqlWithReporting($db, "ALTER DATABASE `{$dbName}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");

        // 4. Получаем список всех таблиц
        $tables = [];
        $result = $db->query("SHOW TABLES");

        if (is_array($result)) {
            foreach ($result as $row) {
                $tables[] = reset($row);
            }
        } else {
            while ($row = $result->fetch(PDO::FETCH_NUM)) {
                $tables[] = $row[0];
            }
        }

        foreach ($tables as $tableName) {
            echo "<div class='action'>";
            echo "<h4>Обработка таблицы: {$tableName}</h4>";

            // 5. Проверяем текущую кодировку таблицы
            $createResult = $db->query("SHOW CREATE TABLE `{$tableName}`");
            $createTable = '';

            if (is_array($createResult)) {
                $createTable = $createResult[0]['Create Table'] ?? $createResult[0][1] ?? '';
            } else {
                $createRow = $createResult->fetch(PDO::FETCH_NUM);
                $createTable = $createRow[1] ?? '';
            }

            if (strpos($createTable, 'CHARSET=utf8mb4') !== false) {
                echo "<div class='skipped'>Таблица уже в utf8mb4, пропускаем</div>";
                echo "</div>";
                continue;
            }

            // 6. Конвертируем таблицу
            executeSqlWithReporting($db, "ALTER TABLE `{$tableName}` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");

            // 7. Обрабатываем проблемные столбцы
            $columns = $db->query("SHOW FULL COLUMNS FROM `{$tableName}`");
            $columnsData = [];

            if (is_array($columns)) {
                $columnsData = $columns;
            } else {
                $columnsData = $columns->fetchAll(PDO::FETCH_ASSOC);
            }

            foreach ($columnsData as $col) {
                $field = $col['Field'] ?? $col[0];

                // Пропускаем проблемные поля
                if (in_array($field, ['nsched_activate', 'nsched_deactivate'])) {
                    echo "<div class='skipped'>Пропускаем поле: {$field}</div>";
                    continue;
                }

                $type = $col['Type'] ?? $col[1];

                // Уменьшаем длину индексированных VARCHAR столбцов
                if (preg_match('/varchar\((\d+)\)/i', $type, $matches)) {
                    $length = (int)$matches[1];
                    if ($length > 191) {
                        $indexes = $db->query("SHOW INDEX FROM `{$tableName}` WHERE Column_name = '{$field}'");
                        $hasIndex = false;

                        if (is_array($indexes)) {
                            $hasIndex = !empty($indexes);
                        } else {
                            $hasIndex = $indexes->rowCount() > 0;
                        }

                        if ($hasIndex) {
                            $newType = str_replace("varchar({$length})", "varchar(191)", $type);
                            executeSqlWithReporting(
                                $db,
                                "ALTER TABLE `{$tableName}` MODIFY `{$field}` {$newType} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
                            );
                        }
                    }
                }
            }

            echo "<div class='success'>Таблица успешно конвертирована</div>";
            echo "</div>";
        }

        // 8. Обновляем версию базы данных до 5
        executeSqlWithReporting($db, "UPDATE " . prefix . "_config SET value = '5' WHERE name = 'database.engine.revision'");
        executeSqlWithReporting($db, "UPDATE " . prefix . "_config SET value = '" . engineVersion . "' WHERE name = 'database.engine.version'");

        echo "<div class='action'><div class='status success'>Конвертация базы {$dbName} успешно завершена! Версия базы обновлена до 5.</div></div>";
    } catch (Exception $e) {
        echo "<div class='action'><div class='status error'>Ошибка: " . htmlspecialchars($e->getMessage()) . "</div></div>";
        throw $e;
    }
}

/**
 * Выполняет SQL запрос с подробным отчетом
 */
function executeSqlWithReporting($db, $sql): void
{
    echo "<div class='action'>";
    echo "<div class='sql-query'><code>" . htmlspecialchars($sql) . "</code></div>";
    echo "<div class='status'>";

    try {
        $result = $db->exec($sql);
        if ($result === null) {
            throw new Exception("Ошибка выполнения запроса");
        }
        echo "<span class='success'><i class='icon-success'></i> Успешно</span>";
    } catch (Exception $e) {
        echo "<span class='error'><i class='icon-error'></i> Ошибка: " . htmlspecialchars($e->getMessage()) . "</span>";
        echo "</div></div>";
        throw $e;
    }

    echo "</div></div>";
}

/**
 * Проверяет существование столбца
 */
function columnExists($db, $table, $column): bool
{
    $result = $db->record(
        "SELECT COUNT(*) AS cnt FROM information_schema.columns 
        WHERE table_schema = DATABASE() 
        AND table_name = '{$table}' 
        AND column_name = '{$column}'"
    );

    return $result && $result['cnt'] > 0;
}

/**
 * Шапка страницы обновления
 */
function renderUpgradeHeader(int $current, int $target): string
{
    return <<<HTML
    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Обновление базы данных NGCMS</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                line-height: 1.6;
                color: #333;
                background: #f5f7fa;
                padding: 20px;
                max-width: 1000px;
                margin: 0 auto;
            }
            .header {
                background: #2c3e50;
                color: white;
                padding: 20px;
                border-radius: 5px;
                margin-bottom: 30px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .upgrade-step {
                background: white;
                border-radius: 5px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .step-actions {
                margin-top: 15px;
            }
            .action {
                padding: 10px;
                margin-bottom: 10px;
                border-left: 4px solid #eee;
            }
            .sql-query {
                font-family: Consolas, Monaco, 'Andale Mono', monospace;
                font-size: 14px;
                color: #555;
                margin-bottom: 5px;
            }
            .status {
                font-weight: 500;
            }
            .success {
                color: #27ae60;
            }
            .skipped {
                color: #f39c12;
            }
            .error {
                color: #e74c3c;
            }
            .icon-success:before {
                content: "✓";
                margin-right: 5px;
            }
            .icon-skip:before {
                content: "↷";
                margin-right: 5px;
            }
            .icon-error:before {
                content: "✗";
                margin-right: 5px;
            }
            .icon-version:before {
                content: "➤";
                margin-right: 10px;
                color: #3498db;
            }
            .btn {
                display: inline-block;
                background: #3498db;
                color: white;
                padding: 10px 20px;
                text-decoration: none;
                border-radius: 5px;
                font-weight: 500;
                margin-top: 20px;
                transition: background 0.3s;
            }
            .btn:hover {
                background: #2980b9;
            }
            .success-message {
                background: #27ae60;
                color: white;
                padding: 20px;
                border-radius: 5px;
                text-align: center;
                margin-top: 20px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
        </style>
    </head>
    <body>
        <div class="header">
            <h1>Обновление базы данных NGCMS</h1>
            <p>Текущая версия: {$current} → Новая версия: {$target}</p>
        </div>
    HTML;
}

/**
 * Сообщение об успешном завершении
 */
function renderSuccessMessage(): string
{
    return <<<HTML
    <div class="success-message">
        <h2><i class="icon-success"></i> Обновление успешно завершено!</h2>
        <p>База данных была успешно обновлена до последней версии.</p>
    </div>
    HTML;
}

/**
 * Сообщение, что обновление не требуется
 */
function renderNoUpgradeNeeded(): string
{
    return <<<HTML
    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Статус базы данных NGCMS</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                line-height: 1.6;
                color: #333;
                background: #f5f7fa;
                padding: 20px;
                max-width: 1000px;
                margin: 0 auto;
                text-align: center;
            }
            .message {
                background: #27ae60;
                color: white;
                padding: 30px;
                border-radius: 5px;
                margin: 50px auto;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                max-width: 600px;
            }
            .btn {
                display: inline-block;
                background: #3498db;
                color: white;
                padding: 12px 25px;
                text-decoration: none;
                border-radius: 5px;
                font-weight: 500;
                margin-top: 20px;
                transition: background 0.3s;
            }
            .btn:hover {
                background: #2980b9;
            }
        </style>
    </head>
    <body>
        <div class="message">
            <h2>База данных актуальна</h2>
            <p>Ваша база данных уже имеет последнюю версию. Обновление не требуется.</p>
            <a href="admin.php" class="btn">Перейти в панель управления</a>
        </div>
    </body>
    </html>
    HTML;
}

/**
 * Подвал страницы с кнопкой
 */
function renderFooter(): void
{
    echo <<<HTML
        <div style="text-align: center; margin-top: 30px;">
            <a href="admin.php" class="btn">
                <i class="icon-admin"></i> Перейти в панель управления
            </a>
        </div>
    </body>
    </html>
    HTML;
}
