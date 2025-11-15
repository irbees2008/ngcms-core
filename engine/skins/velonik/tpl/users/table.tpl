<!-- start page title -->
<div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="admin.php">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item active">{{ lang['users_title'] }}</li>
		</ol>
		<h4>{{ lang['users_title'] }}</h4>
	</div>
</div>
<!-- end page title -->
<!-- Filter form: BEGIN -->
<div id="collapseUsersFilter" class="collapse">
	<div class="x_panel mb-4">
		<div class="x_title">
			<form action="{{ php_self }}" method="get">
				<input type="hidden" name="mod" value="users"/>
				<input type="hidden" name="action" value="list"/>
				<div
					class="row">
					<!--Block 1-->
					<div class="col-lg-4">
						<div class="form-group">
							<label>{{ lang['name'] }}</label>
							<input type="text" name="name" value="{{ name }}" class="form-control"/>
						</div>
					</div>
					<!--Block 2-->
					<div class="col-lg-4">
						<div class="form-group">
							<label>{{ lang['group'] }}</label>
							<select name="group" class="form-select">
								<option value="0">--
									{{ lang['any'] }}
									--</option>
								{% for g in ugroup %}
									<option value="{{ g.id }}" {{ group == g.id ? 'selected' : ''}}>{{ g.name }}</option>
								{% endfor %}
							</select>
						</div>
					</div>
					<!--Block 3-->
					<div class="col-lg-4">
						<div class="form-group">
							<label>{{ lang['per_page'] }}&nbsp;</label>
							<input type="number" name="rpp" value="{{ rpp }}" class="form-control"/>
						</div>
						<div class="form-group mt-3 text-right">
							<button type="submit" class="btn btn-outline-primary">{{ lang['sortit'] }}</button>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
