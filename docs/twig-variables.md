# Справочник Twig‑переменных по шаблонам (темы: default, default2, mangguo)
Документ перечисляет часто используемые Twig‑переменные по файлам шаблонов и кратко поясняет их назначение. Переменные доступны в контексте соответствующего экрана/плагина, поэтому часть из них появляется только при рендере конкретного модуля (поиска, статических страниц, комментариев, плагинов и т. д.).
- Нотация lang.\* — строки локализации, доступны глобально.
- Глобальные помощники: pluginIsActive('name'), фильтры (например, |truncateHTML, |striptags, |date, |cdate), функции random().
- Глобальные пути: home (URL сайта), tpl_url (URL активной темы), admin_url, scriptLibrary.
- Глобальные блоки (по ситуации): mainblock, categories, notify, personal_menu, search_form, voting, switcher.
- Глобальные флаги/пользователь: global.flags._, global.user._ (см. usermenu в default2).
## Тема: default
### main.tpl
- lang['langcode'], lang['encoding'] — язык/кодировка.
- what, version — строка генератора.
- htmlvars — HTML‑вставки из ядра (meta/скрипты).
- tpl_url — URL текущей темы (CSS/JS/изображения).
- scriptLibrary — базовая папка JS (jq, functions.js, ajax.js).
- home, home_title — базовый URL и заголовок сайта.
- titles — заголовок страницы (title).
- personal_menu — пользовательское меню (зависит от авторизации).
- search_form — форма поиска.
- notify — контейнер уведомлений.
- mainblock — основной контент страницы.
- voting — блок опроса (если подключен).
- switcher — блок переключателей (если подключен).
- now|date('Y') — текущий год.
- queries, exectime, memPeakUsage — отладочная статистика (если включена).
- lang.theme.\* — строки темы (подписи меню/подвал и т. п.).
### news.short.tpl
- news.url.full — ссылка на новость.
- news.title — заголовок новости.
- news.date — дата публикации (готовая строка).
- news.author.name, news.author.url — автор и ссылка на профиль (если активен uprofile).
- news.categories.masterText — основная категория в виде текста.
- news.short — краткий текст; часто используется с |truncateHTML(... )|striptags.
- news.views — просмотры (если выводится в теме).
- news.embed.imgCount, news.embed.images[] — встроенные изображения (если подготовлено ядром).
- tpl_url — ресурсы темы (заглушка для картинки).
### pages.tpl
- previous_page, pages, next_page — пагинация для списков.
### Вложения новостей (\_files и \_images)
При выводе новостей (и в списках, и в полной новости) доступен массив `_files` — прикреплённые файлы к записи, и `_images` — прикреплённые изображения.
Элементы `_files[]` содержат:
- plugin — идентификатор плагина‑источника (обычно пусто для обычных вложений).
- pidentity — дополнительная идентификация плагина (если применимо).
- url — абсолютный URL до файла (учитывает storage и папку).
- name — имя файла на диске.
- origName — исходное имя файла (для отображения).
- description — описание файла (если задано при загрузке в админке).
- size — размер файла в байтах (число).
- filesize — человекочитаемый размер (строка, напр. “1.2 Mb”).
  Элементы `_images[]` содержат:
- plugin, pidentity — аналогично `_files`.
- url — URL изображения.
- purl — URL превью (если есть превью/thumbnail), иначе null.
- width, height — исходные размеры изображения.
- pwidth, pheight — размеры превью.
- name, origName, description — метаданные для отображения.
- flags.hasPreview — булево, есть ли превью.
  Почему это важно и как реализовано:
- Запрос «покажи размер файла» часто нужен в шаблоне рядом с ссылкой на вложение. Мы добавили вычисление размера на сервере и два поля `size`/`filesize` для удобства вывода.
- Размер вычисляется по диску по пути `attach_dir` или `files_dir` + `folder/name`. Форматирование — через системную функцию `Formatsize()`.
- Если файл отсутствует или недоступен — `filesize` будет пустой строкой; используйте Twig‑проверку `{% if file.filesize %}` для условного вывода.
  Пример вывода в шаблоне:
- `{% for file in _files %}`
  `* <a href="{{ file.url }}">{{ file.origName }}</a>{% if file.filesize %} ({{ file.filesize }}){% endif %}<br/>`
  `{% endfor %}`
