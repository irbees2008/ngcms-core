# Инструкция по установке мультиязычности для новостей NGCMS

## Обзор

Данный функционал позволяет создавать переводы статей для разных языковых версий мультисайтов.

## Архитектура решения

### 1. Структура БД

- **translation_group_id** - UUID для связи переводов статей
- **lang_code** - код языка статьи (ru, en, uk и т.д.)
- Статьи с одинаковым `translation_group_id` являются переводами друг друга

### 2. Multiconfig

В `multiconfig.php` для каждого сайта добавлено поле `lang`:

```php
$multiconfig = [
    'main' => [
        'domains' => ['example.com'],
        'active' => 1,
        'lang' => 'ru',
        'db' => [...]
    ],
    'en_site' => [
        'domains' => ['en.example.com'],
        'active' => 1,
        'lang' => 'en',
        'db' => [...]
    ]
];
```

### 3. Пример использования

#### Создание языковых версий:

1. **ru.web.ua** - основной сайт на русском (lang: 'ru')
2. **en.web.ua** - английская версия (lang: 'en')
3. **web.ua** - главный домен (lang: 'ru')

## Шаги установки

### 1. Применить миграцию БД

Выполните SQL миграцию для добавления полей в таблицу news:

```bash
# Войдите в MySQL
mysql -u root -p

# Выберите вашу базу данных
USE your_database_name;

# Выполните миграцию (замените XPREFIX_ на ваш префикс, например ng_)
SOURCE /path/to/engine/trash/upgrade_multilang.sql;
```

**Или вручную:**

```sql
-- Замените ng_ на ваш префикс таблиц
ALTER TABLE `ng_news`
ADD COLUMN `translation_group_id` VARCHAR(36) NULL DEFAULT NULL AFTER `id`,
ADD COLUMN `lang_code` VARCHAR(5) NULL DEFAULT NULL AFTER `translation_group_id`,
ADD INDEX `idx_translation_group` (`translation_group_id`),
ADD INDEX `idx_lang_code` (`lang_code`);

-- Установите lang_code для существующих новостей
UPDATE `ng_news`
SET `translation_group_id` = UUID(),
    `lang_code` = 'ru'
WHERE `translation_group_id` IS NULL;
```

### 2. Настроить языки для мультисайтов

1. Перейдите в **Админ панель → Конфигурация → Управление мультисайтами**
2. При добавлении нового сайта выберите **Язык сайта** из выпадающего списка
3. Для существующих сайтов отредактируйте `conf/multiconfig.php` вручную:

```php
$multiconfig['en_site'] = [
    'domains' => ['en.example.com'],
    'active' => 1,
    'lang' => 'en',  // <-- Добавьте это поле
    'db' => [...]
];
```

### 3. Работа с переводами статей

#### Добавление перевода при создании новости:

1. Создайте статью на основном языке (например, ru.web.ua)
2. Сохраните статью
3. В правой панели появится блок **"Переводы"**
4. Выберите язык из списка **"Создать перевод для"**
5. Нажмите **"Добавить перевод"**
6. Откроется новая страница для создания перевода
7. Заполните заголовок и содержимое на выбранном языке
8. Сохраните перевод

#### Просмотр существующих переводов:

В блоке **"Переводы"** отображаются:

- Текущий язык статьи
- Список существующих переводов с кнопками для редактирования
- Список доступных языков для создания новых переводов

#### Редактирование перевода:

1. В блоке "Переводы" нажмите кнопку **"Редактировать перевод"**
2. Откроется редактор соответствующей языковой версии
3. Внесите изменения и сохраните

## API функции

### getCurrentSiteLanguage()

Возвращает код языка текущего сайта (из multiconfig или автоопределение)

```php
$currentLang = getCurrentSiteLanguage(); // 'ru', 'en', 'uk'...
```

### getActiveLanguageSites()

Возвращает список всех активных языковых сайтов

```php
$sites = getActiveLanguageSites();
// [
//   ['site_id' => 'main', 'lang' => 'ru', 'domain' => 'example.com', 'label' => 'RU (main)'],
//   ['site_id' => 'en_site', 'lang' => 'en', 'domain' => 'en.example.com', 'label' => 'EN (en_site)']
// ]
```

### getNewsTranslations($translationGroupId, $excludeNewsId = 0)

Получает все переводы статьи по translation_group_id

```php
$translations = getNewsTranslations($row['translation_group_id'], $newsId);
```

### generateUUID()

Генерирует UUID v4 для группировки переводов

```php
$uuid = generateUUID();
```

### getLanguageName($langCode)

Возвращает название языка по коду

```php
echo getLanguageName('ru'); // "Русский"
echo getLanguageName('en'); // "English"
```

## Примечания

### Автоматическое определение языка

Если в multiconfig не указан `lang`, система пытается определить язык по домену:

- `ru.example.com` → `ru`
- `en.example.com` → `en`
- `uk.example.com` → `uk`

### Синхронизация переводов

Переводы НЕ синхронизируются автоматически. Каждая языковая версия - это отдельная статья с:

- Собственным заголовком
- Собственным содержимым
- Собственными настройками публикации
- Связью через `translation_group_id`

### Для новых установок

Если вы делаете новую установку NGCMS, поля `translation_group_id` и `lang_code` уже присутствуют в `engine/trash/tables.sql` и миграция не требуется.

## Поддерживаемые языки

Предустановленные языки в форме мультисайта:

- Русский (ru)
- English (en)
- Українська (uk)
- Deutsch (de)
- Français (fr)
- Español (es)
- Italiano (it)
- Polski (pl)

Для добавления других языков отредактируйте:

1. `engine/skins/default/tpl/multisite.tpl` (поле выбора языка)
2. `engine/includes/multilang.php` (функция getLanguageName)

## Устранение проблем

### Блок "Переводы" не отображается

- Убедитесь, что файл `engine/includes/multilang.php` подключен
- Проверьте, что в multiconfig добавлено поле `lang` для сайтов
- Проверьте права доступа к файлам

### Переводы не сохраняются

- Убедитесь, что миграция БД выполнена корректно
- Проверьте, что поля `translation_group_id` и `lang_code` существуют в таблице news

### Неправильный язык определяется

- Проверьте наличие поля `lang` в multiconfig для каждого сайта
- Убедитесь, что домены настроены корректно

## Обновление с предыдущих версий

Если вы обновляете существующую систему:

1. **Сделайте резервную копию БД!**

```bash
mysqldump -u root -p your_database > backup_$(date +%Y%m%d).sql
```

2. Примените миграцию SQL
3. Добавьте `lang` в multiconfig для всех сайтов
4. Для существующих новостей будет автоматически установлен lang_code = 'ru'

## Дальнейшее развитие

Возможные улучшения:

- Автоперевод через API (Google Translate, DeepL)
- Синхронизация метаданных (категории, теги) между переводами
- Панель быстрого переключения между языками в редакторе
- Массовое создание переводов
- Отчет о недостающих переводах

---

**Версия:** 1.0
**Дата:** 2026-04-01
**Автор:** NGCMS Multilang Extension
