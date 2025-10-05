<script type="text/javascript">
	var cajax = new sack();
// Перезагрузка капчи
function reload_captcha() {
var captc = document.getElementById('img_captcha');
if (captc != null) {
captc.src = "{{ captcha_url }}?rand=" + (new Date()).getTime();
}
}
// Добавление комментария (AJAX)
function add_comment() {
var form = document.getElementById('comment');
if (! form) 
return false;

cajax.onShow("");{% if not_logged %}cajax.setVar("name", form.name.value);
cajax.setVar("mail", form.mail.value);{% if use_captcha %}cajax.setVar("vcode", form.vcode.value);{% endif %}{% endif %}cajax.setVar("content", form.content.value);
cajax.setVar("newsid", form.newsid.value);
cajax.setVar("ajax", "1");
cajax.setVar("json", "1");
cajax.requestFile = "{{ post_url }}";
cajax.method = 'POST';
cajax.onComplete = function () {
if (cajax.responseStatus[0] == 200) {
try {
var res = (function parseJSONSafe(text) {
try {
return JSON.parse(text);
} catch (e) {
try {
return JSON.parse(String(text).replace(/^\uFEFF/, ''));
} catch (e2) {
return null;
}
}
})(cajax.response);
if (! res) {
if (typeof show_error === "function") 
show_error('Ошибка обработки ответа: ' + cajax.response);

return;
}
var nc = (res['rev'] && document.getElementById('new_comments_rev')) ? document.getElementById('new_comments_rev') : document.getElementById('new_comments');
if (res['status']) {
if (res['data']) {
nc.innerHTML += res['data'];
}
form.content.value = '';{% if not_logged and use_moderation %}if (typeof show_info === "function") 
show_info('Комментарий отправлен на модерацию и будет опубликован после проверки администратором.');

{% else %}
if (typeof show_info === "function") 
show_info('Комментарий добавлен');
{% endif %}
} else {
if (typeof show_error === "function") 
show_error(res['data'] || 'Ошибка при добавлении комментария');

}
} catch (err) {
if (typeof show_error === "function") 
show_error('Ошибка обработки ответа: ' + cajax.response);

}
} else {
if (typeof show_error === "function") 
show_error('HTTP error. Code: ' + cajax.responseStatus[0]);

}
{% if use_captcha %}reload_captcha();{% endif %}
};
cajax.runAJAX();
return false;}// Цитированиеfunction quote(author) {
var textarea = document.getElementById('content');
if (textarea) {
var quoteText = '[quote]' + author + ', [/quote]\n';
textarea.value += quoteText;
textarea.focus();
if (textarea.setSelectionRange) {
var pos = textarea.value.length;
textarea.setSelectionRange(pos, pos);
}
}
var form = document.getElementById('comment');
if (form) {
form.scrollIntoView({behavior: 'smooth'});
}}
</script>
<div class="title">{{ lang['comments:form.title'] }}</div>
<div class="respond">
	<form id="comment" method="post" action="{{ post_url }}" name="form" {% if not noajax %} onsubmit="return add_comment();" {% endif %}>
		<input type="hidden" name="newsid" value="{{ newsid }}"/>
		<input type="hidden" name="referer" value="{{ request_uri }}"/>
		{% if not_logged %}
			<div class="label pull-left">
				<label for="name">{{ lang['comments:form.name'] }}</label>
				<input type="text" name="name" value="{{ savedname }}" class="input">
			</div>
			<div class="label pull-right">
				<label for="email">{{ lang['comments:form.email'] }}</label>
				<input type="text" name="mail" value="{{ savedmail }}" class="input">
			</div>
		{% endif %}
		<div class="clearfix"></div>
		{{ bbcodes|raw }}{{ smilies|raw }}
		<div class="clearfix"></div>
		<div class="label">
			<label></label>
			<textarea onkeypress="if(event.keyCode==10 || (event.ctrlKey && event.keyCode==13)) { return add_comment(); }" name="content" id="content" class="textarea"></textarea>
		</div>
		{% if use_captcha %}
			<div class="label captcha pull-left">
				<label for="captcha">{{ lang['comments:form.captcha'] }}</label>
				<input type="text" name="vcode" id="captcha" class="input">
				<img id="img_captcha" onclick="reload_captcha();" src="{{ captcha_url }}?rand={{ rand }}" alt="captcha"/>
			</div>
		{% endif %}
		<div class="label pull-right">
			<label for="sendComment" class="default">&nbsp;</label>
			<input type="submit" id="sendComment" value="{{ lang['comments:form.submit'] }}" class="button">
		</div>
	</form>
	<div id="new_comments"></div>
	<div id="new_comments_rev"></div>
	<script>
		// Глобальная переменная для сохранения оригинального контента