<!-- Mass actions form: BEGIN -->
<form id="form_users" action="{{ php_self }}" method="get" name="form_users">
	<input type="hidden" name="token" value="{{ token }}"/>
	<input type="hidden" name="mod" value="users"/>
	<input type="hidden" name="name" value="{{ name }}"/>
	<input type="hidden" name="how" value="{{ how_value }}"/>
	<input type="hidden" name="sort" value="{{ sort_value }}"/>
	<input type="hidden" name="page" value="{{ page_value }}"/>
	<input type="hidden" name="per_page" value="{{ rpp }}"/>
	<div class="x_panel">
		<div class="x_title">
			<div class="row">
				<div class="col text-right">
					{% if flags.canModify %}
						<button type="button" class="btn btn-outline-success" data-bs-toggle="modal" data-bs-target="#adduserModal">{{ lang['adduser'] }}</button>
					{% endif %}
					<button type="button" class="btn btn-outline-primary" data-bs-toggle="collapse" data-bs-target="#collapseUsersFilter" aria-expanded="false" aria-controls="collapseUsersFilter">
						<i class="fa fa-filter"></i>
					</button>
				</div>
			</div>
		</div>
		<div class="table-responsive users-table-wrapper">
		<table class="table table-striped table-centered mb-3 users-table">
			<thead>
				<tr>
					<th width="5%" data-label="#">
						<a href="{{ sortLink['i']['link'] }}">#</a>
						{{ sortLink['i']['sign'] }}
					</th>
					<th width="20%" data-label="{{ lang['name'] }}">
						<a href="{{ sortLink['n']['link'] }}">{{ lang['name'] }}</a>
						{{ sortLink['n']['sign'] }}
					</th>
					<th width="20%" data-label="{{ lang['regdate'] }}" data-hide-xs="true">
						<a href="{{ sortLink['r']['link'] }}">{{ lang['regdate'] }}</a>
						{{ sortLink['r']['sign'] }}
					</th>
					<th width="20%" data-label="{{ lang['last_login'] }}" data-hide-xs="true">
						<a href="{{ sortLink['l']['link'] }}">{{ lang['last_login'] }}</a>
						{{ sortLink['l']['sign'] }}
					</th>
					<th width="10%" data-label="{{ lang['all_news2'] }}" data-hide-xs="true">
						<a href="{{ sortLink['p']['link'] }}">{{ lang['all_news2'] }}</a>
						{{ sortLink['p']['sign'] }}
					</th>
					{% if flags.haveComments %}
						<th width="10%" data-label="{l_listhead.comments}" data-hide-xs="true">{l_listhead.comments}</th>
					{% endif %}
					<th width="15%" data-label="{{ lang['groupName'] }}">
						<a href="{{ sortLink['g']['link'] }}">{{ lang['groupName'] }}</a>
						{{ sortLink['g']['sign'] }}
					</th>
					<th width="5%" data-label="{{ lang['active'] }}" data-hide-xs="true">&nbsp;</th>
					<th width="5%" data-label="{{ lang['action'] }}" data-hide-xs="true">
						{% if flags.canModify %}
							<input type="checkbox" name="master_box" class="form-check-input" title="{l_select_all}" onclick="check_uncheck_all(this.form, 'selected_users[]')"/>
						{% endif %}
					</th>
				</tr>
			</thead>
			<tbody>
				{% for entry in entries %}
					<tr>
						<td data-label="#" data-hide-xs="true">{{ entry.id }}</td>
						<td class="table-user" data-label="{{ lang['name'] }}">
							<img src="{{ entry.avatar ?: (skins_url ~ '/images/default-avatar.jpg') }}" alt="table-user" class="me-2 rounded-circle" width="32" height="32"/>
							{% if flags.canView %}
								<a href="{{ php_self }}?mod=users&action=editForm&id={{ entry.id }}">{{ entry.name }}</a>
							{% else %}
								{{ entry.name }}
							{% endif %}
						</td>
						<td data-label="{{ lang['regdate'] }}" data-hide-xs="true">{{ entry.regdate }}</td>
						<td data-label="{{ lang['last_login'] }}" data-hide-xs="true">{{ entry.lastdate }}</td>
						<td data-label="{{ lang['all_news2'] }}" data-hide-xs="true">
							{% if entry.cntNews > 0 %}
								<a href="{{ php_self }}?mod=news&aid={{ id }}">{{ entry.cntNews }}</a>
								{% else %}-
							{% endif %}
						</td>
						{% if flags.haveComments %}
							<td width="10%" data-label="{l_listhead.comments}" data-hide-xs="true">
								{{ entry.cntComments ?: '-'}}
							</td>
						{% endif %}
						<td data-label="{{ lang['groupName'] }}">{{ entry.groupName }}</td>
						<td data-label="{{ lang['active'] }}" data-hide-xs="true">
							{% if entry.flags.isActive %}
								<i class="ri-check-line text-success" title="{{ lang['active'] }}"></i>
							{% else %}
								<i class="ri-close-line text-danger" title="{{ lang['unactive'] }}"></i>
							{% endif %}
						</td>
						<td data-label="{{ lang['action'] }}" data-hide-xs="true">
							{% if (flags.canModify and flags.canMassAction) %}
								<input type="checkbox" name="selected_users[]" class="form-check-input" value="{{ entry.id }}"/>
							{% endif %}
						</td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
		</div>
		<div class="row">
			<div class="col-lg-6 mb-2 mb-lg-0">{{ pagination }}</div>
			<div class="col-lg-6">
				{% if flags.canModify %}
					<div class="input-group">
						<select name="action" class="form-select">
							<option value="">--{{ lang['action'] }}--</option>
							<option value="massActivate">{{ lang['activate'] }}</option>
							<option value="massLock">{{ lang['lock'] }}</option>
							<option value="" class="bg-light" disabled>===================</option>
							<option value="massDel">{{ lang['delete'] }}</option>
							<option value="massDelInactive">{{ lang['delete_unact'] }}</option>
							<option value="" class="bg-light" disabled>===================</option>
							<option value="massSetStatus">{{ lang['setstatus'] }}&raquo;</option>
						</select>
						<select name="newstatus" class="form-select">
							<option value=""></option>
							{% for grp in ugroup|reverse %}
								<option value="{{ grp.id }}">{{ grp.id }}
									({{ grp.name }})</option>
							{% endfor %}
						</select>
						<button type="submit" class="btn btn-outline-warning">{{ lang['submit'] }}</button>
					</div>
				{% endif %}
			</div>
		</div>
	</div>
