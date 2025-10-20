<!-- start page title -->
<div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="admin.php">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item active">{{ lang.dbo.title }}</li>
		</ol>
		<h4>{{ lang.dbo.title }}</h4>
	</div>
</div>
<!-- end page title -->
<!-- FORM: Perform actions with tables -->
<form name="form" method="post" action="{{ php_self }}?mod=dbo">
	<input type="hidden" name="token" value="{{ token }}"/>
	<input type="hidden" name="subaction" value="modify"/>
	<input type="hidden" name="massbackup" value=""/>
	<input type="hidden" name="cat_recount" value=""/>
	<input type="hidden" name="masscheck" value=""/>
	<input type="hidden" name="massrepair" value=""/>
	<input type="hidden" name="massoptimize" value=""/>
	<input type="hidden" name="massdelete" value=""/>
	<div class="x_panel mb-3">
		<div class="table-responsive">
			<table class="table table-striped">
				<thead>
					<tr>
						<th nowrap>{{ lang.dbo.table }}</th>
						<th nowrap>{{ lang.dbo.rows }}</th>
						<th nowrap>{{ lang.dbo.data }}</th>
						<th nowrap>{{ lang.dbo.overhead }}</th>
						<th nowrap>
							<input type="checkbox" id="master_box_head" class="form-check-input" title="{{ lang.dbo.select_all }}" onclick="check_uncheck_all(this)"/>
						</th>
					</tr>
				</thead>
				<tbody>
					{% for tbl in tables %}
						<tr>
							<td>{{ tbl.table }}</td>
							<td>{{ tbl.rows }}</td>
							<td>{{ tbl.data }}</td>
							<td>{{ tbl.overhead }}</td>
							<td><input type="checkbox" name="tables[]" class="form-check-input" value="{{ tbl.table }}"/></td>
						</tr>
					{% endfor %}
				</tbody>
				<tfoot>
					<tr>
						<th nowrap>{{ lang.dbo.table }}</th>
						<th nowrap>{{ lang.dbo.rows }}</th>
						<th nowrap>{{ lang.dbo.data }}</th>
						<th nowrap>{{ lang.dbo.overhead }}</th>
						<th nowrap>
							<input type="checkbox" id="master_box_foot" class="form-check-input" title="{{ lang.dbo.select_all }}" onclick="check_uncheck_all(this)"/>
						</th>
					</tr>
					<tr>
						<td colspan="5">
							<div class="d-flex flex-wrap gap-2 justify-content-center">
								<div class="col-md-auto">
									<div class="btn-group " role="group">
										<button type="submit" class="btn btn-outline-dark" onclick="document.forms['form'].cat_recount.value = 'true';">{{ lang.dbo.cat_recount }}</button>
										<button type="submit" class="btn btn-outline-dark" onclick="document.forms['form'].masscheck.value = 'true';">{{ lang.dbo.check }}</button>
										<button type="submit" class="btn btn-outline-dark" onclick="document.forms['form'].massrepair.value = 'true';">{{ lang.dbo.repair }}</button>
										<button type="submit" class="btn btn-outline-dark" onclick="document.forms['form'].massoptimize.value = 'true';">{{ lang.dbo.optimize }}</button>
										<button type="submit" class="btn btn-outline-danger" onclick="document.forms['form'].massdelete.value = 'true';">{{ lang.dbo.delete }}</button>
									</div>
								</div>
								<div class="col-md-auto">
									<div class="input-group">
										<div class="input-group-text">
											<label class="mb-0">
												<input type="checkbox" name="gzencode" class="form-check-input" value="1"/>
												{{ lang.dbo.gzencode }}
											</label>
										</div>
										<div class="input-group-text">
											<label class="mb-0">
												<input type="checkbox" name="email_send" class="form-check-input" value="1"/>
												{{ lang.dbo.email_send }}
											</label>
										</div>
										<button type="submit" class="btn btn-outline-success ml-auto" onclick="document.forms['form'].massbackup.value = 'true';">{{ lang.dbo.backup }}</button>
									</div>
								</div>
							</div>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
	</div>
</form>
<!-- FORM: Perform actions with backups -->
<form name="backups" method="post" action="{{ php_self }}?mod=dbo">
	<input type="hidden" name="subaction" value="modify"/>
	<input type="hidden" name="token" value="{{ token }}"/>
	<input type="hidden" name="delbackup" value=""/>
	<input type="hidden" name="massdelbackup" value=""/>
	<input type="hidden" name="restore" value=""/>
	<div class="x_panel">
		<div class="x_title">
			<div class="row">
				<div class="col-md-8">
					<div class="form-group mb-md-0 ng-select">
						{{ restore }}
					</div>
				</div>
				<div class="col-md-4">
					<div class="btn-group" role="group">
						<button type="submit" class="btn btn-outline-warning" nowrap onclick="document.forms['backups'].restore.value = 'true';">{{ lang.dbo.restore }}</button>
						<button type="submit" class="btn btn-outline-danger" nowrap onclick="document.forms['backups'].delbackup.value = 'true';">{{ lang.dbo.delete }}</button>
						<button type="submit" class="btn btn-outline-danger" nowrap onclick="document.forms['backups'].massdelbackup.value = 'true';">{{ lang.dbo.deleteall }}</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>
<script>
	document.addEventListener('DOMContentLoaded', function () {
const masterBoxes = document.querySelectorAll('input[id^="master_box"]');
masterBoxes.forEach(box => {
box.addEventListener('change', function () {
const isChecked = this.checked;
// Найти все чекбоксы таблицы
const table = this.closest('table');
if (! table) 
return;
const checkboxes = table.querySelectorAll('input[name="tables[]"]');
checkboxes.forEach(cb => cb.checked = isChecked);
// Синхронизировать оба master-чекбокса
const allMasters = table.querySelectorAll('input[id^="master_box"]');
allMasters.forEach(mb => {
if (mb !== this) 
mb.checked = isChecked;
});
});
});
// Если пользователь вручную снимает/ставит отдельные чекбоксы, обновлять master-чекбоксы
const table = document.querySelector('table.table-sm');
if (table) {
table.addEventListener('change', function (e) {
if (e.target && e.target.name === 'tables[]') {
const checkboxes = table.querySelectorAll('input[name="tables[]"]');
const allChecked = Array.from(checkboxes).every(cb => cb.checked);
const masters = table.querySelectorAll('input[id^="master_box"]');
masters.forEach(mb => mb.checked = allChecked);
}
});
}
});
</script>
