<span id="tags">
	<a onclick="javascript:insertext('[b]','[/b]', {{ area }})" title='{l_tags.bold}'><img src="{{ skins_url }}/tags/bold.gif" hspace="5" vspace="5"></a>
	<a onclick="javascript:insertext('[u]','[/u]', {{ area }})" title='{l_tags.underline}'><img src="{{ skins_url }}/tags/underline.gif" hspace="5" vspace="5"></a>
	<a onclick="javascript:insertext('[left]','[/left]', {{ area }})" title='{l_tags.left}'><img src="{{ skins_url }}/tags/left.gif" hspace="5" vspace="5"></a>
	<a onclick="javascript:insertext('[center]','[/center]', {{ area }})" title='{l_tags.center}'><img src="{{ skins_url }}/tags/center.gif" hspace="5" vspace="5"></a>
	<a onclick="javascript:insertext('[ul]\n[li][/li]\n[li][/li]\n[li][/li]\n[/ul]','', {{ area }})" title='{l_tags.bulllist}'><img src="{{ skins_url }}/tags/bulllist.gif" hspace="5" vspace="5"></a>
	<a onclick="return insertUrlPrompt({{ area }});" title='{l_tags.link}'><img src="{{ skins_url }}/tags/link.gif" hspace="5" vspace="5"></a>
	<a onclick="return insertEmailPrompt({{ area }});" title='{l_tags.email}'><img src="{{ skins_url }}/tags/email.gif" hspace="5" vspace="5"></a>
	<!--
	<a style="cursor: pointer;"  onclick="document.form.content{{ area }}.rows += 5;" title='{l_qt_rowadd}'><img src="{{ skins_url }}/tags/rowadd.gif" hspace="5" vspace="5" alt="{l_qt_rowadd}" /></a>
	<a style="cursor: pointer;"  onclick="document.form.content{{ area }}.cols += 5;" title='{l_qt_coladd}'><img src="{{ skins_url }}/tags/coladd.gif" hspace="5" vspace="5" alt="{l_qt_coladd}" /></a>
	-->
	<br/>
	<a onclick="javascript:insertext('[s]','[/s]', {{ area }})" title='{l_tags.crossline}'><img src="{{ skins_url }}/tags/crossline.gif" hspace="5" vspace="5"></a>
	<a onclick="javascript:insertext('[i]','[/i]', {{ area }})" title='{l_tags.italic}'><img src="{{ skins_url }}/tags/italic.gif" hspace="5" vspace="5"></a>
	<a onclick="javascript:insertext('[right]','[/right]', {{ area }})" title='{l_tags.right}'><img src="{{ skins_url }}/tags/right.gif" hspace="5" vspace="5"></a>
	<a onclick="javascript:insertext('[justify]','[/justify]', {{ area }})" title='{l_tags.justify}'><img src="{{ skins_url }}/tags/justify.gif" hspace="5" vspace="5" width="16" height="16" alt="{l_tags.justify}"/></a>
	<a onclick="javascript:insertext('[ol]\n[li][/li]\n[li][/li]\n[li][/li]\n[/ol]','', {{ area }})" title='{l_tags.numlist}'><img src="{{ skins_url }}/tags/numlist.gif" hspace="5" vspace="5"></a>
	<a onclick="return insertImgPrompt({{ area }});" title='{l_tags.imagelink}'><img src="{{ skins_url }}/tags/imagelink.gif" hspace="5" vspace="5"></a>
	{% if pluginIsActive('bb_media') %}
		<a onclick="return insertMediaPrompt({{ area }});" title='[media]'><img src="{{ skins_url }}/tags/video.gif" hspace="5" vspace="5"></a>
	{% else %}
		<a onclick="try{ if(window.show_info){show_info('{{ lang['media.enable']|e('js') }}');} else { alert('{{ lang['media.enable']|e('js') }}'); } }catch(e){ alert('{{ lang['media.enable']|e('js') }}'); } return false;" title='[media]'><img src="{{ skins_url }}/tags/video.gif" hspace="5" vspace="5"></a>
	{% endif %}
	<!--
	<a style="cursor: pointer;"  onclick="document.form.content{{ area }}.rows -= 5;" title='{l_qt_rowdel}'><img src="{{ skins_url }}/tags/rowdel.gif" hspace="5" vspace="5" alt="{l_qt_rowdel}" /></a>
	<a style="cursor: pointer;"  onclick="document.form.content{{ area }}.cols -= 5;" title='{l_qt_coldel}'><img src="{{ skins_url }}/tags/coldel.gif" hspace="5" vspace="5" alt="{l_qt_coldel}" /></a>
	-->
