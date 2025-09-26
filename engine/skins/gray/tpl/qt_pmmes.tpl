<div id="tags" class="btn-toolbar mb-3" role="toolbar">
	<div class="btn-group btn-group-sm mr-2">
		<button type="submit" class="btn btn-outline-dark">
			<i class="fa fa-floppy-o"></i>
		</button>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn btn-outline-dark" onclick="insertext('[p]','[/p]', {{ area }})">
			<i class="fa fa-paragraph"></i>
		</button>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button id="tags-font" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			<i class="fa fa-font"></i>
		</button>
		<div class="dropdown-menu" aria-labelledby="tags-font">
			<a href="#" class="dropdown-item" onclick="insertext('[b]','[/b]', {{ area }})">
				<i class="fa fa-bold"></i>
				{{ lang['tags.bold'] }}</a>
			<a href="#" class="dropdown-item" onclick="insertext('[i]','[/i]', {{ area }})">
				<i class="fa fa-italic"></i>
				{{ lang['tags.italic'] }}</a>
			<a href="#" class="dropdown-item" onclick="insertext('[u]','[/u]', {{ area }})">
				<i class="fa fa-underline"></i>
				{{ lang['tags.underline'] }}</a>
			<a href="#" class="dropdown-item" onclick="insertext('[s]','[/s]', {{ area }})">
				<i class="fa fa-strikethrough"></i>
				{{ lang['tags.crossline'] }}</a>
		</div>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button id="tags-align" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			<i class="fa fa-align-left"></i>
		</button>
		<div class="dropdown-menu" aria-labelledby="tags-align">
			<a href="#" class="dropdown-item" onclick="insertext('[left]','[/left]', {{ area }})">
				<i class="fa fa-align-left"></i>
				{{ lang['tags.left'] }}</a>
			<a href="#" class="dropdown-item" onclick="insertext('[center]','[/center]', {{ area }})">
				<i class="fa fa-align-center"></i>
				{{ lang['tags.center'] }}</a>
			<a href="#" class="dropdown-item" onclick="insertext('[right]','[/right]', {{ area }})">
				<i class="fa fa-align-right"></i>
				{{ lang['tags.right'] }}</a>
			<a href="#" class="dropdown-item" onclick="insertext('[justify]','[/justify]', {{ area }})">
				<i class="fa fa-align-justify"></i>
				{{ lang['tags.justify'] }}</a>
		</div>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button id="tags-block" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			<i class="fa fa-quote-left"></i>
		</button>
		<div class="dropdown-menu" aria-labelledby="tags-block">
			<a href="#" class="dropdown-item" onclick="insertext('[ul]\n[li][/li]\n[li][/li]\n[li][/li]\n[/ul]','', {{ area }})">
				<i class="fa fa-list-ul"></i>
				{{ lang['tags.bulllist'] }}</a>
			<a href="#" class="dropdown-item" onclick="insertext('[ol]\n[li][/li]\n[li][/li]\n[li][/li]\n[/ol]','', {{ area }})">
				<i class="fa fa-list-ol"></i>
				{{ lang['tags.numlist'] }}</a>
			<div class="dropdown-divider"></div>
			<a href="#" class="dropdown-item" onclick="insertext('[code]','[/code]', {{ area }})">
				<i class="fa fa-code"></i>
				{{ lang['tags.code'] }}</a>
			<a href="#" class="dropdown-item" onclick="insertext('[quote]','[/quote]', {{ area }})">
				<i class="fa fa-quote-left"></i>
				{{ lang['tags.comment'] }}</a>
			<a href="#" class="dropdown-item" onclick="insertext('[spoiler]','[/spoiler]', {{ area }})">
				<i class="fa fa-list-alt"></i>
				{{ lang['tags.spoiler'] }}</a>
			<a href="#" class="dropdown-item" onclick="insertext('[acronym=]','[/acronym]', {{ area }})">
				<i class="fa fa-tags"></i>
				{{ lang['tags.acronym'] }}</a>
		</div>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button id="tags-link" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			<i class="fa fa-link"></i>
		</button>
		<div class="dropdown-menu" aria-labelledby="tags-link">
			<a href="#" class="dropdown-item" data-toggle="modal" data-target="#modal-insert-url" onclick="prepareUrlModal({{ area }})">
				<i class="fa fa-link"></i>
				{{ lang['tags.link'] }}</a>
			<a href="#" class="dropdown-item" data-toggle="modal" data-target="#modal-insert-email" onclick="prepareEmailModal({{ area }})">
				<i class="fa fa-envelope-o"></i>
				{{ lang['tags.email'] }}</a>
			<a href="#" class="dropdown-item" data-toggle="modal" data-target="#modal-insert-image" onclick="prepareImgModal({{ area }})">
				<i class="fa fa-file-image-o"></i>
				{{ lang['tags.image'] }}</a>
		</div>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		{% if pluginIsActive('bb_media') %}
			<button id="tags-media" type="button" class="btn btn-outline-dark" data-toggle="modal" data-target="#modal-insert-media" onclick="prepareMediaModal({{ area }})" title="[media]">
				<i class="fa fa-play-circle"></i>
			</button>
		{% else %}
			<button type="button" class="btn btn-outline-dark" title="[media]" onclick="try{ var msg='{{ lang['media.enable']|e('js') }}'; if(window.show_info){show_info(msg);} else { alert(msg); } }catch(e){ alert('{{ lang['media.enable']|e('js') }}'); } return false;">
				<i class="fa fa-play-circle"></i>
			</button>
		{% endif %}
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" data-toggle="modal" data-target="#modal-smiles" class="btn btn-outline-dark">
			<i class="fa fa-smile-o"></i>
		</button>
	</div>
