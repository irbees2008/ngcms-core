<?php

/**
 * Инструмент обновления базы данных NGCMS
 *
 * @copyright Copyright (C) 2008-2025 Next Generation CMS (http://ngcms.org/)
 * @license MIT
 */
if (PHP_SAPI === 'cli') {
    set_time_limit(0);

    $upgradeHost = getenv('NGCMS_UPGRADE_HOST');
    $_SERVER['HTTP_HOST'] = $upgradeHost ? $upgradeHost : 'localhost';
    $_SERVER['SERVER_NAME'] = $_SERVER['HTTP_HOST'];
    $_SERVER['REQUEST_URI'] = '/engine/upgrade.php';
    $_SERVER['PHP_SELF'] = '/engine/upgrade.php';
    $_SERVER['SERVER_PROTOCOL'] = 'HTTP/1.1';
    $_SERVER['REMOTE_ADDR'] = '127.0.0.1';
    $_SERVER['HTTP_USER_AGENT'] = 'NGCMS database upgrade CLI';
}
require_once __DIR__ . '/core.php';
LoadLang('upgrade', 'admin', 'upgrade');
ob_start('translateUpgradeOutput');
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
    6 => [
        // Выполняется отдельно в doUpgrade(), чтобы проверять наличие таблицы и поля.
    ],
    7 => [
        "UPDATE " . prefix . "_config SET value = 7 WHERE name = 'database.engine.revision'",
    ],
    8 => [
        // Проверка и добавление поля cat_show выполняется в doUpgrade()
        "UPDATE " . prefix . "_config SET value = 8 WHERE name = 'database.engine.revision'",
    ],
    9 => [
        // Обновление схемы ads_pro выполняется до фиксации новой ревизии.
        "UPDATE " . prefix . "_config SET value = 9 WHERE name = 'database.engine.revision'",
    ],
    10 => [
        "UPDATE " . prefix . "_config SET value = 10 WHERE name = 'database.engine.revision'",
    ],
    11 => [
        "UPDATE " . prefix . "_config SET value = 11 WHERE name = 'database.engine.revision'",
    ],
    12 => [
        "UPDATE " . prefix . "_config SET value = 12 WHERE name = 'database.engine.revision'",
    ],
    13 => [
        "UPDATE " . prefix . "_config SET value = 13 WHERE name = 'database.engine.revision'",
    ],
];
function translateUpgradeOutput(string $output): string
{
    global $config, $lang;
    if (($config['default_lang'] ?? 'russian') === 'russian') {
        return $output;
    }

    $sourceFile = root . 'lang/russian/admin/upgrade.ini';
    $sourceMessages = is_file($sourceFile)
        ? parse_ini_file($sourceFile, false, INI_SCANNER_RAW)
        : false;
    $targetMessages = $lang['upgrade'] ?? [];
    if (is_array($sourceMessages)) {
        $translations = [];
        foreach ($sourceMessages as $key => $sourceText) {
            if (isset($targetMessages[$key]) && $sourceText !== $targetMessages[$key]) {
                $translations[$sourceText] = $targetMessages[$key];
            }
        }
        $output = strtr($output, $translations);
    }

    return str_replace('<html lang="ru">', '<html lang="en">', $output);
}
// Получаем текущую версию БД
$currentVersion = getCurrentDBVersion();
// Проверяем необходимость обновления
if ($currentVersion < minDBVersion) {
    echo renderUpgradeHeader($currentVersion, minDBVersion);
    doUpgrade($currentVersion + 1, minDBVersion);
} else {
    // Проверяем и восстанавливаем plugdata.php если нужно (одноразовая операция)
    checkAndRepairPlugdataFile($currentVersion);
    echo renderNoUpgradeNeeded();
}
/**
 * Проверяет и восстанавливает файл plugdata.php если нужно
 */
function checkAndRepairPlugdataFile($currentVersion): void
{
    // Выполняем восстановление только если версия БД >= 7 (после основных обновлений)
    // и только один раз
    if ($currentVersion >= 7) {
        $repairDone = checkRepairStatus();
        if (!$repairDone) {
            echo "<div style='max-width:1000px; margin:20px auto; padding:20px; background:#f8f9fa; border-radius:5px;'>";
            echo "<h3>Проверка файла настроек плагинов</h3>";
            repairPlugdataFile();
            markRepairAsDone();
            echo "</div>";
        }
    }
}
/**
 * Проверяет, было ли уже выполнено восстановление
 */
