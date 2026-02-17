# Настройка мультисайта NGCMS на хостинге

## Локальная разработка (OSPanel)

В OSPanel используются **junction links** (Windows):

```
c:\OSPanel\home\
    ├── it\                 ← основная папка
    └── blog.test.ru\       ← junction → it\
```

## Продакшен на хостинге

### Способ 1: Парковка доменов (Parked Domains) ⭐ РЕКОМЕНДУЕТСЯ

**Структура:**

```
/home/username/public_html/
    ├── engine/
    │   └── conf/
    │       └── multi/
    │           ├── blog/
    │           └── shop/
    ├── uploads/
    │   └── multi/
    │       ├── blog/
    │       └── shop/
    ├── templates/
    ├── vendor/
    └── index.php
```

**Настройка в cPanel:**

1. Основной домен: `example.com` → `/public_html/`
2. Domains → Create a New Domain → Park Domain
3. Добавить: `blog.example.com` (без создания отдельной папки)
4. Результат: оба домена работают с одной папкой
   **Настройка в ISPmanager:**
5. WWW-домены → Создать
6. Основной домен: `example.com`
7. Добавить домен-псевдоним (Alias): `blog.example.com`
   **Настройка в Plesk:**
8. Websites & Domains → Add Domain
9. Document Root: указать тот же путь, что у основного домена

---

### Способ 2: Символические ссылки (если SSH доступен)

**Создание через SSH:**

```bash
cd /home/username/
ln -s public_html blog.example.com
ln -s public_html shop.example.com
```

**Проверка:**

```bash
ls -la
# Вывод:
# public_html/
# blog.example.com -> public_html/
# shop.example.com -> public_html/
```

**Настройка доменов в панели:**

- `example.com` → `/home/username/public_html/`
- `blog.example.com` → `/home/username/blog.example.com/`
- `shop.example.com` → `/home/username/shop.example.com/`

---

### Способ 3: .htaccess редирект (если ничего не работает)

Создать отдельные папки с редиректами:
**/home/username/blog.example.com/.htaccess:**

```apache
RewriteEngine On
RewriteRule ^(.*)$ http://example.com/$1 [R=301,L]
```

## ⚠️ **Не рекомендуется** - это НЕ мультисайт, а просто редирект.

## Настройка NGCMS multiconfig.php

```php
<?php
$multimaster = 'main';
$multiconfig = array(
    'main' => array(
        'domains' => array('example.com', 'www.example.com'),
        'active' => 1
    ),
    'blog' => array(
        'domains' => array('blog.example.com', 'www.blog.example.com'),
        'active' => 1
    ),
    'shop' => array(
        'domains' => array('shop.example.com'),
        'active' => 1
    )
);
```

---

## Требования к хостингу

### Минимальные:

- ✓ PHP 8.1+
- ✓ MySQL 5.7+ / MariaDB 10.3+
- ✓ Один аккаунт может иметь несколько доменов
- ✓ Возможность парковки доменов

### Рекомендуемые:

- ✓ SSH доступ (для symlink)
- ✓ Composer (для установки зависимостей)
- ✓ Возможность изменения php.ini

### Проверенные хостинги:

- **Beget** - поддерживает парковку доменов и symlink
- **TimeWeb** - поддерживает парковку через ISPmanager
- **Majordomo** - через cPanel
- **RU-CENTER** - через панель управления

---

## Миграция с локальной разработки

### 1. Подготовка на локальной машине:

```bash
# Создать дамп базы данных для каждого префикса
mysqldump -u root it ng_* > main_site.sql
mysqldump -u root it blog_* > blog_site.sql
```

### 2. Загрузка на хостинг:

**Через FTP/SFTP:**

- Загрузить всю папку `it/` на хостинг
- Исключить: `/engine/cache/`, `/engine/backups/`
  **Через SSH (быстрее):**

```bash
# Архивировать локально
tar -czf ngcms.tar.gz it/
# Загрузить на сервер
scp ngcms.tar.gz user@hostname:/home/username/
# Разархивировать на сервере
ssh user@hostname
cd /home/username/
tar -xzf ngcms.tar.gz
mv it public_html
```

### 3. Импорт базы данных:

**Через phpMyAdmin:**

- Импортировать `main_site.sql`
- Импортировать `blog_site.sql`
  **Через SSH:**

```bash
mysql -u dbuser -p dbname < main_site.sql
mysql -u dbuser -p dbname < blog_site.sql
```

### 4. Обновить конфиги:

