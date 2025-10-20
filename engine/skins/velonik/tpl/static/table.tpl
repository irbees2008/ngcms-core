<!-- start page title -->
<div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="admin.php">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item active">{{ lang['static_title'] }}</li>
		</ol>
		<h4>{{ lang['static_title'] }}</h4>
	</div>
</div>
<!-- end page title -->
<!-- Filter form: BEGIN -->
<div id="collapseStaticFilter" class="collapse">
	<div class="x_panel mb-4">
		<div class="x_content">
			<form action="{{ php_self }}" method="get" name="options_bar" class="form-inline">
				<input type="hidden" name="mod" value="static"/>
				<label class="my-1 mr-2">{{ lang['per_page'] }}</label>
				<div class="input-group">
					<input type="number" name="per_page" value="{{ per_page }}" size="3" class="form-control my-1 mr-sm-2"/>
					<button type="submit" class="btn btn-outline-primary my-1">{{ lang['do_show'] }}</button>
				</div>
			</form>
		</div>
	</div>
</div>
<!-- Mass actions form: BEGIN -->
<form action="{{ php_self }}?mod=static" method="post" name="static">
	<input type="hidden" name="token" value="{{ token }}"/>
	<div class="x_panel">
		<div class="x_title">
			<div class="row">
				<div class="col text-right">
					{% if (perm.modify) %}
						<button type="button" class="btn btn-outline-success" onclick="document.location='?mod=static&action=addForm'; return false;">{{ lang['addstatic'] }}</button>
					{% endif %}
					<button type="button" class="btn btn-outline-primary" data-bs-toggle="collapse" data-bs-target="#collapseStaticFilter" aria-expanded="false" aria-controls="collapseStaticFilter">
						<i class="fa fa-file"></i>
					</button>
				</div>
			</div>
		</div>
		<div class="table-responsive x_content">
			<table class="table table-sm mb-0">
				<thead>
					<tr>
						<th width="100">{{ lang['list.date'] }}</th>
						<th width="45%">{{ lang['title'] }}</th>
						<th nowrap>{{ lang['list.altname'] }}</th>
						<th>{{ lang['list.template'] }}</th>
						<th width="50">{{ lang['state'] }}</th>
						{% if (perm.modify) %}
							<th width="20">
								<div class="form-check"><input type="checkbox" name="master_box" class="form-check-input" title="{{ lang['select_all'] }}" onclick="javascript:check_uncheck_all(static)"></div>
							</th>
						{% endif %}
					</tr>
				</thead>
				<tbody>
					{% for entry in entries %}
						<tr>
							<td nowrap>{{ entry.date }}</td>
							<td nowrap>
								{% if (perm.details) %}
									<a title="ID: {{ entry.id }}" href="{{ php_self }}?mod=static&action=editForm&id={{ entry.id }}">
									{% endif %}
									{{ entry.title }}
									{% if (perm.details) %}
									</a>
								{% endif %}
								<br/>
								<small>{{ entry.url }}</small>
							</td>
							<td>{{ entry.alt_name }}</td>
							<td>{{ entry.template }}</td>
							<td>
								{{ entry.status }}
							</td>
							{% if (perm.modify) %}
								<td>
									<div class="form-check"><input name="selected[]" class="form-check-input" value="{{ entry.id }}" type="checkbox"></div>
								</td>
							{% endif %}
						</tr>
					{% else %}
						<tr>
							<td colspan="6">
								<p>-
									{{ lang['not_found'] }}
									-</p>
							</td>
						</tr>
					{% endfor %}
				</tbody>
			</table>
		</div>
		<div class="card-footer">
			<div class="row">
				<div class="col-lg-6 mb-2 mb-lg-0">
					{{ pagesss }}
				</div>
				<div class="col-lg-6">
					{% if (perm.modify) %}
						<div class="input-group">
							<select name="action" class="form-select">
								<option value="">--
									{{ lang['action'] }}
									--</option>
								<option value="do_mass_delete">{{ lang['delete'] }}</option>
								<option value="do_mass_approve">{{ lang['approve'] }}</option>
								<option value="do_mass_forbidden">{{ lang['forbidden'] }}</option>
							</select>
							<button type="submit" class="btn btn-outline-warning">OK</button>
						</div>
					{% endif %}
				</div>
			</div>
		</div>
	</div>
</form>
