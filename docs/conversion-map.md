# Карта конверсий шаблонов (Legacy → Twig)

Ниже собраны все места, где в коде регистрируются конверсии старого шаблонного синтаксиса (квадратные скобки, фигурные плейсхолдеры и т. п.) в новый Twig-синтаксис. Для каждого шаблона указано:

- где задаётся конверсия (файл кода),
- какой файл шаблона затрагивается,
- соответствия «старый → новый».
  Примечание: соответствия перечислены исходя из фактических таблиц конверсий в коде ($conversionConfig, $conversionConfigRegex, $conversionConfigE и т. п.).

См. также

- Справочник переменных в шаблонах: [docs/twig-variables.md](./twig-variables.md)
- Главная информация о репозитории и установке: [README.md](../README.md)

## Общие договорённости

- Старые плейсхолдеры вида `{name}` → Twig-переменные `{{ name }}`.
- Старые блоки `[entries]...[/entries]` → Twig-циклы `{% for entry in entries %}...{% endfor %}`.
- Старые условные блоки вида `[something]...[/something]` → Twig-условия `{% if (...) %}...{% endif %}` по смыслу флага.

---

## Категории новостей: `news.categories.tpl`

- Регистрируется в: `engine/includes/inc/functions.inc.php`
- Строки: около 1260–1310
- Конверсия:
  - `[entries]` → `{% for entry in entries %}`
  - `[/entries]` → `{% endfor %}`
  - `[flags.active]` → `{% if (entry.flags.active) %}`
  - `[/flags.active]` → `{% endif %}`
  - `[!flags.active]` → `{% if (not entry.flags.active) %}`
  - `[/!flags.active]` → `{% endif %}`
  - `[flags.counter]` → `{% if (entry.flags.counter) %}`
  - `[/flags.counter]` → `{% endif %}`

---

## Личное меню пользователя: `usermenu.tpl`

- Регистрируется в: `engine/includes/inc/functions.inc.php` (функция `coreUserMenu`)
- Строки: около 2700–2830
- Regex-конверсия блоков:
  - `[login]...[/login]` → `{% if (not flags.isLogged) %}...{% endif %}`
  - `[isnt-logged]...[/isnt-logged]` → `{% if (not flags.isLogged) %}...{% endif %}`
  - `[is-logged]...[/is-logged]` → `{% if (flags.isLogged) %}...{% endif %}`
  - `[login-err]...[/login-err]` → `{% if (flags.loginError) %}...{% endif %}`
  - `[if-have-perm]...[/if-have-perm]` → `{% if (global.flags.isLogged and (global.user['status'] <= 3)) %}...{% endif %}`
- Плейсхолдеры:
  - `{avatar_url}` → `{{ avatar_url }}`
  - `{profile_link}` → `{{ profile_link }}`
  - `{addnews_link}` → `{{ addnews_link }}`
  - `{logout_link}` → `{{ logout_link }}`
  - `{phtumb_url}` → `{{ phtumb_url }}`
  - `{name}` → `{{ name }}`
  - `{result}` → `{{ result }}`
  - `{home_url}` → `{{ home_url }}`
  - `{redirect}` → `{{ redirect }}`
  - `{reg_link}` → `{{ reg_link }}`
  - `{lost_link}` → `{{ lost_link }}`
  - `{form_action}` → `{{ form_action }}`

---

## Регистрация: `registration.tpl` и `registration.entries.tpl`

- Регистрируется в: `engine/cmodules.php`
- Строки: около 180–210
- Regex-конверсия в `registration.tpl`:
  - `[captcha]...[/captcha]` → `{% if (flags.hasCaptcha) %}...{% endif %}`
  - `{entries}` → `{% for entry in entries %}{% include "registration.entries.tpl" %}{% endfor %}`
- Плейсхолдеры в `registration.tpl`:
  - `{form_action}` → `{{ form_action }}`
- Плейсхолдеры в `registration.entries.tpl` (внутри цикла):
  - `{name}` → `{{ entry.name }}`
  - `{title}` → `{{ entry.title }}`
  - `{descr}` → `{{ entry.descr }}`
  - `{error}` → `{{ entry.error }}`
  - `{input}` → `{{ entry.input }}`

---

## Доп. поля (xfields): `plugins/xfields/tpl/news.table.tpl`

