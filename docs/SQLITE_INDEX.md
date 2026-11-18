# SQLite Integration Documentation Index

## 📚 Документация по интеграции SQLite

Полный набор документации для интеграции поддержки SQLite в NGCMS с возможностью выбора БД при установке.

## 🚀 Начните отсюда

### 1. [SQLITE_QUICKSTART.md](./SQLITE_QUICKSTART.md) ⭐ РЕКОМЕНДУЕТСЯ НАЧАТЬ ОТСЮДА
Быстрая справка с основными концепциями, архитектурой и быстрым стартом реализации.
- ⏱️ **Время чтения:** 10-15 минут
- 📖 **Содержит:** Основные идеи, контрольный список, FAQ

### 2. [sqlite-integration.md](./sqlite-integration.md)
Полная архитектурная документация и описание подхода.
- ⏱️ **Время чтения:** 20-30 минут
- 📖 **Содержит:** Описание, преимущества/недостатки, архитектура, ограничения

## 📋 Документация по реализации

### 3. [sqlite-implementation-plan.md](./sqlite-implementation-plan.md)
Детальный пошаговый план реализации всех фаз интеграции.
- ⏱️ **Время чтения:** 15-20 минут
- 📖 **Содержит:** 9 фаз, описание задач, временная смета, риски

**Рекомендуемый порядок фаз:**
1. Фаза 1: Подготовка
2. Фаза 2: Модификация NGPDO (КРИТИЧЕСКАЯ)
3. Фаза 3: Модификация install.php (КРИТИЧЕСКАЯ)
4. Фаза 4: Шаблоны установки
5. Фаза 5: Управление и утилиты
6. Фаза 6: Защита и безопасность
7. Фаза 7: Тестирование
8. Фаза 8: Документирование
9. Фаза 9: Развертывание

### 4. [sqlite-config-examples.md](./sqlite-config-examples.md)
Практические примеры кода для конфигурации, резервного копирования и миграции.
- ⏱️ **Время чтения:** 15-20 минут
- 📖 **Содержит:** 20+ готовых примеров кода на PHP

## 💻 Готовый код

Готовые классы и функции для прямого использования:

### 5. [engine/includes/sqlite_support.php](../engine/includes/sqlite_support.php)
Класс `NGSQLiteAdapter` - адаптер для работы с SQLite.

**Основные функции:**
- `convertSQL()` - преобразование MySQL SQL в SQLite
- `tableExists()` - проверка существования таблицы
- `getTables()` - получение списка таблиц
- `createBackup()` - создание резервной копии
- `restoreBackup()` - восстановление из копии
- `vacuum()` - оптимизация БД
- `setSynchronous()` / `setJournalMode()` - оптимизация производительности

```php
require_once 'engine/includes/sqlite_support.php';

// Преобразование SQL
$sqliteSql = NGSQLiteAdapter::convertSQL($mysqlSql, 'sqlite');

// Работа с резервными копиями
NGSQLiteAdapter::createBackup($dbPath, $backupPath);

// Оптимизация
NGSQLiteAdapter::vacuum($pdo);
```

### 6. [engine/includes/NGPDO_ENHANCED_EXAMPLE.php](../engine/includes/NGPDO_ENHANCED_EXAMPLE.php)
Пример модифицированного класса `NGPDO` с поддержкой SQLite.

**Ключевые модификации:**
- Параметр `dbtype` ('mysql' или 'sqlite')
- Методы `createDSN()` и `initializeDatabase()`
- Преобразование SQL для SQLite в методе `query()`
- Методы `getDbType()` и `getLastInsertId()`

```php
// Использование с MySQL
$db = new NGPDO([
    'dbtype' => 'mysql',
    'host' => 'localhost',
    'db' => 'ngcms',
    'user' => 'root',
    'pass' => ''
]);

// Использование с SQLite
$db = new NGPDO([
    'dbtype' => 'sqlite',
    'dbpath' => '/path/to/database.sqlite'
]);
```

### 7. [engine/includes/INSTALL_PHP_MODIFICATIONS.php](../engine/includes/INSTALL_PHP_MODIFICATIONS.php)
Примеры модификаций для `install.php` с добавлением выбора БД.

**Включает:**
- Функция `doConfig_db_MODIFIED()` - обновленная функция конфигурации
- `doConfig_db_mysql_validation()` - валидация MySQL
- `doConfig_db_sqlite_validation()` - валидация SQLite
- `doConfig_db_form()` - отображение формы
- HTML/JavaScript для динамического переключения
- Примеры локализации

## 🎯 Рекомендуемый путь реализации

### Для разработчика

