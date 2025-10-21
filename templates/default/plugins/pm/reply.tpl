<form method="post" name="form" action="{{ pm_send_link }}">
	<input type="hidden" name="title" value="{{ title }}">
	<input type="hidden" name="to_username" value="{{ to_username }}">
	<div class="block-title">{{ lang['pm:textmessage'] }}</div>
	<table class="table table-striped table-bordered">
		<tr>
			<th>
				<a href="{{ pm_inbox_link }}">{{ lang['pm:inbox'] }}</a>
				|
				<a href="{{ pm_outbox_link }}">{{ lang['pm:outbox'] }}</a>
				|
				<a href="{{ pm_set_link }}" align="right">{{ lang['pm:set'] }}</a>
			</th>
		</tr>
		<tr>
			<td width="100%">
				<div class="clearfix"></div>
				{{ quicktags }}
				{{ smilies }}
				<div class="clearfix"></div>
				<div class="label">
					<label></label>
					<textarea name="content" id="pm_content" style="width: 100%; height: 120px;"></textarea>
					<br/><br/><input name="saveoutbox" type="checkbox"/>
					{{ lang['pm:saveoutbox'] }}
				</div>
			</td>
		</tr>
	</table>
	<div class="clearfix"></div>
	<div class="label pull-right">
		<label class="default">&nbsp;</label>
		<input class="button" type="submit" value="{{ lang['pm:send'] }}" accesskey="s"/>
	</div>
</form>
