<span id="save_area" style="display: block;"></span>
<div id="tags" class="btn-toolbar mb-3" role="toolbar">
	<div class="btn-group btn-group-sm mr-2">
		<button type="submit" class="btn btn-outline-dark">
			<i class="fa fa-floppy-o"></i>
		</button>
	</div>
	<!-- Undo / Redo -->
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn btn-outline-dark" title="Отменить" onclick="ngToolbarUndo({{ area }})">
			<i class="fa fa-undo"></i>
		</button>
		<button type="button" class="btn btn-outline-dark" title="Повторить" onclick="ngToolbarRedo({{ area }})">
			<i class="fa fa-repeat"></i>
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
			<a href="#" class="dropdown-item" onclick="insertext('[hide]','[/hide]', {{ area }})">
				<i class="fa fa-shield"></i>
				{{ lang['tags.hide'] }}</a>
		</div>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button id="tags-link" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			<i class="fa fa-link"></i>
		</button>
		<div class="dropdown-menu" aria-labelledby="tags-link">
			<a href="#" class="dropdown-item" data-toggle="modal" data-target="#modal-insert-url" onclick="prepareUrlModal({{ area }}); showModalById('modal-insert-url'); return false;">
				<i class="fa fa-link"></i>
				{{ lang['tags.link'] }}</a>
			<a href="#" class="dropdown-item" data-toggle="modal" data-target="#modal-insert-email" onclick="prepareEmailModal({{ area }}); showModalById('modal-insert-email'); return false;">
				<i class="fa fa-envelope-o"></i>
				{{ lang['tags.email'] }}</a>
			<a href="#" class="dropdown-item" data-toggle="modal" data-target="#modal-insert-image" onclick="prepareImgModal({{ area }}); showModalById('modal-insert-image'); return false;">
				<i class="fa fa-file-image-o"></i>
				{{ lang['tags.image'] }}</a>
		</div>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		{% if pluginIsActive('bb_media') %}
			<button id="tags-media" type="button" class="btn btn-outline-dark" data-toggle="modal" data-target="#modal-insert-media" onclick="prepareMediaModal({{ area }}); showModalById('modal-insert-media'); return false;" title="[media]">
				<i class="fa fa-play-circle"></i>
			</button>
		{% else %}
			<button type="button" class="btn btn-outline-dark" title="[media]" onclick="try{ if(window.show_info){show_info('{{ lang['media.enable'] }}');} else { alert('{{ lang['media.enable'] }}'); } }catch(e){ alert('{{ lang['media.enable'] }}'); } return false;">
				<i class="fa fa-play-circle"></i>
			</button>
		{% endif %}
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button onclick="try{document.forms['DATA_tmp_storage'].area.value={{ area }};} catch(err){;} window.open('{{ php_self }}?mod=files&amp;ifield='+{{ area }}, '_Addfile', 'height=600,resizable=yes,scrollbars=yes,width=800');return false;" target="DATA_Addfile" type="button" class="btn btn-outline-dark" title="{{ lang['tags.file'] }}">
			<i class="fa fa-file-text-o"></i>
		</button>
		<button onclick="try{document.forms['DATA_tmp_storage'].area.value={{ area }};} catch(err){;} window.open('{{ php_self }}?mod=images&amp;ifield='+{{ area }}, '_Addimage', 'height=600,resizable=yes,scrollbars=yes,width=800');return false;" target="DATA_Addimage" type="button" class="btn btn-outline-dark" title="{{ lang['tags.image'] }}">
			<i class="fa fa-file-image-o"></i>
		</button>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn btn-outline-dark" title="{{ lang['tags.nextpage'] }}" onclick="insertext('<!--nextpage-->','', {{ area }})">
			<i class="fa fa-files-o"></i>
		</button>
		<button type="button" class="btn btn-outline-dark" title="{{ lang['tags.more'] }}" onclick="insertext('<!--more-->','', {{ area }})">
			<i class="fa fa-ellipsis-h"></i>
		</button>
		<button type="button" data-toggle="modal" data-target="#modal-smiles" class="btn btn-outline-dark">
			<i class="fa fa-smile-o"></i>
		</button>
	</div>
	<!-- Dropdown: вставка [code=язык]...[/code] -->
	{% if callPlugin('code_highlight.hasAnyEnabled', {}) %}
		<div class="btn-group btn-group-sm mr-2">
			<button id="tags-code" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Код с подсветкой (выбрать язык)">
				<i class="fa fa-code"></i>
			</button>
			<div class="dropdown-menu dropdown-menu-right" aria-labelledby="tags-code">
				<h6 class="dropdown-header">Язык подсветки</h6>
				{% if callPlugin('code_highlight.brushEnabled', {'name':'php'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('php', {{ area }}); return false;">PHP</a>
				{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'js'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('js', {{ area }}); return false;">JavaScript</a>
				{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'sql'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('sql', {{ area }}); return false;">SQL</a>
				{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'xml'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('xml', {{ area }}); return false;">HTML/XML</a>
				{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'css'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('css', {{ area }}); return false;">CSS</a>
				{% endif %}
				<div class="dropdown-divider"></div>
				{% if callPlugin('code_highlight.brushEnabled', {'name':'bash'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('bash', {{ area }}); return false;">Bash/Shell</a>
				{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'python'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('python', {{ area }}); return false;">Python</a>
				{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'java'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('java', {{ area }}); return false;">Java</a>
				{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'csharp'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('csharp', {{ area }}); return false;">C#</a>
				{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'cpp'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('cpp', {{ area }}); return false;">C/C++</a>
				{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'delphi'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('delphi', {{ area }}); return false;">Delphi/Pascal</a>
				{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'diff'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('diff', {{ area }}); return false;">Diff/Patch</a>
				{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'ruby'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('ruby', {{ area }}); return false;">Ruby</a>
				{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'perl'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('perl', {{ area }}); return false;">Perl</a>
				{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'vb'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('vb', {{ area }}); return false;">VB/VB.Net</a>
				{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'powershell'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('powershell', {{ area }}); return false;">PowerShell</a>
				{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'scala'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('scala', {{ area }}); return false;">Scala</a>
				{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'groovy'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('groovy', {{ area }}); return false;">Groovy</a>
				{% endif %}
				<div class="dropdown-divider"></div>
				{% if callPlugin('code_highlight.brushEnabled', {'name':'plain'}) %}
					<a class="dropdown-item" href="#" onclick="insertCodeBrush('plain', {{ area }}); return false;">Plain (без языка)</a>
				{% endif %}
				<a class="dropdown-item" href="#" onclick="insertext('[code]','[/code]', {{ area }}); return false;">Без параметра [code]</a>
				<a class="dropdown-item" href="#" onclick="insertext('[strong]','[/strong]', {{ area }}); return false;">экранирование в строке</a>
			</div>
		</div>
	{% endif %}
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
<script>
	function showModalById(id) {
var el = document.getElementById(id);
if (! el)
return;
try {
if (window.jQuery && jQuery(el).modal) {
jQuery(el).modal('show');
return;
}
} catch (e) {}el.style.display = 'block';
el.classList.add('show');
el.removeAttribute('aria-hidden');
}
// Store and prepare modal values based on current selection
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
// Prefill text with selection
var urlText = document.getElementById('urlText');
var urlHref = document.getElementById('urlHref');
if (urlText) {
urlText.value = selText || urlText.value || '';
}
// If selection looks like URL - prefill href
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
// Зафиксируем изменение в нашей истории textarea (если доступна)
try {
if (typeof __ng_hist_push === 'function') {
__ng_hist_push(fieldId);
}
} catch (e) {}
}
function insertUrlFromModal() {
var areaId = document.getElementById('urlAreaId').value || '';
var href = (document.getElementById('urlHref').value || '').trim();
var text = (document.getElementById('urlText').value || '').trim();
var target = document.getElementById('urlTarget').value;
var nofollow = document.getElementById('urlNofollow').checked;
if (! href) { // minimal UX: focus URL field if empty
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
// reset minimal state and hide
try {
$('#modal-insert-url').modal('hide');
} catch (e) {
var modal = document.getElementById('modal-insert-url');
if (modal) {
modal.classList.remove('show');
modal.style.display = 'none';
}
}
// keep entered values for potential next insert, but clear selection-based fields
}
</script>
<script>
	// Кнопки Undo/Redo для стандартного textarea
function ngToolbarUndo(areaId) {
try {
if (typeof __ng_hist_flush === 'function') {
__ng_hist_flush(areaId);
}
} catch (e) {}
try {
if (typeof __ng_hist_undo === 'function' && __ng_hist_undo(areaId)) {
return;
}
} catch (e) {}
try {
var ta = document.getElementById(areaId);
if (ta)
ta.focus();
} catch (e) {}
}
function ngToolbarRedo(areaId) {
try {
if (typeof __ng_hist_flush === 'function') {
__ng_hist_flush(areaId);
}
} catch (e) {}
try {
if (typeof __ng_hist_redo === 'function' && __ng_hist_redo(areaId)) {
return;
}
} catch (e) {}
try {
var ta = document.getElementById(areaId);
if (ta)
ta.focus();
} catch (e) {}
}
</script>
<script>
	// Простая история изменений для стандартного textarea (без привязки к внешним редакторам)
(function () {
var MAX_DEPTH = 100;
var maps = {}; // id -> {stack:[{v,s,e}], index:int, attached:bool, lock:bool}
var timers = {}; // debounce таймеры на id
function getId(areaId) {
try {
if (typeof areaId === 'string')
return areaId;
if (areaId && typeof areaId === 'object') {
if (areaId.id)
return String(areaId.id);
if (areaId.getAttribute) {
var aid = areaId.getAttribute('id');
if (aid)
return String(aid);
}
}
if (typeof areaId === 'number')
return String(areaId);
} catch (e) {}
return 'content';
}
function getEl(id) {
try {
return document.getElementById(id);
} catch (e) {
return null;
}
}
function getMap(id) {
if (! maps[id])
maps[id] = {
stack: [],
index: -1,
attached: false,
lock: false
};
return maps[id];
}
function snapshot(el) {
var v = String(el && el.value != null ? el.value : '');
var s = 0,
e = 0;
try {
if (typeof el.selectionStart === 'number' && typeof el.selectionEnd === 'number') {
s = el.selectionStart;
e = el.selectionEnd;
}
} catch (e_) {}
return {v: v, s: s, e: e};
}
function applyState(el, st) {
if (! el || ! st)
return;
try {
maps[el.id] && (maps[el.id].lock = true);
} catch (e) {}el.value = st.v;
try {
if (typeof el.selectionStart === 'number' && typeof el.selectionEnd === 'number') {
el.selectionStart = st.s;
el.selectionEnd = st.e;
}
} catch (e_) {}
try {
el.focus();
} catch (e) {}
setTimeout(function () {
try {
maps[el.id] && (maps[el.id].lock = false);
} catch (e) {}
}, 0);
}
function push(id) {
id = getId(id);
var el = getEl(id);
if (! el)
return false;
var m = getMap(id);
var st = snapshot(el);
var top = m.stack[m.index] || null;
if (top && top.v === st.v)
return false;
// без дубликатов
// отбрасываем «будущее», если были откаты
if (m.index<m.stack.length - 1) {
			m.stack = m.stack.slice(0, m.index + 1);
		}
		m.stack.push(st);
		if (m.stack.length>MAX_DEPTH) {
m.stack.shift();
}
m.index = m.stack.length - 1;
return true;
}
function attach(id) {
id = getId(id);
var el = getEl(id);
if (! el)
return;
var m = getMap(id);
if (m.attached)
return;
m.attached = true;
// Базовое состояние
push(id);
var handler = function () {
if (m.lock)
return;
// игнорируем программные применения
// debounce
if (timers[id]) {
clearTimeout(timers[id]);
}
timers[id] = setTimeout(function () {
push(id);
}, 250);
};
el.addEventListener('input', handler);
el.addEventListener('change', handler);
// Вставка из буфера/drag&drop/потеря фокуса
el.addEventListener('paste', function () {
if (! m.lock) {
if (timers[id])
clearTimeout(timers[id]);
timers[id] = setTimeout(function () {
push(id);
}, 50);
}
});
el.addEventListener('drop', function () {
if (! m.lock) {
if (timers[id])
clearTimeout(timers[id]);
timers[id] = setTimeout(function () {
push(id);
}, 50);
}
});
el.addEventListener('blur', function () {
if (! m.lock) {
push(id);
}
});
// Подстраховка на Enter/Backspace/Delete
el.addEventListener('keyup', function (e) {
if (m.lock)
return;
var k = e && e.key;
if (k === 'Enter' || k === 'Backspace' || k === 'Delete') {
if (timers[id])
clearTimeout(timers[id]);
timers[id] = setTimeout(function () {
push(id);
}, 100);
}
});
}
function undo(id) {
id = getId(id);
var el = getEl(id);
if (! el)
return false;
var m = getMap(id);
if (! m.attached)
attach(id);
if (m.index<= 0) return false;
		m.index--;
		applyState(el, m.stack[m.index]);
		return true;
	}
	function redo(id){
		id = getId(id);
		var el = getEl(id);
		if (!el) return false;
		var m = getMap(id);
		if (!m.attached) attach(id);
		if (m.index >= m.stack.length - 1)
return false;
m.index ++;
applyState(el, m.stack[m.index]);
return true;
}
// Экспорт в глобал
window.__ng_hist_attach = attach;
window.__ng_hist_push = push;
window.__ng_hist_undo = undo;
window.__ng_hist_redo = redo;
window.__ng_hist_flush = function (id) {
id = getId(id);
var el = getEl(id);
if (! el)
return false;
attach(id);
if (timers[id]) {
try {
clearTimeout(timers[id]);
} catch (e) {}timers[id] = null;
}
return push(id);
};
// Обернём стандартный insertext, чтобы фиксировать изменения
try {
if (typeof window.insertext === 'function' && !window.__ng_insertext_wrapped) {
window.__ng_insertext_wrapped = true;
window.__ng_insertext_orig = window.insertext;
window.insertext = function (open, close, field) {
var id = (field === '' || field === null || typeof field === 'undefined') ? 'content' : field;
try {
attach(id);
} catch (e) {}
var res = false;
try {
res = window.__ng_insertext_orig(open, close, field);
} finally {
try {
push(id);
} catch (e) {}
}
return res;
};
}
} catch (e) {}
// Автоподключение истории по фокусу на любом textarea
try {
document.addEventListener('focusin', function (ev) {
try {
var t = ev && ev.target;
if (t && t.tagName === 'TEXTAREA' && t.id) {
attach(t.id);
}
} catch (e) {}
}, true);
} catch (e) {}
// Поддержка поля по умолчанию 'content', если оно присутствует
try {
var __el0 = document.getElementById('content');
if (__el0)
attach('content');
} catch (e) {}
})();
</script>
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
<script>
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
</script>
<!-- Modal: Insert Media -->
{% if pluginIsActive('bb_media') %}
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
	<script>
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
hrefField.value = selText.trim();
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
	<!-- Modal: Insert Acronym -->
	<div id="modal-insert-acronym" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="acronym-modal-label" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 id="acronym-modal-label" class="modal-title">Акроним</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<input type="hidden" id="acronymAreaId" value=""/>
					<div class="form-group">
						<label for="acronymTitle">Подсказка (title)</label>
						<input type="text" class="form-control" id="acronymTitle" placeholder="Полный расшифровки акронима"/>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Отмена</button>
					<button type="button" class="btn btn-primary" onclick="insertAcronymFromModal()">Вставить</button>
				</div>
			</div>
		</div>
	</div>
	<script>
		function prepareAcronymModal(areaId) {
try {
document.getElementById('acronymAreaId').value = areaId || '';
} catch (e) {}
}
function insertAcronymFromModal() {
var title = (document.getElementById('acronymTitle').value || '').replace(/\]/g, ')').trim();
if (title === '') {
document.getElementById('acronymTitle').focus();
return;
}
var aid = (document.getElementById('acronymAreaId').value || '');
insertext('[acronym=' + title + ']', '[/acronym]', aid);
try {
$('#modal-insert-acronym').modal('hide');
} catch (e) {
var m = document.getElementById('modal-insert-acronym');
if (m) {
m.classList.remove('show');
m.style.display = 'none';
}
}
}
	</script>
	<!-- Modal: Insert Code (language) -->
	<div id="modal-insert-code" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="code-modal-label" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 id="code-modal-label" class="modal-title">Код с языком</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<input type="hidden" id="codeAreaId" value=""/>
					<div class="form-group">
						<label for="codeLang">Язык</label>
						<input type="text" class="form-control" id="codeLang" placeholder="Напр.: php, js, sql, xml, css, bash..."/>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Отмена</button>
					<button type="button" class="btn btn-primary" onclick="insertCodeFromModal()">Вставить</button>
				</div>
			</div>
		</div>
	</div>
	<script>
		function prepareCodeModal(areaId) {
try {
document.getElementById('codeAreaId').value = areaId || '';
} catch (e) {}
}
function insertCodeFromModal() {
var lang = (document.getElementById('codeLang').value || '').trim();
var aid = (document.getElementById('codeAreaId').value || '');
insertext('[code' + (
lang ? ('=' + lang) : ''
) + ']', '[/code]', aid);
try {
$('#modal-insert-code').modal('hide');
} catch (e) {
var m = document.getElementById('modal-insert-code');
if (m) {
m.classList.remove('show');
m.style.display = 'none';
}
}
}
	</script>
{% endif %}
<script>
	// Code highlight helper for toolbar: inserts [code=lang]...[/code]
if (typeof insertCodeBrush !== 'function') {
function insertCodeBrush(alias, areaId) {
try {
if (! alias)
return;
} catch (e) {}
var a = String(alias || '').toLowerCase();
var map = {
'html': 'xml',
'xhtml': 'xml',
'xml': 'xml',
'javascript': 'js',
'node': 'js',
'js': 'js',
'c#': 'csharp',
'csharp': 'csharp',
'cs': 'csharp',
'c++': 'cpp',
'cpp': 'cpp',
'c': 'cpp',
'text': 'plain',
'plain': 'plain',
'txt': 'plain',
'mysql': 'sql',
'mariadb': 'sql',
'pgsql': 'sql',
'postgres': 'sql'
};
var lang = (map[a] || a);
// Попробуем работать с текущим выделением без вложения [code] внутрь [code=...]
var el = null;
try {
el = document.getElementById(areaId);
} catch (e) {}
if (! el) {
insertext('[code=' + lang + ']', '[/code]', areaId);
return;
}
// Получаем выделение
var start = 0,
end = 0,
selected = '';
if (typeof el.selectionStart === 'number' && typeof el.selectionEnd === 'number') {
start = el.selectionStart;
end = el.selectionEnd;
selected = el.value.substring(start, end);
} else if (document.selection && document.selection.createRange) {
el.focus();
var sel = document.selection.createRange();
selected = sel.text || '';
}
// Нормализуем переносы для регекспов
var sel = String(selected);
var reBlock = /^\[code(?:=[^\]]+)?\]([\s\S]*?)\[\/code\]$/i; // весь блок [code]
if (sel && reBlock.test(sel)) { // если выделен целый блок [code]...[/code] — заменяем заголовок, не создавая вложенности
var inner = sel.replace(/^\[code(?:=[^\]]+)?\]/i, '').replace(/\[\/code\]$/i, '');
var replacement = '[code=' + lang + ']' + inner + '[/code]';
// Замена выделения на месте
if (document.selection && document.selection.createRange) {
var r = document.selection.createRange();
r.text = replacement;
} else if (typeof el.selectionStart === 'number' && typeof el.selectionEnd === 'number') {
var scroll = el.scrollTop;
el.value = el.value.substring(0, start) + replacement + el.value.substring(end);
el.selectionStart = el.selectionEnd = start + replacement.length;
el.scrollTop = scroll;
} else { // fallback
el.value += replacement;
}
return;
}
// Иначе просто оборачиваем выделение (или курсор) в [code=lang]...[/code]
insertext('[code=' + lang + ']', '[/code]', areaId);
}
}
</script>
