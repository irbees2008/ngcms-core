<script type="text/javascript">
	var cajax = new sack();
function reload_captcha() {
var captc = document.getElementById('img_captcha');
if (captc != null) {
captc.src = "{captcha_url}?rand=" + Math.random();
}
}
// Добавление комментария (AJAX)
function add_comment() { // Удаляем возможное старое сообщение об ошибке, если есть
var perr = document.getElementById('error_message');
if (perr && perr.parentNode) {
perr.parentNode.removeChild(perr);
}
var form = document.getElementById('comment');
if (! form) {
return false;
}
cajax.onShow("");
[not - logged]
cajax.setVar("name", form.name.value);
cajax.setVar("mail", form.mail.value);
[captcha]
cajax.setVar("vcode", form.vcode.value);
[
/captcha]
		[/not-logged]
		cajax.setVar("content", form.content.value);
		cajax.setVar("newsid", form.newsid.value);
		cajax.setVar("ajax", "1");
		cajax.setVar("json", "1");
		cajax.requestFile = "{post_url}";
		cajax.method = 'POST';
		cajax.onComplete = function () {
			if (cajax.responseStatus[0] == 200) {
				try {
					var resRX = eval('(' + cajax.response + ')');
					var nc = (resRX['rev'] && document.getElementById('new_comments_rev'))
						? document.getElementById('new_comments_rev')
						: document.getElementById('new_comments');
					if (resRX['status']) {
						if (resRX['data']) { nc.innerHTML += resRX['data']; }
						form.content.value = '';
						if (typeof show_info === 'function') { show_info('Комментарий добавлен'); }
					} else {
						if (typeof show_error === 'function') { show_error(resRX['data'] || 'Ошибка при добавлении комментария'); }
					}
				} catch (err) {
					if (typeof show_error === 'function') { show_error('Ошибка обработки ответа: ' + cajax.response); }
				}
			} else {
				if (typeof show_error === 'function') { show_error('HTTP error. Code: ' + cajax.responseStatus[0]); }
			}
			[captcha]
			reload_captcha();
			[/captcha]
		};
		cajax.runAJAX();
		return false;
	}
</script > <script>
// Отображение ошибки в виде стикера (без зависимостей)
function show_error(message) {
try {
var c = document.getElementById('ng-stickers');
if (! c) {
c = document.createElement('div');
c.id = 'ng-stickers';
c.style.position = 'fixed';
c.style.top = '12px';
c.style.right = '12px';
c.style.zIndex = 2147483647;
document.body.appendChild(c);
}
var b = document.createElement('div');
b.setAttribute('role', 'alert');
b.style.background = '#f8d7da';
b.style.border = '1px solid #f5c6cb';
b.style.color = '#721c24';
b.style.padding = '10px 14px';
b.style.marginTop = '10px';
b.style.borderRadius = '4px';
b.style.boxShadow = '0 2px 8px rgba(0,0,0,.1)';
b.style.maxWidth = '420px';
b.style.minWidth = '260px';
b.style.fontSize = '14px';
b.style.lineHeight = '1.4';
var close = document.createElement('button');
close.innerHTML = '&times';
close.setAttribute('aria-label', 'Close');
close.style.marginLeft = '10px';
close.style.float = 'right';
close.style.fontSize = '18px';
close.style.lineHeight = '1';
close.style.border = '0';
close.style.background = 'transparent';
close.style.color = '#721c24';
close.style.cursor = 'pointer';
close.addEventListener('click', function () {
if (b && b.parentNode) {
b.parentNode.removeChild(b);
}
});
b.innerHTML = String(message);
b.appendChild(close);
c.appendChild(b);
} catch (e) {
alert(message);
}
}
}
</script>
		<div class="respond card card-body">
			<form id="comment" method="post" action="{post_url}" name="form" [ajax]onsubmit="return add_comment();" [/ajax]>
				<input type="hidden" name="newsid" value="{newsid}"/>
				<input type="hidden" name="referer" value="{request_uri}"/>
				<fieldset>
					<legend class="">Добавить комментарий</legend>
					[not-logged]
					<div class="row">
						<div class="col-md-4">
							<div class="form-group">
								<input type="text" name="name" value="{savedname}" class="form-control" placeholder="Имя" id="name" required=""/>
							</div>
						</div>
						<div class="col-md-4">
							<div class="form-group">
								<input type="email" name="mail" value="{savedmail}" class="form-control" placeholder="Email" id="email" required=""/>
							</div>
						</div>
						[captcha]
						<div class="col-md-4">
							<div class="input-group">
								<input type="text" name="vcode" id="captcha" class="form-control" placeholder="Код безопасности" required=""/>
								<span class="input-group-addon p-0">
									<img id="img_captcha" onclick="reload_captcha();" src="{captcha_url}?rand={rand}" alt="captcha" class="captcha"/>
								</span>
							</div>
						</div>
						[/captcha]
					</div>
					[/not-logged]
					<div class="form-group">
						{bbcodes}
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
										{smilies}
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
		</div>
