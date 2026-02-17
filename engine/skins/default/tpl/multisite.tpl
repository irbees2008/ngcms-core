<div class="container-fluid">
	<div class="row mb-2">
		<div class="col-sm-6 d-none d-md-block ">
			<h1 class="m-0 text-dark">{{ lang.multisite_management }}</h1>
		</div>
		<div class="col-12 col-sm-12 col-md-6 ">
			<ol class="breadcrumb float-sm-right">
				<li class="breadcrumb-item">
					<a href="admin.php">
						<i class="fa fa-home"></i>
					</a>
				</li>
				<li class="breadcrumb-item">
					<a href="admin.php?mod=configuration">{{ lang.configuration_title }}</a>
				</li>
				<li class="breadcrumb-item active" aria-current="page">{{ lang.multisite_management }}</li>
			</ol>
		</div>
	</div>
</div>

<!-- Add New Site Form -->
<div class="card mb-4">
	<div class="card-header">
		<h5 class="mb-0">{{ lang.multisite_add_new }}</h5>
	</div>
	<div class="card-body">
		<form action="admin.php?mod=configuration&action=multisite_add" method="POST">
			<input type="hidden" name="token" value="{{ token }}"/>

			<div class="form-group row">
				<label class="col-sm-3 col-form-label">{{ lang.multisite_site_id }}</label>
				<div class="col-sm-9">
					<input type="text" name="site_id" id="site_id" class="form-control" required pattern="[a-zA-Z0-9_]+" placeholder="blog"/>
					<small class="form-text text-muted">{{ lang.multisite_site_id_desc }}</small>
				</div>
			</div>

			<div class="form-group row">
				<label class="col-sm-3 col-form-label">{{ lang.multisite_db_prefix }}</label>
				<div class="col-sm-9">
					<input type="text" name="db_prefix" id="db_prefix" class="form-control" required pattern="[a-zA-Z0-9_]+" placeholder="blog"/>
					<small class="form-text text-muted">{{ lang.multisite_db_prefix_desc }}</small>
				</div>
			</div>

			<div class="form-group row">
				<label class="col-sm-3 col-form-label">{{ lang.multisite_domains }}</label>
				<div class="col-sm-9">
					<textarea name="domains" class="form-control" rows="3" required placeholder="blog.example.com&#10;myblog.local"></textarea>
					<small class="form-text text-muted">{{ lang.multisite_domains_desc }}</small>
				</div>
			</div>

			<div class="form-group row">
				<label class="col-sm-3 col-form-label">{{ lang.multisite_active }}</label>
				<div class="col-sm-9">
					<select name="active" class="form-control">
						<option value="1">{{ lang.yesa }}</option>
						<option value="0">{{ lang.noa }}</option>
					</select>
				</div>
			</div>

			<div class="form-group row">
				<div class="col-sm-9 offset-sm-3">
					<button type="submit" class="btn btn-primary">{{ lang.multisite_add_button }}</button>
				</div>
			</div>
		</form>
	</div>
</div>

<!-- Sites List -->
<div class="card">
	<div class="card-header">
		<h5 class="mb-0">{{ lang.multisite_existing_sites }}</h5>
	</div>
	<div class="card-body">
		<table class="table table-hover">
			<thead>
				<tr>
					<th width="10%">{{ lang.status }}</th>
					<th width="20%">{{ lang.multisite_site_id }}</th>
					<th width="40%">{{ lang.domains }}</th>
					<th width="10%">{{ lang.multisite_master }}</th>
					<th width="20%">{{ lang.actions }}</th>
				</tr>
			</thead>
			<tbody>
				{% if multiConfig %}
					{% for site in multiConfig %}
						<tr>
							<td>
								{% if site.active %}
									<span class="badge badge-success">{{ lang.ona }}</span>
								{% else %}
									<span class="badge badge-secondary">{{ lang.offa }}</span>
								{% endif %}
							</td>
							<td>
								<strong>{{ site.key }}</strong>
							</td>
							<td>
								{% for domain in site.domains %}
									<div>
										<code>{{ domain }}</code>
									</div>
								{% endfor %}
							</td>
							<td>
								{% if site.is_master %}
									<span class="badge badge-info">{{ lang.yesa }}</span>
								{% else %}
									-
								{% endif %}
							</td>
							<td>
								<div class="btn-group btn-group-sm">
									<a href="admin.php?mod=configuration&action=multisite_toggle&site_id={{ site.key }}&token={{ token }}" class="btn btn-secondary" title="{{ lang.multisite_toggle }}">
										<i class="fa fa-power-off"></i>
									</a>

									<a href="admin.php?mod=configuration&site_id={{ site.key }}" class="btn btn-primary" title="{{ lang.multisite_edit_config }}">
										<i class="fa fa-cog"></i>
									</a>

									{% if not site.is_master %}
										<a href="admin.php?mod=configuration&action=multisite_delete&site_id={{ site.key }}&token={{ token }}" class="btn btn-danger" onclick="return confirm('{{ lang.multisite_delete_confirm }}');" title="{{ lang.delete }}">
											<i class="fa fa-trash"></i>
										</a>
									{% endif %}
								</div>
							</td>
						</tr>
					{% endfor %}
				{% else %}
					<tr>
						<td colspan="5" class="text-center">{{ lang.multisite_no_sites }}</td>
					</tr>
				{% endif %}
			</tbody>
		</table>
	</div>
</div>

 <script>
// Auto-fill db_prefix based on site_id
document.addEventListener('DOMContentLoaded', function() {
	const siteIdInput = document.getElementById('site_id');
	const dbPrefixInput = document.getElementById('db_prefix');

	if (siteIdInput && dbPrefixInput) {
		siteIdInput.addEventListener('input', function() {
			// Only auto-fill if prefix is empty or matches previous site_id
			const siteId = this.value.toLowerCase().replace(/[^a-z0-9_]/g, '_');
			dbPrefixInput.value = siteId;
		});
	}
});
</script>

<div class="mt-3">
	<a href="admin.php?mod=configuration" class="btn btn-secondary">{{ lang.back }}</a>
