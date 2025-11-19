## Шаблон main.tpl (актуальный Twig вариант)
Файл `main.tpl` формирует каркас HTML‑страницы: `<!DOCTYPE>`, `<html>`, `<head>`, `<body>`, общие CSS/JS, шапку, меню, область контента (`{{ mainblock }}`) и футер.
### Основные задачи
- Подключить метаданные: `{{ metatags }}`, `{{ canonical }}`, `{{ htmlvars }}`.
- Вывести глобальные переменные: `{{ what }}`, `{{ version }}`, `{{ titles }}`.
- Разместить служебный блок загрузки (`#loading-layer`).
- Отрисовать меню, поиск (`{{ search_form }}`), личный блок (`{{ personal_menu }}`) или форму входа.
- Вывести основной контент через `{{ mainblock }}` и при необходимости дополнительные сайдбар-блоки (вызовы плагинов через `callPlugin`).
### Больше нет legacy‑блоков
Конструкции вида `[sitelock] ... [/sitelock]`, `[is-logged]`, `[debug]` устарели. Их заменяют Twig‑условия:
```twig
{% if global.flags.isLogged %} ... {% endif %}
{% if pluginIsActive('archive') %}{{ callPlugin('archive.show', {...}) }}{% endif %}
```
### Часто используемые переменные
- `{{ mainblock }}` – основной контент текущей страницы.
- `{{ home }}` – абсолютный/относительный корень сайта.
- `{{ titles }}` – заголовок страницы (используется внутри `<title>`).
- `{{ htmlvars }}` – подключение стилей/скриптов ядра и плагинов.
- `{{ queries }}`, `{{ exectime }}`, `{{ memPeakUsage }}` – показатели производительности.
- `{{ personal_menu }}` – блок пользователя (шаблон `usermenu.tpl`).
- `{{ search_form }}` – форма быстрого поиска.
- `{{ notify|raw }}` – накопленные уведомления (выводится после основной разметки).
- `{{ lang[...] }}` – языковые строки.
### Подключение JS/CSS
Правильное место – внутри `<head>` для критичных стилей и в конце `<body>` для поведения. Пример:
```twig
<link rel="stylesheet" href="{{ tpl_url }}/css/style.css">
<script src="{{ scriptLibrary }}/functions.js"></script>
<script src="{{ scriptLibrary }}/ajax.js"></script>
```
### Пример модернизированного main.tpl (упрощённая версия)
```twig
<!DOCTYPE html>
{% apply spaceless %}
<html lang="{{ lang['langcode'] }}">
	<head>
		<meta charset="{{ lang['encoding'] }}"/>
		<meta name="generator" content="{{ what }} {{ version }}"/>
		{{ metatags }}
		{{ canonical }}
		{{ htmlvars }}
		<link rel="stylesheet" href="{{ tpl_url }}/css/style.css">
		<title>{{ titles }}{% if pagination_current and pagination_current > 1 %} — Стр. {{ pagination_current }}{% endif %}</title>
	</head>
	<body>
		<div id="loading-layer"><img src="{{ tpl_url }}/img/loading.gif" alt=""/></div>
		<header id="header">
			<a id="logo" href="{{ home }}"><img src="{{ tpl_url }}/img/logo.png" alt="Logo"></a>
			{% if global.flags.isLogged %}
				{{ personal_menu }}
			{% else %}
				<div id="auth"><a href="/register/">{{ lang.registration }}</a></div>
			{% endif %}
			<nav class="menu">
				<ul>
					<li><a href="{{ home }}">{{ lang.theme.home }}</a></li>
					<li><a href="#">{{ lang.theme.news }}</a></li>
				</ul>
			</nav>
			<div id="search">{{ search_form }}</div>
		</header>
		<main id="content">
			{% if isHandler('news:main|news:by.category') %}
				<div class="articles">{{ mainblock }}</div>
			{% else %}
				{{ mainblock }}
			{% endif %}
		</main>
		<aside id="sidebar">
			{% if pluginIsActive('archive') %}{{ callPlugin('archive.show', {'maxnum': 12, 'template': 'archive'}) }}{% endif %}
			{% if pluginIsActive('tags') %}{{ plugin_tags }}{% endif %}
		</aside>
		<footer id="footer">
			<p>&copy; {{ now|date('Y') }} Powered by <a href="http://ngcms.ru/" target="_blank">NG CMS</a><br>
				 {{ lang.sql_queries }}: <b>{{ queries }}</b> | {{ lang.page_generation }}: <b>{{ exectime }}</b> {{ lang.sec }} | <b>{{ memPeakUsage }} Mb</b>
			</p>
		</footer>
		{{ notify|raw }}
	</body>
</html>
{% endapply %}
```
### Отладка
Для отображения профайлера используйте условие и переменные `debug_queries`, `debug_profiler` (видимы администратору):
```twig
{% if pluginIsActive('debug') %}
	<div class="debug">{{ debug_queries }}<br>{{ debug_profiler }}</div>
{% endif %}
```
### Рекомендации
- Минимизируйте inline‑стили, выносите в отдельные `.css`.
- Не размещайте тяжёлые блоки (большие циклы) внутри `main.tpl` – выносите в включаемые шаблоны.
- Старайтесь не смешивать логику и оформление: вся логика – в PHP/плагинах, отображение – в Twig.
- Проверяйте активность плагинов через `pluginIsActive()` перед выводом их блоков.
### Ссылка на CMS
Добавление ссылки «Powered by NG CMS» во футере – хорошая практика:
```twig
<p>Powered by <a href="http://ngcms.org/" target="_blank">NG CMS</a></p>
```
Этот пример можно использовать как стартовую точку при создании собственного шаблона.