</div>
<!-- Modal: Insert URL -->
<div id="modal-insert-url" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="url-modal-label" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="url-modal-label" class="modal-title">Вставить ссылку</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<input type="hidden" id="urlAreaId" value=""/>
				<div class="form-group">
					<label for="urlHref">Адрес (URL)</label>
					<input type="text" class="form-control" id="urlHref" placeholder="https://example.com"/>
				</div>
				<div class="form-group">
					<label for="urlText">Текст ссылки</label>
					<input type="text" class="form-control" id="urlText" placeholder="Текст для отображения"/>
				</div>
				<div class="form-row">
					<div class="form-group col-md-6">
						<label for="urlTarget">Открывать</label>
						<select id="urlTarget" class="form-control">
							<option value="">В этой же вкладке</option>
							<option value="_blank">В новой вкладке</option>
						</select>
					</div>
					<div class="form-group col-md-6">
						<label class="d-block">Индексация</label>
						<div class="form-check mt-2">
							<input class="form-check-input" type="checkbox" id="urlNofollow">
							<label class="form-check-label" for="urlNofollow">Не индексировать (rel="nofollow")</label>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Отмена</button>
				<button type="button" class="btn btn-primary" onclick="insertUrlFromModal()">Вставить</button>
			</div>
		</div>
	</div>
</div>
<!-- Modal: Insert Email -->
<div id="modal-insert-email" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="email-modal-label" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="email-modal-label" class="modal-title">Вставить e-mail</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<input type="hidden" id="emailAreaId" value=""/>
				<div class="form-group">
					<label for="emailAddress">Адрес e-mail</label>
					<input type="text" class="form-control" id="emailAddress" placeholder="user@example.com"/>
				</div>
				<div class="form-group">
					<label for="emailText">Текст ссылки</label>
					<input type="text" class="form-control" id="emailText" placeholder="Например: Написать нам"/>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Отмена</button>
				<button type="button" class="btn btn-primary" onclick="insertEmailFromModal()">Вставить</button>
			</div>
		</div>
	</div>
</div>
<!-- Modal: Insert Image -->
<div id="modal-insert-image" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="image-modal-label" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="image-modal-label" class="modal-title">Вставить изображение</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<input type="hidden" id="imgAreaId" value=""/>
				<div class="form-group">
					<label for="imgHref">Адрес изображения (URL)</label>
					<input type="text" class="form-control" id="imgHref" placeholder="https://example.com/image.jpg"/>
				</div>
				<div class="form-group">
					<label for="imgAlt">Альтернативный текст (alt)</label>
					<input type="text" class="form-control" id="imgAlt" placeholder="Краткое описание изображения"/>
				</div>
				<div class="form-row">
					<div class="form-group col-md-4">
						<label for="imgWidth">Ширина</label>
						<input type="number" min="0" class="form-control" id="imgWidth" placeholder="Напр. 600"/>
					</div>
					<div class="form-group col-md-4">
						<label for="imgHeight">Высота</label>
						<input type="number" min="0" class="form-control" id="imgHeight" placeholder="Напр. 400"/>
					</div>
					<div class="form-group col-md-4">
						<label for="imgAlign">Выравнивание</label>
						<select id="imgAlign" class="form-control">
							<option value="">Без выравнивания</option>
							<option value="left">Слева</option>
							<option value="right">Справа</option>
							<option value="middle">По середине строки</option>
							<option value="top">По верхней линии</option>
							<option value="bottom">По нижней линии</option>
						</select>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Отмена</button>
				<button type="button" class="btn btn-primary" onclick="insertImgFromModal()">Вставить</button>
			</div>
		</div>
	</div>
