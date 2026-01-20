 <script type="text/javascript">
	var cajax = new sack();

	// Универсальная функция для уведомлений
	function notify(type, msg) {
		if (typeof showToast === 'function') {
			showToast(type, msg);
		} else if (typeof show_error === 'function' && type === 'error') {
			show_error(msg);
		} else if (typeof show_info === 'function' && type === 'success') {
			show_info(msg);
		} else {
			alert(msg);
		}
	}

	// Безопасный парсинг JSON (защита от BOM)
	function parseJSONSafe(src) {
		try {
			return JSON.parse(src);
		} catch (e) {
			try {
				return JSON.parse(String(src).replace(/^\uFEFF/, ''));
			} catch (e2) {
				return null;
			}
		}
	}

	function reload_captcha() {
		var captc = document.getElementById('img_captcha');
		if (captc != null) {
			captc.src = "{{ captcha_url }}?rand=" + Math.random();
		}
	}

	// Добавление комментария (AJAX)
	function add_comment() {
		var form = document.getElementById('comment');
		if (!form) {
			return false;
		}

		cajax.onShow("");
		{% if not_logged %}
			cajax.setVar("name", form.name.value);
			cajax.setVar("mail", form.mail.value);
			{% if use_captcha %}
				cajax.setVar("vcode", form.vcode.value);
			{% endif %}
		{% endif %}
		cajax.setVar("content", form.content.value);
		cajax.setVar("newsid", form.newsid.value);
		cajax.setVar("ajax", "1");
		cajax.setVar("json", "1");
		cajax.requestFile = "{{ post_url }}";
		cajax.method = 'POST';
		cajax.onComplete = function () {
			if (cajax.responseStatus[0] == 200) {
				try {
					var resRX = parseJSONSafe(cajax.response);
					if (!resRX) {
						notify('error', 'Ошибка обработки ответа: ' + cajax.response);
						return;
					}

					var nc = (resRX['rev'] && document.getElementById('new_comments_rev'))
						? document.getElementById('new_comments_rev')
						: document.getElementById('new_comments');

					if (resRX['status']) {
						if (resRX['data']) {
							nc.innerHTML += resRX['data'];
						}
						form.content.value = '';

						// Проверка на модерацию
						if (resRX['moderation']) {
							notify('info', 'Комментарий добавлен и будет опубликован после проверки модератором');
						} else {
							notify('success', 'Комментарий добавлен');
						}
					} else {
						notify('error', resRX['data'] || 'Ошибка при добавлении комментария');
					}
				} catch (err) {
					notify('error', 'Ошибка обработки ответа: ' + cajax.response);
				}
			} else {
				notify('error', 'HTTP error. Code: ' + cajax.responseStatus[0]);
			}
			{% if use_captcha %}
				reload_captcha();
			{% endif %}
		};
		cajax.runAJAX();
		return false;
	}

	// Цитирование
	function quote(author) {
		var textarea = document.getElementById('content');
		if (!textarea) return;
		var quoteText = '[quote]' + author + ', [/quote]\n';
		textarea.value += quoteText;
		textarea.focus();
		if (textarea.setSelectionRange) {
			var pos = textarea.value.length;
			textarea.setSelectionRange(pos, pos);
		}
		var form = document.getElementById('comment');
		if (form) {
			form.scrollIntoView({behavior: 'smooth'});
		}
	}

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
				var result = parseJSONSafe(dajax.response);
				if (!result) {
					notify('error', 'Ошибка обработки ответа: ' + dajax.response);
					return;
				}
				if (result && result.status) {
					var el = document.getElementById('comment' + comment_id);
					if (el) {
						el.style.display = 'none';
					}
					if (result.data) {
						if (result.data.indexOf('<') !== -1) {
							document.body.insertAdjacentHTML('beforeend', result.data);
						} else {
							notify('success', result.data);
						}
					} else {
						notify('success', 'Комментарий удалён');
					}
				} else if (result && result.data) {
					if (result.data.indexOf('<') !== -1) {
						document.body.insertAdjacentHTML('beforeend', result.data);
					} else {
						notify('error', result.data);
					}
				}
			} else {
				notify('error', 'HTTP error. Code: ' + dajax.responseStatus[0]);
			}
		};
		dajax.runAJAX();
	}

	// Редактирование комментария
	function edit_comment(comment_id) {
		var comment_text_div = document.getElementById('comment_text_' + comment_id);
		if (!comment_text_div)
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
					var result = parseJSONSafe(eajax.response);
					if (!result) {
						notify('error', 'Ошибка обработки ответа: ' + eajax.response);
						return;
					}
					if (result['status'] == 1) {
						var edit_form = '<textarea id="edit_textarea_' + comment_id + '" class="form-control" style="width:100%; height:100px;">' + result['text'] + '</textarea><br/>' +
							'<button class="btn btn-primary btn-sm" onclick="save_comment(' + comment_id + '); return false;">Сохранить</button> ' +
							'<button class="btn btn-secondary btn-sm" onclick="cancel_edit(' + comment_id + '); return false;">Отмена</button>';
						comment_text_div.innerHTML = edit_form;
					} else if (result['data']) {
						if (result['data'].indexOf('<') !== -1) {
							document.body.insertAdjacentHTML('beforeend', result['data']);
						} else {
							notify('error', result['data']);
						}
					}
				} catch (err) {
					notify('error', 'Ошибка обработки ответа: ' + eajax.response);
				}
			}
		};
		eajax.runAJAX();
	}

	// Сохранение отредактированного комментария
	function save_comment(comment_id) {
		var textarea = document.getElementById('edit_textarea_' + comment_id);
		if (!textarea)
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
					var result = parseJSONSafe(sajax.response);
					if (!result) {
						notify('error', 'Ошибка обработки ответа: ' + sajax.response);
						return;
					}
					if (result['status'] == 1) {
						var comment_text_div = document.getElementById('comment_text_' + comment_id);
						comment_text_div.innerHTML = result['html'];
						if (result['data']) {
							if (result['data'].indexOf('<') !== -1) {
								document.body.insertAdjacentHTML('beforeend', result['data']);
							} else {
								notify('success', result['data']);
							}
						} else {
							notify('success', 'Комментарий обновлён');
						}
					} else if (result['data']) {
						if (result['data'].indexOf('<') !== -1) {
							document.body.insertAdjacentHTML('beforeend', result['data']);
						} else {
							notify('error', result['data']);
						}
					}
				} catch (err) {
					notify('error', 'Ошибка обработки ответа: ' + sajax.response);
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
<div class="respond card card-body">
	<form id="comment" method="post" action="{{ post_url }}" name="form" {% if not noajax %} onsubmit="return add_comment();" {% endif %}>
		<input type="hidden" name="newsid" value="{{ newsid }}"/>
		<input type="hidden" name="referer" value="{{ request_uri }}"/>
		<fieldset>
			<legend class="">Добавить комментарий</legend>
			{% if not_logged %}
				<div class="row">
					<div class="col-md-4">
						<div class="form-group">
							<input type="text" name="name" value="{{ savedname }}" class="form-control" placeholder="Имя" id="name" required=""/>
						</div>
					</div>
					<div class="col-md-4">
						<div class="form-group">
							<input type="email" name="mail" value="{{ savedmail }}" class="form-control" placeholder="Email" id="email" required=""/>
						</div>
					</div>
					{% if use_captcha %}
						<div class="col-md-4">
							<div class="input-group">
								<input type="text" name="vcode" id="captcha" class="form-control" placeholder="Код безопасности" required=""/>
								<span class="input-group-addon p-0">
									<img id="img_captcha" onclick="reload_captcha();" src="{{ captcha_url }}?rand={{ rand }}" alt="captcha" class="captcha"/>
								</span>
							</div>
						</div>
					{% endif %}
				</div>
			{% endif %}
			<div class="form-group">
				{{ bbcodes|raw }}
				<div id="modal-smiles" class="modal fade" tabindex="-1" role="dialog">
					<div class="modal-dialog modal-sm" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title">Вставить смайл</h5>
								<button type="button" class="close" data-dismiss="modal" aria-label="Close">
									<span aria-hidden="true">&times;</span>
								</button>
							</div>
							<div class="modal-body text-center">
								{{ smilies|raw }}
							</div>
							<div class="modal-footer">
								<button type="cancel" class="btn btn-default" data-dismiss="modal">{{ lang['cancel'] }}</button>
							</div>
						</div>
					</div>
				</div>
				<textarea onkeypress="if(event.keyCode==10 || (event.ctrlKey && event.keyCode==13)) {add_comment();}" name="content" id="content" rows="8" class="form-control message-content" placeholder="Комментарий" required=""></textarea>
			</div>
			<div class="form-group">
				<p>Ваш e-mail не будет опубликован. Убедительная просьба соблюдать правила этики. Администрация оставляет за собой право удалять сообщения без объяснения причин.</p>
			</div>
		</fieldset>
		<div class="form-group">
			<button type="submit" id="sendComment" class="btn btn-primary">Написать</button>
		</div>
	</form>
	<div id="new_comments"></div>
	<div id="new_comments_rev"></div>
</div>
