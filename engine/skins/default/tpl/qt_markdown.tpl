<div id="tags" class="btn-toolbar mb-3" role="toolbar" aria-label="Markdown">
	<div class="btn-group btn-group-sm mr-2">
		<button type="submit" class="btn btn-outline-dark" title="Сохранить">
			<i class="fa fa-floppy-o"></i>
		</button>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn btn-outline-dark" title="Отменить" onclick="ngToolbarUndo({{ area }})">
			<i class="fa fa-undo"></i>
		</button>
		<button type="button" class="btn btn-outline-dark" title="Повторить" onclick="ngToolbarRedo({{ area }})">
			<i class="fa fa-repeat"></i>
		</button>
	</div>
	{% if editor_template == 'news' and pluginIsActive('ai_rewriter') %}
		<div class="btn-group btn-group-sm mr-2">
			<button type="button" class="btn btn-outline-primary" title="{{ lang['ai_rewriter:rewrite'] }}" onclick="aiRewriteCurrentArea();">
				<i class="fa fa-magic"></i>
			</button>
		</div>
	{% endif %}
	<div class="btn-group btn-group-sm mr-2" role="group" aria-label="Заголовки и таблица">
		<button id="markdown-heading" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Заголовок">
			<i class="fa fa-header"></i>
		</button>
		<div class="dropdown-menu" aria-labelledby="markdown-heading">
			<a href="#" class="dropdown-item" onclick="insertext('# ', '', {{ area }}); return false;">Заголовок 1</a>
			<a href="#" class="dropdown-item" onclick="insertext('## ', '', {{ area }}); return false;">Заголовок 2</a>
			<a href="#" class="dropdown-item" onclick="insertext('### ', '', {{ area }}); return false;">Заголовок 3</a>
			<a href="#" class="dropdown-item" onclick="insertext('#### ', '', {{ area }}); return false;">Заголовок 4</a>
			<a href="#" class="dropdown-item" onclick="insertext('##### ', '', {{ area }}); return false;">Заголовок 5</a>
			<a href="#" class="dropdown-item" onclick="insertext('###### ', '', {{ area }}); return false;">Заголовок 6</a>
		</div>
		<button type="button" class="btn btn-outline-dark" title="Вставить таблицу" onclick="insertext('| Заголовок 1 | Заголовок 2 |\n| --- | --- |\n| Ячейка 1 | Ячейка 2 |\n', '', {{ area }})">
			<i class="fa fa-table"></i>
		</button>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn btn-outline-dark" title="Абзац" onclick="insertext('\n\n', '\n\n', {{ area }})">
			<i class="fa fa-paragraph"></i>
		</button>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button id="markdown-font" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Форматирование текста">
			<i class="fa fa-font"></i>
		</button>
		<div class="dropdown-menu" aria-labelledby="markdown-font">
			<a href="#" class="dropdown-item" onclick="insertext('**', '**', {{ area }}); return false;"><i class="fa fa-bold"></i> Жирный</a>
			<a href="#" class="dropdown-item" onclick="insertext('*', '*', {{ area }}); return false;"><i class="fa fa-italic"></i> Курсив</a>
			<a href="#" class="dropdown-item" onclick="insertext('&lt;u&gt;', '&lt;/u&gt;', {{ area }}); return false;"><i class="fa fa-underline"></i> Подчеркнутый</a>
			<a href="#" class="dropdown-item" onclick="insertext('~~', '~~', {{ area }}); return false;"><i class="fa fa-strikethrough"></i> Зачеркнутый</a>
		</div>
	</div>
	<div class="btn-group btn-group-sm mr-2" role="group" aria-label="Выравнивание">
		<button id="markdown-align" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Выравнивание">
			<i class="fa fa-align-left"></i>
		</button>
		<div class="dropdown-menu" aria-labelledby="markdown-align">
			<a href="#" class="dropdown-item" onclick="ngMarkdownWrapSelection({{ area }}, '&lt;div style=&quot;text-align: left&quot;&gt;\n', '\n&lt;/div&gt;'); return false;"><i class="fa fa-align-left"></i> Слева</a>
			<a href="#" class="dropdown-item" onclick="ngMarkdownWrapSelection({{ area }}, '&lt;div style=&quot;text-align: center&quot;&gt;\n', '\n&lt;/div&gt;'); return false;"><i class="fa fa-align-center"></i> По центру</a>
			<a href="#" class="dropdown-item" onclick="ngMarkdownWrapSelection({{ area }}, '&lt;div style=&quot;text-align: right&quot;&gt;\n', '\n&lt;/div&gt;'); return false;"><i class="fa fa-align-right"></i> Справа</a>
			<a href="#" class="dropdown-item" onclick="ngMarkdownWrapSelection({{ area }}, '&lt;div style=&quot;text-align: justify&quot;&gt;\n', '\n&lt;/div&gt;'); return false;"><i class="fa fa-align-justify"></i> По ширине</a>
		</div>
	</div>
	<div class="btn-group btn-group-sm mr-2" role="group" aria-label="Цвет и размер">
		<button id="markdown-color" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Цвет текста и фона">
			<i class="fa fa-eyedropper"></i>
		</button>
		<div class="dropdown-menu" aria-labelledby="markdown-color">
			<h6 class="dropdown-header">Цвет текста</h6>
			<a href="#" class="dropdown-item" onclick="ngMarkdownWrapSelection({{ area }}, '&lt;span style=&quot;color: #d32f2f&quot;&gt;', '&lt;/span&gt;'); return false;">Красный</a>
			<a href="#" class="dropdown-item" onclick="ngMarkdownWrapSelection({{ area }}, '&lt;span style=&quot;color: #1976d2&quot;&gt;', '&lt;/span&gt;'); return false;">Синий</a>
			<a href="#" class="dropdown-item" onclick="ngMarkdownWrapSelection({{ area }}, '&lt;span style=&quot;color: #388e3c&quot;&gt;', '&lt;/span&gt;'); return false;">Зеленый</a>
			<a href="#" class="dropdown-item" onclick="ngMarkdownWrapSelection({{ area }}, '&lt;span style=&quot;color: #000000&quot;&gt;', '&lt;/span&gt;'); return false;">Черный</a>
			<label class="dropdown-item mb-0" for="markdown-text-color">Другой цвет текста <input id="markdown-text-color" type="color" value="#000000" onchange="ngMarkdownApplyColor({{ area }}, this.value, 'color')"></label>
			<div class="dropdown-divider"></div>
			<h6 class="dropdown-header">Фон</h6>
			<a href="#" class="dropdown-item" onclick="ngMarkdownWrapSelection({{ area }}, '&lt;span style=&quot;background-color: #fff59d&quot;&gt;', '&lt;/span&gt;'); return false;">Желтый</a>
			<a href="#" class="dropdown-item" onclick="ngMarkdownWrapSelection({{ area }}, '&lt;span style=&quot;background-color: #b3e5fc&quot;&gt;', '&lt;/span&gt;'); return false;">Голубой</a>
			<label class="dropdown-item mb-0" for="markdown-background-color">Другой цвет фона <input id="markdown-background-color" type="color" value="#ffffff" onchange="ngMarkdownApplyColor({{ area }}, this.value, 'background-color')"></label>
			<div class="dropdown-divider"></div>
			<a href="#" class="dropdown-item" onclick="ngMarkdownWrapSelection({{ area }}, '&lt;span style=&quot;font-size: 80%&quot;&gt;', '&lt;/span&gt;'); return false;">Мелкий текст</a>
			<a href="#" class="dropdown-item" onclick="ngMarkdownWrapSelection({{ area }}, '&lt;span style=&quot;font-size: 120%&quot;&gt;', '&lt;/span&gt;'); return false;">Крупный текст</a>
		</div>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button id="markdown-lists" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Списки и цитата">
			<i class="fa fa-list-ul"></i>
		</button>
		<div class="dropdown-menu" aria-labelledby="markdown-lists">
			<a href="#" class="dropdown-item" onclick="insertext('- ', '', {{ area }}); return false;"><i class="fa fa-list-ul"></i> Маркированный список</a>
			<a href="#" class="dropdown-item" onclick="insertext('1. ', '', {{ area }}); return false;"><i class="fa fa-list-ol"></i> Нумерованный список</a>
			<a href="#" class="dropdown-item" onclick="insertext('&gt; ', '', {{ area }}); return false;"><i class="fa fa-quote-left"></i> Цитата</a>
		</div>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button id="markdown-special" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Специальные блоки">
			<i class="fa fa-puzzle-piece"></i>
		</button>
		<div class="dropdown-menu" aria-labelledby="markdown-special">
			<a href="#" class="dropdown-item" onclick="ngMarkdownWrapSelection({{ area }}, '&lt;details&gt;\n&lt;summary&gt;Спойлер&lt;/summary&gt;\n', '\n&lt;/details&gt;'); return false;"><i class="fa fa-list-alt"></i> Спойлер</a>
			<a href="#" class="dropdown-item" onclick="ngMarkdownInsertAbbr({{ area }}); return false;"><i class="fa fa-tags"></i> Акроним</a>
			<a href="#" class="dropdown-item" onclick="insertext('[hide]', '[/hide]', {{ area }}); return false;"><i class="fa fa-shield"></i> Текст только для зарегистрированных</a>
			{% if editor_template == 'news' and pluginIsActive('finance') %}
				<div class="dropdown-divider"></div>
				<h6 class="dropdown-header">{{ lang['tags.finance_lock'] }}</h6>
				{% for block_number in 1..finance_lock_block_count %}
					{% set open_tag = block_number == 1 ? '[fin_lock]' : '[fin_lock' ~ block_number ~ ']' %}
					{% set close_tag = block_number == 1 ? '[/fin_lock]' : '[/fin_lock' ~ block_number ~ ']' %}
					<a href="#" class="dropdown-item" onclick="insertext('{{ open_tag }}','{{ close_tag }}', {{ area }}); return false;"><i class="fa fa-lock"></i> {{ lang['tags.finance_lock'] }} {{ block_number }}</a>
				{% endfor %}
			{% endif %}
		</div>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button id="markdown-links" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Ссылки и медиа">
			<i class="fa fa-link"></i>
		</button>
		<div class="dropdown-menu" aria-labelledby="markdown-links">
			<a href="#" class="dropdown-item" onclick="ngMarkdownInsertLink({{ area }}, 'link'); return false;"><i class="fa fa-link"></i> Ссылка</a>
			<a href="#" class="dropdown-item" onclick="ngMarkdownInsertLink({{ area }}, 'email'); return false;"><i class="fa fa-envelope-o"></i> Электронная почта</a>
			<a href="#" class="dropdown-item" onclick="ngMarkdownInsertLink({{ area }}, 'image'); return false;"><i class="fa fa-file-image-o"></i> Изображение</a>
			{% if pluginIsActive('bb_media') %}
				<a href="#" class="dropdown-item" onclick="ngMarkdownInsertMedia({{ area }}); return false;"><i class="fa fa-play-circle"></i> Вставить медиа</a>
			{% else %}
				<a href="#" class="dropdown-item" onclick="window.alert('{{ lang['media.enable']|e('js') }}'); return false;"><i class="fa fa-play-circle"></i> {{ lang['media.enable'] }}</a>
			{% endif %}
		</div>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button id="markdown-code-insert" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Вставить код">
			<i class="fa fa-code"></i>
		</button>
		<div class="dropdown-menu dropdown-menu-right" aria-labelledby="markdown-code-insert">
			<a href="#" class="dropdown-item" onclick="insertext('`', '`', {{ area }}); return false;"><i class="fa fa-code"></i> Встроенный код</a>
			<a href="#" class="dropdown-item" onclick="insertext('```\n', '\n```', {{ area }}); return false;"><i class="fa fa-terminal"></i> Блок кода</a>
			{% if callPlugin('code_highlight.hasAnyEnabled', {}) %}
				<div class="dropdown-divider"></div>
				<h6 class="dropdown-header">Язык подсветки</h6>
				{% if callPlugin('code_highlight.brushEnabled', {'name':'php'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('php', {{ area }}); return false;">PHP</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'js'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('js', {{ area }}); return false;">JavaScript</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'sql'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('sql', {{ area }}); return false;">SQL</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'xml'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('xml', {{ area }}); return false;">HTML/XML</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'css'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('css', {{ area }}); return false;">CSS</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'bash'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('bash', {{ area }}); return false;">Bash/Shell</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'python'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('python', {{ area }}); return false;">Python</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'java'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('java', {{ area }}); return false;">Java</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'csharp'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('csharp', {{ area }}); return false;">C#</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'cpp'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('cpp', {{ area }}); return false;">C/C++</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'delphi'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('delphi', {{ area }}); return false;">Delphi/Pascal</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'diff'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('diff', {{ area }}); return false;">Diff/Patch</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'ruby'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('ruby', {{ area }}); return false;">Ruby</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'perl'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('perl', {{ area }}); return false;">Perl</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'vb'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('vb', {{ area }}); return false;">VB/VB.Net</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'powershell'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('powershell', {{ area }}); return false;">PowerShell</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'scala'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('scala', {{ area }}); return false;">Scala</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'groovy'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('groovy', {{ area }}); return false;">Groovy</a>{% endif %}
				{% if callPlugin('code_highlight.brushEnabled', {'name':'plain'}) %}<a class="dropdown-item" href="#" onclick="insertCodeBrush('plain', {{ area }}); return false;">Plain (без языка)</a>{% endif %}
			{% endif %}
		</div>
	</div>
	{% if editor_template == 'news' or editor_template == 'static' %}
		<div class="btn-group btn-group-sm mr-2">
			<button type="button" class="btn btn-outline-dark" data-toggle="modal" data-target="#modal-uplimg" title="Загрузить изображение или файл" onclick="window.__editorAreaId={{ area }};">
				<i class="fa fa-folder-open-o"></i>
			</button>
		</div>
		<div class="btn-group btn-group-sm mr-2">
			<button id="markdown-pagebreak" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Разрывы страницы">
				<i class="fa fa-files-o"></i>
			</button>
			<div class="dropdown-menu" aria-labelledby="markdown-pagebreak">
				<a href="#" class="dropdown-item" onclick="insertext('&lt;!--nextpage--&gt;', '', {{ area }}); return false;"><i class="fa fa-files-o"></i> {{ lang['tags.nextpage'] }}</a>
				<a href="#" class="dropdown-item" onclick="insertext('&lt;!--more--&gt;', '', {{ area }}); return false;"><i class="fa fa-ellipsis-h"></i> {{ lang['tags.more'] }}</a>
			</div>
		</div>
	{% endif %}
	<div class="btn-group btn-group-sm mr-2">
		<button id="markdown-smiles" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Смайлики и emoji">
			<i class="fa fa-smile-o"></i>
		</button>
		<div class="dropdown-menu" aria-labelledby="markdown-smiles">
			<a href="#" class="dropdown-item" data-toggle="modal" data-target="#modal-smiles"><i class="fa fa-smile-o"></i> Смайлики</a>
			<a href="#" class="dropdown-item" data-toggle="modal" data-target="#markdown-emoji-modal">😀 Вставить emoji</a>
		</div>
	</div>
</div>
{% if editor_template == 'news' or editor_template == 'static' %}
	<div id="modal-uplimg" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="markdown-uplimg-label" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content" role="document">
				<div class="modal-header">
					<h5 id="markdown-uplimg-label" class="modal-title">Загрузка изображений и файлов</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				</div>
				<div class="modal-body">
					<ul class="nav nav-tabs nav-fill" role="tablist">
						<li class="nav-item"><a href="#upl-img" class="nav-link active" data-toggle="tab" role="tab">Изображения</a></li>
						<li class="nav-item"><a href="#upl-data" class="nav-link" data-toggle="tab" role="tab">Файлы</a></li>
					</ul>
					<div class="tab-content">
						<div id="upl-img" class="tab-pane fade show active" role="tabpanel">
							<ul id="newsimage-area" style="list-style: none; padding-left: 0;"></ul>
							<input type="file" id="uploadimage" name="newsimage" style="display:none;" onchange="uploadNewsImage({{ area }});">
							<div data-ng-dropzone="image" class="mb-2 w-100" style="border:2px dashed #cbd3da;border-radius:6px;padding:12px;text-align:center;cursor:pointer;" onclick="document.getElementById('uploadimage').click();">
								<i class="fa fa-cloud-upload"></i> Выберите изображение или перетащите его сюда
							</div>
						</div>
						<div id="upl-data" class="tab-pane fade" role="tabpanel">
							<ul id="newsfile-area" style="list-style: none; padding-left: 0;"></ul>
							<input type="file" id="uploadfile" name="newsfile" style="display:none;" onchange="uploadNewsFile({{ area }});">
							<div data-ng-dropzone="file" class="mb-2 w-100" style="border:2px dashed #cbd3da;border-radius:6px;padding:12px;text-align:center;cursor:pointer;" onclick="document.getElementById('uploadfile').click();">
								<i class="fa fa-cloud-upload"></i> Выберите файл или перетащите его сюда
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer"><button type="button" class="btn btn-outline-dark" data-dismiss="modal">Закрыть</button></div>
			</div>
		</div>
	</div>
{% endif %}
<div id="markdown-emoji-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="markdown-emoji-label" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="markdown-emoji-label" class="modal-title">Вставить emoji</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Закрыть"><span aria-hidden="true">&times;</span></button>
			</div>
			<div class="modal-body">
				<style>.emoji-picker-grid{display:flex;flex-wrap:wrap;gap:4px}.emoji-picker-item{border:0;background:transparent;border-radius:4px;cursor:pointer;font-size:1.5rem;line-height:1;padding:6px}.emoji-picker-item:hover{background:#f0f0f0}</style>
				{{ emoji_picker|raw }}
			</div>
			<div class="modal-footer"><button type="button" class="btn btn-outline-dark" data-dismiss="modal">Закрыть</button></div>
		</div>
	</div>
</div>
<script>
	if (!window.NGCMS) window.NGCMS = {};
	NGCMS.content_format = 'markdown';
	NGCMS.images_url = "{{ config['images_url']|default('/uploads/images') }}";
	NGCMS.files_url = "{{ config['files_url']|default('/uploads/files') }}";

	function ngMarkdownWrapSelection(areaId, open, close) {
		var field = document.getElementById(areaId);
		if (!field) return false;
		field.focus();
		var start = field.selectionStart || 0;
		var end = field.selectionEnd || start;
		var selected = field.value.substring(start, end);
		var prefix = String(open);
		var suffix = String(close || '');
		field.value = field.value.substring(0, start) + prefix + selected + suffix + field.value.substring(end);
		var cursor = start + prefix.length + selected.length;
		field.setSelectionRange(cursor, cursor);
		return false;
	}

	function ngMarkdownInsertLink(areaId, kind) {
		var field = document.getElementById(areaId);
		if (!field) return false;
		var start = field.selectionStart || 0;
		var end = field.selectionEnd || start;
		var label = field.value.substring(start, end);
		var promptText = kind === 'email' ? 'Адрес электронной почты:' : 'Адрес ссылки:';
		var target = window.prompt(promptText, kind === 'email' ? '' : 'https://');
		if (target === null || !target.trim()) return false;
		target = target.trim();
		if (kind === 'email') {
			if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(target)) {
				window.alert('Укажите корректный адрес электронной почты.');
				return false;
			}
			target = 'mailto:' + target;
		} else {
			if (!/^https?:\/\//i.test(target)) target = 'https://' + target;
			if (!/^https?:\/\/[^\s]+$/i.test(target)) {
				window.alert('Допускаются только ссылки HTTP или HTTPS.');
				return false;
			}
		}
		if (!label) {
			var defaultLabel = kind === 'image' ? '' : target.replace(/^mailto:/, '');
			var enteredLabel = window.prompt(kind === 'image' ? 'Описание изображения:' : 'Текст ссылки:', defaultLabel);
			if (enteredLabel === null) return false;
			label = enteredLabel || defaultLabel;
		}
		label = label.replace(/\\/g, '\\\\').replace(/([\[\]])/g, '\\$1');
		target = target.replace(/[\\()\s"]/g, function (character) {
			return encodeURIComponent(character);
		});
		var markdown = kind === 'image' ? '![' + label + '](' + target + ')' : '[' + label + '](' + target + ')';
		field.value = field.value.substring(0, start) + markdown + field.value.substring(end);
		field.setSelectionRange(start + markdown.length, start + markdown.length);
		field.focus();
		return false;
	}

	function ngMarkdownApplyColor(areaId, color, property) {
		if (!/^#[0-9a-f]{6}$/i.test(color)) return false;
		return ngMarkdownWrapSelection(areaId, '<span style="' + property + ': ' + color + '">', '</span>');
	}

	function ngMarkdownInsertAbbr(areaId) {
		var field = document.getElementById(areaId);
		if (!field) return false;
		var start = field.selectionStart || 0;
		var end = field.selectionEnd || start;
		var text = field.value.substring(start, end);
		if (!text) {
			window.alert('Сначала выделите текст акронима.');
			return false;
		}
		var title = window.prompt('Расшифровка акронима:');
		if (title === null) return false;
		title = title.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
		field.value = field.value.substring(0, start) + '<abbr title="' + title + '">' + text + '</abbr>' + field.value.substring(end);
		var cursor = start + '<abbr title="' + title + '">'.length + text.length + '</abbr>'.length;
		field.setSelectionRange(cursor, cursor);
		field.focus();
		return false;
	}

	function ngMarkdownInsertMedia(areaId) {
		var field = document.getElementById(areaId);
		if (!field) return false;
		var start = field.selectionStart || 0;
		var end = field.selectionEnd || start;
		var url = window.prompt('URL медиафайла или встраиваемого плеера:', 'https://');
		if (url === null || !url.trim()) return false;
		url = url.trim();
		if (!/^https?:\/\/[^\s]+$/i.test(url)) {
			window.alert('Укажите корректный адрес HTTP или HTTPS.');
			return false;
		}
		var token = '[media]' + url + '[/media]';
		field.value = field.value.substring(0, start) + token + field.value.substring(end);
		field.setSelectionRange(start + token.length, start + token.length);
		field.focus();
		return false;
	}
</script>
<script src="/lib/news_editor.js"></script>
