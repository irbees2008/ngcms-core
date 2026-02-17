# Настройка robots.txt для мультисайта NGCMS

## Как это работает

Для каждого мультисайта можно создать отдельный `robots.txt` файл, который будет автоматически показываться для соответствующего домена.

## Структура файлов

```
engine/conf/
├── robots.txt                  ← robots.txt для основного сайта (it, localhost)
└── multi/
    ├── blog/
    │   └── robots.txt          ← robots.txt для blog.test.ru
    └── shop/
        └── robots.txt          ← robots.txt для shop.example.com
```

## Динамический robots.php

В корне сайта находится файл `robots.php`, который:

1. Определяет текущий домен через `$_SERVER['HTTP_HOST']`
2. Загружает соответствующий конфиг мультисайта
3. Отдает правильный `robots.txt` для текущего домена

##.htaccess настройка

```apache
# Dynamic robots.txt for multisite
RewriteRule ^robots\.txt$ robots.php [L]
```

Запросы к `/robots.txt` автоматически перенаправляются на `robots.php`.

## Placeholder'ы в robots.txt

В файлах robots.txt можно использовать placeholder'ы:

- `{SITE_URL}` - заменяется на `home_url` из конфига (например, `http://blog.test.ru`)
- `{DOMAIN}` - заменяется на текущий домен (например, `blog.test.ru`)

### Пример robots.txt для мультисайта:

```
User-agent: *
Disallow: /engine/
Disallow: /templates/
Allow: /uploads/

User-agent: Yandex
Disallow: /engine/
Disallow: /templates/
Allow: /uploads/

# AI Search боты
User-agent: OAI-SearchBot
Allow: /

User-agent: PerplexityBot
Allow: /

# AI Training боты (блокированы)
User-agent: GPTBot
Disallow: /

User-agent: ClaudeBot
Disallow: /

# Sitemaps
Sitemap: {SITE_URL}/sitemap.xml
Sitemap: {SITE_URL}/gsmg.xml

Host: {DOMAIN}
```

После обработки `{SITE_URL}` → `http://blog.test.ru`, `{DOMAIN}` → `blog.test.ru`

## Создание robots.txt для нового мультисайта

### Автоматически

При добавлении нового мультисайта через админ-панель (Конфигурация → Управление мультисайтом):

- Автоматически копируется `robots.txt` из `engine/conf/robots.txt`
- Сохраняется в `engine/conf/multi/{site_id}/robots.txt`
- Placeholder'ы автоматически работают без изменений

### Вручную

1. Скопировать template:

```bash
cp engine/conf/robots.txt engine/conf/multi/новый_сайт/robots.txt
```

