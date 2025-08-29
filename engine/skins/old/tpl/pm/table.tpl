<form name="form" method="POST" action="?mod=pm&action=delete">
<input type="hidden" name="token" value="{{ token }}">
<table class="content" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
<td width="100%" style="padding-right:10px;" valign="top">
<table border="0" width="100%" cellpadding="0" cellspacing="0">
<tr>
<td width="100%" colspan="5" class="contentHead"><img src="{{ skins_url }}/images/nav.gif" hspace="8"><a href="?mod=pm">{{ lang.pm }}</a>
</td>
</tr>
<tr>
<td width=100% colspan="5">&nbsp;</td>
</tr>
<tr align="center" class="contHead">
<td width="15%" class="contentHead">{{ lang.pmdate }}</td>
<td width="40%" class="contentHead">{{ lang.title }}</td>
<td width="25%" class="contentHead">{{ lang.from }}</td>
<td width="15%" class="contentHead">{{ lang.status }}</td>
<td width="5%" class="contentHead"><input class="check" type="checkbox" name="master_box" title="{{ lang.select_all }}" onclick="javascript:check_uncheck_all(form)"></td>
</tr>
{% for entry in entries %}
	<tr>
		<td>{{ entry.date }}</td>
		<td>
			<a href="?mod=pm&action=read&pmid={{ entry.id }}&token={{ token }}">{{ entry.title }}</a>
		</td>
		<td nowrap>
			{% if entry.flags.haveSender %}
				<a href="{{ entry.senderProfileURL }}">{{ entry.senderName }}</a>
			{% else %}
				{{ entry.senderName }}
			{% endif %}
		</td>
		<td>
			{% if entry.flags.viewed %}
				{{ lang.viewed }}
			{% else %}
				{{ lang.unviewed }}
			{% endif %}
		</td>
		<td><input type="checkbox" name="selected_pm[]" value="{{ entry.id }}"/></td>
	</tr>
{% endfor %}
<tr>
<td width=100% colspan="5">&nbsp;</td>
</tr>
<tr align="center">
<td width="100%" colspan="5" class="contentEdit">
<input class="button" type="submit" value="{l_delete}">
</form>
<form name="pm" method="POST" action="?mod=pm&action=write">
<input class="button" type="submit" value="{l_write}">
</form>
</td>
</tr>
</table>
</td>
</tr>
</table>