function checkRepairStatus(): bool
{
    $db = NGEngine::getInstance()->getDB();
    try {
        $result = $db->record(
            "SELECT value FROM " . prefix . "_config WHERE name = 'plugdata.repair.done'"
        );
        return is_array($result) && $result['value'] == '1';
    } catch (Exception $e) {
        // Если таблицы нет или произошла ошибка, считаем что восстановление не делалось
        return false;
    }
}
/**
 * Помечает восстановление как выполненное
 */
function markRepairAsDone(): void
{
    $db = NGEngine::getInstance()->getDB();
    try {
        $db->exec(
            "INSERT INTO " . prefix . "_config (name, value) VALUES ('plugdata.repair.done', '1')
             ON DUPLICATE KEY UPDATE value = '1'"
        );
    } catch (Exception $e) {
        // Игнорируем ошибки при записи статуса
    }
}
/**
 * Получает текущую версию БД
 */
function getCurrentDBVersion(): int
{
    $db = NGEngine::getInstance()->getDB();
    try {
        $versionRecord = $db->record(
            "SELECT * FROM " . prefix . "_config WHERE name = 'database.engine.revision'"
        );
        return is_array($versionRecord) ? (int)$versionRecord['value'] : 0;
    } catch (Exception $e) {
        return 0;
    }
}
/**
 * Выполняет обновление БД
 */
