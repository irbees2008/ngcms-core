# Журнал изменений: Мультиязычность NGCMS

**Дата:** 2026-04-01
**Версия:** 1.0
**Разработчик:** GitHub Copilot

---

## 🎯 Цель

Реализовать мультиязычность для мультисайтов NGCMS с возможностью:

- Связывать переводы статей между языковыми версиями
- Указывать язык каждого мультисайта (ru.web.ua, en.web.ua, web.ua)
- Управлять переводами через интерфейс администратора
- Автоматически определять язык по домену

---

## 📝 Выполненные задачи

### ✅ 1. Структура базы данных

**Добавлены поля в таблицу `news`:**

- `translation_group_id` VARCHAR(36) - UUID для группировки переводов
- `lang_code` VARCHAR(5) - код языка статьи (ru, en, uk, и т.д.)
- Индексы для быстрого поиска

**Файлы:**

- [engine/trash/upgrade_multilang.sql](../engine/trash/upgrade_multilang.sql) - миграция для существующих установок
- [engine/trash/tables.sql](../engine/trash/tables.sql) - обновлена структура для новых установок

**SQL миграция:**

```sql
ALTER TABLE `ng_news`
ADD COLUMN `translation_group_id` VARCHAR(36) NULL DEFAULT NULL AFTER `id`,
ADD COLUMN `lang_code` VARCHAR(5) NULL DEFAULT NULL AFTER `translation_group_id`,
ADD INDEX `idx_translation_group` (`translation_group_id`),
ADD INDEX `idx_lang_code` (`lang_code`);

UPDATE `ng_news`
SET `translation_group_id` = UUID(),
    `lang_code` = 'ru'
WHERE `translation_group_id` IS NULL;
```

---

### ✅ 2. Библиотека функций мультиязычности

**Файл:** [engine/includes/multilang.php](../engine/includes/multilang.php)

**Функции:**

- `getCurrentSiteLanguage()` - определяет текущий язык сайта
- `getActiveLanguageSites()` - получает список всех языковых сайтов
- `getNewsTranslations($translationGroupId, $excludeNewsId)` - загружает переводы статьи
- `generateUUID()` - генерирует UUID v4 для группировки
- `createNewsTranslation()` - создает связь между переводами
- `getLanguageName($langCode)` - возвращает название языка

---

### ✅ 3. Настройка языков для мультисайтов

**Файл:** [engine/skins/default/tpl/multisite.tpl](../engine/skins/default/tpl/multisite.tpl)

**Изменения:**

- Добавлено поле выбора языка при создании мультисайта
- Поддержка 8 языков: ru, en, uk, de, fr, es, it, pl

**Файл:** [engine/actions/configuration.php](../engine/actions/configuration.php)

**Изменения:**

- Функция `multisiteAdd()` сохраняет `lang_code` в multiconfig
- Язык сохраняется в структуре: `$multiconfig[$siteId]['lang'] = $langCode`

**Пример конфигурации:**

```php
$multiconfig = [
    'main' => [
        'domains' => ['ru.web.ua', 'web.ua'],
        'active' => 1,
        'lang' => 'ru',
        'db' => ['type' => 'shared', 'prefix' => 'ng']
    ],
    'en_site' => [
        'domains' => ['en.web.ua'],
        'active' => 1,
        'lang' => 'en',
        'db' => ['type' => 'shared', 'prefix' => 'en']
    ]
];
```

---

### ✅ 4. Интерфейс управления переводами

**Файл:** [engine/skins/default/tpl/news/translations.tpl](../engine/skins/default/tpl/news/translations.tpl)

**Блок включает:**

- Отображение текущего языка статьи
- Список существующих переводов с кнопками редактирования
- Выбор языка для создания нового перевода
- JavaScript функцию `createTranslation()` для открытия формы перевода

**Файл:** [engine/skins/default/tpl/news/edit.tpl](../engine/skins/default/tpl/news/edit.tpl)

**Изменения:**

- Подключен блок переводов в правую панель редактора
- Используется Twig include для переиспользования шаблона

**Файл:** [engine/actions/news.php](../engine/actions/news.php)

**Изменения:**

- Подключена библиотека `multilang.php`
- Функция `editNewsForm()` загружает:
  - Текущий язык сайта
  - Список всех языковых версий
  - Существующие переводы статьи
  - Доступные языки для создания переводов
- Данные передаются в шаблон через массив `$tVars`

---

### ✅ 5. Языковые строки

**Файлы:**

- [engine/lang/russian/admin/configuration.ini](../engine/lang/russian/admin/configuration.ini)
- [engine/lang/english/admin/configuration.ini](../engine/lang/english/admin/configuration.ini)

**Добавлены строки для multisite:**

- `multisite_language` - "Язык сайта"
- `multisite_language_desc` - описание поля

**Файлы:**

