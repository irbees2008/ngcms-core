<li id="comment_{id}">
	<div class="comment clearfix">
		<div class="comment-avatar">
			<div class="avatar">{avatar}</div>
		</div>
		<div class="comment-content">
			<div class="comment-name">[profile]<a href="{profile_link}" target="_blank" title="{l_profile}">[/profile]{author}[profile]</a>[/profile]
			</div>
			<div class="meta">{date} | [quote]<a onclick="quote('{author}');" style="cursor: pointer;">Ответить</a>[/quote][if-have-perm]|
				<a href="javascript:void(0);" onclick="edit_comment({id}); return false;">Изменить</a> | <a href="javascript:void(0);" onclick="delete_comment({id}, '{delete_token}'); return false;">Удалить</a>[/if-have-perm]
			</div>
			<div class="comment-text" id="comment_text_{id}">
				{comment-short}[comment_full]<span id="comment_full{comnum}" style="display: none;">{comment-full}</span>
				<p style="text-align: right;"><a href="javascript:ShowOrHide('comment_full{comnum}');">{l_showhide}</a>
				</p>[/comment_full]
				[answer]<br clear="all"/>--------------------<br/><i>{l_answer}</i> <b>{name}</b><br/>{answer}[/answer]
				{edit_info}
			</div>
		</div>
	</div>
</li>