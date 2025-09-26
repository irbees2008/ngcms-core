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
	<a onclick="insertext('[email]','[/email]', {{ area }})" title='{l_tags.email}'><img src="{{ skins_url }}/tags/email.gif" width="16" height="16" alt="{l_tags.email}"/></a>
	<img src="{{ skins_url }}/tags/sep.gif" width="1" height="16" alt=""/>
	<a onclick="insertext('[url]','[/url]', {{ area }})" title='{l_tags.link}'><img src="{{ skins_url }}/tags/link.gif" width="16" height="16" alt="{l_tags.link}"/></a>
	<a onclick="insertext('[img]','[/img]', {{ area }})" title='{l_tags.imagelink}'><img src="{{ skins_url }}/tags/imagelink.gif" width="16" height="16" alt="{l_tags.imagelink}"/></a>
	{% if pluginIsActive('bb_media') %}
		<a onclick="prepareMediaPrompt({{ area }})" title='[media]'><img src="{{ skins_url }}/tags/media.gif" width="16" height="16" alt="[media]"/></a>
	{% else %}
		<a onclick="try{ if(window.show_info){show_info('{{ lang['media.enable'] }}');} else { alert('{{ lang['media.enable'] }}'); } }catch(e){ alert('{{ lang['media.enable'] }}'); } return false;" title='[media]'><img src="{{ skins_url }}/tags/media.gif" width="16" height="16" alt="[media]"/></a>
	{% endif %}
	<img src="{{ skins_url }}/tags/sep.gif" width="1" height="16" alt=""/>
	<a onclick="try{document.forms['DATA_tmp_storage'].area.value={{ area }};} catch(err){;} window.open('{{ php_self }}?mod=files&amp;ifield={{ area }}', '_Addfile', 'height=600,resizable=yes,scrollbars=yes,width=800');return false;" target="DATA_Addfile" title='{l_tags.file}'><img src="{{ skins_url }}/tags/file.gif" width="16" height="16" alt="{l_tags.file}"/></a>
	<a onclick="try{document.forms['DATA_tmp_storage'].area.value={{ area }};} catch(err){;} window.open('{{ php_self }}?mod=images&amp;ifield={{ area }}', '_Addimage', 'height=600,resizable=yes,scrollbars=yes,width=800');return false;" target="DATA_Addimage" title='{l_tags.image}'><img src="{{ skins_url }}/tags/image.gif" width="16" height="16" alt="{l_tags.image}"/></a>
	<img src="{{ skins_url }}/tags/sep.gif" width="1" height="16" alt=""/>
	<a onclick="insertext('<!--nextpage-->','', {{ area }})" title='{l_tags.nextpage}'><img src="{{ skins_url }}/tags/nextpage.gif" width="16" height="16" alt="{l_tags.nextpage}"/></a>
	<img src="{{ skins_url }}/tags/sep.gif" width="1" height="16" alt=""/>
	<span class="more">
		<a onclick="insertext('<!--more-->','', {{ area }})" title='{l_tags.more}'><img src="{{ skins_url }}/tags/more.gif" width="16" height="16" alt="{l_tags.more}"/></a>
	</span>
</div>
<script>
	function insertAtCursor(fieldId, text) {
var el = document.getElementById(fieldId);
if (! el) {
return;
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
}
function prepareMediaPrompt(areaId) {
var href = prompt('{{ lang['media.url'] }}' + ' ' + '(*)', '');
if (! href) {
return;
}
var w = prompt('{{ lang['media.width'] }}' + ' ( {{ lang['btn_optional']|default('необязательно') }})', '');
var h = prompt('{{ lang['media.height'] }}' + ' ( {{ lang['btn_optional']|default('необязательно') }})', '');
var p = prompt('{{ lang['media.preview'] }}' + ' ( {{ lang['btn_optional']|default('необязательно') }})', '');
var attrs = '';
if (w) {
attrs += ' width="' + (
w + ''
).replace(/[^0-9]/g, '') + '"';
}
if (h) {
attrs += ' height="' + (
h + ''
).replace(/[^0-9]/g, '') + '"';
}
if (p) {
attrs += ' preview="' + (
p + ''
).replace(/"/g, '&quot;') + '"';
}
var bb = attrs ? ('[media' + attrs + ']' + href + '[/media]') : ('[media]' + href + '[/media]');
insertAtCursor(areaId, bb);
}
</script>