function doUpgrade(int $fromVersion, int $toVersion): void
{
    global $upgradeMatrix;
    $db = NGEngine::getInstance()->getDB();
    $db->setQueryLogging(false);
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
            // Специальная логика для определенных версий
            if ($version == 6) {
                // Обновление таблицы новостей - проверяем наличие поля xfields
                echo "<h4>Обновление таблицы новостей</h4>";
                $newsTable = prefix . '_news';
                // Проверяем существование поля xfields
                if (columnExists($db, $newsTable, 'xfields')) {
                    echo "<div class='action'><div class='status'>Поле 'xfields' найдено, выполняем обновление...</div></div>";
                    // Меняем тип поля обратно на MEDIUMTEXT (оптимальный вариант)
                    executeSqlWithReporting($db, "ALTER TABLE " . prefix . "_news MODIFY xfields MEDIUMTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
                    // Восстанавливаем поврежденные данные
                    executeSqlWithReporting($db, "UPDATE " . prefix . "_news SET xfields = REPLACE(xfields, 'SER[a:', 'SER|a:') WHERE xfields LIKE 'SER[a:%'");
                    executeSqlWithReporting($db, "UPDATE " . prefix . "_news SET xfields = '' WHERE xfields LIKE 'SER|a:%' AND xfields NOT LIKE '%}'");
                    echo "<div class='action'><div class='success'>Поле 'xfields' успешно обновлено</div></div>";
                } else {
                    echo "<div class='action'><div class='skipped'>Поле 'xfields' не найдено в таблице новостей. Обновление пропущено.</div></div>";
                }
                // Обновляем версию БД
                executeSqlWithReporting($db, "UPDATE " . prefix . "_config SET value = 6 WHERE name = 'database.engine.revision'");
            }
            if ($version == 7) {
                // Обновление плагина комментариев - ДОБАВЛЯЕМ ПОЛЕ moderated
                echo "<h4>Обновление плагина комментариев</h4>";
                $commentsTable = prefix . '_comments';
                try {
                    $tableExistsResult = $db->query("SHOW TABLES LIKE '{$commentsTable}'");
                    $tableExists = false;
                    if (is_array($tableExistsResult)) {
                        $tableExists = count($tableExistsResult) > 0;
                    } elseif ($tableExistsResult) {
                        $tableExists = $tableExistsResult->rowCount() > 0;
                    }
                    if ($tableExists) {
                        echo "<div class='action'><div class='status'>Таблица комментариев `{$commentsTable}` найдена.</div></div>";
                        // Проверяем наличие поля 'moderated'
                        if (!columnExists($db, $commentsTable, 'moderated')) {
                            executeSqlWithReporting($db, "ALTER TABLE `{$commentsTable}` ADD `moderated` TINYINT(1) NOT NULL DEFAULT '1'");
                            echo "<div class='action'><div class='success'>Поле 'moderated' успешно добавлено</div></div>";
                        } else {
                            echo "<div class='action'><div class='skipped'>Поле 'moderated' уже существует.</div></div>";
                        }
                    } else {
                        echo "<div class='action'><div class='skipped'>Плагин комментариев не установлен (таблица `{$commentsTable}` не найдена). Обновление пропущено.</div></div>";
                    }
                } catch (Exception $e) {
                    echo "<div class='action'><div class='status error'>Ошибка при обновлении плагина комментариев: " . htmlspecialchars($e->getMessage()) . "</div></div>";
                }

                // Создание таблицы сессий пользователей
                echo "<h4>Проверка таблицы сессий пользователей</h4>";
                $sessionsTable = prefix . '_users_sessions';
                try {
                    $tableExistsResult = $db->query("SHOW TABLES LIKE '{$sessionsTable}'");
                    $tableExists = false;
                    if (is_array($tableExistsResult)) {
                        $tableExists = count($tableExistsResult) > 0;
                    } elseif ($tableExistsResult) {
                        $tableExists = $tableExistsResult->rowCount() > 0;
                    }

                    if (!$tableExists) {
                        echo "<div class='action'><div class='status'>Таблица `{$sessionsTable}` не найдена, создаем...</div></div>";
                        $createTableSql = "CREATE TABLE `{$sessionsTable}` (
                            `userID` int NOT NULL,
                            `ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
                            `last` int NOT NULL DEFAULT '0',
                            `authcookie` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                            KEY `userUpdate` (`userID`,`authcookie`),
                            KEY `users_auth` (`authcookie`)
                        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";
                        executeSqlWithReporting($db, $createTableSql);
                        echo "<div class='action'><div class='success'>Таблица `{$sessionsTable}` успешно создана</div></div>";
                    } else {
                        echo "<div class='action'><div class='skipped'>Таблица `{$sessionsTable}` уже существует</div></div>";
                    }
                } catch (Exception $e) {
                    echo "<div class='action'><div class='status error'>Ошибка при создании таблицы сессий: " . htmlspecialchars($e->getMessage()) . "</div></div>";
                }
            }
            // Специальная обработка для версии 8
            if ($version == 8) {
                echo "<h4>Обновление таблицы категорий</h4>";
                $categoryTable = prefix . '_category';
                // Проверяем наличие поля 'cat_show'
                if (!columnExists($db, $categoryTable, 'cat_show')) {
                    echo "<div class='action'><div class='status'>Поле 'cat_show' не найдено, добавляем...</div></div>";
                    executeSqlWithReporting($db, "ALTER TABLE `{$categoryTable}` ADD COLUMN `cat_show` TINYINT(1) NOT NULL DEFAULT 0 AFTER `poslevel`");
                    echo "<div class='action'><div class='success'>Поле 'cat_show' успешно добавлено</div></div>";
                } else {
                    echo "<div class='action'><div class='skipped'>Поле 'cat_show' уже существует, пропускаем</div></div>";
                }
            }
            if ($version == 9) {
                echo "<h4>Обновление схемы плагина ads_pro</h4>";
                upgradeAdsProSchema($db);
            }
            if ($version == 10) {
                echo "<h4>Индексы для ускорения страниц категорий новостей</h4>";
                upgradeNewsCategoryIndexes($db);
            }
            if ($version == 11) {
                echo "<h4>Индекс для фильтра категорий в админском списке новостей</h4>";
                upgradeNewsCategoryIndexes($db);
            }
            if ($version == 12) {
                echo "<h4>Индекс для быстрой пагинации списка новостей</h4>";
                upgradeNewsCategoryIndexes($db);
            }
            if ($version == 13) {
                echo "<h4>Индекс опубликованных новостей для сортировки по закреплению и дате</h4>";
                upgradeNewsCategoryIndexes($db);
            }
            // Фиксируем версию только после выполнения специальных изменений схемы.
            if ($version != 6 && !empty($upgradeMatrix[$version])) {
                foreach ($upgradeMatrix[$version] as $sql) {
                    executeSqlWithReporting($db, $sql);
                }
            }
        }
        echo "</div></div>";
    }
    if ($toVersion >= 7) {
        echo "<div class='upgrade-step'><h3>Файлы конфигурации и настройки плагинов</h3><div class='step-actions'>";
        checkAndRepairPlugdataFile($toVersion);
        echo "<h4>Обновление конфигурационного файла</h4>";
        updateConfigFile();
        echo "</div></div>";
    }
    // Восстановление стандартного режима SQL
    $db->exec("SET SQL_MODE=''");
    echo renderSuccessMessage();
    renderFooter();
}
/**
 * Добавляет только отсутствующие поля в существующую таблицу ads_pro.
 */
function upgradeAdsProSchema($db): void
{
    $tableName = prefix . '_ads_pro';
    $tableResult = $db->record(
        "SELECT COUNT(*) AS cnt FROM information_schema.tables "
            . "WHERE table_schema = DATABASE() AND table_name = '{$tableName}'"
    );
    if (!$tableResult || (int)$tableResult['cnt'] === 0) {
        echo "<div class='action'><div class='skipped'>Таблица ads_pro не найдена; плагин не установлен, пропускаем.</div></div>";
        return;
    }
    $fields = [
        'block_name' => "varchar(190) NOT NULL DEFAULT ''",
        'description' => 'text NULL',
        'type' => 'tinyint(1) NOT NULL DEFAULT 0',
        'state' => 'tinyint(1) NOT NULL DEFAULT 0',
        'start_view' => 'int(11) NOT NULL DEFAULT 0',
        'end_view' => 'int(11) NOT NULL DEFAULT 0',
        'location' => 'mediumtext NULL',
        'sort_order' => 'int(11) NOT NULL DEFAULT 0',
    ];
    $quotedTable = '`' . str_replace('`', '``', $tableName) . '`';
    foreach ($fields as $field => $definition) {
        if (!columnExists($db, $tableName, $field)) {
            executeSqlWithReporting(
                $db,
                "ALTER TABLE {$quotedTable} ADD COLUMN `{$field}` {$definition}"
            );
        }
    }
    echo "<div class='action'><div class='success'>Схема ads_pro проверена</div></div>";
}
/**
 * Создает индексы, используемые оптимизированной выборкой новостей.
 */
function upgradeNewsCategoryIndexes($db): void
{
    $indexes = [
        prefix . '_news' => [
            'idx_news_approved_order' => ['approve', 'catpinned', 'postdate', 'id'],
            'idx_news_home_order' => ['approve', 'mainpage', 'pinned', 'postdate'],
            'idx_news_approved_pinned_order' => ['approve', 'pinned', 'postdate', 'id'],
            'news_id_pagination' => ['id'],
        ],
        prefix . '_news_map' => [
            'idx_news_category' => ['newsID', 'categoryID'],
            'newsmap_category_news' => ['categoryID', 'newsID'],
        ],
    ];

    foreach ($indexes as $table => $tableIndexes) {
        foreach ($tableIndexes as $index => $columns) {
            $quotedTable = '`' . str_replace('`', '``', $table) . '`';
            $quotedIndex = '`' . str_replace('`', '``', $index) . '`';
            $columnList = implode(',', $columns);
            $existing = $db->record(
                "SELECT GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') AS columns "
                    . "FROM information_schema.statistics "
                    . "WHERE table_schema = DATABASE() "
                    . "AND table_name = '{$table}' "
                    . "AND index_name = '{$index}'"
            );
            if (is_array($existing) && $existing['columns'] !== null) {
                if ($existing['columns'] !== $columnList) {
                    throw new RuntimeException("Индекс {$index} таблицы {$table} существует с несовместимыми полями.");
                }
                echo "<div class='action'><div class='skipped'>Индекс {$index} уже существует.</div></div>";
                continue;
            }

            executeSqlWithReporting(
                $db,
                "ALTER TABLE {$quotedTable} ADD INDEX {$quotedIndex} (" . implode(', ', array_map(
                    static fn($column) => '`' . str_replace('`', '``', $column) . '`',
                    $columns
                )) . ')'
            );
        }
    }
}
/**
 * Обновляет конфигурационный файл, добавляя параметр admin_skin если его нет
 */
function updateConfigFile(): void
{
    $configFile = confroot . 'config.php';
    echo "<div class='action'>";
    echo "<div class='status'>Проверка конфигурационного файла: " . htmlspecialchars($configFile) . "</div>";
    if (!file_exists($configFile)) {
        echo "<div class='skipped'>Файл конфигурации не существует</div>";
        echo "</div>";
        return;
    }
    // Читаем содержимое файла
    $content = file_get_contents($configFile);
    // Проверяем, существует ли уже параметр admin_skin
    if (strpos($content, "'admin_skin'") !== false) {
        echo "<div class='skipped'>Параметр 'admin_skin' уже существует</div>";
        echo "</div>";
        return;
    }
    // Ищем позицию строки 'theme'
    $themePos = strpos($content, "'theme'");
    if ($themePos === false) {
        echo "<div class='error'>Параметр 'theme' не найден в конфигурационном файле</div>";
        echo "</div>";
        return;
    }
    // Находим конец строки с theme (ищем запятую)
    $endPos = strpos($content, "',", $themePos);
    if ($endPos === false) {
        // Если нет запятой, ищем закрывающую кавычку
        $endPos = strpos($content, "'", $themePos + 7);
    }
    if ($endPos === false) {
        echo "<div class='error'>Не удалось определить конец строки 'theme'</div>";
        echo "</div>";
        return;
    }
    // Вставляем новую строку после theme
    $newContent = substr_replace($content, ",\n  'admin_skin' => 'default'", $endPos + 1, 0);
    // Создаем резервную копию
    $backupFile = $configFile . '.backup_' . date('Ymd_His');
    file_put_contents($backupFile, $content);
    // Записываем обновленное содержимое
    if (file_put_contents($configFile, $newContent)) {
        echo "<div class='success'>Параметр 'admin_skin' => 'default' успешно добавлен после 'theme'</div>";
        echo "<div class='status'>Резервная копия: " . basename($backupFile) . "</div>";
    } else {
        echo "<div class='error'>Ошибка записи в файл конфигурации</div>";
    }
    echo "</div>";
}
/**
 * Восстанавливает файл plugdata.php
 */
function repairPlugdataFile(): void
{
    $plugdataFile = confroot . 'plugdata.php';
    echo "<div class='action'>";
    echo "<div class='status'>Проверка файла: " . htmlspecialchars($plugdataFile) . "</div>";
    // Если файла нет - просто выходим, не создаем новый
    if (!file_exists($plugdataFile)) {
        echo "<div class='skipped'>Файл не существует. Плагины будут использовать настройки по умолчанию.</div>";
        echo "</div>";
        return;
    }
    $content = file_get_contents($plugdataFile);
    $content = trim($content);
    // Проверка на BOM
    if (substr($content, 0, 3) === "\xEF\xBB\xBF") {
        $content = substr($content, 3);
        echo "<div class='status'>Обнаружен и удален BOM</div>";
    }
    // Пробуем десериализовать
    $data = @unserialize($content);
    if (is_array($data)) {
        echo "<div class='success'>Файл корректный, восстановление не требуется</div>";
    } else {
        echo "<div class='error'>Файл поврежден, пытаемся восстановить...</div>";
        // Пробуем восстановить
        $repaired = repairSerializedData($content);
        if ($repaired !== $content) {
            // Проверяем восстановленные данные
            $testData = @unserialize($repaired);
            if (is_array($testData)) {
                // Создаем резервную копию
                $backupFile = $plugdataFile . '.backup_' . date('Ymd_His');
                file_put_contents($backupFile, $content);
                // Сохраняем исправленную версию
                file_put_contents($plugdataFile, $repaired);
                echo "<div class='success'>Файл успешно восстановлен! Резервная копия: " . basename($backupFile) . "</div>";
            } else {
                echo "<div class='error'>Автоматическое восстановление не удалось. Файл остался без изменений.</div>";
            }
        } else {
            echo "<div class='error'>Не удалось восстановить автоматически. Файл остался без изменений.</div>";
        }
    }
    echo "</div>";
}
/**
 * Восстанавливает сериализованные данные
 */
function repairSerializedData($data)
{
    // 1. Убираем лишние символы в начале/конце
    $data = trim($data);
    // 2. Проверяем корректность структуры
    if (substr($data, 0, 2) !== 'a:') {
        // Пробуем найти начало массива
        if (preg_match('/a:\d+:\{/', $data, $matches, PREG_OFFSET_CAPTURE)) {
            $startPos = $matches[0][1];
            $data = substr($data, $startPos);
        } else {
            return $data;
        }
    }
    // 3. Исправляем некорректные длины строк
    $data = preg_replace_callback('/s:(\d+):"([^"]*)";/', function ($matches) {
        $correctLength = strlen($matches[2]);
        return 's:' . $correctLength . ':"' . $matches[2] . '";';
    }, $data);
    // 4. Исправляем проблемы с кодировкой
    if (function_exists('mb_convert_encoding')) {
        $data = mb_convert_encoding($data, 'UTF-8', 'UTF-8');
    }
    // 5. Исправляем распространенные проблемы с сериализацией NGCMS
    $data = str_replace('SER[a:', 'SER|a:', $data);
    return $data;
}
/**
 * Получает тип столбца
 */
function getColumnType($db, $table, $column): string
{
    $result = $db->record(
        "SELECT COLUMN_TYPE FROM information_schema.columns
        WHERE table_schema = DATABASE()
        AND table_name = '{$table}'
        AND column_name = '{$column}'"
    );
    return $result['COLUMN_TYPE'] ?? '';
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
        // 5. Обрабатываем таблицу ng_tags_tmp_export отдельно
        if (in_array('ng_tags_tmp_export', $tables)) {
            echo "<div class='action'>";
            echo "<h4>Обработка временной таблицы тегов: ng_tags_tmp_export</h4>";
            // Проверяем существование индекса 'tag'
            $indexExists = false;
            $indexResult = $db->query("SHOW INDEX FROM `ng_tags_tmp_export` WHERE Key_name = 'tag'");
            if (is_array($indexResult)) {
                $indexExists = !empty($indexResult);
            } else {
                $indexExists = $indexResult->rowCount() > 0;
            }
            // Удаляем уникальный индекс если существует
            if ($indexExists) {
                executeSqlWithReporting($db, "ALTER TABLE `ng_tags_tmp_export` DROP INDEX `tag`");
                echo "<div class='success'>Уникальный индекс 'tag' удален</div>";
            }
            // Удаляем дубликаты тегов (более надежный способ)
            try {
                // Создаем временную таблицу с уникальными тегами
                executeSqlWithReporting($db, "CREATE TEMPORARY TABLE temp_unique_tags AS
            SELECT MIN(id) as min_id, tag, COUNT(*) as cnt
            FROM ng_tags_tmp_export
            GROUP BY tag
            HAVING COUNT(*) > 1");
                // Показываем информацию о дубликатах
                $dupResult = $db->query("SELECT COUNT(*) as duplicate_count FROM temp_unique_tags");
                $dupCount = 0;
                if (is_array($dupResult)) {
                    $dupCount = $dupResult[0]['duplicate_count'] ?? 0;
                } else {
                    $dupRow = $dupResult->fetch(PDO::FETCH_ASSOC);
                    $dupCount = $dupRow['duplicate_count'] ?? 0;
                }
                echo "<div class='status'>Найдено дубликатов: {$dupCount}</div>";
                if ($dupCount > 0) {
                    // Удаляем дубликаты, оставляя только первую запись
                    executeSqlWithReporting($db, "DELETE t1 FROM ng_tags_tmp_export t1
                INNER JOIN temp_unique_tags t2 ON t1.tag = t2.tag
                WHERE t1.id != t2.min_id");
                    echo "<div class='success'>Дубликаты удалены</div>";
                }
                // Удаляем временную таблицу
                executeSqlWithReporting($db, "DROP TEMPORARY TABLE temp_unique_tags");
            } catch (Exception $e) {
                echo "<div class='skipped'>Ошибка при удалении дубликатов: " . htmlspecialchars($e->getMessage()) . "</div>";
                // Продолжаем выполнение даже если не удалось удалить дубликаты
            }
            // Конвертируем таблицу
            executeSqlWithReporting($db, "ALTER TABLE `ng_tags_tmp_export` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            // Восстанавливаем уникальный индекс (если он был)
            if ($indexExists) {
                try {
                    // Проверяем, что нет дубликатов перед созданием индекса
                    $dupCheck = $db->query("SELECT COUNT(*) as total, COUNT(DISTINCT tag) as unique_count FROM ng_tags_tmp_export");
                    $checkData = [];
                    if (is_array($dupCheck)) {
                        $checkData = $dupCheck[0] ?? [];
                    } else {
                        $checkData = $dupCheck->fetch(PDO::FETCH_ASSOC);
                    }
                    $total = $checkData['total'] ?? 0;
                    $unique = $checkData['unique_count'] ?? 0;
                    if ($total == $unique) {
                        executeSqlWithReporting($db, "ALTER TABLE `ng_tags_tmp_export` ADD UNIQUE INDEX `tag` (`tag`)");
                        echo "<div class='success'>Уникальный индекс 'tag' восстановлен</div>";
                    } else {
                        echo "<div class='skipped'>Не удалось восстановить уникальный индекс: остались дубликаты тегов</div>";
                        // Создаем обычный индекс вместо уникального
                        executeSqlWithReporting($db, "ALTER TABLE `ng_tags_tmp_export` ADD INDEX `tag` (`tag`)");
                        echo "<div class='success'>Создан обычный индекс 'tag'</div>";
                    }
                } catch (Exception $e) {
                    echo "<div class='skipped'>Не удалось восстановить индекс: " . htmlspecialchars($e->getMessage()) . "</div>";
                }
            }
            echo "<div class='success'>Таблица успешно конвертирована</div>";
            echo "</div>";
            // Удаляем обработанную таблицу из списка
            $tables = array_diff($tables, ['ng_tags_tmp_export']);
        }
        // 6. Обрабатываем остальные таблицы
        // 5b. Обрабатываем все таблицы тегов (устранение дубликатов перед конвертацией)
        // Ищем все таблицы формата *_tags (кроме временных *_tmp_*)
        $tagTables = array_filter($tables, function ($table) {
            return preg_match('/_tags$/', $table) && strpos($table, '_tmp_') === false;
        });
        foreach ($tagTables as $tagTable) {
            echo "<div class='action'>";
            echo "<h4>Обработка таблицы тегов: {$tagTable}</h4>";
            try {
                // Проверяем наличие поля tag
                if (!columnExists($db, $tagTable, 'tag')) {
                    echo "<div class='skipped'>Таблица не содержит поле 'tag', обычная обработка</div>";
                    echo "</div>";
                    continue;
                }
                // Определяем индекс по полю tag и его уникальность
                $indexInfo = $db->query("SHOW INDEX FROM `{$tagTable}` WHERE Column_name = 'tag'");
                $indexRows = [];
                if (is_array($indexInfo)) {
                    $indexRows = $indexInfo;
                } else if ($indexInfo) {
                    $indexRows = $indexInfo->fetchAll(PDO::FETCH_ASSOC);
                }
                $hasTagIndex = !empty($indexRows);
                $keyName = 'tag';
                $isUnique = false;
                if ($hasTagIndex) {
                    $first = $indexRows[0];
                    $keyName = $first['Key_name'] ?? $keyName;
                    // Non_unique == 0 означает уникальный индекс
                    foreach ($indexRows as $row) {
                        $nonUnique = isset($row['Non_unique']) ? (int)$row['Non_unique'] : 1;
                        if ($nonUnique === 0) {
                            $isUnique = true;
                            $keyName = $row['Key_name'] ?? $keyName;
                            break;
                        }
                    }
                }
                // Если индекс уникальный – временно снимаем его, чтобы можно было удалить дубликаты
                if ($isUnique) {
                    executeSqlWithReporting($db, "ALTER TABLE `{$tagTable}` DROP INDEX `{$keyName}`");
                    echo "<div class='success'>Уникальный индекс по полю 'tag' временно удален</div>";
                }
                // Ищем и удаляем дубликаты значений tag, оставляя минимальный id
                $tempTable = "temp_" . str_replace('-', '_', $tagTable) . "_dedup";
                executeSqlWithReporting($db, "CREATE TEMPORARY TABLE `{$tempTable}` AS
                        SELECT MIN(id) as keep_id, tag, COUNT(*) as cnt
                        FROM `{$tagTable}`
                        GROUP BY tag
                        HAVING COUNT(*) > 1");
                $dupResult = $db->query("SELECT COUNT(*) as duplicate_count FROM `{$tempTable}`");
                $dupCount = 0;
                if (is_array($dupResult)) {
                    $dupCount = $dupResult[0]['duplicate_count'] ?? 0;
                } else if ($dupResult) {
                    $dupRow = $dupResult->fetch(PDO::FETCH_ASSOC);
                    $dupCount = $dupRow['duplicate_count'] ?? 0;
                }
                echo "<div class='status'>Найдено дубликатов тегов: {$dupCount}</div>";
                if ($dupCount > 0) {
                    executeSqlWithReporting($db, "DELETE t1 FROM `{$tagTable}` t1
                            INNER JOIN `{$tempTable}` d ON t1.tag = d.tag
                            WHERE t1.id <> d.keep_id");
                    echo "<div class='success'>Дубликаты строк в {$tagTable} удалены</div>";
                } else {
                    echo "<div class='skipped'>Дубликаты не обнаружены</div>";
                }
                executeSqlWithReporting($db, "DROP TEMPORARY TABLE `{$tempTable}`");
                // Конвертируем таблицу в utf8mb4
                executeSqlWithReporting($db, "ALTER TABLE `{$tagTable}` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
                // Пытаемся восстановить индекс по полю tag
                $checkRes = $db->query("SELECT COUNT(*) as total, COUNT(DISTINCT tag) as unique_count FROM `{$tagTable}`");
                $total = 0;
                $unique = 0;
                if (is_array($checkRes)) {
                    $total = (int)($checkRes[0]['total'] ?? 0);
                    $unique = (int)($checkRes[0]['unique_count'] ?? 0);
                } else if ($checkRes) {
                    $checkRow = $checkRes->fetch(PDO::FETCH_ASSOC);
                    $total = (int)($checkRow['total'] ?? 0);
                    $unique = (int)($checkRow['unique_count'] ?? 0);
                }
                if ($total === $unique) {
                    // Все значения уникальны – создаем уникальный индекс
                    executeSqlWithReporting($db, "ALTER TABLE `{$tagTable}` ADD UNIQUE INDEX `tag` (`tag`)");
                    echo "<div class='success'>Уникальный индекс по полю 'tag' восстановлен</div>";
                } else {
                    // Есть дубликаты – создаем обычный индекс
                    executeSqlWithReporting($db, "ALTER TABLE `{$tagTable}` ADD INDEX `tag` (`tag`)");
                    echo "<div class='skipped'>Остались дубликаты значений 'tag' – создан обычный индекс</div>";
                }
            } catch (Exception $e) {
                echo "<div class='skipped'>Ошибка при обработке {$tagTable}: " . htmlspecialchars($e->getMessage()) . "</div>";
                // Продолжаем обработку остальных таблиц
            }
            echo "<div class='success'>Таблица {$tagTable} успешно обработана</div>";
            echo "</div>";
            // Исключаем таблицу из общего списка, чтобы не обрабатывать её повторно
            $tables = array_diff($tables, [$tagTable]);
        }
        // 6. Обрабатываем остальные таблицы
        foreach ($tables as $tableName) {
            echo "<div class='action'>";
            echo "<h4>Обработка таблицы: {$tableName}</h4>";
            // Проверяем наличие поля xfields
            $hasXfields = columnExists($db, $tableName, 'xfields');
            if ($hasXfields) {
                echo "<div class='status'>Обнаружено поле xfields - особая обработка</div>";
                // Шаг 1: Определяем текущий тип поля
                $currentType = getColumnType($db, $tableName, 'xfields');
                // Сохраняем исходные байты сериализованных значений до смены кодировки.
                $backupTable = "backup_{$tableName}_xfields";
                executeSqlWithReporting($db, "CREATE TEMPORARY TABLE `{$backupTable}` AS SELECT id, xfields FROM `{$tableName}` WHERE xfields != ''");
                $createResult = $db->query("SHOW CREATE TABLE `{$tableName}`");
                $createTable = is_array($createResult)
                    ? ($createResult[0]['Create Table'] ?? $createResult[0][1] ?? '')
                    : ($createResult->fetch(PDO::FETCH_NUM)[1] ?? '');
                if (strpos($createTable, 'CHARSET=utf8mb4') === false) {
                    executeSqlWithReporting($db, "ALTER TABLE `{$tableName}` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
                } else {
                    echo "<div class='skipped'>Таблица уже в utf8mb4, пропускаем конвертацию кодировки</div>";
                }
                // Восстанавливаем MEDIUMTEXT тип для xfields (не LONGTEXT!)
                if (stripos($currentType, 'longtext') === false) {
                    executeSqlWithReporting($db, "ALTER TABLE `{$tableName}` MODIFY `xfields` MEDIUMTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
                }
                executeSqlWithReporting($db, "ALTER TABLE `{$backupTable}` ADD INDEX (`id`)");
                executeSqlWithReporting(
                    $db,
                    "UPDATE `{$tableName}` AS target INNER JOIN `{$backupTable}` AS backup ON target.id = backup.id "
                        . "SET target.xfields = backup.xfields "
                        . "WHERE NOT (BINARY target.xfields <=> BINARY backup.xfields)"
                );
                // Очищаем поврежденные значения только после восстановления исходных данных.
                executeSqlWithReporting(
                    $db,
                    "UPDATE `{$tableName}` SET xfields = '' WHERE BINARY xfields LIKE 'SER|a:%' "
                        . "AND (RIGHT(xfields, 1) <> '}' OR BINARY xfields NOT REGEXP '^SER[|]a:[0-9]+:[{]')"
                );
                executeSqlWithReporting($db, "DROP TEMPORARY TABLE `{$backupTable}`");
                echo "<div class='success'>Проверка данных xfields завершена (MEDIUMTEXT)</div>";
            } else {
                // 7. Проверяем текущую кодировку таблицы
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
                // 8. Конвертируем таблицу
                executeSqlWithReporting($db, "ALTER TABLE `{$tableName}` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            }
            // 9. Обрабатываем проблемные столбцы (только для таблиц без xfields)
            if (!$hasXfields) {
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
            }
            echo "<div class='success'>Таблица успешно конвертирована</div>";
            echo "</div>";
        }
        // 10. Обновляем версию базы данных до 5
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
            <p>Для больших баз данных запускайте обновление через PHP CLI из корня сайта: <code>php -d max_execution_time=0 engine/upgrade.php</code>. Для мультисайта перед запуском задайте переменную окружения <code>NGCMS_UPGRADE_HOST</code> с доменом сайта. Не запускайте CLI, пока предыдущий процесс обновления еще выполняется.</p>
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
        <a href="/engine" class="btn">Перейти в панель управления</a>
    </div>
    HTML;
}
/**
 * Сообщение о ненужности обновления
 */
function renderNoUpgradeNeeded(): string
{
    return <<<HTML
    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8">
        <title>Обновление не требуется</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                text-align: center;
                padding: 50px;
                background: #f5f7fa;
            }
            .message {
                background: white;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                max-width: 500px;
                margin: 0 auto;
            }
            .success {
                color: #27ae60;
                font-size: 24px;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <div class="message">
            <div class="success">✓</div>
            <h2>Обновление не требуется</h2>
            <p>Ваша база данных уже актуальна.</p>
            <a href="/engine" style="display: inline-block; margin-top: 20px; padding: 10px 20px; background: #3498db; color: white; text-decoration: none; border-radius: 5px;">Перейти в панель управления</a>
        </div>
    </body>
    </html>
    HTML;
}
/**
 * Подвал страницы
 */
function renderFooter(): void
{
    echo <<<HTML
        </body>
    </html>
    HTML;
}