</span><br/>
<script>
	function insertAtCursor(fieldId, text) {
var el = document.getElementById(fieldId);
if (! el) {
return false;
}
el.focus();
if (document.selection && document.selection.createRange) {
var sel = document.selection.createRange();
sel.text = text;
} else if (typeof el.selectionStart === 'number' && typeof el.selectionEnd === 'number') {
var startPos = el.selectionStart;
var endPos = el.selectionEnd;
var scrollPos = el.scrollTop;
el.value = el.value.substring(0, startPos) + text + el.value.substring(endPos, el.value.length);
el.selectionStart = el.selectionEnd = startPos + text.length;
el.scrollTop = scrollPos;
} else {
el.value += text;
}
return false;
}
function insertUrlPrompt(area) {
var href = prompt('Адрес (URL):', 'https://');
if (! href) {
return false;
}
if (!/^([a-z]+:\/\/|\/|#|mailto:)/i.test(href))
href = 'http://' + href;
var text = prompt('Текст ссылки:', href) || href;
var target = prompt('Открывать в новой вкладке? (y/N):', 'N');
var nofollow = prompt('Добавить rel="nofollow"? (y/N):', 'N');
var attrs = '="' + href.replace(/"/g, '&quot;') + '"';
if (/^y(es)?$/i.test(target || ''))
attrs += ' target="_blank"';
if (/^y(es)?$/i.test(nofollow || ''))
attrs += ' rel="nofollow"';
return insertAtCursor(area, '[url' + attrs + ']' + text + '[/url]');
}
function insertEmailPrompt(area) {
var email = prompt('E-mail:', '');
if (! email) {
return false;
}
var text = prompt('Текст ссылки (необязательно):', '') || '';
var bb = text && text !== email ? ('[email="' + email.replace(/"/g, '&quot;') + '"]' + text + '[/email]') : ('[email]' + email + '[/email]');
return insertAtCursor(area, bb);
}
function insertImgPrompt(area) {
var href = prompt('Адрес изображения:', 'https://');
if (! href) {
return false;
}
if (!/^((https?:\/\/|ftp:\/\/)|\/|#)/i.test(href))
href = 'http://' + href;
var alt = prompt('Alt (описание, необязательно):', '') || '';
var width = prompt('Ширина (пиксели, необязательно):', '') || '';
var height = prompt('Высота (пиксели, необязательно):', '') || '';
var align = prompt('Выравнивание (left/right/middle/top/bottom):', '') || '';
var attrs = '="' + href.replace(/"/g, '&quot;') + '"';
if (width) {
attrs += ' width="' + String(width).replace(/[^0-9]/g, '') + '"';
}
if (height) {
attrs += ' height="' + String(height).replace(/[^0-9]/g, '') + '"';
}
if (align) {
attrs += ' align="' + String(align).replace(/[^a-z]/ig, '').toLowerCase() + '"';
}
return insertAtCursor(area, '[img' + attrs + ']' + alt + '[/img]');
}
function insertMediaPrompt(area) {
var href = prompt('URL медиа-объекта:', 'https://');
if (! href) {
return false;
}
var w = prompt('Ширина (px, необязательно):', '') || '';
var h = prompt('Высота (px, необязательно):', '') || '';
var p = prompt('URL превью (необязательно):', '') || '';
var attrs = '';
if (w) {
attrs += ' width="' + String(w).replace(/[^0-9]/g, '') + '"';
}
if (h) {
attrs += ' height="' + String(h).replace(/[^0-9]/g, '') + '"';
}
if (p) {
attrs += ' preview="' + String(p).replace(/"/g, '&quot;') + '"';
}
return insertAtCursor(area, (attrs ? ('[media' + attrs + ']' + href + '[/media]') : ('[media]' + href + '[/media]')));
}
</script>
