<script type="text/javascript">
	// === Глобальные переменные / состояние ===
{% if (flags.edit_split) %}
var currentInputAreaID = 'ng_news_content_short';
{% else %}
var currentInputAreaID = 'ng_news_content';{% endif %}

// Унифицированный вывод уведомлений
function notify(type, text) {
if (type === 'error' && typeof show_error === 'function') {
show_error(text);
return;
}
if (typeof show_info === 'function') {
show_info(text);
return;
}
// Fallback
if (type === 'error') {
alert(text);
} else {
console.log(text);
}
}

// Предпросмотр
function preview() {
var form = document.getElementById('postForm');
var contentField = form['ng_news_content{% if (flags.edit_split) %}_short{% endif %}'];
if (! contentField || contentField.value.trim() === '' || form.title.value.trim() === '') {
notify('error', '{{ lang.nsm['err.preview'] }}');
return false;
}
form['mod'].value = 'preview';
form.target = '_blank';
form.submit();
form['mod'].value = 'news';
form.target = '_self';
return true;
}

// Переключение активной области текста
function changeActive(name) {
if (name === 'full') {
document.getElementById('container.content.full').className = 'contentActive';
document.getElementById('container.content.short').className = 'contentInactive';
currentInputAreaID = 'ng_news_content_full';
} else {
document.getElementById('container.content.short').className = 'contentActive';
document.getElementById('container.content.full').className = 'contentInactive';
currentInputAreaID = 'ng_news_content_short';
}
}

// Установка режима (публикация / модерация / черновик)
function approveMode(mode) {
document.getElementById('approve').value = mode;
return true;
}

// Валидация перед отправкой
function validatePostForm() {
var form = document.getElementById('postForm');
if (! form) 
return true;

var title = form.title ? form.title.value.trim() : '';
var bodyShort = form.ng_news_content_short ? form.ng_news_content_short.value.trim() : '';
var bodyFull = form.ng_news_content_full ? form.ng_news_content_full.value.trim() : '';
var bodySingle = form.ng_news_content ? form.ng_news_content.value.trim() : '';
var hasContent = (bodyShort || bodyFull || bodySingle);
if (! title) {
notify('error', 'Введите заголовок');
return false;
}
if (! hasContent) {
notify('error', 'Введите текст новости');
return false;
}
return true;
}

// Сообщения по типу отправки
function announceSubmit() {
var approve = document.getElementById('approve').value;
if (approve == '1') {
notify('info', 'Публикация новости...');
} else if (approve == '0') {
notify('info', 'Отправка на модерацию...');
} else if (approve == '-1') {
notify('info', 'Сохранение черновика...');
}
}

// Перехват отправки формы
document.addEventListener('DOMContentLoaded', function () {
var form = document.getElementById('postForm');
if (! form) 
return;

form.addEventListener('submit', function (e) {
if (! validatePostForm()) {
e.preventDefault();
return false;
}
announceSubmit();
});
});
</script>

