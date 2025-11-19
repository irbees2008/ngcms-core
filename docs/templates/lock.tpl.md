# Шаблон lock.tpl
## Назначение
`lock.tpl` используется, когда сайт переведён в режим «Заблокировать сайт» (Настройки → Настройки системы → Основные настройки) и при этом отсутствует шаблон `sitelock.tpl`. В актуальных версиях NGCMS не используются legacy‑блоки вида `[sitelock] ... [/sitelock]`: вывод блокировки происходит напрямую через Twig.
Приоритет шаблонов при блокировке
---
1. Если существует `sitelock.tpl`, движок выведет его содержимое.
2. Иначе будет использован `lock.tpl`.
   Доступные переменные
---
- `{{ lock_reason }}` — причина блокировки, задаётся в админ‑панели (Настройки → Настройки системы → Основные настройки → «Причина блокировки сайта»).
  Рекомендации по верстке
---
- Используйте Twig‑синтаксис и стандартные переменные; не применяйте устаревшие маркеры.
- Добавьте минимальную разметку/стили для понятного сообщения пользователю.
  Пример (Twig)
---
```twig
<section class="site-locked">
	<h1>{{ lang['site_locked']|default('Сайт временно недоступен') }}</h1>
	<p>{{ lock_reason }}</p>
	<p><a href="{{ home }}">{{ lang['go_home']|default('На главную') }}</a></p>
</section>
<style>
.site-locked{max-width:720px;margin:12vh auto;font:16px/1.5 Arial, sans-serif;text-align:center;color:#333}
.site-locked h1{font-size:28px;margin:0 0 12px}
.site-locked p{margin:8px 0}
.site-locked a{color:#0a58ca;text-decoration:none}
.site-locked a:hover{text-decoration:underline}
</style>
```
## См. также
- Основной каркас: `templates/main.tpl.md`
- Альтернативный шаблон блокировки: `templates/sitelock.tpl.md`
