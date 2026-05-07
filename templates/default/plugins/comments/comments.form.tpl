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
<script src="{{ home }}/engine/plugins/comments/js/comments.js"></script>
<div class="title">{{ lang['comments:form.title'] }}</div>
<div class="respond">
<form id="comment" method="post" action="{{ post_url }}" name="form" {% if not noajax %} onsubmit="return add_comment();" {% endif %}>
<input type="hidden" name="newsid" value="{{ newsid }}"/>
<input type="hidden" name="referer" value="{{ request_uri }}"/>
<input type="hidden" name="module" value="{{ module|default('') }}"/>
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
{% if captcha_widget %}
<div class="form-group">
{{ captcha_widget|raw }}
</div>
{% endif %}
<div class="label pull-right">
<label for="sendComment" class="default">&nbsp;</label>
<input type="submit" id="sendComment" value="{{ lang['comments:form.submit'] }}" class="button">
</div>
</form>
<div id="new_comments"></div>
<div id="new_comments_rev"></div>
</div>