### redirect.tpl
- lang['langcode'], lang['encoding'] — служебные мета.
  Примечание: редиректы в теме не используются для UX — уведомления заменены на стикеры.
### registration.tpl
- form_action — URL отправки формы регистрации.
- entry.id, entry.title, entry.input, entry.descr — поля, подготовленные модулем регистрации (итерируются в списке).
- admin_url — используется для CAPTCHA.
- random() — параметр для обновления CAPTCHA.
- redirect — скрытое поле для возврата.
- lang._/lang.theme._ — локализация (подсказки, ошибки, заголовки).
### search.table.tpl
- form_url — адрес GET‑формы поиска.
- author — предзаполненное значение автора.
- catlist — HTML со списком категорий (готовый блок).
- datelist — HTML со списком интервалов даты.
- orderlist — HTML для сортировки (если есть в теме default2; в default — может отсутствовать).
- search — поисковая строка.
- count — количество найденного.
- entry — шаблон записи результата (вставка из entries.tpl, если используется).
- pagination — вывод пагинации.
- lang['search.*'] — локализация заголовков/подписей.
### slider.tpl
- tpl_url — путь к изображениям слайдера.
- lang.theme['slider.*'] — подписи к слайдам.
### usermenu.tpl
- p.nsm.link — ссылка на добавление новости (плагин NSM, если активен).
- admin_url — ссылка в админку (для модераторов/админов).
- addnews_link — ссылка на добавление новости.
- profile_link, user_link — профили (зависят от uprofile/ядра).
- p.pm.link, p.pm.pm_unread — личные сообщения (если плагин PM активен).
- logout_link — выход.
- form_action — URL авторизации.
- redirect — возврат после логина.
- lost_link — «Забыли пароль».
- lang.\* — подписи кнопок и полей.
### plugins/uprofile/profile.tpl
- form_action — URL сохранения профиля.
- token — CSRF токен формы.
- user.email, user.from, user.info — данные пользователя.
- info_sizelimit — предельный размер поля «О себе» (число).
- info_sizelimit_text — текст‑подсказка о лимите.
- plugin_xfields_0 — блок доп. полей профиля (если активен xfields).
- lang.uprofile['*'] — локализация плагина профиля.
### plugins/comments/comments.form.tpl
- post_url — URL добавления комментария.
- delete_url — URL удаления комментария.
- edit_url — URL загрузки/сохранения редактирования.
- newsid — ID новости.
- request_uri — реферер для возврата/сообщений.
- savedname, savedmail — предзаполненные поля для гостя.
- bbcodes, smilies — HTML‑вставки редактора.
- captcha_url — URL капчи; rand — параметр кэш‑бейта.
- noajax — флаг, при котором AJAX отправка отключается.
- lang['comments:form.*'] — строки формы.
### plugins/comments/comments.show.tpl
- id — ID комментария (используется в DOM id/JS).
- avatar|raw — HTML аватара.
- profile_link, author — профиль/имя автора.
- date — дата комментария (готовая строка).
- delete_token — токен для удаления.
- text|raw — тело комментария (HTML после фильтров).
- answer|raw, name — ответ администратора и имя отвечающего (если есть).
- edit_info|raw — подпись об изменениях.
- lang['comments:form.*'], lang['comments:external.admin_answer'] — локализация.
## Тема: default2
### 404.internal.tpl
- lang['404.title'], lang['404.description'] — тексты страницы 404.
### search.table.tpl
- tpl_url — фон/стили.
- form_url — адрес формы поиска (GET).
- search — поисковый запрос.
- searchSettings — чекбокс сохранения настроек (cookie, булево в разметке).
- catlist — HTML категорий.
- datelist — HTML диапазона дат (в select).
- orderlist — HTML сортировки (в select).
- author — поле автора.
- entry — элемент результата (вставка).
- pagination — пагинация.
- count — кол-во найденного.
- lang['search.*'], lang.news — подписи.
### usermenu.tpl
- admin_url — ссылка в админку (если global.user.status ≤ 3).
- addnews_link — добавление новости.
- profile_link — редактирование профиля (uprofile).
- p.pm.link, p.pm.pm_unread — личные сообщения (PM плагин).
- logout_link — выход.
- form_action — URL авторизации (модальное окно).
- redirect — возврат после логина.
- lang.\* — подписи.
- global.flags.isLogged, global.user.status — флаги доступа.
### static/default.tpl
- havePermission — право на редактирование статической страницы (bool).
- staticEditLink — ссылка на редактирование.
- staticTitle — заголовок.
- staticContent — содержимое (HTML).
- staticDate — строка даты.
- staticDateStamp|cdate — форматированная дата по таймстампу.
- staticPrintLink — ссылка на печать.
### static/default.print.tpl
- home, home_title — хлебные крошки.
- staticTitle, staticContent — заголовок/содержимое.
- staticDateStamp|cdate — дата печати.
### plugins/calendar/calendar.tpl
- currentEntry.month, currentEntry.year — текущий месяц/год (числа).
- currentMonth.name, currentMonth.link — текущий месяц (название/ссылка).
- prevMonth.link, nextMonth.link — ссылки на соседние месяцы.
- weekdays[1..7] — заголовки дней недели.
- week[1..7].className — класс ячейки (состояния).
- week[1..7].dayNo — номер дня.
- week[1..7].link — ссылка на новости за день (если countNews>0).
- week[1..7].countNews — кол-во новостей в день.
### plugins/nsm (упрощённо)
- news.list.tpl: addURL — ссылка «Добавить новость»; entry._ — поля списка; skins_url — иконки состояний; entry.attach_count, images_count; entry.link/title; entry.flags._; entry.itemdate/approve.
- news.edit.tpl: php_self — URL обработки; token — CSRF; title, alt_name; mastercat, extcat — HTML списков; quicktags, smilies — тулбары; content.short/full/delimiter; flags.\* (mainpage, pinned, catpinned, favorite, html, ...); id; approve; deleteURL; JEV — параметр (JS‑флаг/число).
- news.add.tpl: аналогично edit, но без id; currentURL — action формы.
### plugins/xfields/tpl/uprofile.edit.\*.tpl
- entry.id, entry.title, entry.input — доп. поля профиля.
### smilies.tpl
- smile — имя смайла.
- area — ID поля редактирования.
- skins_url — путь к изображениям смайлов.
### sitelock.tpl
- lang['site_temporarily_disabled'], lang['encoding'], lang['langcode'] — служебные строки.
- what, version — генератор.
- lock_reason — причина блокировки.
### registration.tpl
- lang.registration — заголовок.
- form_action — URL отправки.
- Остальные поля — аналогично теме default (entry.\*, CAPTCHA и пр.).
### plugins/comments/comments.form.tpl
- Аналогично default, плюс могут отличаться классы/кнопки (например, кнопка cancel в модале).
## Тема: mangguo
### main.tpl
- lang['langcode'], lang['encoding'], what, version — мета.
- htmlvars — дополнительные meta/скрипты.
- tpl_url — ресурсы темы (CSS/JS/картинки).
- scriptLibrary — базовая папка JS.
- titles — заголовок страницы.
- home, home_title — ссылки/тексты в шапке/подвале.
- notify — контейнер уведомлений.
- mainblock — основной контент.
- categories — блок категорий (если используется в боковике).
### news.short.tpl / news.table.tpl / pages.tpl
- news.url.full, news.title — ссылка/заголовок.
- news.date — дата публикации.
- news.author.name, news.author.url — автор.
- news.views — просмотры (если выводится).
- catz.id, catz.url, catz.name — вывод категории тегом.
- news.short — анонс; |truncateHTML(... )|striptags — усечение.
- pagination / previous_page / next_page — пагинация.
- lang.notifyWindowInfo, lang['msgi_no_news'] — тексты пустых списков.
### search.form.tpl
- form_url — адрес формы поиска.
- lang['search.enter'] — плейсхолдер input.
### registration.tpl
- lang.registration — заголовок.
- form_action — URL отправки.
- entry.\* — поля регистрации (id/title/input/descr).
- admin_url — CAPTCHA.
- lang.theme['registration.check_rules'] — предупреждение.
### usermenu.tpl (смешанный синтаксис)
- addnews_link — добавление новости.
- admin_url — админка (видна при правах).
- profile_link — профиль (uprofile).
- p.pm.link, p.pm.new — личные сообщения.
- logout_link — выход.
- form_action, redirect, lost_link — авторизация.
  Примечание: в отдельных местах присутствуют артефакты старого синтаксиса — в Twig‑вариантах используйте {{ ... }}.
