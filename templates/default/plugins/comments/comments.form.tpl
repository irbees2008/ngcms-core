<script type="text/javascript">
	var cajax = new sack();
	// Перезагрузка капчи
	function reload_captcha() {
		var captc = document.getElementById('img_captcha');
		if (captc != null) {
			captc.src = "{captcha_url}?rand=" + (new Date()).getTime();
		}
	}

	// Добавление комментария
	function add_comment() {
		// Сначала удаляем предыдущее сообщение об ошибке
		var perr = document.getElementById('error_message');
		if (perr) {
			perr.parentNode.removeChild(perr);
		}

		// Теперь вызываем AJAX для добавления комментария
		var form = document.getElementById('comment');
		if (!form) return false;
		cajax.onShow("");
		[not-logged]
		cajax.setVar("name", form.name.value);
		cajax.setVar("mail", form.mail.value);
		[captcha]
		cajax.setVar("vcode", form.vcode.value);
		[/captcha]
		[/not-logged]
		cajax.setVar("content", form.content.value);
		cajax.setVar("newsid", form.newsid.value);
		cajax.setVar("ajax", "1");
		cajax.setVar("json", "1");
		cajax.requestFile = "{post_url}";
		cajax.method = 'POST';
		//cajax.element = 'new_comments';
		cajax.onComplete = function () {
			if (cajax.responseStatus[0] == 200) {
				try {
					var resRX = eval('(' + cajax.response + ')');
					var nc;
					if (resRX['rev'] && document.getElementById('new_comments_rev')) {
						nc = document.getElementById('new_comments_rev');
					} else {
						nc = document.getElementById('new_comments');
					}
					nc.innerHTML += resRX['data'];
					if (resRX['status']) {
						// Added successfully!
						form.content.value = '';
					}
				} catch (err) {
					alert('Error parsing JSON output. Result: ' + cajax.response);
				}
			} else {
				alert('TX.fail: HTTP code ' + cajax.responseStatus[0]);
			}
			[captcha]
			reload_captcha();
			[/captcha]
		}
		cajax.runAJAX();
	}

	// Удаление комментария
	function delete_comment(comment_id, token) {
		if (!confirm('Вы уверены, что хотите удалить этот комментарий?')) {
			return false;
		}
		
		var dajax = new sack();
		dajax.setVar("id", comment_id);
		dajax.setVar("uT", token);
		dajax.setVar("ajax", "1");
		dajax.requestFile = "{delete_url}";
		dajax.method = 'GET';
		dajax.onComplete = function () {
			if (dajax.responseStatus[0] == 200) {
				try {
					var result = eval('(' + dajax.response + ')');
					if (result['status'] == 1) {
						// Успешно удален
						var comment_element = document.getElementById('comment_' + comment_id);
						if (comment_element) {
							comment_element.style.display = 'none';
						}
						alert('Комментарий удалён');
					} else {
						alert('Ошибка: ' + result['data']);
					}
				} catch (err) {
					alert('Ошибка обработки ответа сервера');
				}
			} else {
				alert('Ошибка связи с сервером');
			}
		};
		dajax.runAJAX();
	}

	// Глобальная переменная для сохранения оригинального контента
	var original_comment_content = {};

	// Редактирование комментария
	function edit_comment(comment_id) {
		var comment_text_div = document.getElementById('comment_text_' + comment_id);
		if (!comment_text_div) return;
		
		// Сохраняем оригинальный контент
		original_comment_content[comment_id] = comment_text_div.innerHTML;
		
		// Получаем текст комментария
		var eajax = new sack();
		eajax.setVar("id", comment_id);
		eajax.setVar("action", "get");
		eajax.setVar("ajax", "1");
		eajax.requestFile = "{edit_url}";
		eajax.method = 'GET';
		eajax.onComplete = function () {
			if (eajax.responseStatus[0] == 200) {
				try {
					var result = eval('(' + eajax.response + ')');
					if (result['status'] == 1) {
						// Создаем форму редактирования
						var edit_form = '<textarea id="edit_textarea_' + comment_id + '" style="width:100%; height:100px;">' + result['text'] + '</textarea><br/>' +
							'<button onclick="save_comment(' + comment_id + '); return false;">Сохранить</button> ' +
							'<button onclick="cancel_edit(' + comment_id + '); return false;">Отмена</button>';
						comment_text_div.innerHTML = edit_form;
					} else {
						alert('Ошибка: ' + result['data']);
					}
				} catch (err) {
					alert('Ошибка обработки ответа');
				}
			}
		};
		eajax.runAJAX();
	}

	// Сохранение отредактированного комментария
	function save_comment(comment_id) {
		var textarea = document.getElementById('edit_textarea_' + comment_id);
		if (!textarea) return;
		
		var sajax = new sack();
		sajax.setVar("id", comment_id);
		sajax.setVar("text", textarea.value);
		sajax.setVar("action", "save");
		sajax.setVar("ajax", "1");
		sajax.requestFile = "{edit_url}";
		sajax.method = 'POST';
		sajax.onComplete = function () {
			if (sajax.responseStatus[0] == 200) {
				try {
					var result = eval('(' + sajax.response + ')');
					if (result['status'] == 1) {
						// Обновляем содержимое
						var comment_text_div = document.getElementById('comment_text_' + comment_id);
						comment_text_div.innerHTML = result['html'];
						alert('Комментарий обновлён');
					} else {
						alert('Ошибка: ' + result['data']);
					}
				} catch (err) {
					alert('Ошибка обработки ответа');
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
<div class="title">Добавить комментарий</div>
<div class="respond">
	<form id="comment" method="post" action="{post_url}" name="form" [ajax]onsubmit="add_comment(); return false;"[/ajax]>
	<input type="hidden" name="newsid" value="{newsid}"/>
	<input type="hidden" name="referer" value="{request_uri}"/>
	[not-logged]
	<div class="label pull-left">
		<label for="name">Введите имя:</label>
		<input type="text" name="name" value="{savedname}" class="input">
	</div>
	<div class="label pull-right">
		<label for="email">Введите E-mail:</label>
		<input type="text" name="mail" value="{savedmail}" class="input">
	</div>
	[/not-logged]
	<div class="clearfix"></div>
	{bbcodes}{smilies}
	<div class="clearfix"></div>
	<div class="label">
		<label></label>
		<textarea onkeypress="if(event.keyCode==10 || (event.ctrlKey && event.keyCode==13)) {add_comment();}" name="content" id="content" class="textarea"></textarea>
	</div>
	[captcha]
	<div class="label captcha pull-left">
		<label for="captcha">Введите код безопасности:</label>
		<input type="text" name="vcode" id="captcha" class="input">
		<img id="img_captcha" onclick="reload_captcha();" src="{captcha_url}?rand={rand}" alt="captcha"/>
	</div>
	[/captcha]
	<div class="label pull-right">
		<label for="sendComment" class="default">&nbsp;</label>
		<input type="submit" id="sendComment" value="Добавить комментарий" class="button">
	</div>
	</form>
</div>