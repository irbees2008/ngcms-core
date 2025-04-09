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

        foreach ($upgradeMatrix[$version] as $sql) {
            echo "<div class='action'>";
            echo "<div class='sql-query'><code>" . htmlspecialchars($sql) . "</code></div>";
            echo "<div class='status'>";

            try {
                // Проверка для ADD COLUMN
                if (strpos($sql, 'ADD COLUMN') !== false) {
                    preg_match('/ADD COLUMN (\w+)/', $sql, $matches);
                    $column = $matches[1] ?? '';
                    $table = prefix . '_news';

                    if ($column && columnExists($db, $table, $column)) {
                        echo "<span class='skipped'><i class='icon-skip'></i> Пропущено (столбец уже существует)</span>";
                        echo "</div></div>";
                        continue;
                    }
                }

                // Проверка для DROP COLUMN
                if (strpos($sql, 'DROP COLUMN') !== false) {
                    preg_match('/DROP COLUMN (\w+)/', $sql, $matches);
                    $column = $matches[1] ?? '';
                    $table = prefix . '_news';

                    if ($column && !columnExists($db, $table, $column)) {
                        echo "<span class='skipped'><i class='icon-skip'></i> Пропущено (столбец не найден)</span>";
                        echo "</div></div>";
                        continue;
                    }
                }

                $result = $db->exec($sql);
                if ($result === null) {
                    throw new Exception("Ошибка запроса");
                }
                echo "<span class='success'><i class='icon-success'></i> Успешно</span>";
            } catch (Exception $e) {
                if (strpos($e->getMessage(), 'Duplicate column name') !== false) {
                    echo "<span class='skipped'><i class='icon-skip'></i> Пропущено (столбец уже существует)</span>";
                } elseif (strpos($e->getMessage(), 'check that column/key exists') !== false) {
                    echo "<span class='skipped'><i class='icon-skip'></i> Пропущено (столбец не найден)</span>";
                } elseif (strpos($e->getMessage(), 'Incorrect datetime value') !== false) {
                    echo "<span class='error'><i class='icon-error'></i> Ошибка формата даты. Исправьте неверные даты.</span>";
                    echo "</div></div></div>";
                    renderFooter();
                    return;
                } else {
                    echo "<span class='error'><i class='icon-error'></i> Ошибка: " . htmlspecialchars($e->getMessage()) . "</span>";
                    echo "</div></div></div>";
                    renderFooter();
                    return;
                }
            }

            echo "</div></div>";
        }

        echo "</div></div>";
    }

    // Восстановление стандартного режима SQL
    $db->exec("SET SQL_MODE=''");

    echo renderSuccessMessage();
    renderFooter();
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