### plugins/comments/comments.form.tpl / comments.show.tpl
- Набор переменных аналогичен теме default (см. выше).
### Плагин zboard (шаблоны: edit_zboard.tpl, search_zboard.tpl, show_zboard.tpl, zboard.tpl, блоки)
- Общие пути: home, tpl_home, tpl_url.
- error — текст ошибки (если есть).
- id, zid — идентификаторы записи/заказа.
- list_period, options — HTML списков.
- announce_name, announce_description, announce_contacts, author — поля объявления.
- tel_clean — телефон без форматирования (для tel: ссылки).
- entry.\* — в циклах: fulllink, catlink, cat_name, cid, filepath, home, pid, views, date, announce_name/description, price и пр.
- pages.print, prevlink.link, nextlink.link — пагинация.
- vip\_\* — данные VIP‑статуса.
- get_url — текущий URL в выводе поиска.
## Админка (панель управления)
### users/edit.tpl (все скины: default, gray, tabl_default, Velonic, old)
Переменные формы редактирования пользователя в админке унифицированы во всех скинах.
- php_self — базовый обработчик формы (обычно admin.php).
- token — CSRF‑токен формы.
- id — ID пользователя.
- name — логин пользователя (используется в заголовках/крошках).
- status — HTML со списком групп/статусов пользователя (select с option'ами готов к вставке).
- mail — e‑mail пользователя.
- site — веб‑сайт пользователя.
- where_from — место/город.
- info — поле «О себе».
- regdate — дата регистрации (готовая строка).
- last — дата последнего входа (готовая строка).
- ip — последний IP (строка).
- news — количество новостей пользователя (число).
- com — количество комментариев пользователя (число).
  Аватар (новая функциональность):
- flags.avatarAllowed — разрешены ли аватары по конфигу (bool).
- flags.hasAvatar — есть ли у пользователя текущий аватар (bool).
- avatar — URL текущего аватара (строка), используется в <img> предпросмотра.
- avatar_hint — текст‑подсказка с ограничениями по размеру/весу, формируется на сервере из конфига.
- Поля формы: newavatar (input type=file), delavatar (checkbox — «удалить аватар»).
- Требуется enctype="multipart/form-data" на <form>.
- Локализация: lang['avatar'], lang['delete_avatar'], lang['avatars_disabled'].
  Доп. блок (если активен плагин xfields):
- pluginIsActive('xfields') — условие вывода таблицы.
- p.xfields.fields — коллекция доп. полей; внутри цикла доступны:
  - xFN — ID поля,
  - xfV.title — название,
  - xfV.data.type — тип поля,
  - xfV.data.area — блок/область,
  - xfV.input — HTML‑вставка элемента управления,
  - xfV.secure_value — безопасное значение (актуально для отдельных типов).
    Примечания:
- На сервере обработка newavatar/delavatar реализована в users.php (проверки размера из конфигурации, удаление/замена, сообщения об ошибках/информации локализованы).
- Все скины используют одинаковые переменные; различия только в разметке/классах.
## Глобальные заметки и совместимость
- Некоторые темы переопределяют шаблоны плагинов (plugins/... под папкой темы) — используйте переменные, соответствующие базовому шаблону плагина.
- Для комментариев доступны флаги: noajax (отключение JS‑отправки), moderation (сообщения о модерации — если выводятся шаблоном контейнера).
- Уведомления/стикеры на сайте выводятся через глобальный контейнер и JS‑хелперы; шаблоны используют notify‑плейсхолдер для серверных сообщений.
- Если в шаблоне встречается legacy‑синтаксис, см. документ docs/conversion-map.md по соответствиям «старый → Twig».
---
Если чего‑то не хватает для вашего конкретного шаблона — откройте файл темы и сопоставьте {{ ... }} с контекстом из соответствующего модуля (ядро/плагин). Этот справочник покрывает все обнаруженные в темах default, default2 и mangguo переменные из текущего репозитория.
