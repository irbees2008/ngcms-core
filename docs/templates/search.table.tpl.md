# Шаблон `search.table.tpl`
Шаблон отвечает за генерацию полной поисковой формы и отображения результатов поиска.
Фактически этот шаблон – часть шаблона [main.tpl](templates/main.tpl.md), но для удобства работы поисковая форма была вынесена в отдельный `.tpl` файл.
Шаблон должен содержать форму (тег `<form>`, метод запроса – *GET* или *POST*), которая позволит вводить параметры поиска.
## Доступные блоки / переменные
### Поля ввода
В форме поддерживаются следующие поля ввода с именами:
- `search` (тип: `text`) – строка для поиска;
- `author` (тип: `text`) – автор новости;
- `catid` (тип: `select`) – выбор категории новостей; содержимое генерируется в переменой `{{ catlist }}` ядра;
- `postdate` (тип: `select`) – выбор даты новостей; содержимое списка месяцев в виде блока `<option value="ГОД_МЕСЯЦ">ГОД_МЕСЯЦ</option>` генерируется в переменной `{{ datelist }}` ядра.
### Блоки:
- `flags` – блок переменных-флагов:
    - `found` – содержимое блока отображается в случае, если в результатах поиска найдена одна или более новостей;
    - `notfound` – содержимое блока отображается в случае, если в результатах поиска не найдено ни одной новости;
    - `error` – содержимое блока отображается при незаполнении обязательного *HTML* поля `search` (строка для поиска).
- `{{ entries }}` – блок с найденными новостями.
Для отображения блока с найденными новостями используется шаблон [news.search.tpl](templates/news.search.tpl.md), при его отсутствии – [news.short.tpl](templates/news.short.tpl.md).
### Переменные:
- `{{ form_url }}` – URL поисковой формы;
- `{{ count }}` – количество найденных в результатах поиска новостей;
- `{{ search }}` – полученное значение поля `search` (строка поиска), введенное в форме поиска;
- `{{ author }}` – полученное значение поля `author` (автор новости), введенное в форме поиска;
- `{{ catlist }}` – блок с кодом *HTML* для поля `catid` из поисковой формы;
- `{{ datelist }}` – блок с кодом *HTML* для выпадающего списка `postdate` из поисковой формы;
### Доступные языковые переменные:
- `{{ lang['search.filter.author'] }}` - текст «Автор» для поля ввода `author`;
- `{{ lang['search.filter.category'] }}` - текст «Категория» для поля ввода `catlist`;
- `{{ lang['search.filter.date'] }}` - текст «Дата» для поля ввода `postdate`;
- `{{ lang['search.submit'] }}` - текст «Поиск» для кнопки отправки формы;
- `{{ lang['search.found'] }}` - текст «Найдено новостей» для блока `flags.found`);
- `{{ lang['search.notfound'] }}` - текст «Не найдено ни одной записи, удовлетворяющей вашему запросу» для блока `flags.notfound`;
- `{{ lang['search.error'] }}` - текст «Возможно вы не задали слово для поиска, либо оно состоит из менее чем 3-х букв!» для блока `flags.error`.
## Пример заполнения шаблона
В примере показан минимально набор для полнофункциональной работы:
```html
{% if (flags.found) %}
	<div class="alert alert-success">{{ lang['search.found'] }}:
		<b>{{ count }}</b>
	</div>
{% endif %}
{% if (flags.notfound) %}
	<div class="alert alert-info">{{ lang['search.notfound'] }}</div>
{% endif %}
{% if (flags.error) %}
	<div class="alert alert-error">
		<b>{{ lang['search.error'] }}</b>
	</div>
{% endif %}
<form action="{{ form_url }}" method="get">
	<div class="block-title">{{ lang['search.site_search'] }}</div>
	<table border="0" width="100%" cellspacing="0" cellpadding="0" style="margin:20px 0 0 0;">
		<tr align="center">
			<td>{{ lang['search.filter.author'] }}
				<input type="text" name="author" class="input" value="{{ author }}" style="width:130px"/>
			</td>
			<td>{{ lang['search.filter.category'] }}
				<div class="search_catz">{{ catlist }}</div>
			</td>
			<td>{{ lang['search.filter.date'] }}
				<select name="postdate">
					<option value=""></option>
					{{ datelist }}
				</select>
			</td>
		</tr>
	</table>
	<table border="0" width="100%" cellspacing="0" cellpadding="0" style="margin:0 0 20px 0;">
		<tr>
			<td align="center">
				<br/>
				<input type="text" name="search" value="{{ search }}" style="width:400px" class="input"/>
				<input type="submit" value="{{ lang['search.submit'] }}" class="button"/>
			</td>
		</tr>
	</table>
</form>
<div class="articles full">
	{% for entry in entries %}
		{{ entry }}
	{% else %}
		<div class="alert alert-info">
			<strong>{{ lang.notifyWindowInfo }}</strong>
			{{ lang['msgi_no_news'] }}
		</div>
	{% endfor %}
	{{ pagination }}
</div>
```