<form id="postForm" name="form" enctype="multipart/form-data" method="POST" action="{{ currentURL }}">
	<input type="hidden" name="token" value="{{ token }}"/>
	<input type="hidden" name="mod" value="news"/>
	<input type="hidden" name="approve" id="approve" value="0"/>
	<div class="block-title">{{ lang.nsm['addnews_title'] }}</div>
	<table class="table table-striped table-bordered">
		<tr>
			<th colspan="2">
				<a role="button" href="{{ listURL }}">{{ lang.nsm['news.list'] }}</a>
			</th>
		</tr>
		<tr>
			<td>{{ lang.nsm['newstitle'] }}:</td>
			<td><input type="text" name="title" class="input" value=""/></td>
		</tr>
		<tr>
			<td>{{ lang.nsm['alt_name'] }}:</td>
			<td><input type="text" name="alt_name" class="input" value=""/></td>
		</tr>
		<tr>
			<td>{{ lang.nsm['category'] }}:</td>
			<td>{{ mastercat }}</td>
		</tr>
		{% if flags['multicat.show'] %}
			<tr>
				<td>{{ lang.nsm['dop.categories'] }}:</td>
				<td>{{ extcat }}</td>
			</tr>
		{% endif %}
		{% if (flags.edit_split) %}
			<tr>
				<td colspan="2">
					<b>{{ lang.nsm['news.anons'] }}:</b>
					{{ lang.nsm['desk.news.anons'] }}
					<div>
						<div>{{ quicktags }}<br/>
							{{ smilies }}<br/><br/></div>
						<textarea onclick="changeActive('short');" onfocus="changeActive('short');" name="ng_news_content_short" id="ng_news_content_short" style="width:98%; height: 200px;" class="textarea"></textarea>
					</div>
				</td>
			</tr>
			{% if (flags.extended_more) %}
				<tr>
					<td>{{ lang.nsm['news.more'] }}:</td>
					<td><input tabindex="2" type="text" name="content_delimiter" class="input" value=""/></td>
				</tr>
			{% endif %}
			<tr>
				<td colspan="2">
					<b>{{ lang.nsm['full.news'] }}:</b>
					{{ lang.nsm['desk.news.full'] }}
					<div>
						<div>{{ quicktags }}<br/>
							{{ smilies }}<br/><br/></div>
						<textarea onclick="changeActive('full');" onfocus="changeActive('full');" name="ng_news_content_full" id="ng_news_content_full" style="width:98%; height: 200px;" class="textarea"></textarea>
					</div>
				</td>
			</tr>
		{% else %}
			<tr>
				<td colspan="2">
					<div>
						<div>{{ quicktags }}<br/>
							{{ smilies }}<br/><br/></div>
						<textarea name="ng_news_content" id="ng_news_content" style="width:98%; height: 400px;" class="textarea"></textarea>
					</div>
				</td>
			</tr>
		{% endif %}
		<tr>
			<td colspan="2">
				<div>
					{% if not flags['mainpage.disabled'] %}
						<label><input type="checkbox" name="mainpage" value="1" id="mainpage" {% if (flags.mainpage) %} checked="checked" {% endif %} {% if flags['mainpage.disabled'] %} disabled {% endif %}/>
							{{ lang.nsm['mainpage'] }}
						</label><br/>
					{% endif %}
					{% if not flags['pinned.disabled'] %}
						<label><input type="checkbox" name="pinned" value="1" id="pinned" {% if (flags.pinned) %} checked="checked" {% endif %} {% if flags['pinned.disabled'] %} disabled {% endif %}/>
							{{ lang.nsm['add_pinned'] }}
						</label><br/>
					{% endif %}
					{% if not flags['catpinned.disabled'] %}
						<label><input type="checkbox" name="catpinned" value="1" id="catpinned" {% if (flags.catpinned) %} checked="checked" {% endif %} {% if flags['catpinned.disabled'] %} disabled {% endif %}/>
							{{ lang.nsm['add_catpinned'] }}
						</label><br/>
					{% endif %}
					{% if not flags['favorite.disabled'] %}
						<label><input type="checkbox" name="favorite" value="1" id="favorite" {% if (flags.favorite) %} checked="checked" {% endif %} {% if flags['favorite.disabled'] %} disabled {% endif %}/>
							{{ lang.nsm['add_favorite'] }}
						</label><br/>
					{% endif %}
					{% if not flags['html.disabled'] %}
						<label><input name="flag_HTML" type="checkbox" id="flag_HTML" value="1" {% if (flags['html.disabled']) %} disabled {% endif %} {% if flags['html'] %} checked="checked" {% endif %}/>
							{{ lang.nsm['flag_html'] }}
						</label><br/>
						<label><input type="checkbox" name="flag_RAW" value="1" id="flag_RAW" {% if (flags['html.disabled']) %} disabled {% endif %} {% if flags['html'] %} checked="checked" {% endif %}/>
							{{ lang.nsm['flag_raw'] }}
						</label><br/>
					{% endif %}
				</div>
			</td>
		</tr>
	</table>
	<div class="clearfix"></div>
	<div class="label pull-right">
		<label class="default">&nbsp;</label>
		{% if flags['can_publish'] %}
			<input class="button" type="submit" onclick="return approveMode(1);" value="{{ lang.nsm['add'] }}"/>
		{% else %}
			&nbsp;
		{% endif %}
		<input class="button" type="submit" onclick="return approveMode(0);" value="{{ lang.nsm['moder.news'] }}"/>
		<input class="button" type="submit" onclick="return approveMode(-1);" value="{{ lang.nsm['save.draft'] }}"/>
		<input class="button" type="button" onclick="return preview();" value="{{ lang.nsm['preview'] }}"/>
	</div>
</form>

<script language="javascript" type="text/javascript">
	// Restore variables if needed
var jev = {{ JEV }};
var form = document.getElementById('postForm');
for (i in jev) { // try { alert(i+' ('+form[i].type+')'); } catch (err) {;}
if (typeof(jev[i]) == 'object') {
for (j in jev[i]) { // alert(i+'['+j+'] = '+ jev[i][j]);
try {
form[i + '[' + j + ']'].value = jev[i][j];
} catch (err) {;
}
}
} else {
try {
if ((form[i].type == 'text') || (form[i].type == 'textarea') || (form[i].type == 'select-one')) {
form[i].value = jev[i];
} else if (form[i].type == 'checkbox') {
form[i].checked = (jev[i] ? true : false);
}
} catch (err) {;
}
}
}
</script>
