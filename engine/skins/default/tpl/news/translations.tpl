<!-- Translations Block -->
<div id="translations" class="card mb-4">
	<div class="card-header">
		<i class="fa fa-language mr-2"></i>
		{{ lang.addnews['translations'] }}
	</div>
	<div
		class="card-body">
		<!-- Current Language -->
		<div class="alert alert-info mb-3">
			<strong>{{ lang.addnews['current_language'] }}:</strong>
			{% if currentLang %}
				{{ currentLang.label }}
				({{ currentLang.domain }})
			{% else %}
				{{ lang.addnews['no_translation_sites'] }}
			{% endif %}
		</div>

		<!-- Existing Translations -->
		{% if translations and translations|length > 0 %}
			<h6 class="mb-3">{{ lang.addnews['available_translations'] }}:</h6>
			<div class="table-responsive">
				<table class="table table-sm table-hover">
					<thead>
						<tr>
							<th width="15%">{{ lang.addnews['translation_site'] }}</th>
							<th width="45%">{{ lang.addnews['translation_title'] }}</th>
							<th width="20%">{{ lang.addnews['translation_status'] }}</th>
							<th width="20%">{{ lang.editnews['action'] }}</th>
						</tr>
					</thead>
					<tbody>
						{% for trans in translations %}
							<tr>
								<td>
									<span class="badge badge-primary">{{ trans.lang_code|upper }}</span>
									{{ trans.site_label }}
								</td>
								<td>{{ trans.title }}</td>
								<td>
									{% if trans.approve %}
										<span class="badge badge-success">{{ lang.editnews['approved'] }}</span>
									{% else %}
										<span class="badge badge-warning">{{ lang.editnews['unapproved'] }}</span>
									{% endif %}
								</td>
								<td>
									<a href="admin.php?mod=news&action=edit&id={{ trans.id }}" class="btn btn-sm btn-primary" target="_blank">
										<i class="fa fa-edit"></i>
										{{ lang.addnews['edit_translation'] }}
									</a>
								</td>
							</tr>
						{% endfor %}
					</tbody>
				</table>
			</div>
		{% else %}
			<p class="text-muted mb-3">{{ lang.addnews['no_translation_sites'] }}</p>
		{% endif %}

		<!-- Add New Translation -->
		{% if availableLangs and availableLangs|length > 0 %}
			<hr class="my-3">
			<h6 class="mb-3">{{ lang.addnews['add_translation'] }}:</h6>
			<div class="form-row">
				<div class="col-md-6 mb-3">
					<select id="translation_target_lang" class="form-control">
						<option value="">--
							{{ lang.addnews['create_translation_for'] }}
							--</option>
						{% for langSite in availableLangs %}
							<option value="{{ langSite.site_id }}" data-lang="{{ langSite.lang }}">
								{{ langSite.label }}
								({{ langSite.domain }})
							</option>
						{% endfor %}
					</select>
				</div>
				<div class="col-md-6 mb-3">
					<button type="button" class="btn btn-success" onclick="createTranslation()">
						<i class="fa fa-plus"></i>
						{{ lang.addnews['add_translation'] }}
					</button>
				</div>
			</div>
			<small class="form-text text-muted">{{ lang.addnews['translations_desc'] }}</small>
		{% endif %}
	</div>
</div>

 <script>
function createTranslation() {
	var targetSelect = document.getElementById('translation_target_lang');
	var targetSiteId = targetSelect.value;
	var targetLang = targetSelect.options[targetSelect.selectedIndex].getAttribute('data-lang');

	if (!targetSiteId) {
		alert('Пожалуйста, выберите язык для перевода');
		return;
	}

	// Get current news data
	var newsId = {{ id|default(0) }};
	var title = document.querySelector('input[name="title"]').value;
	var translationGroupId = '{{ translationGroupId|default('') }}';

	if (!title) {
		alert('Пожалуйста, введите заголовок новости');
		return;
	}

	// If this is a new article, save it first
	if (newsId == 0) {
		alert('Пожалуйста, сначала сохраните новость, а затем добавьте переводы');
		return;
	}

	// Open new window to create translation
	var url = 'admin.php?mod=news&action=add&translation_source=' + newsId + '&translation_lang=' + targetLang + '&translation_site=' + targetSiteId;
	window.open(url, '_blank');
}
</script>