- Регистрируется в: `engine/plugins/xfields/xfields.php`
- Строки: около 920–980, 1210–1216
- Конверсия:
  - `[entries]` → `{% for entry in entries %}`
  - `[/entries]` → `{% endfor %}`
  - Динамические поля таблицы: `{entry_field_<id>}` → `{{ entry.field_<id> }}`
    Примечание: шаблон `plugins/xfields/tpl/news.show.images.tpl` также подключается через `setConversion`, однако явная таблица конверсий внутри текущего контекста кода не показана. Он используется для рендера блоков изображений доп. полей.

---

## Профиль пользователя (плагин uprofile)

### `users.tpl`

- Регистрируется в: `engine/plugins/uprofile/uprofile.php`
- Строки: около 120–170
- Плейсхолдеры:
  - `{user}` → `{{ user.name }}`
  - `{news}` → `{{ user.news }}`
  - `{com}` → `{{ user.com }}`
  - `{status}` → `{{ user.status }}`
  - `{last}` → `{{ user.last }}`
  - `{reg}` → `{{ user.reg }}`
  - `{from}` → `{{ user.from }}`
  - `{info}` → `{{ user.info }}`
  - `{avatar}` → `{{ user.avatar }}`
  - `{tpl_url}` → `{{ tpl_url }}`
- Regex-конверсия:
  - `{l_uprofile:...}` → `{{ lang.uprofile['...'] }}`

### `profile.tpl`

- Регистрируется в: `engine/plugins/uprofile/uprofile.php`
- Строки: около 210–290
- Плейсхолдеры (частично со вставками Twig в значения):
  - `{php_self}` → `{{ php_self }}`
  - `{name}` → `{{ user.name }}`
  - `{regdate}` → `{{ user.reg }}`
  - `{last}` → `{{ user.last }}`
  - `{status}` → `{{ user.status }}`
  - `{news}` → `{{ user.news }}`
  - `{comments}` → `{{ user.com }}`
  - `{email}` → `{{ user.email }}`
  - `{from}` → `{{ user.from }}`
  - `{about}` → `{{ user.info }}`
  - `{about_sizelimit_text}` → `{{ info_sizelimit_text }}`
  - `{about_sizelimit}` → `{{ info_sizelimit }}`
  - `{avatar}` → сложный Twig-блок с условием `flags.avatarAllowed` и `user.flags.hasAvatar`
  - `{form_action}` → `{{ form_action }}`
  - `{token}` → `{{ token }}`
  - `{tpl_url}` → `{{ tpl_url }}`
- Regex-конверсия:
  - `{l_uprofile:...}` → `{{ lang.uprofile['...'] }}`
  - `{plugin_xfields_<id>}` → `{{ p.xfields[<id>] }}`

---

## Последние комментарии: `<prefix>lastcomments.tpl` и `<prefix>entries.tpl`

- Регистрируется в: `engine/plugins/lastcomments/lastcomments.php`
- Строки: около 170–220
- Regex-конверсия блоков:
  - `[profile]...[/profile]` → `{% if (entry.author_id) and (pluginIsActive('uprofile')) %}...{% endif %}`
  - `[answer]...[/answer]` → `{% if (entry.answer != '') %}...{% endif %}`
  - `[nocomments]...[/nocomments]` → `{% if (comnum == 0) %}...{% endif %}`
- Плейсхолдеры (используются и в `entries.tpl`):
  - `{tpl_url}` → `{{ tpl_url }}`
  - `{link}` → `{{ entry.link }}`
  - `{date}` → `{{ entry.date }}`
  - `{author}` → `{{ entry.author }}`
  - `{author_id}` → `{{ entry.author_id }}`
  - `{title}` → `{{ entry.title }}`
  - `{text}` → `{{ entry.text }}`
  - `{category_link}` → `{{ entry.category_link }}`
  - `{comnum}` → `{{ entry.comnum }}`
  - `{author_link}` → `{{ entry.author_link }}`
  - `{avatar}` → `{{ entry.avatar }}`
  - `{avatar_url}` → `{{ entry.avatar_url }}`
  - `{answer}` → `{{ entry.answer }}`
  - `{name}` → `{{ entry.name }}`
  - `{alternating}` → `{{ entry.alternating }}`
  - `{entries}` → `{% for entry in entries %}{% include localPath(0) ~ "entries.tpl" %}{% endfor %}`

