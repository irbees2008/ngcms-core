# Быстрая справка: Интеграция SQLite в NGCMS

## 📋 Содержание документации

Создана полная документация по интеграции SQLite в NGCMS:

1. **sqlite-integration.md** - Полное описание архитектуры и подхода
2. **sqlite-config-examples.md** - Практические примеры конфигурации и кода
3. **sqlite-implementation-plan.md** - Пошаговый план реализации
4. **sqlite_support.php** - Готовый класс-адаптер SQLite
5. **NGPDO_ENHANCED_EXAMPLE.php** - Пример модифицированного NGPDO
6. **INSTALL_PHP_MODIFICATIONS.php** - Примеры модификаций для установщика

## 🎯 Ключевые решения

### Архитектура

```
MySQL/SQLite выбор при установке
        ↓
    install.php (Шаг 2: конфигурация БД)
        ↓
    Динамическая форма (MySQL или SQLite)
        ↓
    NGPDO.class.php (поддержка обоих драйверов)
        ↓
    NGSQLiteAdapter (преобразование SQL)
        ↓
    Работающая CMS с выбранной БД
```

### Основные компоненты

#### 1. **NGSQLiteAdapter** - Класс адаптера
```php
// Преобразование SQL синтаксиса
convertSQL($sql, 'sqlite')

// Работа с файлом БД
tableExists($pdo, $table)
getTables($pdo)
enableForeignKeys($pdo)

// Резервное копирование
createBackup($dbPath, $backupPath)
restoreBackup($backupPath, $dbPath)

// Оптимизация
vacuum($pdo)
setSynchronous($pdo, 'NORMAL')
setJournalMode($pdo, 'WAL')
```

#### 2. **NGPDO расширение** - Универсальный класс подключения
```php
// Динамическое создание DSN
createDSN(['dbtype' => 'sqlite', 'dbpath' => '...'])
createDSN(['dbtype' => 'mysql', 'host' => '...', 'db' => '...'])

// Инициализация с настройками БД
initializeDatabase()

// Преобразование SQL при необходимости
convertSQLForSQLite($sql)

// Универсальные методы
getDbType()
getLastInsertId()
```

#### 3. **install.php модификации** - Выбор БД
```
Шаг 2: Настройка БД
├─ ○ MySQL
│  ├─ Хост
│  ├─ База
│  ├─ Пользователь
│  └─ Пароль
└─ ○ SQLite
   └─ Путь к файлу

JavaScript переключение между секциями
Валидация в зависимости от типа
```

## 🛠 Основные преимущества решения

✅ **Совместимость** - Поддержка MySQL осталась без изменений  
✅ **Простота** - Выбор БД прямо в установщике  
✅ **Безопасность** - Защита файла SQLite от скачивания  
✅ **Масштабируемость** - Возможность миграции между БД  
✅ **Тестируемость** - Легко развернуть SQLite для разработки  
✅ **Резервирование** - Простое копирование файла БД  

## 🔧 Быстрый старт реализации

### Этап 1: Добавление поддержки в NGPDO (Приоритет: КРИТИЧЕСКИЙ)

```php
// engine/classes/NGPDO.class.php

// В конструктор добавить:
$this->dbType = isset($params['dbtype']) ? strtolower($params['dbtype']) : 'mysql';

// Проверка параметров в зависимости от типа БД
if ($this->dbType === 'sqlite') {
    if (!isset($params['dbpath'])) {
        throw new Exception('SQLite: dbpath required');
    }
} else {
    if (!isset($params['user'])) {
        throw new Exception('MySQL: user required');
    }
    // ... остальные проверки MySQL
}

// Метод подключения:
protected function createDSN($params) {
    if ($this->dbType === 'sqlite') {
        return 'sqlite:' . $params['dbpath'];
    } else {
        return 'mysql:host=' . $params['host'] . ';dbname=' . $params['db'];
    }
}

// Использование:
$dsn = $this->createDSN($params);
if ($this->dbType === 'sqlite') {
    $this->db = new PDO($dsn);
} else {
    $this->db = new PDO($dsn, $params['user'], $params['pass']);
}
```

### Этап 2: Модификация install.php (Приоритет: КРИТИЧЕСКИЙ)

```php
// install.php - функция doConfig_db

// Добавить выбор типа БД
$dbType = $_POST['reg_dbtype'] ?? 'mysql';

if ($dbType === 'mysql') {
    // Валидация MySQL параметров
    // Проверка подключения
    // Сохранение конфигурации
} elseif ($dbType === 'sqlite') {
    // Валидация пути к файлу
    // Проверка прав доступа
    // Создание директории если нужно
    // Сохранение конфигурации
}
```

### Этап 3: Шаблон install.tpl (Приоритет: ВЫСОКИЙ)

