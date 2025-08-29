<form name="form" action="?mod=pm&action=send" method="post">
	<input type="hidden" name="sendto" value="{{ toID }}"/>
	<input type="hidden" name="token" value="{{ token }}"/>
<table border="0" cellspacing="0" cellpadding="0" class="content" align="center">
<tr>
<td width="50%" style="padding-right:10px;" valign="top">
<table border="0" width="100%" cellspacing="0" cellpadding="0" align="left">
<tr>
<td width=100% class="contentHead"><img src="{{skins_url}}/images/nav.gif" hspace="8">{l_content}</td>
</tr>
<tr>
<td width="100%" class="contentEntry1">{{ quicktags }}<br/>{{ smilies }}<br/><textarea name="content" id="content" rows="10" cols="60" tabindex="1" maxlength="3000"/>
</textarea></td>
</tr>
</table>
</td>
</tr>
<tr align="center">
<td width="100%" colspan="2" class="contentEdit" valign="top">
<input type="submit" value="{{ lang.send }}" accesskey="s" class="button"/>
</td>
</tr>
</table>
</form>