```
1. Прочитай SQLITE_QUICKSTART.md (15 мин)
   ↓
2. Прочитай sqlite-integration.md (25 мин)
   ↓
3. Прочитай sqlite-implementation-plan.md (20 мин)
   ↓
4. Начни с Фазы 2 (Модификация NGPDO)
   - Используй NGPDO_ENHANCED_EXAMPLE.php как образец
   - Используй sqlite_support.php для адаптера
   ↓
5. Переходи к Фазе 3 (install.php)
   - Используй INSTALL_PHP_MODIFICATIONS.php как образец
   ↓
6. Следуй оставшимся фазам из плана
```

**Ориентировочное время реализации:** 28-38 часов

### Для администратора

```
1. Прочитай SQLITE_QUICKSTART.md (15 мин)
   ↓
2. Прочитай разделы "Рекомендации по использованию" в sqlite-integration.md
   ↓
3. Используй примеры резервного копирования из sqlite-config-examples.md
   ↓
4. Настрой защиту БД согласно разделу "Безопасность"
```

### Для пользователя

```
1. Во время установки выбери между MySQL и SQLite
   ↓
2. Если SQLite - убедись что путь и права доступа правильные
   ↓
3. Используй обычный интерфейс NGCMS
   ↓
4. Для резервных копий - просто копируй файл БД
```

## 🔍 Навигация по типам задач

### Я хочу понять...

| Что? | Где читать |
|------|-----------|
| Общую архитектуру решения | SQLITE_QUICKSTART.md > Архитектура |
| Преимущества и недостатки SQLite | sqlite-integration.md > Преимущества/Недостатки |
| Как реализовать поддержку SQLite | sqlite-implementation-plan.md > Пошаговый план |
| Различия в SQL синтаксисе | sqlite-integration.md > Совместимость SQL |
| Примеры кода | sqlite-config-examples.md |

### Мне нужен код...

| Для чего? | Где найти |
|-----------|----------|
| Адаптера SQLite | engine/includes/sqlite_support.php |
| Модифицированного NGPDO | engine/includes/NGPDO_ENHANCED_EXAMPLE.php |
| Модификаций install.php | engine/includes/INSTALL_PHP_MODIFICATIONS.php |
| Резервного копирования | sqlite-config-examples.md > Backup function |
| Миграции MySQL → SQLite | sqlite-config-examples.md > Migration Script |
| Конфигурации | sqlite-config-examples.md > Configuration Examples |

### Я тестирую...

| Что тестировать? | Рекомендация |
|------------------|-------------|
| Установку | Используй обе ветки: MySQL и SQLite |
| Функциональность | Пройди все операции в обеих БД |
| Производительность | Сравни скорость MySQL vs SQLite |
| Безопасность | Проверь защиту файла SQLite (.htaccess) |
| Резервные копии | Создай, удали, восстанови БД |

## 📞 Поддержка и вопросы

### Часто задаваемые вопросы

Смотри раздел **❓ Часто задаваемые вопросы** в [SQLITE_QUICKSTART.md](./SQLITE_QUICKSTART.md)

### Решение проблем

Смотри раздел **Troubleshooting** в [sqlite-config-examples.md](./sqlite-config-examples.md)

## 📊 Статус документации

✅ **Полная** - Все аспекты интеграции описаны  
✅ **Актуальная** - Создано 2025-01-14  
✅ **Практичная** - Включены примеры кода  
✅ **Структурированная** - Логичный порядок фаз  

## 📝 История изменений

### v1.0 (2025-01-14)
- Создана полная документация по интеграции SQLite
- Добавлены примеры кода
- Создан подробный план реализации
- Добавлены практические примеры конфигурации

## 🔗 Связанные документы

- [installation.md](./installation.md) - Инструкция по установке NGCMS
- [config.md](./config.md) - Документация по конфигурации
- [plugin-development.md](./plugin-development.md) - Разработка плагинов
- [README.md](../README.md) - Главная документация

## ⚡ Быстрые ссылки

| Ссылка | Описание |
|--------|---------|
| [SQLITE_QUICKSTART.md](./SQLITE_QUICKSTART.md) | Начните здесь ⭐ |
| [sqlite-integration.md](./sqlite-integration.md) | Полная архитектура |
| [sqlite-implementation-plan.md](./sqlite-implementation-plan.md) | План реализации |
| [sqlite-config-examples.md](./sqlite-config-examples.md) | Примеры кода |
| [sqlite_support.php](../engine/includes/sqlite_support.php) | Класс адаптера |
| [NGPDO_ENHANCED_EXAMPLE.php](../engine/includes/NGPDO_ENHANCED_EXAMPLE.php) | Пример NGPDO |
| [INSTALL_PHP_MODIFICATIONS.php](../engine/includes/INSTALL_PHP_MODIFICATIONS.php) | Пример install.php |

---

**Начните с [SQLITE_QUICKSTART.md](./SQLITE_QUICKSTART.md) и следуйте рекомендуемому пути!**
