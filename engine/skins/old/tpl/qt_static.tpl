<span id="save_area" style="display: block;"></span>
<div id="tags">
	<a onclick="insertext('[b]','[/b]', {{ area }})" title='{l_tags.bold}'><img src="{{ skins_url }}/tags/bold.gif" height="16" width="16" alt="{l_tags.bold}"/></a>
	<a onclick="insertext('[u]','[/u]', {{ area }})" title='{l_tags.underline}'><img src="{{ skins_url }}/tags/underline.gif" width="16" height="16" alt="{l_tags.underline}"/></a>
	<a onclick="insertext('[i]','[/i]', {{ area }})" title='{l_tags.italic}'><img src="{{ skins_url }}/tags/italic.gif" width="16" height="16" alt="{l_tags.italic}"/></a>
	<a onclick="insertext('[s]','[/s]', {{ area }})" title='{l_tags.crossline}'><img src="{{ skins_url }}/tags/crossline.gif" width="16" height="16" alt="{l_tags.crossline}"/></a>
	<img src="{{ skins_url }}/tags/sep.gif" width="1" height="16" alt=""/>
	<a onclick="insertext('[left]','[/left]', {{ area }})" title='{l_tags.left}'><img src="{{ skins_url }}/tags/left.gif" width="16" height="16" alt="{l_tags.left}"/></a>
	<a onclick="insertext('[center]','[/center]', {{ area }})" title='{l_tags.center}'><img src="{{ skins_url }}/tags/center.gif" width="16" height="16" alt="{l_tags.center}"/></a>
	<a onclick="insertext('[right]','[/right]', {{ area }})" title='{l_tags.right}'><img src="{{ skins_url }}/tags/right.gif" width="16" height="16" alt="{l_tags.right}"/></a>
	<a onclick="insertext('[justify]','[/justify]', {{ area }})" title='{l_tags.justify}'><img src="{{ skins_url }}/tags/justify.gif" width="16" height="16" alt="{l_tags.justify}"/></a>
	<img src="{{ skins_url }}/tags/sep.gif" width="1" height="16" alt=""/>
	<a onclick="insertext('[ul]\n[li][/li]\n[li][/li]\n[li][/li]\n[/ul]','', {{ area }})" title='{l_tags.bulllist}'><img src="{{ skins_url }}/tags/bulllist.gif" width="16" height="16" alt="{l_tags.bulllist}"/></a>
	<a onclick="insertext('[ol]\n[li][/li]\n[li][/li]\n[li][/li]\n[/ol]','', {{ area }})" title='{l_tags.numlist}'><img src="{{ skins_url }}/tags/numlist.gif" width="16" height="16" alt="{l_tags.numlist}"/></a>
	<img src="{{ skins_url }}/tags/sep.gif" width="1" height="16" alt=""/>
	<a onclick="insertext('[spoiler]','[/spoiler]', {{ area }})" title='{l_tags.spoiler}'><img src="{{ skins_url }}/tags/spoiler.gif" width="16" height="16" alt="{l_tags.spoiler}"/></a>
	<a onclick="insertext('[p]','[/p]', {{ area }})" title='{l_tags.paragraph}'><img src="{{ skins_url }}/tags/paragraph.gif" width="16" height="16" alt="{l_tags.paragraph}"/></a>
	<a onclick="insertext('[quote]','[/quote]', {{ area }})" title='{l_tags.comment}'><img src="{{ skins_url }}/tags/comment.gif" width="16" height="16" alt="{l_tags.comment}"/></a>
	<a onclick="insertext('[acronym=]','[/acronym]', {{ area }})" title='{l_tags.acronym}'><img src="{{ skins_url }}/tags/acronym.gif" width="16" height="16" alt="{l_tags.acronym}"/></a>
	<a onclick="insertext('[code]','[/code]', {{ area }})" title='{l_tags.code}'><img src="{{ skins_url }}/tags/code.gif" width="16" height="16" alt="{l_tags.code}"/></a>
	<a onclick="insertext('[hide]','[/hide]', {{ area }})" title='{l_tags.hide}'><img src="{{ skins_url }}/tags/hide.gif" width="16" height="16" alt="{l_tags.hide}"/></a>
	<a onclick="return insertEmailPrompt({{ area }});" title='{l_tags.email}'><img src="{{ skins_url }}/tags/email.gif" width="16" height="16" alt="{l_tags.email}"/></a>
	<img src="{{ skins_url }}/tags/sep.gif" width="1" height="16" alt=""/>
	<a onclick="return insertUrlPrompt({{ area }});" title='{l_tags.link}'><img src="{{ skins_url }}/tags/link.gif" width="16" height="16" alt="{l_tags.link}"/></a>
	<a onclick="return insertImgPrompt({{ area }});" title='{l_tags.imagelink}'><img src="{{ skins_url }}/tags/imagelink.gif" width="16" height="16" alt="{l_tags.imagelink}"/></a>
	{% if pluginIsActive('bb_media') %}
		<a onclick="return insertMediaPrompt({{ area }});" title='[media]'><img src="{{ skins_url }}/tags/video.gif" width="16" height="16" alt="[media]"/></a>
	{% else %}
		<a onclick="try{ if(window.show_info){show_info('{{ lang['media.enable']|e('js') }}');} else { alert('{{ lang['media.enable']|e('js') }}'); } }catch(e){ alert('{{ lang['media.enable']|e('js') }}'); } return false;" title='[media]'><img src="{{ skins_url }}/tags/video.gif" width="16" height="16" alt="[media]"/></a>
	{% endif %}
	<img src="{{ skins_url }}/tags/sep.gif" width="1" height="16" alt=""/>
	<a onclick="try{document.forms['DATA_tmp_storage'].area.value={{ area }};} catch(err){;} window.open('{php_self}?mod=files&amp;area={{ area }}', '_Addfile', 'height=600,resizable=yes,scrollbars=yes,width=800');return false;" target="DATA_Addfile" title='{l_tags.file}'><img src="{{ skins_url }}/tags/file.gif" width="16" height="16" alt="{l_tags.file}"/></a>
	<a onclick="try{document.forms['DATA_tmp_storage'].area.value={{ area }};} catch(err){;} window.open('{php_self}?mod=images&amp;area={{ area }}', '_Addimage', 'height=600,resizable=yes,scrollbars=yes,width=800');return false;" target="DATA_Addimage" title='{l_tags.image}'><img src="{{ skins_url }}/tags/image.gif" width="16" height="16" alt="{l_tags.image}"/></a>
	<img src="{{ skins_url }}/tags/sep.gif" width="1" height="16" alt=""/>
	<a onclick="insertext('<!--nextpage-->','', {{ area }})" title='{l_tags.nextpage}'><img src="{{ skins_url }}/tags/nextpage.gif" width="16" height="16" alt="{l_tags.nextpage}"/></a>
</div>
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
