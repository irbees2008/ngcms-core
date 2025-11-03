<span id="save_area" style="display: block;"></span>
<div
	id="tags" class="bb-pane" role="toolbar">
	<!-- Undo / Redo -->
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn" title="Отменить" onclick="ngToolbarUndo({{ area }})">
			<i class="fa fa-undo"></i>
		</button>
		<button type="button" class="btn" title="Повторить" onclick="ngToolbarRedo({{ area }})">
			<i class="fa fa-repeat"></i>
		</button>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn" onclick="insertext('[b]','[/b]', {{ area }})" title="{{ lang['tags.bold'] }}">
			<i class="fa fa-bold"></i>
		</button>
		<button type="button" class="btn" onclick="insertext('[i]','[/i]', {{ area }})" title="{{ lang['tags.italic'] }}">
			<i class="fa fa-italic"></i>
		</button>
		<button type="button" class="btn" onclick="insertext('[u]','[/u]', {{ area }})" title="{{ lang['tags.underline'] }}">
			<i class="fa fa-underline"></i>
		</button>
		<button type="button" class="btn" onclick="insertext('[s]','[/s]', {{ area }})" title="{{ lang['tags.crossline'] }}">
			<i class="fa fa-strikethrough"></i>
		</button>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn" title="{{ lang['tags.image'] }}" data-bs-toggle="modal" data-bs-target="#modal-insert-image" onclick="prepareImgModal({{ area }})">
			<i class="fa fa-picture-o"></i>
		</button>
		<button type="button" class="btn" title="{{ lang['tags.link'] }}" data-bs-toggle="modal" data-bs-target="#modal-insert-url" onclick="prepareUrlModal({{ area }})">
			<i class="fa fa-link"></i>
		</button>
		<button type="button" class="btn" title="{{ lang['tags.email'] }}" data-bs-toggle="modal" data-bs-target="#modal-insert-email" onclick="prepareEmailModal({{ area }})">
			<i class="fa fa-envelope"></i>
		</button>
		{% if pluginIsActive('bb_media') %}
			<button type="button" class="btn" title="[media]" data-bs-toggle="modal" data-bs-target="#modal-insert-media" onclick="prepareMediaModal({{ area }})">
				<i class="fa fa-play"></i>
			</button>
		{% else %}
			<button type="button" class="btn" title="[media]" onclick="try{ if(window.show_info){show_info('{{ lang['media.enable'] }}');} else { alert('{{ lang['media.enable'] }}'); } }catch(e){ alert('{{ lang['media.enable'] }}'); } return false;">
				<i class="fa fa-play"></i>
			</button>
		{% endif %}
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn" title="Вставка смайликов" data-bs-toggle="modal" data-bs-target="#modal-smiles">
			<i class="fa fa-smile-o"></i>
		</button>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button onclick="try{document.forms['DATA_tmp_storage'].area.value={{ area }};} catch(err){;} window.open('{{ php_self }}?mod=files&amp;ifield='+{{ area }}, '_Addfile', 'height=600,resizable=yes,scrollbars=yes,width=800');return false;" target="DATA_Addfile" type="button" class="btn" title="{{ lang['tags.file'] }}">
			<i class="fa fa-folder"></i>
		</button>
		<button onclick="try{document.forms['DATA_tmp_storage'].area.value={{ area }};} catch(err){;} window.open('{{ php_self }}?mod=images&amp;ifield='+{{ area }}, '_Addimage', 'height=600,resizable=yes,scrollbars=yes,width=800');return false;" target="DATA_Addimage" type="button" class="btn" title="{{ lang['tags.image'] }}">
			<i class="fa fa-file-image-o"></i>
		</button>
		<!-- Открыть модалку быстрой загрузки -->
		<button type="button" class="btn" title="Загрузить" data-bs-toggle="modal" data-bs-target="#modal-uplimg" onclick="try{window.__editorAreaId={{ area }};}catch(e){}">
			<i class="fa fa-folder-open-o"></i>
		</button>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn" onclick="insertext('[hide]','[/hide]', {{ area }})" title="{{ lang['tags.code'] }}">
			<i class="fa fa-eye-slash"></i>
		</button>
		<button type="button" class="btn" onclick="insertext('[quote]','[/quote]', {{ area }})" title="{{ lang['tags.comment'] }}">
			<i class="fa fa-quote-right"></i>
		</button>
		<button type="button" class="btn" onclick="insertext('[code]','[/code]', {{ area }})" title="{{ lang.theme.b_code }}">
			<i class="fa fa-code"></i>
		</button>
		<!-- Dropdown: вставка [code=язык]...[/code] -->
		{% if callPlugin('code_highlight.hasAnyEnabled', {}) %}
			<div class="btn-group btn-group-sm">
				<button type="button" class="btn dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" title="Код с подсветкой (выбрать язык)">
					<i class="fa fa-angle-down"></i>
				</button>
				<ul class="dropdown-menu dropdown-menu-end">
					<li class="dropdown-header">Язык подсветки</li>
					{% if callPlugin('code_highlight.brushEnabled', {'name':'php'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('php', {{ area }}); return false;">PHP</a>
						</li>
					{% endif %}
					{% if callPlugin('code_highlight.brushEnabled', {'name':'js'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('js', {{ area }}); return false;">JavaScript</a>
						</li>
					{% endif %}
					{% if callPlugin('code_highlight.brushEnabled', {'name':'sql'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('sql', {{ area }}); return false;">SQL</a>
						</li>
					{% endif %}
					{% if callPlugin('code_highlight.brushEnabled', {'name':'xml'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('xml', {{ area }}); return false;">HTML/XML</a>
						</li>
					{% endif %}
					{% if callPlugin('code_highlight.brushEnabled', {'name':'css'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('css', {{ area }}); return false;">CSS</a>
						</li>
					{% endif %}
					<li><hr class="dropdown-divider"></li>
					{% if callPlugin('code_highlight.brushEnabled', {'name':'bash'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('bash', {{ area }}); return false;">Bash/Shell</a>
						</li>
					{% endif %}
					{% if callPlugin('code_highlight.brushEnabled', {'name':'python'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('python', {{ area }}); return false;">Python</a>
						</li>
					{% endif %}
					{% if callPlugin('code_highlight.brushEnabled', {'name':'java'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('java', {{ area }}); return false;">Java</a>
						</li>
					{% endif %}
					{% if callPlugin('code_highlight.brushEnabled', {'name':'csharp'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('csharp', {{ area }}); return false;">C#</a>
						</li>
					{% endif %}
					{% if callPlugin('code_highlight.brushEnabled', {'name':'cpp'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('cpp', {{ area }}); return false;">C/C++</a>
						</li>
					{% endif %}
					{% if callPlugin('code_highlight.brushEnabled', {'name':'delphi'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('delphi', {{ area }}); return false;">Delphi/Pascal</a>
						</li>
					{% endif %}
					{% if callPlugin('code_highlight.brushEnabled', {'name':'diff'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('diff', {{ area }}); return false;">Diff/Patch</a>
						</li>
					{% endif %}
					{% if callPlugin('code_highlight.brushEnabled', {'name':'ruby'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('ruby', {{ area }}); return false;">Ruby</a>
						</li>
					{% endif %}
					{% if callPlugin('code_highlight.brushEnabled', {'name':'perl'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('perl', {{ area }}); return false;">Perl</a>
						</li>
					{% endif %}
					{% if callPlugin('code_highlight.brushEnabled', {'name':'vb'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('vb', {{ area }}); return false;">VB/VB.Net</a>
						</li>
					{% endif %}
					{% if callPlugin('code_highlight.brushEnabled', {'name':'powershell'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('powershell', {{ area }}); return false;">PowerShell</a>
						</li>
					{% endif %}
					{% if callPlugin('code_highlight.brushEnabled', {'name':'scala'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('scala', {{ area }}); return false;">Scala</a>
						</li>
					{% endif %}
					{% if callPlugin('code_highlight.brushEnabled', {'name':'groovy'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('groovy', {{ area }}); return false;">Groovy</a>
						</li>
					{% endif %}
					<li><hr class="dropdown-divider"></li>
					{% if callPlugin('code_highlight.brushEnabled', {'name':'plain'}) %}
						<li>
							<a class="dropdown-item" href="#" onclick="insertCodeBrush('plain', {{ area }}); return false;">Plain (без языка)</a>
						</li>
					{% endif %}
					<li>
						<a class="dropdown-item" href="#" onclick="insertext('[code]','[/code]', {{ area }}); return false;">Без параметра [code]</a>
					</li>
					<li>
						<a class="dropdown-item" href="#" onclick="insertext('[strong]','[/strong]', {{ area }}); return false;">экранирование в строке</a>
					</li>
				</ul>
			</div>
		{% endif %}
	</div>
	<div class="clr"></div>
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn" onclick="insertext('[acronym=]','[/acronym]', {{ area }})" title="{{ lang['tags.acronym'] }}">
			<i class="fa fa-font"></i>
		</button>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn" onclick="insertext('[left]','[/left]', {{ area }})" title="{{ lang['tags.left'] }}">
			<i class="fa fa-align-left"></i>
		</button>
		<button type="button" class="btn" onclick="insertext('[center]','[/center]', {{ area }})" title="{{ lang['tags.center'] }}">
			<i class="fa fa-align-center"></i>
		</button>
		<button type="button" class="btn" onclick="insertext('[right]','[/right]', {{ area }})" title="{{ lang['tags.right'] }}">
			<i class="fa fa-align-right"></i>
		</button>
		<button type="button" class="btn" onclick="insertext('[justify]','[/justify]', {{ area }})" title="{{ lang['tags.justify'] }}">
			<i class="fa fa-align-justify"></i>
		</button>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn dropdown-toggle" title="{{ lang.theme.b_color }}" data-bs-toggle="dropdown" aria-expanded="false">
			<i class="fa fa-paint-brush"></i>
		</button>
		<ul class="dropdown-menu">
			<li>
				<div class="color-palette">
					<div>
						<button type="button" onclick="insertext('[color=#000000]','[/color]', {{ area }})" class="color-btn" style="background-color:#000000;" data-value="#000000"></button>
						<button type="button" onclick="insertext('[color=#424242]','[/color]', {{ area }})" class="color-btn" style="background-color:#424242;" data-value="#424242"></button>
						<button type="button" onclick="insertext('[color=#636363]','[/color]', {{ area }})" class="color-btn" style="background-color:#636363;" data-value="#636363"></button>
						<button type="button" onclick="insertext('[color=#9C9C94]','[/color]', {{ area }})" class="color-btn" style="background-color:#9C9C94;" data-value="#9C9C94"></button>
						<button type="button" onclick="insertext('[color=#CEC6CE]','[/color]', {{ area }})" class="color-btn" style="background-color:#CEC6CE;" data-value="#CEC6CE"></button>
						<button type="button" onclick="insertext('[color=#EFEFEF]','[/color]', {{ area }})" class="color-btn" style="background-color:#EFEFEF;" data-value="#EFEFEF"></button>
						<button type="button" onclick="insertext('[color=#F7F7F7]','[/color]', {{ area }})" class="color-btn" style="background-color:#F7F7F7;" data-value="#F7F7F7"></button>
						<button type="button" onclick="insertext('[color=#FFFFFF]','[/color]', {{ area }})" class="color-btn" style="background-color:#FFFFFF;" data-value="#FFFFFF"></button>
					</div>
					<div>
						<button type="button" onclick="insertext('[color=#FF0000]','[/color]', {{ area }})" class="color-btn" style="background-color:#FF0000;" data-value="#FF0000"></button>
						<button type="button" onclick="insertext('[color=#FF9C00]','[/color]', {{ area }})" class="color-btn" style="background-color:#FF9C00;" data-value="#FF9C00"></button>
						<button type="button" onclick="insertext('[color=#FFFF00]','[/color]', {{ area }})" class="color-btn" style="background-color:#FFFF00;" data-value="#FFFF00"></button>
						<button type="button" onclick="insertext('[color=#00FF00]','[/color]', {{ area }})" class="color-btn" style="background-color:#00FF00;" data-value="#00FF00"></button>
						<button type="button" onclick="insertext('[color=#00FFFF]','[/color]', {{ area }})" class="color-btn" style="background-color:#00FFFF;" data-value="#00FFFF"></button>
						<button type="button" onclick="insertext('[color=#0000FF]','[/color]', {{ area }})" class="color-btn" style="background-color:#0000FF;" data-value="#0000FF"></button>
						<button type="button" onclick="insertext('[color=#9C00FF]','[/color]', {{ area }})" class="color-btn" style="background-color:#9C00FF;" data-value="#9C00FF"></button>
						<button type="button" onclick="insertext('[color=#FF00FF]','[/color]', {{ area }})" class="color-btn" style="background-color:#FF00FF;" data-value="#FF00FF"></button>
					</div>
					<div>
						<button type="button" onclick="insertext('[color=#F7C6CE]','[/color]', {{ area }})" class="color-btn" style="background-color:#F7C6CE;" data-value="#F7C6CE"></button>
						<button type="button" onclick="insertext('[color=#FFE7CE]','[/color]', {{ area }})" class="color-btn" style="background-color:#FFE7CE;" data-value="#FFE7CE"></button>
						<button type="button" onclick="insertext('[color=#FFEFC6]','[/color]', {{ area }})" class="color-btn" style="background-color:#FFEFC6;" data-value="#FFEFC6"></button>
						<button type="button" onclick="insertext('[color=#D6EFD6]','[/color]', {{ area }})" class="color-btn" style="background-color:#D6EFD6;" data-value="#D6EFD6"></button>
						<button type="button" onclick="insertext('[color=#CEDEE7]','[/color]', {{ area }})" class="color-btn" style="background-color:#CEDEE7;" data-value="#CEDEE7"></button>
						<button type="button" onclick="insertext('[color=#CEE7F7]','[/color]', {{ area }})" class="color-btn" style="background-color:#CEE7F7;" data-value="#CEE7F7"></button>
						<button type="button" onclick="insertext('[color=#D6D6E7]','[/color]', {{ area }})" class="color-btn" style="background-color:#D6D6E7;" data-value="#D6D6E7"></button>
						<button type="button" onclick="insertext('[color=#E7D6DE]','[/color]', {{ area }})" class="color-btn" style="background-color:#E7D6DE;" data-value="#E7D6DE"></button>
					</div>
					<div>
						<button type="button" onclick="insertext('[color=#E79C9C]','[/color]', {{ area }})" class="color-btn" style="background-color:#E79C9C;" data-value="#E79C9C"></button>
						<button type="button" onclick="insertext('[color=#FFC69C]','[/color]', {{ area }})" class="color-btn" style="background-color:#FFC69C;" data-value="#FFC69C"></button>
						<button type="button" onclick="insertext('[color=#FFE79C]','[/color]', {{ area }})" class="color-btn" style="background-color:#FFE79C;" data-value="#FFE79C"></button>
						<button type="button" onclick="insertext('[color=#B5D6A5]','[/color]', {{ area }})" class="color-btn" style="background-color:#B5D6A5;" data-value="#B5D6A5"></button>
						<button type="button" onclick="insertext('[color=#A5C6CE]','[/color]', {{ area }})" class="color-btn" style="background-color:#A5C6CE;" data-value="#A5C6CE"></button>
						<button type="button" onclick="insertext('[color=#9CC6EF]','[/color]', {{ area }})" class="color-btn" style="background-color:#9CC6EF;" data-value="#9CC6EF"></button>
						<button type="button" onclick="insertext('[color=#B5A5D6]','[/color]', {{ area }})" class="color-btn" style="background-color:#B5A5D6;" data-value="#B5A5D6"></button>
						<button type="button" onclick="insertext('[color=#D6A5BD]','[/color]', {{ area }})" class="color-btn" style="background-color:#D6A5BD;" data-value="#D6A5BD"></button>
					</div>
					<div>
						<button type="button" onclick="insertext('[color=#E76363]','[/color]', {{ area }})" class="color-btn" style="background-color:#E76363;" data-value="#E76363"></button>
						<button type="button" onclick="insertext('[color=#F7AD6B]','[/color]', {{ area }})" class="color-btn" style="background-color:#F7AD6B;" data-value="#F7AD6B"></button>
						<button type="button" onclick="insertext('[color=#FFD663]','[/color]', {{ area }})" class="color-btn" style="background-color:#FFD663;" data-value="#FFD663"></button>
						<button type="button" onclick="insertext('[color=#94BD7B]','[/color]', {{ area }})" class="color-btn" style="background-color:#94BD7B;" data-value="#94BD7B"></button>
						<button type="button" onclick="insertext('[color=#73A5AD]','[/color]', {{ area }})" class="color-btn" style="background-color:#73A5AD;" data-value="#73A5AD"></button>
						<button type="button" onclick="insertext('[color=#6BADDE]','[/color]', {{ area }})" class="color-btn" style="background-color:#6BADDE;" data-value="#6BADDE"></button>
						<button type="button" onclick="insertext('[color=#8C7BC6]','[/color]', {{ area }})" class="color-btn" style="background-color:#8C7BC6;" data-value="#8C7BC6"></button>
						<button type="button" onclick="insertext('[color=#C67BA5]','[/color]', {{ area }})" class="color-btn" style="background-color:#C67BA5;" data-value="#C67BA5"></button>
					</div>
					<div>
						<button type="button" onclick="insertext('[color=#CE0000]','[/color]', {{ area }})" class="color-btn" style="background-color:#CE0000;" data-value="#CE0000"></button>
						<button type="button" onclick="insertext('[color=#E79439]','[/color]', {{ area }})" class="color-btn" style="background-color:#E79439;" data-value="#E79439"></button>
						<button type="button" onclick="insertext('[color=#EFC631]','[/color]', {{ area }})" class="color-btn" style="background-color:#EFC631;" data-value="#EFC631"></button>
						<button type="button" onclick="insertext('[color=#6BA54A]','[/color]', {{ area }})" class="color-btn" style="background-color:#6BA54A;" data-value="#6BA54A"></button>
						<button type="button" onclick="insertext('[color=#4A7B8C]','[/color]', {{ area }})" class="color-btn" style="background-color:#4A7B8C;" data-value="#4A7B8C"></button>
						<button type="button" onclick="insertext('[color=#3984C6]','[/color]', {{ area }})" class="color-btn" style="background-color:#3984C6;" data-value="#3984C6"></button>
						<button type="button" onclick="insertext('[color=#634AA5]','[/color]', {{ area }})" class="color-btn" style="background-color:#634AA5;" data-value="#634AA5"></button>
						<button type="button" onclick="insertext('[color=#A54A7B]','[/color]', {{ area }})" class="color-btn" style="background-color:#A54A7B;" data-value="#A54A7B"></button>
					</div>
					<div>
						<button type="button" onclick="insertext('[color=#9C0000]','[/color]', {{ area }})" class="color-btn" style="background-color:#9C0000;" data-value="#9C0000"></button>
						<button type="button" onclick="insertext('[color=#B56308]','[/color]', {{ area }})" class="color-btn" style="background-color:#B56308;" data-value="#B56308"></button>
						<button type="button" onclick="insertext('[color=#BD9400]','[/color]', {{ area }})" class="color-btn" style="background-color:#BD9400;" data-value="#BD9400"></button>
						<button type="button" onclick="insertext('[color=#397B21]','[/color]', {{ area }})" class="color-btn" style="background-color:#397B21;" data-value="#397B21"></button>
						<button type="button" onclick="insertext('[color=#104A5A]','[/color]', {{ area }})" class="color-btn" style="background-color:#104A5A;" data-value="#104A5A"></button>
						<button type="button" onclick="insertext('[color=#085294]','[/color]', {{ area }})" class="color-btn" style="background-color:#085294;" data-value="#085294"></button>
						<button type="button" onclick="insertext('[color=#311873]','[/color]', {{ area }})" class="color-btn" style="background-color:#311873;" data-value="#311873"></button>
						<button type="button" onclick="insertext('[color=#731842]','[/color]', {{ area }})" class="color-btn" style="background-color:#731842;" data-value="#731842"></button>
					</div>
					<div>
						<button type="button" onclick="insertext('[color=#630000]','[/color]', {{ area }})" class="color-btn" style="background-color:#630000;" data-value="#630000"></button>
						<button type="button" onclick="insertext('[color=#7B3900]','[/color]', {{ area }})" class="color-btn" style="background-color:#7B3900;" data-value="#7B3900"></button>
						<button type="button" onclick="insertext('[color=#846300]','[/color]', {{ area }})" class="color-btn" style="background-color:#846300;" data-value="#846300"></button>
						<button type="button" onclick="insertext('[color=#295218]','[/color]', {{ area }})" class="color-btn" style="background-color:#295218;" data-value="#295218"></button>
						<button type="button" onclick="insertext('[color=#083139]','[/color]', {{ area }})" class="color-btn" style="background-color:#083139;" data-value="#083139"></button>
						<button type="button" onclick="insertext('[color=#003163]','[/color]', {{ area }})" class="color-btn" style="background-color:#003163;" data-value="#003163"></button>
						<button type="button" onclick="insertext('[color=#21104A]','[/color]', {{ area }})" class="color-btn" style="background-color:#21104A;" data-value="#21104A"></button>
						<button type="button" onclick="insertext('[color=#4A1031]','[/color]', {{ area }})" class="color-btn" style="background-color:#4A1031;" data-value="#4A1031"></button>
					</div>
				</div>
			</li>
		</ul>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn" onclick="insertext('[spoiler]','[/spoiler]', {{ area }})" title="{{ lang['tags.spoiler'] }}">
			<i class="fa fa-text-height"></i>
		</button>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn" onclick="insertext('[ul]\n[li][/li]\n[li][/li]\n[li][/li]\n[/ul]','', {{ area }})" title="{{ lang['tags.bulllist'] }}">
			<i class="fa fa-list-ul"></i>
		</button>
		<button type="button" class="btn" onclick="insertext('[ol]\n[li][/li]\n[li][/li]\n[li][/li]\n[/ol]','', {{ area }})" title="{{ lang['tags.numlist'] }}">
			<i class="fa fa-list-ol"></i>
		</button>
	</div>
	<div class="btn-group btn-group-sm mr-2">
		<button type="button" class="btn" onclick="insertext('<!--more-->','', {{ area }})" title="{{ lang['tags.more'] }}">
			<i class="fa fa-files-o"></i>
		</button>
		<button type="button" class="btn" onclick="insertext('<!--nextpage-->','', {{ area }})" title="{{ lang['tags.nextpage'] }}">
			<i class="fa fa-file-o"></i>
		</button>
	</div>
</div>
<!-- Modals: URL / Email / Image -->
<div id="modal-insert-url" class="modal fade" tabindex="-1" aria-labelledby="url-modal-label" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="url-modal-label" class="modal-title">Вставить ссылку</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<input type="hidden" id="urlAreaId" value=""/>
				<div class="mb-3">
					<label for="urlHref" class="form-label">Адрес (URL)</label>
					<input type="text" class="form-control" id="urlHref" placeholder="https://example.com"/>
				</div>
				<div class="mb-3">
					<label for="urlText" class="form-label">Текст ссылки</label>
					<input type="text" class="form-control" id="urlText" placeholder="Текст для отображения"/>
				</div>
				<div class="row">
					<div class="col-md-6 mb-3">
						<label for="urlTarget" class="form-label">Открывать</label>
						<select id="urlTarget" class="form-select">
							<option value="">В этой же вкладке</option>
							<option value="_blank">В новой вкладке</option>
						</select>
					</div>
					<div class="col-md-6 mb-3">
						<div class="form-check mt-4">
							<input class="form-check-input" type="checkbox" id="urlNofollow">
							<label class="form-check-label" for="urlNofollow">Не индексировать (rel="nofollow")</label>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
				<button type="button" class="btn btn-primary" onclick="insertUrlFromModal()">Вставить</button>
			</div>
		</div>
	</div>
</div>
<!-- Modal: AJAX загрузка изображений/файлов (Bootstrap 5) -->
<div id="modal-uplimg" class="modal fade" tabindex="-1" aria-labelledby="uplimg-modal-label" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="uplimg-modal-label" class="modal-title">Загрузка</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<ul class="nav nav-tabs nav-fill" role="tablist">
					<li class="nav-item">
						<a href="#upl-img" class="nav-link active" data-bs-toggle="tab" role="tab">Загрузка изображений</a>
					</li>
					<li class="nav-item">
						<a href="#upl-data" class="nav-link" data-bs-toggle="tab" role="tab">Загрузка файла</a>
					</li>
				</ul>
				<div class="form-group"></div>
				<div id="upl" class="tab-content">
					<div id="upl-img" class="tab-pane fade show active" role="tabpanel">
						<ul id="newsimage-area" style="list-style: none; padding-left: 0;"></ul>
						<div class="d-flex align-items-center justify-content-between flex-wrap">
							<div data-ng-dropzone="image" class="mb-3 w-100" style="border:2px dashed #cbd3da;border-radius:6px;padding:12px;text-align:center;background:#fafafa;color:#6c757d;">
								Перетащите изображения сюда для загрузки
							</div>
							<div class="w-100"></div>
							<div class="form-group mb-3  d-flex align-items-center">
								<input type="file" id="uploadimage" name="newsimage" class="form-control">
								<a class="btn btn-primary ms-2" title="Загрузить" onclick="return uploadNewsImage({{ area }});">
									<i class="fa fa-download"></i>
								</a>
							</div>
						</div>
					</div>
					<div id="upl-data" class="tab-pane fade" role="tabpanel">
						<ul id="newsfile-area" style="list-style: none; padding-left: 0;"></ul>
						<div class="d-flex align-items-center justify-content-between flex-wrap">
							<div data-ng-dropzone="file" class="mb-3 w-100" style="border:2px dashed #cbd3da;border-radius:6px;padding:12px;text-align:center;background:#fafafa;color:#6c757d;">
								Перетащите файлы сюда для загрузки
							</div>
							<div class="w-100"></div>
							<div class="form-group mb-2 d-flex align-items-center">
								<input type="file" id="uploadfile" name="newsfile" class="form-control">
								<a class="btn btn-primary ms-2" title="Загрузить" onclick="return uploadNewsFile({{ area }});">
									<i class="fa fa-download"></i>
								</a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-outline-dark" data-bs-dismiss="modal">Закрыть</button>
			</div>
		</div>
	</div>
</div>
<div id="modal-insert-email" class="modal fade" tabindex="-1" aria-labelledby="email-modal-label" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="email-modal-label" class="modal-title">Вставить e-mail</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<input type="hidden" id="emailAreaId" value=""/>
				<div class="mb-3">
					<label for="emailAddress" class="form-label">Адрес e-mail</label>
					<input type="text" class="form-control" id="emailAddress" placeholder="user@example.com"/>
				</div>
				<div class="mb-3">
					<label for="emailText" class="form-label">Текст ссылки</label>
					<input type="text" class="form-control" id="emailText" placeholder="Например: Написать нам"/>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
				<button type="button" class="btn btn-primary" onclick="insertEmailFromModal()">Вставить</button>
			</div>
		</div>
	</div>
</div>
<div id="modal-insert-image" class="modal fade" tabindex="-1" aria-labelledby="image-modal-label" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="image-modal-label" class="modal-title">Вставить изображение</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<input type="hidden" id="imgAreaId" value=""/>
				<div class="mb-3">
					<label for="imgHref" class="form-label">Адрес изображения (URL)</label>
					<input type="text" class="form-control" id="imgHref" placeholder="https://example.com/image.jpg"/>
				</div>
				<div class="mb-3">
					<label for="imgAlt" class="form-label">Альтернативный текст (alt)</label>
					<input type="text" class="form-control" id="imgAlt" placeholder="Краткое описание изображения"/>
				</div>
				<div class="row">
					<div class="col-md-4 mb-3">
						<label for="imgWidth" class="form-label">Ширина</label>
						<input type="number" min="0" class="form-control" id="imgWidth" placeholder="Напр. 600"/>
					</div>
					<div class="col-md-4 mb-3">
						<label for="imgHeight" class="form-label">Высота</label>
						<input type="number" min="0" class="form-control" id="imgHeight" placeholder="Напр. 400"/>
					</div>
					<div class="col-md-4 mb-3">
						<label for="imgAlign" class="form-label">Выравнивание</label>
						<select id="imgAlign" class="form-select">
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
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
				<button type="button" class="btn btn-primary" onclick="insertImgFromModal()">Вставить</button>
			</div>
		</div>
	</div>
</div>
{% if pluginIsActive('bb_media') %}
	<!-- Modal: Insert Media -->
	<div id="modal-insert-media" class="modal fade" tabindex="-1" aria-labelledby="media-modal-label" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 id="media-modal-label" class="modal-title">{{ lang['tags.media'] }}</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<input type="hidden" id="mediaAreaId" value=""/>
					<div class="mb-3">
						<label for="mediaHref" class="form-label">{{ lang['media.url'] }}</label>
						<input type="text" class="form-control" id="mediaHref" placeholder="https://example.com/embed.mp4"/>
					</div>
					<div class="row">
						<div class="col-md-4 mb-3">
							<label for="mediaWidth" class="form-label">{{ lang['media.width'] }}</label>
							<input type="number" min="0" class="form-control" id="mediaWidth" placeholder="напр. 640"/>
						</div>
						<div class="col-md-4 mb-3">
							<label for="mediaHeight" class="form-label">{{ lang['media.height'] }}</label>
							<input type="number" min="0" class="form-control" id="mediaHeight" placeholder="напр. 360"/>
						</div>
						<div class="col-md-4 mb-3">
							<label for="mediaPreview" class="form-label">{{ lang['media.preview'] }}</label>
							<input type="text" class="form-control" id="mediaPreview" placeholder="https://example.com/preview.jpg"/>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">{{ lang['btn_cancel'] }}</button>
					<button type="button" class="btn btn-primary" onclick="insertMediaFromModal()">{{ lang['btn_insert'] }}</button>
				</div>
			</div>
		</div>
	</div>
{% endif %}
<!-- Вся логика модалок и вставок реализована в общем файле: -->
<script src="/lib/news_editor.js"></script>