</form>
<!-- Mass actions form: END -->
{% if flags.canModify %}
	<div id="adduserModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="adduserModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">{{ lang.adduser }}</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form method="post" action="{{ php_self }}?mod=users">
						<input type="hidden" name="action" value="add"/>
						<input type="hidden" name="token" value="{{ token }}"/>
						<div class="modal-body">
							<div class="form-group row mb-2">
								<label class="col-sm-4 col-form-label">{{ lang.name }}</label>
								<div class="col-sm-8">
									<input type="text" name="regusername" class="form-control"/>
								</div>
							</div>
							<div class="form-group row mb-2">
								<label class="col-sm-4 col-form-label">{{ lang.password }}</label>
								<div class="col-sm-8">
									<input type="text" name="regpassword" class="form-control"/>
								</div>
							</div>
							<div class="form-group row mb-2">
								<label class="col-sm-4 col-form-label">{{ lang.email }}</label>
								<div class="col-sm-8">
									<input type="email" name="regemail" class="form-control"/>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-4 col-form-label">{{ lang.status }}</label>
								<div class="col-sm-8">
									<select name="reglevel" class="form-select">
										{% for grp in ugroup %}
											<option value="{{ grp.id }}">{{ grp.id }}
												({{ grp.name }})</option>
										{% endfor %}
									</select>
								</div>
							</div>
						</div>
						<div class="modal-footer">
							<button type="submit" class="btn btn-outline-success">{{ lang.adduser }}</button>
							<button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
						</div>
					</form>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->
{% endif %}
<script type="text/javascript">
	$(document).ready(function () {
$('#form_users').on('input', function (event) {
$(this.elements.newstatus).toggle('massSetStatus' === $(this.elements.action).val());
}).on('submit', function (event) {
event.preventDefault();
var action = $(this.elements.action).val();
var newstatus = $(this.elements.newstatus).val();
if ('' == action) {
return alert('Необходимо выбрать действие!');
}
if (('massSetStatus' == action) && ! newstatus) {
return alert(NGCMS.lang.msge_setstatus);
}
this.submit();
}).trigger('input');
});
</script>
<style>
/* ----- Адаптивность таблицы пользователей ----- */
@media (max-width: 767.98px) {
	.users-table thead { display: none; }
	.users-table tbody tr { display: block; border:1px solid #dee2e6; border-radius:4px; margin-bottom:.75rem; background:#fff; }
	.users-table tbody td { display:flex; justify-content:space-between; align-items:center; padding:.5rem .75rem; border-bottom:1px solid #f1f1f1; }
	.users-table tbody td:last-child { border-bottom:0; }
	.users-table tbody td.table-user { display:block; }
	.users-table tbody td.table-user img { margin-bottom:.5rem; }
	.users-table tbody td.table-user a, .users-table tbody td.table-user span, .users-table tbody td.table-user { font-weight:600; }
	.users-table tbody td::before { content: attr(data-label); font-weight:600; color:#6c757d; margin-right:.75rem; }
	.users-table-wrapper { overflow-x: visible; }
}
@media (max-width: 575.98px) {
	.users-table tbody td[data-hide-xs='true'] { display: none !important; }
	.users-table tbody td { padding:.5rem .65rem; }
}
/* Сохранить нормальный вид на десктопе */
@media (min-width: 768px) {
	.users-table-wrapper { overflow-x:auto; }
}
</style>
