<script type="text/javascript">
	var cajax = new sack();
			function reload_captcha() {
				var captc = document.getElementById('img_captcha');
				if (captc != null) {
					captc.src = "{captcha_url}?rand=" + Math.random();
				}
			}
		
			function add_comment() {
				// First - delete previous error message
				var perr;
				if (perr = document.getElementById('error_message')) {
					perr.parentNode.removeChild(perr);
				}
		
				// Now let's call AJAX comments add
				var form = document.getElementById('comment');
				//cajax.whattodo = 'append';
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
				cajax.requestFile = "{post_url}"; //+Math.random();
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
		</script>
		
		<div class="respond card card-body">
		 <form id="comment" method="post" action="{post_url}" name="form" [ajax]onsubmit="add_comment(); return false;" [ /ajax]>
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
		                 <input type="text" name="vcode" id="captcha" class="form-control" placeholder="Код безопасности"  required=""/>
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