</div>
{% if pluginIsActive('bb_media') %}
	<!-- Modal: Insert Media -->
	<div id="modal-insert-media" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="media-modal-label" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 id="media-modal-label" class="modal-title">{{ lang['tags.media'] }}</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<input type="hidden" id="mediaAreaId" value=""/>
					<div class="form-group">
						<label for="mediaHref">{{ lang['media.url'] }}</label>
						<input type="text" class="form-control" id="mediaHref" placeholder="https://example.com/embed.mp4"/>
					</div>
					<div class="form-row">
						<div class="form-group col-md-4">
							<label for="mediaWidth">{{ lang['media.width'] }}</label>
							<input type="number" min="0" class="form-control" id="mediaWidth" placeholder="напр. 640"/>
						</div>
						<div class="form-group col-md-4">
							<label for="mediaHeight">{{ lang['media.height'] }}</label>
							<input type="number" min="0" class="form-control" id="mediaHeight" placeholder="напр. 360"/>
						</div>
						<div class="form-group col-md-4">
							<label for="mediaPreview">{{ lang['media.preview'] }}</label>
							<input type="text" class="form-control" id="mediaPreview" placeholder="https://example.com/preview.jpg"/>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-outline-secondary" data-dismiss="modal">{{ lang['btn_cancel'] }}</button>
					<button type="button" class="btn btn-primary" onclick="insertMediaFromModal()">{{ lang['btn_insert'] }}</button>
				</div>
			</div>
		</div>
	</div>
{% endif %}
<script>
	function prepareUrlModal(areaId) {
try {
document.getElementById('urlAreaId').value = areaId;
} catch (e) {}
var ta = null;
try {
ta = document.getElementById(areaId);
} catch (e) {}
if (! ta) {
return;
}
var selText = '';
if (typeof ta.selectionStart === 'number' && typeof ta.selectionEnd === 'number') {
selText = ta.value.substring(ta.selectionStart, ta.selectionEnd);
} else if (document.selection && document.selection.createRange) {
ta.focus();
var sel = document.selection.createRange();
selText = sel.text || '';
}
var urlText = document.getElementById('urlText');
var urlHref = document.getElementById('urlHref');
if (urlText) {
urlText.value = selText || urlText.value || '';
}
var looksLikeUrl = /^([a-z]+:\/\/|www\.|\/|#).+/i.test(selText.trim());
if (looksLikeUrl && urlHref && ! urlHref.value) {
urlHref.value = selText.trim();
}
}
function insertAtCursor(fieldId, text) {
var el = null;
try {
el = document.getElementById(fieldId);
} catch (e) {}
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
function insertUrlFromModal() {
var areaId = document.getElementById('urlAreaId').value || '';
var href = (document.getElementById('urlHref').value || '').trim();
var text = (document.getElementById('urlText').value || '').trim();
var target = document.getElementById('urlTarget').value;
var nofollow = document.getElementById('urlNofollow').checked;
if (! href) {
document.getElementById('urlHref').focus();
return;
}
if (!/^([a-z]+:\/\/|\/|#|mailto:)/i.test(href)) {
href = 'http://' + href;
}
if (! text) {
text = href;
}
var attrs = '="' + href.replace(/"/g, '&quot;') + '"';
if (target) {
attrs += ' target="' + target.replace(/[^_a-zA-Z0-9\-]/g, '') + '"';
}
if (nofollow) {
attrs += ' rel="nofollow"';
}
var bb = '[url' + attrs + ']' + text + '[/url]';
insertAtCursor(areaId, bb);
try {
$('#modal-insert-url').modal('hide');
} catch (e) {
var modal = document.getElementById('modal-insert-url');
if (modal) {
modal.classList.remove('show');
modal.style.display = 'none';
}
}
}
function prepareEmailModal(areaId) {
try {
document.getElementById('emailAreaId').value = areaId;
} catch (e) {}
var ta = null;
try {
ta = document.getElementById(areaId);
} catch (e) {}
if (! ta) {
return;
}
var selText = '';
if (typeof ta.selectionStart === 'number' && typeof ta.selectionEnd === 'number') {
selText = ta.value.substring(ta.selectionStart, ta.selectionEnd);
} else if (document.selection && document.selection.createRange) {
ta.focus();
var sel = document.selection.createRange();
selText = sel.text || '';
}
var emailField = document.getElementById('emailAddress');
var textField = document.getElementById('emailText');
var looksLikeEmail = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,20}$/i.test(selText.trim());
if (looksLikeEmail) {
if (emailField && ! emailField.value) {
emailField.value = selText.trim();
}
if (textField && ! textField.value) {
textField.value = selText.trim();
}
} else {
if (textField) {
textField.value = selText || textField.value || '';
}
}
}
function insertEmailFromModal() {
var areaId = document.getElementById('emailAreaId').value || '';
var email = (document.getElementById('emailAddress').value || '').trim();
var text = (document.getElementById('emailText').value || '').trim();
if (! email || email.indexOf('@') === -1) {
document.getElementById('emailAddress').focus();
return;
}
if (! text) {
text = email;
}
var bb = (text === email) ? ('[email]' + email + '[/email]') : ('[email="' + email.replace(/"/g, '&quot;') + '"]' + text + '[/email]');
insertAtCursor(areaId, bb);
try {
$('#modal-insert-email').modal('hide');
} catch (e) {
var modal = document.getElementById('modal-insert-email');
if (modal) {
modal.classList.remove('show');
modal.style.display = 'none';
}
}
}
function prepareImgModal(areaId) {
try {
document.getElementById('imgAreaId').value = areaId;
} catch (e) {}
var ta = null;
try {
ta = document.getElementById(areaId);
} catch (e) {}
if (! ta) {
return;
}
var selText = '';
if (typeof ta.selectionStart === 'number' && typeof ta.selectionEnd === 'number') {
selText = ta.value.substring(ta.selectionStart, ta.selectionEnd);
} else if (document.selection && document.selection.createRange) {
ta.focus();
var sel = document.selection.createRange();
selText = sel.text || '';
}
var hrefField = document.getElementById('imgHref');
var altField = document.getElementById('imgAlt');
var looksLikeImg = /^((https?:\/\/|ftp:\/\/|\/).+)\.(jpg|jpeg|png|gif|webp|svg)(\?.*)?$/i.test(selText.trim());
if (looksLikeImg && hrefField && ! hrefField.value) {
hrefField.value = selText.trim();
}
if (altField && ! looksLikeImg) {
altField.value = selText || altField.value || '';
}
}
function insertImgFromModal() {
var areaId = document.getElementById('imgAreaId').value || '';
var href = (document.getElementById('imgHref').value || '').trim();
var alt = (document.getElementById('imgAlt').value || '').trim();
var width = (document.getElementById('imgWidth').value || '').trim();
var height = (document.getElementById('imgHeight').value || '').trim();
var align = document.getElementById('imgAlign').value;
if (! href) {
document.getElementById('imgHref').focus();
return;
}
if (!/^((https?:\/\/|ftp:\/\/)|\/|#)/i.test(href)) {
href = 'http://' + href;
}
var attrs = '="' + href.replace(/"/g, '&quot;') + '"';
if (width) {
attrs += ' width="' + width.replace(/[^0-9]/g, '') + '"';
}
if (height) {
attrs += ' height="' + height.replace(/[^0-9]/g, '') + '"';
}
if (align) {
attrs += ' align="' + align.replace(/[^a-z]/ig, '').toLowerCase() + '"';
}
var bb = '[img' + attrs + ']' + (
alt || ''
) + '[/img]';
insertAtCursor(areaId, bb);
try {
$('#modal-insert-image').modal('hide');
} catch (e) {
var modal = document.getElementById('modal-insert-image');
if (modal) {
modal.classList.remove('show');
modal.style.display = 'none';
}
}
}
function prepareMediaModal(areaId) {
try {
document.getElementById('mediaAreaId').value = areaId;
} catch (e) {}
var ta = null;
try {
ta = document.getElementById(areaId);
} catch (e) {}
if (! ta) {
return;
}
var selText = '';
if (typeof ta.selectionStart === 'number' && typeof ta.selectionEnd === 'number') {
selText = ta.value.substring(ta.selectionStart, ta.selectionEnd);
} else if (document.selection && document.selection.createRange) {
ta.focus();
var sel = document.selection.createRange();
selText = sel.text || '';
}
var hrefField = document.getElementById('mediaHref');
if (hrefField && ! hrefField.value) {
hrefField.value = (selText || '').trim();
}
}
function insertMediaFromModal() {
var areaId = document.getElementById('mediaAreaId').value || '';
var href = (document.getElementById('mediaHref').value || '').trim();
var w = (document.getElementById('mediaWidth').value || '').trim();
var h = (document.getElementById('mediaHeight').value || '').trim();
var p = (document.getElementById('mediaPreview').value || '').trim();
if (! href) {
document.getElementById('mediaHref').focus();
return;
}
var attrs = '';
if (w) {
attrs += ' width="' + w.replace(/[^0-9]/g, '') + '"';
}
if (h) {
attrs += ' height="' + h.replace(/[^0-9]/g, '') + '"';
}
if (p) {
attrs += ' preview="' + p.replace(/"/g, '&quot;') + '"';
}
var bb = attrs ? ('[media' + attrs + ']' + href + '[/media]') : ('[media]' + href + '[/media]');
insertAtCursor(areaId, bb);
try {
$('#modal-insert-media').modal('hide');
} catch (e) {
var modal = document.getElementById('modal-insert-media');
if (modal) {
modal.classList.remove('show');
modal.style.display = 'none';
}
}
}
</script>
