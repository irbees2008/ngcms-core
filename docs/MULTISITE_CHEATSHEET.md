# Шпаргалка по мультисайту NGCMS

## 📁 Структура файлов

```
engine/conf/multiconfig.php     ← Список всех сайтов ⭐
engine/conf/config.php          ← Главный конфиг (main)
engine/conf/multi/blog/         ← Конфиг для blog
engine/conf/multi/shop/         ← Конфиг для shop
```

## 🚀 Быстрое создание нового сайта

### Вариант 1: Автоматически

```bash
create_multisite.bat
```

### Вариант 2: Вручную

**1. Добавить в multiconfig.php:**

```php
'blog' => ['domains' => ['blog.test.ru'], 'active' => 1]
```

**2. Создать папку:**

```
engine\conf\multi\blog\
```

**3. Скопировать:**

```
config.php → multi\blog\config.php
```

**4. Изменить в blog\config.php:**

```php
'home_url' => 'https://blog.test.ru'
'theme' => 'blog-theme'
```

## 🔧 Переменные для автоподстановки

В config.php используйте:

```php
'home_url' => 'https://{domain}'
'images_url' => 'https://{domain}/uploads/images/'
'images_dir' => '/var/www/uploads/{domainid}/images/'
'theme' => '{domainid}-theme'
```

### Замены:

- `{domain}` → test.ru, blog.test.ru, shop.test.ru
- `{domainid}` → main, blog, shop

## 🌐 Настройка DNS/HOSTS

### Локальный тест (Windows):

Файл: `C:\Windows\System32\drivers\etc\hosts`

```
127.0.0.1   test.ru
127.0.0.1   blog.test.ru
127.0.0.1   shop.test.ru
```

### На сервере (DNS):

```
test.ru       A   → 123.45.67.89
blog.test.ru  A   → 123.45.67.89
shop.test.ru  A   → 123.45.67.89
```

## ✅ Чек-лист после настройки

- [ ] Добавил сайт в multiconfig.php
- [ ] Создал папку engine/conf/multi/[название]/
- [ ] Скопировал и настроил config.php
- [ ] Добавил домен в hosts (или DNS)
- [ ] Очистил кеш в админке
- [ ] Проверил сайт в браузере

## 🐛 Решение проблем

### Проблема: {domain} не заменяется

✓ Проверить multiconfig.php - есть ли домен
✓ Очистить кеш: engine/cache/
✓ Проверить $\_SERVER['HTTP_HOST'] совпадает с доменом

### Проблема: Сайт не открывается

✓ Проверить hosts файл
✓ Проверить config.php существует
✓ Включить debug: 'debug' => 1 в config.php

### Проблема: Таблица в админке пустая

✓ Проверить multiconfig.php загружается
✓ Проверить синтаксис PHP в multiconfig.php

## 📚 Полная документация

- [engine/conf/MULTISITE_GUIDE.md](../engine/conf/MULTISITE_GUIDE.md) - Подробное руководство
- [engine/conf/multiconfig.example.php](../engine/conf/multiconfig.example.php) - Примеры конфигураций
- [README_MULTISITE.md](../README_MULTISITE.md) - Быстрый старт

## 💡 Примеры использования

### Пример 1: Три сайта - один движок

```
main  → test.ru         (новостной портал)
blog  → blog.test.ru    (блог компании)
shop  → shop.test.ru    (интернет-магазин)
```

### Пример 2: Сеть филиалов

```
head    → company.ru      (головной офис)
moscow  → msk.company.ru  (Московский филиал)
spb     → spb.company.ru  (Питерский филиал)
```

### Пример 3: Разработка

```
main     → test.ru        (production)
dev      → dev.test.ru    (development)
staging  → stage.test.ru  (staging)
```

---

**Удачи! 🚀**