---

## Календарь: `calendar.tpl` и `entries.tpl`

- Регистрируется в: `engine/plugins/calendar/calendar.php`
- Строки: около 150–190
- Плейсхолдеры для `calendar.tpl`:
  - `{entries}` → `{% for week in weeks %}{% include localPath(0) ~ "entries.tpl" %}{% endfor %}`
  - `{current_link}` → `<a href="{{ currentMonth.link }}">{{ currentMonth.name }}</a>`
  - `{tpl_url}` → `{{ tpl_url }}`
- Regex-конверсия блоков:
  - `[prev_link]...[/prev_link]` → `{% if (flags.havePrevMonth) %}<a href="{{ prevMonth.link }}">...{% endif %}`
  - `[next_link]...[/next_link]` → `{% if (flags.haveNextMonth) %}<a href="{{ nextMonth.link }}">...{% endif %}`
- Автогенерация по дням недели (`for i` из кода):
  - `{l_weekday_0}`..`{l_weekday_6}` → `{{ weekdays[i] }}`
- Для `entries.tpl` (по дням недели 1..7):
  - `{cl1}`..`{cl7}` → `{{ week[i].className }}`
  - `{d1}`..`{d7}` → Twig-условный линк по `week[i].countNews`

---

## Архив: `archive.tpl` и `entries.tpl`

- Регистрируется в: `engine/plugins/archive/archive.php`
- Строки: около 80–110
- Плейсхолдеры для `archive.tpl`:
  - `{archive}` → `{% for entry in entries %}{% include localPath(0) ~ "entries.tpl" %}{% endfor %}`
  - `{tpl_url}` → `{{ tpl_url }}`
- Плейсхолдеры для `entries.tpl`:
  - `{link}` → `{{ entry.link }}`
  - `{title}` → `{{ entry.title }}`
  - `{cnt}` → `{{ entry.cnt }}`
  - `{ctext}` → `{{ entry.ctext }}`
- Regex-конверсия блоков:
  - `[counter]...[/counter]` → `{% if (entry.counter) %}...{% endif %}`

---

## Уведомления (feedback): `site.notify.tpl`

- Упоминание в: `engine/plugins/feedback/feedback.php`
- Особенности:
  - Шаблон `site.notify.tpl` загружается так: `$twig->loadTemplate($tpath['site.notify'].'site.notify.tpl', $conversionConfig)`.
  - Явная таблица конверсий в данном файле не задаётся через `setConversion`, следовательно предполагается, что `site.notify.tpl` написан на чистом Twig и не требует legacy-конверсий.

---

## Информация об авторе новости: (плагин `news_author_info`)

- Файл: `engine/plugins/news_author_info/news_author_info.php`
- Особенности:
  - Плагин рендерит данные в Twig-шаблон(ы) напрямую, явные таблицы конверсий не регистрирует.
  - Встречается вспомогательная переменная `$conversionParams`, но `setConversion()` не вызывается — значит, старый синтаксис в рамках этого плагина не используется.

---

## Служебное: как работает `setConversion` (NGTwigLoader)

- Источник: `engine/classes/NGTwigLoader.class.php`
- Метод: `setConversion($name, $variables, $regexp = [], $options = [])`
  - Назначение: регистрирует карту подстановок (простых и regex) для конкретного шаблона.
  - Подстановки применяются при загрузке контента шаблона, до компиляции Twig.
- Колбэки:
  - `isPluginHandlerCallback` и `isHandlerCallback` — служебные функции, используемые при regex-подстановках для условных блоков, зависящих от активности плагинов (преобразуют условные конструкции в Twig `{% if pluginIsActive(...) %}...{% endif %}`).

---

## Дополнительно

- Класс `NGTwigLoader::setConversion($name, $variables, $regexp = [], $options = [])` хранит карты конверсий на уровне конкретного шаблона. Сами подмены выполняются при загрузке контента шаблона.
- Если вам попадутся шаблоны, ещё использующие старый синтаксис, можно ориентироваться по аналогии: плейсхолдеры в фигурных скобках становятся `{{ ... }}`, блочные конструкции в квадратных — Twig `{% if/for %}`.
  Если нужен экспорт этой матрицы в таблицу или дополнение новыми шаблонами — скажите, расширю документ.