- [engine/lang/russian/admin/addnews.ini](../engine/lang/russian/admin/addnews.ini)
- [engine/lang/english/admin/addnews.ini](../engine/lang/english/admin/addnews.ini)

**Добавлены строки для переводов:**

- `translations` - "Переводы"
- `translations_desc` - описание функционала
- `add_translation` - "Добавить перевод"
- `current_language` - "Текущий язык"
- `available_translations` - "Доступные переводы"
- `create_translation_for` - "Создать перевод для"
- `edit_translation` - "Редактировать перевод"
- `translation_site` - "Сайт"
- `translation_title` - "Заголовок перевода"
- `translation_status` - "Статус"

---

### ✅ 6. Документация

**Файлы:**

- [docs/MULTILANG-README.md](MULTILANG-README.md) - краткая инструкция на русском
- [docs/multilang-installation.md](multilang-installation.md) - полная документация с API

**Содержание:**

- Инструкция по установке
- Применение миграции БД
- Настройка языков для мультисайтов
- Работа с переводами статей
- API функций
- Примеры конфигурации
- Устранение проблем
- Дальнейшее развитие

---

## 📊 Статистика изменений

### Новые файлы (5):

1. engine/includes/multilang.php (228 строк)
2. engine/trash/upgrade_multilang.sql (14 строк)
3. engine/skins/default/tpl/news/translations.tpl (98 строк)
4. docs/MULTILANG-README.md (180 строк)
5. docs/multilang-installation.md (385 строк)

### Измененные файлы (8):

1. engine/trash/tables.sql - добавлены поля в CREATE TABLE news
2. engine/actions/configuration.php - сохранение lang_code для мультисайтов
3. engine/actions/news.php - загрузка данных о переводах
4. engine/skins/default/tpl/multisite.tpl - поле выбора языка
5. engine/skins/default/tpl/news/edit.tpl - блок переводов
6. engine/lang/russian/admin/configuration.ini - 2 новые строки
7. engine/lang/english/admin/configuration.ini - 2 новые строки
8. engine/lang/russian/admin/addnews.ini - 13 новых строк
9. engine/lang/english/admin/addnews.ini - 13 новых строк

**Всего добавлено:** ~905 строк кода и документации

---

## 🔄 Архитектура решения

### Связь переводов

Статьи связываются через `translation_group_id`:

```
Статья 1 (ru):          Статья 2 (en):          Статья 3 (uk):
id: 123                 id: 456                 id: 789
translation_group_id:   translation_group_id:   translation_group_id:
  "550e8400-..."          "550e8400-..."          "550e8400-..."
lang_code: "ru"         lang_code: "en"         lang_code: "uk"
```

### Определение языка

1. Проверка `$multiconfig[$siteId]['lang']`
2. Если не задан, автоопределение по домену:
   - `ru.example.com` → `ru`
   - `en.example.com` → `en`
3. По умолчанию: `ru`

### Workflow создания перевода

1. Пользователь создает статью на основном языке (ru.web.ua)
2. Сохраняет статью → генерируется `translation_group_id`
3. Открывает редактор → видит блок "Переводы"
4. Выбирает язык (English) → открывается форма добавления
5. Заполняет перевод → сохраняет с тем же `translation_group_id`
6. Переводы связаны и отображаются в блоке "Переводы"

---

## 🚀 Следующие шаги

### Что еще нужно сделать:

1. **Сохранение translation_group_id при добавлении новости**
   - Модифицировать функции добавления/редактирования
   - Автоматически генерировать UUID при создании
   - Сохранять lang_code текущего сайта

2. **Обработка параметров translation_source**
   - При создании перевода через кнопку "Добавить перевод"
   - Копировать базовую информацию из исходной статьи

3. **Тестирование**
   - Создание мультисайтов с разными языками
   - Добавление статьи и переводов
   - Редактирование переводов
   - Удаление переводов

4. **Оптимизация**
   - Кеширование списка языковых сайтов
   - Индексы для быстрого поиска переводов

---

## ⚠️ Известные ограничения

1. **Переводы не синхронизируются** - каждая языковая версия независима
2. **Требуется миграция БД** для существующих установок
3. **Ручное добавление переводов** - нет автоперевода
4. **Один язык на мультисайт** - нельзя назначить несколько языков одному сайту

---

## 💡 Возможные улучшения

- Автоперевод через API (Google Translate, DeepL)
- Синхронизация метаданных (категории, автор)
- Панель быстрого переключения между языками
- Массовое создание переводов
- Отчет о недостающих переводах
- История изменений переводов
- Сравнение версий переводов

---

## 📞 Поддержка

При возникновении проблем:

1. Проверьте логи PHP/MySQL
2. Убедитесь, что миграция применена корректно
3. Проверьте права доступа к файлам
4. См. раздел "Устранение проблем" в [multilang-installation.md](multilang-installation.md)

---

**Статус:** ✅ Готово к тестированию
**Версия:** 1.0
**Требуется:** Применение SQL миграции для существующих установок
