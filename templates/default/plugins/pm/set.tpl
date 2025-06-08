<form method="POST" action="{{ pm_set_link }}">
	<div class="block-title">{{ lang['pm:set'] }}</div>
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
		<tr align="center">
			<td><input type="checkbox" name="email" id="email" {{ checked }}/>
				{{ lang['pm:email_set'] }}</td>
		</tr>
	</table>
	<div class="clearfix"></div>
	<div class="label pull-right">
		<label class="default">&nbsp;</label>
		<input type="hidden" name="check" value="1"/>
		<input type="submit" class="button" value="{{ lang['pm:send'] }}"/>
	</div>
</form>
