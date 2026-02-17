# Список измененных файлов для мультисайта NGCMS

## Дата: 8-10 февраля 2026 г.

---

## 1. Основная функциональность мультисайта

### engine/actions/configuration.php

**Описание:** Добавлены функции управления мультисайтами
**Изменения:**

- `multisiteManage()` - отображение списка мультисайтов
- `multisiteAdd()` - добавление нового мультисайта
- `multisiteDelete()` - удаление мультисайта
- `multisiteToggle()` - переключение статуса активности
- `systemConfigEditForm()` - добавлена поддержка переключения конфигов
- Защита: управление доступно только на основном сайте (проверка `$multiDomainName`)
- Автоматическое копирование конфигов и базы данных
- Создание структуры папок uploads/multi/{site_id}/
- Создание junction links для OSPanel (Windows)
- Исправлены методы работы с БД: `$mysql->select()` вместо `$mysql->query()` для SELECT

### engine/skins/default/tpl/multisite.tpl

**Описание:** Новый шаблон для управления мультисайтами
**Создан:** Полная страница управления
**Содержимое:**

- Форма добавления нового мультисайта (site_id, db_prefix, domains)
- JavaScript автозаполнение db_prefix на основе site_id
- Таблица существующих мультисайтов
- Кнопки управления (активировать/деактивировать, удалить)
- Индикаторы статуса и мастер-сайта

### engine/skins/default/tpl/configuration.tpl

**Описание:** Расширен основной шаблон конфигурации
**Изменения:**

- Добавлен раздел "Мультисайт" на вкладке "Система"
- Кнопка "Управление мультисайтом" (видна только на основном сайте)
- Таблица со списком мультисайтов (видна только на основном сайте)
- Переключатель конфигураций (site_id в GET параметрах)
- Алерт с информацией о текущем редактируемом сайте
- Условие `{% if isMainSite %}` для скрытия управления на мультисайтах

---

## 2. Конфигурация и переводы

### engine/conf/multiconfig.php

**Описание:** Конфигурация мультисайтов
**Создан:** Новый файл
**Структура:**

```php
$multimaster = 'main';
$multiconfig = array(
    'main' => array(
        'domains' => array('it', 'localhost'),
        'active' => 1
    ),
    'blog' => array(
        'domains' => array('blog.test.ru'),
        'active' => 1
    )
);
```

### engine/conf/multi/blog/

**Описание:** Конфигурация мультисайта blog
**Создана:** Полная структура папок
**Файлы:**

