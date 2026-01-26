<span id="save_area" style="display: block;"></span>
<div id="tags" class="btn-toolbar mb-3" role="toolbar">
	<div class="btn-group btn-group-sm mr-2">
		<button type="submit" class="btn btn-outline-dark">
			<i class="fa fa-floppy-o"></i>
		</button>
	</div>
	{% if pluginIsActive('ai_rewriter') %}
		<div class="btn-group btn-group-sm mr-2">
			<button type="button" class="btn btn-outline-primary" title="Сделать рерайт" onclick="aiRewriteCurrentArea();">
				<i class="fa fa-magic"></i>
			</button>
		</div>
	{% endif %}
	<!-- Undo / Redo -->
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn btn-outline-dark" title="Отменить" onclick="ngToolbarUndo({{ area }})">
			<i class="fa fa-undo"></i>
		</button>
		<button type="button" class="btn btn-outline-dark" title="Повторить" onclick="ngToolbarRedo({{ area }})">
			<i class="fa fa-repeat"></i>
		</button>
	</div>
	<!-- Параграф -->
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn btn-outline-dark" onclick="insertext('[p]','[/p]', {{ area }})">
			<i class="fa fa-paragraph"></i>
		</button>
	</div>
	<!-- Кнопка открытия модалки загрузки -->
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn btn-outline-dark" data-toggle="modal" data-target="#modal-uplimg" title="Загрузить" onclick="try{window.__editorAreaId={{ area }};}catch(e){}">
			<i class="fa fa-folder-open-o"></i>
		</button>
	</div>
	<!-- Шрифт: B/I/U/S -->
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
	<!-- Выравнивание -->
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
		<button id="paint-brush" type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			<i class="fa fa-paint-brush"></i>
		</button>
		<div class="dropdown-menu p-2" aria-labelledby="paint-brush">
			<div id="ng-color-palette" class="d-flex flex-wrap" data-area="{{ area }}" style="max-width:240px;"></div>
		</div>
	</div>
	<!-- Блоки/списки/код -->
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
	<!-- Ссылки: URL / Email / Image -->
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
	<!-- Modal: AJAX загрузка изображений/файлов -->
	<div id="modal-uplimg" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="uplimg-modal-label" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content" role="document">
				<div class="modal-header">
					<h5 id="uplimg-modal-label" class="modal-title">Загрузка</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<ul class="nav nav-tabs nav-fill" role="tablist">
						<li class="nav-item">
							<a href="#upl-img" class="nav-link active" data-toggle="tab" role="tab">Загрузка изображений</a>
						</li>
						<li class="nav-item">
							<a href="#upl-data" class="nav-link" data-toggle="tab" role="tab">Загрузка файла</a>
						</li>
					</ul>
					<div class="form-group"></div>
					<!-- Tab panes -->
					<div
						id="upl" class="tab-content">
						<!-- img -->
						<div id="upl-img" class="tab-pane fade show active" role="tabpanel">
							<ul id="newsimage-area" style="list-style: none; padding-left: 0;"></ul>
							<div class="d-flex align-items-center justify-content-between flex-wrap">
								<div class="mb-2 text-muted">
									<i>
										<b>Дополнительные настройки:</b>
									</i>
								</div>
								<div class="w-100"></div>
								<div class="form-group mb-2"><!-- Опции миниатюры и случайного имени удалены: миниатюра создаётся по умолчанию, имя формируется как имя+хеш на сервере --></div>
								<input type="file" id="uploadimage" name="newsimage" style="display:none;" onchange="uploadNewsImage({{ area }});">
								<div data-ng-dropzone="image" class="mb-2 w-100" style="border:2px dashed #cbd3da;border-radius:6px;padding:12px;text-align:center;background:#fafafa;color:#6c757d;cursor:pointer;transition:all 0.2s;" onclick="document.getElementById('uploadimage').click();" onmouseover="this.style.background='#e9ecef';this.style.borderColor='#adb5bd';" onmouseout="this.style.background='#fafafa';this.style.borderColor='#cbd3da';">
									<i class="fa fa-cloud-upload" style="font-size:24px;margin-bottom:8px;display:block;color:#007bff;"></i>
									Перетащите изображения сюда или нажмите для выбора
								</div>
							</div>
						</div>
						<!-- data -->
						<div id="upl-data" class="tab-pane fade" role="tabpanel">
							<ul id="newsfile-area" style="list-style: none; padding-left: 0;"></ul>
							<div class="d-flex align-items-center justify-content-between flex-wrap">
								<div class="w-100"></div>
								<div class="form-group mb-2"><!-- Опция случайного имени для файла удалена: имя формируется как имя+хеш на сервере --></div>
								<input type="file" id="uploadfile" name="newsfile" style="display:none;" onchange="uploadNewsFile({{ area }});">
								<div data-ng-dropzone="file" class="mb-2 w-100" style="border:2px dashed #cbd3da;border-radius:6px;padding:12px;text-align:center;background:#fafafa;color:#6c757d;cursor:pointer;transition:all 0.2s;" onclick="document.getElementById('uploadfile').click();" onmouseover="this.style.background='#e9ecef';this.style.borderColor='#adb5bd';" onmouseout="this.style.background='#fafafa';this.style.borderColor='#cbd3da';">
									<i class="fa fa-cloud-upload" style="font-size:24px;margin-bottom:8px;display:block;color:#007bff;"></i>
									Перетащите файлы сюда или нажмите для выбора
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-outline-dark" data-dismiss="modal">Закрыть</button>
				</div>
			</div>
		</div>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button onclick="try{document.forms['DATA_tmp_storage'].area.value={{ area }};} catch(err){;} window.open('{{ php_self }}?mod=files&amp;ifield='+{{ area }}, '_Addfile', 'height=600,resizable=yes,scrollbars=yes,width=760');return false;" target="DATA_Addfile" type="button" class="btn btn-outline-dark" title="{{ lang['tags.file'] }}">
			<i class="fa fa-file-text-o"></i>
		</button>
		<button onclick="try{document.forms['DATA_tmp_storage'].area.value={{ area }};} catch(err){;} window.open('{{ php_self }}?mod=images&amp;ifield='+{{ area }}, '_Addimage', 'height=600,resizable=yes,scrollbars=yes,width=760');return false;" target="DATA_Addimage" type="button" class="btn btn-outline-dark" title="{{ lang['tags.image'] }}">
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
<!-- JS логика перенесена во внешний файл /lib/news_editor.js -->
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
{% endif %}
 <script src="/lib/news_editor.js"></script>
