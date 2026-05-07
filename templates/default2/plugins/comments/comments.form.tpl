<script>
window.CommentsConfig = {
	captcha_url:    "{{ captcha_url }}",
	post_url:       "{{ post_url }}",
	delete_url:     "{{ delete_url }}",
	edit_url:       "{{ edit_url }}",
	not_logged:     {{ not_logged     ? 'true' : 'false' }},
	use_captcha:    {{ use_captcha    ? 'true' : 'false' }},
	use_moderation: {{ use_moderation ? 'true' : 'false' }}
};
</script>
<script src="{{ home }}/engine/plugins/comments/js/comments.js"></script><div class="respond card card-body">
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
				</div>
			{% endif %}
			{% if captcha_widget %}
				<div class="form-group">
					{{ captcha_widget|raw }}
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
			{% if captcha_widget %}
				<div class="form-group">
					{{ captcha_widget|raw }}
				</div>
			{% endif %}
		</fieldset>
		<div class="form-group">
			<button type="submit" id="sendComment" class="btn btn-primary">Написать</button>
		</div>
	</form>
	<div id="new_comments"></div>
	<div id="new_comments_rev"></div>
</div>