**engine/conf/config.php** и **engine/conf/multi/\*/config.php**:

```php
'dbhost' => 'localhost',  // или адрес MySQL сервера
'dbname' => 'yourdb',
'dbuser' => 'youruser',
'dbpasswd' => 'yourpass',
'prefix' => 'ng',
'home_url' => 'https://example.com',
'admin_url' => 'https://example.com/engine',
'avatars_dir' => '/home/username/public_html/uploads/multi/blog/avatars/',
'images_dir' => '/home/username/public_html/uploads/multi/blog/images/',
// и т.д.
```

### 5. Настроить права доступа:

```bash
chmod 755 /home/username/public_html/
chmod 755 /home/username/public_html/uploads/
chmod 777 /home/username/public_html/engine/cache/
chmod 777 /home/username/public_html/engine/conf/
chmod 666 /home/username/public_html/engine/conf/config.php
```

---

## Проверка работы

1. Очистить кэш: `rm -rf engine/cache/*`
2. Проверить домены:
   - `http://example.com/` - основной сайт
   - `http://blog.example.com/` - мультисайт
3. Проверить admin панели:
   - `http://example.com/engine/admin.php`
   - `http://blog.example.com/engine/admin.php`

---

## Troubleshooting

### Проблема: 403 Forbidden

**Решение:**

```bash
chmod 755 /home/username/public_html/
chmod 644 /home/username/public_html/index.php
```

### Проблема: Все домены показывают один сайт

**Решение:**

- Проверить `engine/conf/multiconfig.php`
- Проверить `use_multisite = 1` в config.php
- Очистить кэш

### Проблема: Ошибка базы данных

**Решение:**

- Проверить правильность префикса в config.php
- Убедиться, что таблицы с префиксом существуют
- Проверить права пользователя БД

### Проблема: Не загружаются картинки

**Решение:**

- Проверить пути `images_dir`, `avatars_dir` в config.php
- Убедиться, что папки существуют и права 755/777
- Проверить URL `images_url` совпадает с доменом

---

## Автоматизация (для профи)

### Скрипт автодеплоя через Git:

**deploy.sh:**

```bash
#!/bin/bash
cd /home/username/public_html
git pull origin main
composer install --no-dev
rm -rf engine/cache/*
chmod -R 755 .
chmod -R 777 engine/cache
chmod -R 777 uploads
echo "Deploy complete!"
```

### Cron для очистки кэша:

```cron
0 3 * * * rm -rf /home/username/public_html/engine/cache/*
```

---

## Безопасность на продакшене

1. **Отключить debug в config.php:**

```php
'debug' => '0',
'sql_error_show' => '0',
```

2. **Защитить admin панель (.htaccess):**

```apache
<Files "admin.php">
    AuthType Basic
    AuthName "Admin Area"
    AuthUserFile /home/username/.htpasswd
    Require valid-user
</Files>
```

3. **Закрыть конфиги от публичного доступа:**

```apache
<FilesMatch "\.(ini|sql|md)$">
    Require all denied
</FilesMatch>
```

4. **Обновить .htaccess для защиты:**

```apache
# В корне сайта
RewriteEngine On
RewriteRule ^engine/conf/ - [F,L]
RewriteRule ^engine/backups/ - [F,L]
```

---

## Производительность

### Включить кэширование в config.php:

```php
'use_memcached' => '1',  // если доступен Memcached
'use_gzip' => '1',       // сжатие контента
```

### Настроить .htaccess кэширование:

```apache
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType text/css "access plus 1 month"
    ExpiresByType application/javascript "access plus 1 month"
</IfModule>
```

---

## Итоговая структура на хостинге

```
/home/username/public_html/
    ├── .htaccess
    ├── index.php
    ├── robots.txt
    ├── engine/
    │   ├── admin.php
    │   ├── conf/
    │   │   ├── config.php
    │   │   ├── multiconfig.php
    │   │   └── multi/
    │   │       ├── blog/config.php
    │   │       └── shop/config.php
    │   ├── cache/          (777)
    │   └── backups/        (777)
    ├── uploads/
    │   └── multi/
    │       ├── blog/       (изолированные загрузки)
    │       └── shop/
    ├── templates/
    │   ├── default/
    │   ├── Masonry/
    │   └── ...
    └── vendor/
Все домены (example.com, blog.example.com, shop.example.com)
→ указывают на /home/username/public_html/
```

NGCMS автоматически определяет домен и переключает конфигурацию!