```html
<form method="POST">
    <div class="db-type-selection">
        <label>
            <input type="radio" name="reg_dbtype" value="mysql" 
                   onchange="switchDatabaseType()" required>
            MySQL
        </label>
        <label>
            <input type="radio" name="reg_dbtype" value="sqlite" 
                   onchange="switchDatabaseType()" required>
            SQLite
        </label>
    </div>

    <div id="mysql-config" style="display: none;">
        <!-- MySQL поля -->
    </div>

    <div id="sqlite-config" style="display: none;">
        <input type="text" name="reg_dbpath" placeholder="data/database.sqlite">
    </div>
</form>

<script>
function switchDatabaseType() {
    var type = document.querySelector('input[name="reg_dbtype"]:checked').value;
    document.getElementById('mysql-config').style.display = 
        (type === 'mysql') ? 'block' : 'none';
    document.getElementById('sqlite-config').style.display = 
        (type === 'sqlite') ? 'block' : 'none';
}
</script>
```

### Этап 4: Конфигурация (Приоритет: СРЕДНИЙ)

```php
// engine/conf/config.php

// Вариант 1: MySQL
$config['dbtype'] = 'pdo';
$config['dbhost'] = 'localhost';
$config['dbname'] = 'ngcms';
$config['dbuser'] = 'root';
$config['dbpasswd'] = '';

// Вариант 2: SQLite
$config['dbtype'] = 'pdo';
$config['db_driver'] = 'sqlite';
$config['dbpath'] = '/absolute/path/to/database.sqlite';
```

## 📊 Различия в SQL синтаксисе

| Функция | MySQL | SQLite |
|---------|-------|--------|
| Последний ID | `LAST_INSERT_ID()` | `last_insert_rowid()` |
| Типы данных | `INT UNSIGNED` | `INT` (нет UNSIGNED) |
| Автоприращение | `AUTO_INCREMENT` | `AUTOINCREMENT` |
| Идентификаторы | `` ` `` (backticks) | `"` (двойные кавычки) |
| Индексы | `USING BTREE` | - (не нужно) |
| Кодировка | `CHARACTER SET utf8mb4` | UTF-8 по умолчанию |
| Проверка таблицы | `SHOW TABLES` | `sqlite_master` |

## 🔐 Безопасность

### Защита файла SQLite

```apache
# .htaccess или data/.htaccess
<FilesMatch "\.(sqlite|sqlite3|db|db-wal|db-shm)$">
    Deny from all
</FilesMatch>
```

### Права доступа на файл

```bash
chmod 640 database.sqlite  # rw-r----- (владелец и группа)
chmod 700 data/            # rwx------ (только владелец)
```

## 📝 Контрольный список

### До реализации:
- [ ] Создать ветку для разработки
- [ ] Убедиться что тесты MySQL проходят
- [ ] Подготовить окружение SQLite

### Во время реализации:
- [ ] Модифицировать NGPDO.class.php
- [ ] Добавить поддержку в install.php
- [ ] Создать шаблоны для установщика
- [ ] Добавить валидацию формы
- [ ] Реализовать преобразование SQL

### После реализации:
- [ ] Провести функциональное тестирование
- [ ] Проверить производительность
- [ ] Обновить документацию
- [ ] Создать примеры миграции
- [ ] Подготовить release notes

## 📚 Дополнительные ресурсы

### Документация
- [sqlite-integration.md](./sqlite-integration.md) - Полный гайд
- [sqlite-config-examples.md](./sqlite-config-examples.md) - Примеры кода
- [sqlite-implementation-plan.md](./sqlite-implementation-plan.md) - План реализации

### Классы
- `engine/includes/sqlite_support.php` - Адаптер SQLite
- `engine/includes/NGPDO_ENHANCED_EXAMPLE.php` - Пример NGPDO

### Примеры
- `engine/includes/INSTALL_PHP_MODIFICATIONS.php` - Модификации install.php

## ❓ Часто задаваемые вопросы

**Q: Нужно ли переписывать весь код?**
A: Нет, достаточно модифицировать NGPDO и install.php

**Q: Будет ли SQLite медленнее чем MySQL?**
A: Для малых сайтов - нет. Для большой нагрузки - да.

**Q: Можно ли переключиться с MySQL на SQLite потом?**
A: Да, есть скрипт миграции в примерах.

**Q: Как делать резервные копии SQLite?**
A: Просто копировать файл БД.

**Q: Безопасен ли файл SQLite?**
A: Да, если защищен .htaccess и находится вне веб-доступа.

## 🚀 Выполнение

Начните с этапа 1 (Модификация NGPDO). Это самый критичный и сложный этап. После его завершения переходите к остальным.

Рекомендуемое время реализации: **3-4 недели**

**Вопросы или предложения?** Обратитесь к документации или откройте issue.