2. Отредактировать при необходимости (можно оставить placeholder'ы)

3. Сохранить файл

4. Готово! robots.txt для нового домена работает автоматически

## Различные robots.txt для каждого мультисайта

### Пример 1: Основной сайт - полная индексация

**engine/conf/robots.txt:**

```
User-agent: *
Disallow: /engine/
Allow: /

Sitemap: {SITE_URL}/sitemap.xml
Host: {DOMAIN}
```

### Пример 2: Blog - блокировать архивы

**engine/conf/multi/blog/robots.txt:**

```
User-agent: *
Disallow: /engine/
Disallow: /archive/
Allow: /

Sitemap: {SITE_URL}/sitemap.xml
Host: {DOMAIN}
```

### Пример 3: Test сайт - полностью закрыт

**engine/conf/multi/test/robots.txt:**

```
User-agent: *
Disallow: /

# Закрыто для индексации
```

## Проверка работы

### Через браузер:

```
http://it/robots.txt           → показывает engine/conf/robots.txt
http://blog.test.ru/robots.txt → показывает engine/conf/multi/blog/robots.txt
http://shop.test.ru/robots.txt → показывает engine/conf/multi/shop/robots.txt
```

### Через curl:

```bash
curl http://it/robots.txt
curl http://blog.test.ru/robots.txt
```

### Через PowerShell:

```powershell
Invoke-WebRequest -Uri "http://blog.test.ru/robots.txt" | Select-Object -ExpandProperty Content
```

## Тестирование в Google Search Console

1. Зайти в Google Search Console
2. Выбрать нужный домен (например, blog.test.ru)
3. Открыть инструменты → robots.txt Tester
4. Проверить содержимое и протестировать URL

## Интеграция с плагином robots_editor

Если установлен плагин `robots_editor`:

- Плагин генерирует содержимое через функцию `robots_editor_generate_content_twig()`
- robots.php автоматически использует сгенерированное содержимое
- Настройки плагина применяются ко ВСЕМ мультисайтам

Чтобы иметь разные настройки для каждого мультисайта:

- Отключить плагин robots_editor ИЛИ
- Использовать статические файлы robots.txt в каждом `engine/conf/multi/{site_id}/`

## Troubleshooting

### Проблема: Все домены показывают одинаковый robots.txt

**Причины:**

1. Не включен мультисайт (`use_multisite = 0` в config.php)
2. Не создан файл `engine/conf/multi/{site_id}/robots.txt`
3. Ошибка в .htaccess

**Решение:**

```php
// Проверить engine/conf/config.php
'use_multisite' => '1',  // Должно быть 1

// Создать robots.txt для мультисайта
cp engine/conf/robots.txt engine/conf/multi/blog/robots.txt

// Проверить .htaccess содержит:
RewriteRule ^robots\.txt$ robots.php [L]
```

### Проблема: 404 ошибка на /robots.txt

**Причины:**

1. Файл robots.php отсутствует в корне

**Решение:**

- Проверить наличие файла `robots.php` в корне сайта
- Проверить права доступа (должен быть readable)

### Проблема: Placeholder'ы не заменяются

**Причины:**

1. Неправильный синтаксис placeholder'ов
2. Ошибка в robots.php

**Решение:**

- Использовать точный синтаксис: `{SITE_URL}` и `{DOMAIN}` (заглавные буквы, фигурные скобки)
- Проверить логи ошибок PHP

## Продвинутая настройка

### Разные правила для разных user-agent

```
# Основной сайт - разрешить все
User-agent: *
Allow: /

# Blog - ограничить глубину
User-agent: *
Disallow: /page/
Crawl-delay: 10

# Shop - запретить фильтры
User-agent: *
Disallow: /*?filter=
Disallow: /*?sort=
```

### Блокировка AI ботов

```
# Блокировать обучение AI
User-agent: GPTBot
Disallow: /

User-agent: ClaudeBot
Disallow: /

User-agent: Google-Extended
Disallow: /

# Но разрешить AI поиск
User-agent: OAI-SearchBot
Allow: /

User-agent: PerplexityBot
Allow: /
```

### Множественные Sitemaps

```
Sitemap: {SITE_URL}/sitemap.xml
Sitemap: {SITE_URL}/sitemap-news.xml
Sitemap: {SITE_URL}/sitemap-images.xml
Sitemap: {SITE_URL}/gsmg.xml
```

## На хостинге

На реальном хостинге все работает точно так же:

1. Все домены указывают на одну папку (через парковку или symlink)
2. robots.php определяет домен и отдает нужный robots.txt
3. Никаких дополнительных настроек не требуется

### Важно для SEO:

- Каждый мультисайт должен иметь свой robots.txt с правильным `Host:`
- В Sitemap указывать полные URL с доменом мультисайта
- В Google Search Console добавить каждый домен мультисайта отдельно
- Проверять robots.txt через инструменты для вебмастеров

## Резюме

✓ Один файл robots.php обслуживает все мультисайты
✓ Каждый мультисайт имеет свой robots.txt в engine/conf/multi/{site_id}/
✓ Placeholder'ы автоматически заменяются на правильные значения
✓ При добавлении нового мультисайта robots.txt копируется автоматически
✓ Поддержка плагина robots_editor (опционально)
✓ Работает одинаково на локальной разработке и на хостинге