var original_comment_content = {};
// Удаление комментария
function delete_comment(comment_id, token) {
if (!confirm('Удалить комментарий?')) 
return false;

var dajax = new sack();
dajax.setVar("id", comment_id);
dajax.setVar("uT", token);
dajax.setVar("ajax", "1");
dajax.requestFile = "{{ delete_url }}";
dajax.method = 'GET';
dajax.onComplete = function () {
if (dajax.responseStatus[0] == 200) {
var result = null;
try {
result = JSON.parse(dajax.response);
} catch (e) {
if (typeof show_error === "function") 
show_error('Ошибка обработки ответа: ' + dajax.response);

return;
}
if (result && result.status) {
var el = document.getElementById('comment' + comment_id);
if (el) {
el.style.display = 'none';
}
if (typeof show_info === "function") 
show_info(result.data || 'Комментарий удалён');

} else {
if (typeof show_error === "function") 
show_error((result && result.data) ? result.data : 'Не удалось удалить комментарий');

}
} else {
if (typeof show_error === "function") 
show_error('HTTP error. Code: ' + dajax.responseStatus[0]);

}
};
dajax.runAJAX();
}
// Редактирование комментария
function edit_comment(comment_id) {
var comment_text_div = document.getElementById('comment_text_' + comment_id);
if (! comment_text_div) 
return;

original_comment_content[comment_id] = comment_text_div.innerHTML;
var eajax = new sack();
eajax.setVar("id", comment_id);
eajax.setVar("action", "get");
eajax.setVar("ajax", "1");
eajax.requestFile = "{{ edit_url }}";
eajax.method = 'GET';
eajax.onComplete = function () {
if (eajax.responseStatus[0] == 200) {
try {
var result = (function parseJSONSafe(text) {
try {
return JSON.parse(text);
} catch (e) {
try {
return JSON.parse(String(text).replace(/^\uFEFF/, ''));
} catch (e2) {
return null;
}
}
})(eajax.response);
if (! result) {
if (typeof show_error === "function") 
show_error('Ошибка обработки ответа: ' + eajax.response);

return;
}
if (result['status'] == 1) {
var edit_form = '<textarea id="edit_textarea_' + comment_id + '" style="width:100%; height:100px;">' + result['text'] + '</textarea><br/>' + '<button onclick="save_comment(' + comment_id + '); return false;">Сохранить</button> ' + '<button onclick="cancel_edit(' + comment_id + '); return false;">Отмена</button>';
comment_text_div.innerHTML = edit_form;
} else {
if (typeof show_error === "function") 
show_error('Ошибка: ' + (
result['data'] || 'Неизвестная ошибка'
));

}
} catch (err) {
if (typeof show_error === "function") 
show_error('Ошибка обработки ответа: ' + eajax.response);

}
}
};
eajax.runAJAX();
}
// Сохранение отредактированного комментария
function save_comment(comment_id) {
var textarea = document.getElementById('edit_textarea_' + comment_id);
if (! textarea) 
return;

var sajax = new sack();
sajax.setVar("id", comment_id);
sajax.setVar("text", textarea.value);
sajax.setVar("action", "save");
sajax.setVar("ajax", "1");
sajax.requestFile = "{{ edit_url }}";
sajax.method = 'POST';
sajax.onComplete = function () {
if (sajax.responseStatus[0] == 200) {
try {
var result = (function parseJSONSafe(text) {
try {
return JSON.parse(text);
} catch (e) {
try {
return JSON.parse(String(text).replace(/^\uFEFF/, ''));
} catch (e2) {
return null;
}
}
})(sajax.response);
if (! result) {
if (typeof show_error === "function") 
show_error('Ошибка обработки ответа: ' + sajax.response);

return;
}
if (result['status'] == 1) {
var comment_text_div = document.getElementById('comment_text_' + comment_id);
comment_text_div.innerHTML = result['html'];
if (typeof show_info === "function") 
show_info('Комментарий обновлён');

} else {
if (typeof show_error === "function") 
show_error('Ошибка: ' + (
result['data'] || 'Неизвестная ошибка'
));

}
} catch (err) {
if (typeof show_error === "function") 
show_error('Ошибка обработки ответа: ' + sajax.response);

}
}
};
sajax.runAJAX();
}
// Отмена редактирования
function cancel_edit(comment_id) {
var comment_text_div = document.getElementById('comment_text_' + comment_id);
if (comment_text_div && original_comment_content[comment_id]) {
comment_text_div.innerHTML = original_comment_content[comment_id];
delete original_comment_content[comment_id];
}
}
	</script>
</div>
