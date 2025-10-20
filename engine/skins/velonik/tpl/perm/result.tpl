<!-- start page title -->
<div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="admin.php">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item active">{{ lang['permissions'] }}</li>
		</ol>
		<h4>{{ lang['permissions'] }}</h4>
	</div>
</div>
<!-- end page title -->
<div class="alert {{ execResult ? 'alert-success' : 'alert-danger'}}">
	{{ lang['result'] }}:
	{{ execResult ? lang['success'] : lang['error'] }}
</div>
{% if updateList %}
	<div class="x_panel mb-5">
		<div class="x_title">
			{{ lang['list_changes_performed'] }}
		</div>
		<table class="table table-sm mb-0">
			<thead>
				<tr>
					<th>{{ lang['group'] }}</th>
					<th>ID</th>
					<th>{{ lang['name'] }}</th>
					<th nowrap>{{ lang['old_value'] }}</th>
					<th nowrap>{{ lang['new_value'] }}</th>
				</tr>
			</thead>
			<tbody>
				{% for entry in updateList %}
					<tr>
						<td>{{ GRP[entry.group]['title'] }}</td>
						<td>{{ entry.id }}</td>
						<td>{{ entry.title }}</td>
						<td>{{ entry.displayOld }}</td>
						<td>{{ entry.displayNew }}</td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
	</div>
{% endif %}