- **config.php** - основной конфиг (prefix='blog', home_url, theme, etc.)
- **plugins.php** - конфигурация плагинов (копия с основного сайта)
- **plugdata.php** - данные плагинов
- **cron.php** - настройки cron
- **perm.default.php** - права по умолчанию
- **perm.rules.php** - правила прав доступа
- **rewrite.php** - правила ЧПУ
- **urlconf.php** - конфигурация URL
- **robots.txt** - robots.txt для blog.test.ru
- **extras/** - папка с настройками плагинов (полная копия)

### engine/lang/russian/admin/configuration.ini

**Описание:** Переводы для интерфейса мультисайтов
**Добавлены ключи:**

- `multisite` = "Мультисайт"
- `multisite_management` = "Управление мультисайтом"
- `multisite_add_new` = "Добавить новый мультисайт"
- `multisite_site_id` = "ID сайта"
- `multisite_site_id_desc` = "Уникальный идентификатор..."
- `multisite_domains` = "Домены"
- `multisite_domains_desc` = "Список доменов..."
- `multisite_db_prefix` = "Префикс базы данных"
- `multisite_db_prefix_desc` = "Префикс для таблиц..."
- `multisite_active` = "Активен"
- `multisite_status` = "Статус"
- `multisite_master_site` = "Главный сайт"
- `multisite_actions` = "Действия"
- `multisite_toggle` = "Переключить статус"
- `multisite_delete` = "Удалить"
- `multisite_delete_confirm` = "Вы уверены..."
- `multisite_added` = "Мультисайт добавлен"
- `multisite_deleted` = "Мультисайт удален"
- `multisite_toggled` = "Статус изменен"
- `multisite_invalid_id` = "Неверный ID"
- `multisite_already_exists` = "Уже существует"
- `multisite_cannot_delete_master` = "Нельзя удалить главный"
- И другие...

---

## 3. Система переключения конфигураций

### engine/includes/inc/multimaster.php

**Описание:** Определение текущего мультисайта по домену
**Изменено:**

- **Строка 15:** Исправлена проверка `use_multisite`
  - Было: `if (empty($config['use_multisite']))`
  - Стало: `if (isset($config['use_multisite']) && empty($config['use_multisite']))`
  - Причина: проверка срабатывала до загрузки конфига, вызывая ошибки
- Функция вызывается дважды: до и после загрузки config.php
- Устанавливает глобальную переменную `$multiDomainName`
- Определяет путь к конфигу через `confroot`

### engine/core.php

**Описание:** Интеграция мультисайта в ядро
**Проверено:** Уже содержит двойной вызов multimaster

- Первый вызов перед загрузкой конфига (строка ~110)
- Второй вызов после загрузки конфига (строка ~216)

---

## 4. Изоляция загрузок (uploads)

### uploads/multi/blog/

**Описание:** Отдельные папки для загрузок мультисайта
**Создана структура:**

```
uploads/multi/blog/
├── avatars/    - аватары пользователей
├── files/      - файлы
├── dsn/        - вложения (attachments)
└── images/     - изображения
```

### engine/conf/multi/blog/config.php

**Изменено:** Пути к загрузкам
**Настройки:**

```php
'avatars_url'  => 'http://blog.test.ru/uploads/multi/blog/avatars',
'avatars_dir'  => 'C:/OSPanel/home/it/uploads/multi/blog/avatars/',
'files_url'    => 'http://blog.test.ru/uploads/multi/blog/files',
'files_dir'    => 'C:/OSPanel/home/it/uploads/multi/blog/files/',
'attach_url'   => 'http://blog.test.ru/uploads/multi/blog/dsn',
'attach_dir'   => 'C:/OSPanel/home/it/uploads/multi/blog/dsn/',
'images_url'   => 'http://blog.test.ru/uploads/multi/blog/images',
'images_dir'   => 'C:/OSPanel/home/it/uploads/multi/blog/images/',
```

### engine/actions/configuration.php

**Добавлено:** Автоматическое создание папок загрузок
**Код (строки ~410-420):**

```php
$uploadsBasePath = rtrim($config['images_dir'], '/\\');
$uploadsBasePath = dirname($uploadsBasePath);
$multisiteUploadsPath = $uploadsBasePath . '/multi/' . $siteId;
$uploadDirs = ['avatars', 'files', 'dsn', 'images'];
foreach ($uploadDirs as $dir) {
    $dirPath = $multisiteUploadsPath . '/' . $dir;
    if (!is_dir($dirPath)) {
        @mkdir($dirPath, 0755, true);
    }
}
```

---

## 5. Динамический robots.txt

### robots.php

**Описание:** Динамический генератор robots.txt для мультисайтов
**Создан:** Новый файл в корне
**Функциональность:**

- Определяет текущий домен через `$_SERVER['HTTP_HOST']`
- Загружает NGCMS core и multimaster
- Читает robots.txt из `engine/conf/multi/{site_id}/robots.txt`
- Заменяет placeholder'ы `{SITE_URL}` и `{DOMAIN}`
- Для основного сайта: `engine/conf/robots.txt`
- Поддержка плагина robots_editor (опционально)

### .htaccess

**Описание:** Перенаправление запросов robots.txt
**Добавлено правило:**

```apache
# Dynamic robots.txt for multisite
RewriteRule ^robots\.txt$ robots.php [L]
# Allow robots-debug.php (before checking file existence)
RewriteCond %{REQUEST_URI} !^/robots-debug\.php$
```

### engine/conf/robots.txt

**Описание:** robots.txt для основного сайта
**Создан:** Шаблон с placeholder'ами
**Содержимое:**

- Правила для всех user-agent
- Блокировка /engine/, /templates/
- Разрешение /uploads/
- AI Search боты (разрешены)
- AI Training боты (блокированы)
- Sitemaps с placeholder'ами: `{SITE_URL}/sitemap.xml`
- Host: `{DOMAIN}`

### engine/conf/multi/blog/robots.txt

**Описание:** robots.txt для blog.test.ru
**Создан:** Копия с тем же содержимым
**Замена:** Placeholder'ы автоматически заменяются на blog.test.ru

### engine/actions/configuration.php

**Изменено:** Добавлено копирование robots.txt
**В multisiteAdd() (строка ~383):**

```php
$configFiles = [
    'config.php',
    'plugins.php',
    'plugdata.php',
    'cron.php',
    'perm.default.php',
    'perm.rules.php',
    'rewrite.php',
    'urlconf.php',
    'robots.txt'  // <-- добавлено
];
```

### robots-debug.php

**Описание:** Отладочный скрипт для проверки работы мультисайта
**Создан:** Временный файл для диагностики
**Выводит:**

- HTTP_HOST текущего запроса
- multiDomainName после загрузки
- confroot путь
- Путь к используемому robots.txt
- Содержимое до и после замены placeholder'ов

### robots.txt.static

**Описание:** Резервная копия статического robots.txt
**Переименован из:** robots.txt

---

## 6. Копирование базы данных

### engine/actions/configuration.php

**Функция:** `multisiteAdd()` (строки ~485-580)
**Добавлено:**

- Проверка уникальности префикса БД
- Получение списка таблиц: `$mysql->select("SHOW TABLES LIKE " . db_squote($sourcePrefix . '_%'))`
- Цикл копирования таблиц:
  ```php
  foreach ($tables as $sourceTable) {
      $targetTable = $targetPrefix . $tableSuffix;
      // Drop target table if exists
      $mysql->query("DROP TABLE IF EXISTS `{$targetTable}`");
      // Create table structure
      $createResult = $mysql->select("SHOW CREATE TABLE `{$sourceTable}`");
      $createSQL = $createResult[0]['Create Table'];
      $createSQL = str_replace("CREATE TABLE `{$sourceTable}`",
                                "CREATE TABLE `{$targetTable}`",
                                $createSQL);
      $mysql->query($createSQL);
      // Copy data
      $mysql->query("INSERT INTO `{$targetTable}` SELECT * FROM `{$sourceTable}`");
  }
  ```
- Обработка ошибок и подсчет скопированных таблиц
- Исправлено использование методов БД (select/query вместо get_row)
  **Исправления:**
- **Строка 442:** `$mysql->select()` вместо `$mysql->query()` для SHOW TABLES
- **Строка 465:** `$mysql->select()` вместо `$mysql->query()` для SHOW CREATE TABLE
- **Строка 466:** `$createResult[0]` вместо `$mysql->get_row($createResult)`

---

## 7. OSPanel конфигурация

### it/.osp/project.ini

**Описание:** Настройка проекта в OSPanel
**Изменено:**

```ini
[it]
php_engine = PHP-8.3
```

Было добавлено `domains = it, localhost, blog.test.ru`, но затем убрано для использования junction

### blog.test.ru/.osp/project.ini

**Описание:** Настройка проекта blog в OSPanel
**Создан:**

```ini
[blog.test.ru]
php_engine = PHP-8.3
```

### blog.test.ru/ (junction)

**Описание:** Junction link на папку it
**Создан:** `mklink /J "c:\OSPanel\home\blog.test.ru" "c:\OSPanel\home\it"`
**Тип:** Junction point (ReparsePoint)
**Содержимое:** Все файлы из it/ доступны как есть

### engine/actions/configuration.php

**Добавлено:** Автоматическое создание junction для доменов (строки ~583-610)
**Код:**

```php
if (DIRECTORY_SEPARATOR == '\\' && !empty($domainList)) {
    // Windows environment - create junction links
    $baseDir = dirname(dirname(dirname(__DIR__)));
    $itPath = $baseDir;
    foreach ($domainList as $domain) {
        $domainPath = dirname($baseDir) . DIRECTORY_SEPARATOR . $domain;
        if (!file_exists($domainPath)) {
            $command = 'mklink /J "' . $domainPath . '" "' . $itPath . '"';
            @exec($command, $output, $returnCode);
            if ($returnCode === 0) {
                // Create .osp directory and project.ini
                $ospDir = $domainPath . DIRECTORY_SEPARATOR . '.osp';
                @mkdir($ospDir, 0755, true);
                $projectIni = "[{$domain}]\n\nphp_engine = PHP-8.3\n";
                @file_put_contents($ospDir . DIRECTORY_SEPARATOR . 'project.ini', $projectIni);
            }
        }
    }
}
```

---

## 8. Документация

### docs/hosting-multisite.md

**Описание:** Полная инструкция по настройке мультисайта на хостинге
**Создан:** Новый файл
**Разделы:**

- Локальная разработка (OSPanel)
- Продакшен на хостинге (парковка доменов, symlinks)
- Настройка в cPanel/ISPmanager/Plesk
- Миграция с локальной разработки
- Импорт базы данных
- Обновление конфигов
- Права доступа
- Troubleshooting
- Безопасность
- Производительность
- Автоматизация (deploy.sh, cron)

### docs/multisite-robots.md

**Описание:** Инструкция по настройке robots.txt для мультисайтов
**Создан:** Новый файл
**Разделы:**

- Как работает динамический robots.php
- Структура файлов
- Placeholder'ы {SITE_URL} и {DOMAIN}
- Примеры robots.txt для разных сценариев
- Создание robots.txt для нового мультисайта
- Различные правила для каждого мультисайта
- Проверка работы (curl, PowerShell, Google Search Console)
- Интеграция с плагином robots_editor
- Troubleshooting
- Продвинутая настройка (AI боты, множественные Sitemaps)
- SEO рекомендации

---

## 9. Безопасность и права доступа

### engine/actions/configuration.php

**Добавлена защита:** Управление мультисайтами только на основном сайте
**Проверка добавлена в функции:**

- `multisiteManage()` - строки ~692-696
- `multisiteAdd()` - строки ~294-298
- `multisiteDelete()` - строки ~638-642
- `multisiteToggle()` - строки ~750-754
  **Код проверки:**

```php
// Multisite management is only available on main site
if (!empty($multiDomainName) && $multiDomainName !== 'main') {
    msg(['type' => 'error', 'text' => 'Управление мультисайтами доступно только на основном сайте.']);
    return false;
}
```

### engine/actions/configuration.php

**Функция:** `systemConfigEditForm()`
**Изменения (строки ~138, ~248-250):**

- Добавлен `global $multiDomainName`
- Добавлены переменные в шаблон:
  ```php
  'multiDomainName' => $multiDomainName ?? 'main',
  'isMainSite' => empty($multiDomainName) || $multiDomainName === 'main',
  ```

### engine/skins/default/tpl/configuration.tpl

**Добавлено:** Условное отображение управления мультисайтами
**Изменения (строки ~1041, ~1089):**

```twig
{% if isMainSite %}
    <!-- Кнопка "Управление мультисайтом" -->
    <!-- Таблица мультисайтов -->
{% endif %}
```

---

## 10. Исправления ошибок

### engine/actions/configuration.php

**Ошибка 1: Call to undefined method NGLegacyDB::safesql()**

- **Строка 321:** Было `$mysql->safesql($testTable)` → стало `db_squote($testTable)`
- **Строка 442:** Было `$mysql->safesql($sourcePrefix)` → стало `db_squote($sourcePrefix . '_%')`
- **Причина:** Метод safesql() не существует в NGLegacyDB, правильно использовать функцию db_squote()
  **Ошибка 2: Call to undefined method NGLegacyDB::get_row()**
- **Строка 444-446:** Заменено `while ($row = $mysql->get_row($result))` на `foreach ($result as $row)`
- **Строка 442:** Заменено `$mysql->query()` на `$mysql->select()` для SELECT запросов
- **Строка 465:** Заменено `$mysql->query()` на `$mysql->select()` для SHOW CREATE TABLE
- **Строка 466:** Заменено `$mysql->get_row($createResult)` на `$createResult[0]`
- **Причина:**
  - `$mysql->query()` предназначен для DDL (DROP, CREATE, INSERT) - возвращает PDOStatement
  - `$mysql->select()` предназначен для SELECT - возвращает массив результатов
  - Метод `get_row()` не существует, нужно работать с массивом напрямую

### engine/includes/inc/multimaster.php

**Ошибка 3: Проверка use_multisite падала до загрузки конфига**

- **Строка 15:** Было `if (empty($config['use_multisite']))`
- **Стало:** `if (isset($config['use_multisite']) && empty($config['use_multisite']))`
- **Причина:** multimaster.php вызывается дважды - до и после загрузки config.php. При первом вызове переменная $config не определена, что вызывало warning.

---

## 11. Автоматизация при добавлении мультисайта

### engine/actions/configuration.php - функция multisiteAdd()

**Что происходит автоматически при добавлении нового мультисайта:**

1. **Валидация входных данных** (строки ~300-337):
   - Проверка site_id на допустимые символы
   - Проверка db_prefix на допустимые символы
   - Проверка уникальности префикса в БД
   - Парсинг доменов (один на строку)
2. **Обновление multiconfig.php** (строки ~339-366):
   - Чтение текущего multiconfig.php
   - Добавление нового сайта в массив $multiconfig
   - Сохранение обновленного multiconfig.php
3. **Создание структуры конфигов** (строки ~368-377):
   - Создание папки `engine/conf/multi/{site_id}/`
   - Права доступа 0755
4. **Копирование конфигов** (строки ~380-397):
   - Копируются файлы: config.php, plugins.php, plugdata.php, cron.php, perm.default.php, perm.rules.php, rewrite.php, urlconf.php, robots.txt
   - Рекурсивное копирование папки extras/ с настройками плагинов
5. **Создание структуры uploads** (строки ~408-420):
   - Создание `uploads/multi/{site_id}/avatars/`
   - Создание `uploads/multi/{site_id}/files/`
   - Создание `uploads/multi/{site_id}/dsn/`
   - Создание `uploads/multi/{site_id}/images/`
6. **Обновление config.php** (строки ~423-482):
   - Замена префикса БД: `'prefix' => '{$dbPrefix}'`
   - Обновление URL:
     - `home_url` → `http://{firstDomain}`
     - `admin_url` → `http://{firstDomain}/engine`
   - Обновление заголовка: `home_title` → `{$siteId}`
   - Обновление путей uploads:
     - `avatars_url` → `http://{firstDomain}/uploads/multi/{site_id}/avatars`
     - `avatars_dir` → полный путь к uploads/multi/{site_id}/avatars/
     - Аналогично для files, attach, images
7. **Копирование таблиц БД** (строки ~485-580):
   - Получение списка всех таблиц с префиксом основного сайта
   - Для каждой таблицы:
     - DROP TABLE IF EXISTS `{новый_префикс}_таблица`
     - SHOW CREATE TABLE `{старый_префикс}_таблица`
     - Создание новой таблицы с новым префиксом
     - INSERT INTO `{новый_префикс}_таблица` SELECT \* FROM `{старый_префикс}_таблица`
   - Подсчет успешно скопированных таблиц
   - Список неудачных копирований (если есть)
8. **Создание OSPanel структуры** (Windows only, строки ~583-610):
   - Для каждого домена из списка:
     - Создание junction link: `c:\OSPanel\home\{domain}` → `c:\OSPanel\home\it`
     - Создание папки `.osp/`
     - Создание `project.ini` с настройками PHP
     - Сообщение об успешном создании
9. **Уведомления** (строка ~613):
   - Вывод сообщения об успешном добавлении мультисайта

---

## 12. Тестирование и отладка

### Созданные тестовые файлы (могут быть удалены):

- `robots-debug.php` - отладка определения мультисайта
- `test_domain.php` - проверка HTTP_HOST
- `multisite_debug.php` - диагностика конфигов
- `debug_auth.php` - проверка плагинов авторизации

### Команды проверки использованные в PowerShell:

```powershell
# Проверка статуса доменов
Invoke-WebRequest -Uri "http://it/" | Select-Object StatusCode
Invoke-WebRequest -Uri "http://blog.test.ru/" | Select-Object StatusCode
# Проверка содержимого
$response = Invoke-WebRequest -Uri "http://blog.test.ru/"
$response.Content -match 'блог'
# Проверка robots.txt
Invoke-WebRequest -Uri "http://it/robots.txt"
Invoke-WebRequest -Uri "http://blog.test.ru/robots.txt"
# Проверка junction links
Get-Item "c:\OSPanel\home\blog.test.ru" | Select-Object Name, LinkType, Target
# Очистка кэша
Remove-Item -Path "c:\OSPanel\home\it\engine\cache\*" -Recurse -Force
```

---

## Итоговая статистика

### Создано новых файлов: 10

1. `engine/skins/default/tpl/multisite.tpl`
2. `engine/conf/multiconfig.php`
3. `engine/conf/robots.txt`
4. `robots.php`
5. `robots-debug.php` (временный)
6. `docs/hosting-multisite.md`
7. `docs/multisite-robots.md`
8. `it/.osp/project.ini`
9. `blog.test.ru/.osp/project.ini`
10. `robots.txt.static` (резервная копия)

### Изменено существующих файлов: 4

1. `engine/actions/configuration.php` (основной файл - множество изменений)
2. `engine/includes/inc/multimaster.php` (исправление проверки)
3. `engine/skins/default/tpl/configuration.tpl` (UI для мультисайтов)
4. `.htaccess` (правило для robots.txt)

### Расширено переводов: 1

1. `engine/lang/russian/admin/configuration.ini` (добавлено ~30 ключей)

### Создано папок: 5

1. `engine/conf/multi/blog/` (+ подпапка extras/)
2. `uploads/multi/blog/avatars/`
3. `uploads/multi/blog/files/`
4. `uploads/multi/blog/dsn/`
5. `uploads/multi/blog/images/`

### Скопировано конфигов в multi/blog/: 9

1. `config.php`
2. `plugins.php`
3. `plugdata.php`
4. `cron.php`
5. `perm.default.php`
6. `perm.rules.php`
7. `rewrite.php`
8. `urlconf.php`
9. `robots.txt`
10. `extras/` (папка с ~20+ файлами настроек плагинов)

### Создано junction links: 1

- `c:\OSPanel\home\blog.test.ru` → `c:\OSPanel\home\it`

### Скопировано таблиц БД: ~30-40

- Все таблицы с префиксом `ng_*` → `blog_*` (зависит от установленных плагинов)

---

## Ключевые технологии и подходы

### 1. Junction Links (Windows)

- Позволяет одному физическому набору файлов обслуживать несколько доменов
- Экономит место на диске
- Упрощает обновление (изменения в одном месте)

### 2. Префиксы таблиц БД

- Изоляция данных между мультисайтами
- Одна база данных - несколько сайтов
- Полная копия структуры и данных

### 3. Динамический robots.txt

- Один скрипт robots.php для всех доменов
- Определение домена через HTTP_HOST
- Placeholder'ы для гибкости

### 4. Конфигурационные файлы

- Каждый мультисайт имеет полную копию конфигов
- Независимые настройки плагинов
- Изолированные права доступа

### 5. Автоматизация

- Полное создание мультисайта одной кнопкой
- Копирование БД, конфигов, создание папок
- Создание OSPanel структуры (junction + project.ini)

---

## Что нужно сделать вручную

### При добавлении нового мультисайта:

1. **Hosts файл** (C:\Windows\System32\drivers\etc\hosts):
   ```
   127.127.126.54 новый-домен.ru
   ```
2. **Перезапуск Apache**:
   - Через интерфейс OSPanel
   - Или: `Restart-Service OSPanelApache` (если служба)
3. **На реальном хостинге**:
   - Припарковать домен в панели управления
   - ИЛИ создать symlink через SSH
   - Добавить домен в DNS

### Необязательно (автоматически):

- ✓ Копирование конфигов
- ✓ Создание таблиц БД
- ✓ Создание папок uploads
- ✓ Создание junction links (OSPanel)
- ✓ Создание project.ini
- ✓ Обновление multiconfig.php

---

## Совместимость

### Требования:

- **PHP:** 8.1+ (NGCMS требование)
- **MySQL:** 5.7+ / MariaDB 10.3+
- **Windows:** Junction links работают только на Windows (на Linux используются symlinks)
- **OSPanel:** Настроено для OSPanel, на других средах требует адаптации

### Проверено на:

- OSPanel (Windows)
- PHP 8.3
- MySQL 8.0
- Apache

### Планируется поддержка:

- Linux (symlinks вместо junction)
- Nginx (альтернативные правила rewrite)
- Docker (конфигурация контейнеров)

---

## Дальнейшие улучшения

### Возможные доработки:

1. Интерфейс для управления robots.txt через админку
2. Массовое добавление мультисайтов (импорт из CSV)
3. Автоматическое создание DNS записей (через API DNS провайдера)
4. Синхронизация плагинов между мультисайтами
5. Статистика по мультисайтам (количество записей, размер БД)
6. Клонирование существующего мультисайта
7. Экспорт/импорт конфигурации мультисайта
8. Логирование всех операций с мультисайтами
9. Резервное копирование отдельного мультисайта
10. Миграция мультисайта на отдельный сервер

---

## Известные ограничения

1. **Управление мультисайтами:**
   - Доступно только на основном сайте (main)
   - На мультисайтах интерфейс скрыт
2. **База данных:**
   - Все мультисайты в одной БД
   - Нельзя использовать разные СУБД для разных сайтов
3. **OSPanel (Windows):**
   - Требуется ручное добавление в hosts
   - Требуется перезапуск Apache после добавления домена
4. **Хостинг:**
   - Зависит от возможностей хостинга (парковка доменов, symlinks)
   - Ограничения на количество доменов
5. **Обновления:**
   - Обновление engine/ затрагивает все мультисайты
   - Нельзя использовать разные версии NGCMS для разных сайтов

---

## Контакты и поддержка

**Разработано:** 8-10 февраля 2026 г.
**Тестирование:** OSPanel, PHP 8.3, MySQL 8.0
**Документация:** docs/hosting-multisite.md, docs/multisite-robots.md
