<!-- Preload JS/CSS for plugins -->
{{ preloadRAW }}
<!-- /end preload -->
<!-- start page title -->
	<div class="row mb-2"> <div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="admin.php">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item">
				<a href="{{ php_self }}?mod=static">{{ lang['static_title'] }}</a>
			</li>
			<li class="breadcrumb-item active">
				{% if (flags.editMode) %}
					{{ data.title }}
				{% else %}
					{{ lang['static_title_add'] }}
				{% endif %}
			</li>
		</ol>
		<h4>
			{% if (flags.editMode) %}
				{{ data.title }}
			{% else %}
				{{ lang['static_title_add'] }}
			{% endif %}
		</h4>
	</div>
</div>
<!-- end page title -->
<form name="form" id="postForm" method="post" action="{{ php_self }}?mod=static" target="_self">
	<input type="hidden" name="token" value="{{ token }}"/>
	{% if (flags.editMode) %}
		<input type="hidden" name="action" value="edit"/>
		<input type="hidden" name="id" value="{{ data.id }}"/>
	{% else %}
		<input type="hidden" name="action" value="add"/>
	{% endif %}
	<div
		class="row">
		<!-- Left edit column -->
		<div
			class="col-lg-8">
			<!-- MAIN CONTENT -->
			<div id="maincontent" class="x_panel mb-4">
				<div class="x_content">
					<div class="form-row mb-3">
						<label class="col-lg-3 col-form-label">{{ lang['title'] }}</label>
						<div class="col-lg-9">
							{% if (flags.isPublished) %}
								<div class="input-group">
									<input type="text" name="title" value="{{ data.title }}" class="form-control"/>
									<a href="{{ data.url }}" class="btn btn-outline-secondary" target="_blank">
										<i class="fa fa-link"></i>
									</a>
								</div>
							{% else %}
								<input type="text" name="title" value="{{ data.title }}" class="form-control"/>
							{% endif %}
						</div>
					</div>
					<div class="form-row mb-3">
						<label class="col-lg-3 col-form-label">{{ lang['alt_name'] }}</label>
						<div class="col-lg-9">
							<input type="text" name="alt_name" value="{{ data.alt_name }}" class="form-control"/>
						</div>
					</div>
					{% if (flags.isPublished) %}
						<div class="form-row mb-3">
							<label class="col-lg-3 col-form-label">{{ lang['url_static_page'] }}</label>
							<div class="col-lg-9">
								<input type="text" value="{{ data.url }}" class="form-control" readonly/>
							</div>
						</div>
					{% endif %}
					{% if (not flags.disableTagsSmilies) %}
						<!-- SMILES -->
						<div id="modal-smiles" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="smiles-modal-label" aria-hidden="true">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<h4 class="modal-title" id="smiles-modal-label">Вставить смайл</h4>
										<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
									</div>
									<div class="modal-body">
										{{ smilies }}
									</div>
									<div class="modal-footer">
										<button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
									</div>
								</div>
							</div>
						</div>
					{% endif %}
					<div class="mb-3 bb-editor">
						{{ quicktags }}
						<textarea id="content" name="content" class="{{ editorClassName ? editorClassName : 'form-control' }}" rows="10">{{ data.content }}</textarea>
					</div>
					{% if (flags.meta) %}
						<div class="form-row mb-3">
							<label class="col-lg-3 col-form-label">{{ lang['description'] }}</label>
							<div class="col-lg-9">
								<textarea name="description" cols="80" class="form-control">{{ data.description }}</textarea>
							</div>
						</div>
						<div class="form-row mb-3">
							<label class="col-lg-3 col-form-label">{{ lang['keywords'] }}</label>
							<div class="col-lg-9">
								<textarea name="keywords" cols="80" class="form-control">{{ data.keywords }}</textarea>
							</div>
						</div>
					{% endif %}
				</div>
			</div>
		</div>
		<!-- Right edit column -->
		<div id="rightBar" class="col col-lg-4">
			<div class="x_panel mb-4">
				<div class="x_title">{{ lang['editor.configuration'] }}</div>
				<div class="x_content">
					<div class="form-check mb-2">
						{% if (not flags.canPublish) or (not flags.canUnpublish) %}
							<input type="checkbox" class="form-check-input" id="approve" name="flag_published" value="1" {{ data.flag_published ? 'checked' : '' }} disabled>
						{% else %}
							<input type="checkbox" class="form-check-input" id="approve" name="flag_published" value="1" {{ data.flag_published ? 'checked' : '' }}>
						{% endif %}
						<label class="form-check-label" for="approve">{{ lang['approve'] }}</label>
					</div>
					<div class="form-check mb-2">
						<input type="checkbox" class="form-check-input" id="flag_html" name="flag_html" value="1" {{ data.flag_html ? 'checked' : '' }}>
						<label class="form-check-label" for="flag_html">{{ lang['flag_html'] }}</label>
					</div>
					<div class="form-check mb-2">
						<input type="checkbox" class="form-check-input" id="flag_raw" name="flag_raw" value="1" {{ data.flag_raw ? 'checked' : '' }}>
						<label class="form-check-label" for="flag_raw">{{ lang['flag_raw'] }}</label>
					</div>
				</div>
			</div>
			<div class="x_panel mb-4">
				<div class="x_title">{{ lang['editor.template'] }}</div>
				<div class="x_content">
					<select name="template" class="form-select">
						{% for t in templateList %}
							<option value="{{ t }}" {{ data.template == t ? 'selected' : '' }}>{{ t }}</option>
						{% endfor %}
					</select>
					<div class="form-check mt-2">
						<input type="checkbox" class="form-check-input" id="flag_main" name="flag_template_main" value="1" {{ data.flag_template_main ? 'checked' : '' }}/>
						<label class="form-check-label" for="flag_main">{{ lang['flag_main'] }}</label>
					</div>
				</div>
			</div>
			<div class="x_panel mb-4">
				<div class="x_title">{{ lang['postdate'] }}</div>
				<div class="x_content">
					<div class="form-check mb-2">
						<input type="checkbox" class="form-check-input" id="set_postdate" name="set_postdate" value="1">
						<label class="form-check-label" for="set_postdate">{{ lang['set_postdate'] }}</label>
					</div>
					<div class="form-group mb-0">
						<input id="cdate" type="text" name="cdate" value="{{ data.cdate }}" class="form-control" pattern="[0-9]{2}\.[0-9]{2}\.[0-9]{4} [0-9]{2}:[0-9]{2}" placeholder="{{ "now" | date('d.m.Y H:i') }}" autocomplete="off">
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col col-lg-8">
			<div class="row">
				{% if (flags.editMode) %}
					{% if (flags.canModify) %}
						<div class="col-md-6 mb-4">
							<button type="button" class="btn btn-outline-danger" onclick="confirmit('{{ php_self }}?mod=static&token={{ token }}&action=do_mass_delete&selected[]={{ data.id }}', '{{ lang['sure_del'] }}')">
								<span class="d-xl-none">
									<i class="ri-delete-bin-line"></i>
								</span>
								<span class="d-none d-xl-block">{{ lang['delete'] }}</span>
							</button>
						</div>
						<div class="col-md-6 mb-4 text-right">
							<button type="submit" class="btn btn-outline-success">
								<span class="d-xl-none">
									<i class="ri-save-3-line"></i>
								</span>
								<span class="d-none d-xl-block">{{ lang['do_editnews'] }}</span>
							</button>
						</div>
					{% endif %}
				{% else %}
					{% if (flags.canAdd) %}
						<div class="col-md-6 mb-4 text-right">
							<button type="submit" class="btn btn-outline-success">
								<span class="d-xl-none">
									<i class="ri-save-3-line"></i>
								</span>
								<span class="d-none d-xl-block">{{ lang['addstatic'] }}</span>
							</button>
						</div>
					{% endif %}
				{% endif %}
			</div>
		</div>
	</div>
</form>
<form id="DATA_tmp_storage" name="DATA_tmp_storage" action="">
	<input type="hidden" name="area" value=""/>
</form>
<script type="text/javascript">
	var currentInputAreaID = 'content';
</script>
