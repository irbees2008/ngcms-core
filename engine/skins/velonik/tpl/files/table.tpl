<!-- start page title -->
<div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="admin.php">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item active">{l_files_title}</li>
		</ol>
		<h4>{l_files_title}</h4>
	</div>
</div>
<!-- end page title -->
<!-- Filter form: BEGIN -->
<div id="collapseFilesFilter" class="collapse">
	<div class="x_panel mb-4">
		<div class="x_content">
			<form action="{php_self}" method="get" name="options_bar">
				<input type="hidden" name="mod" value="files"/>
				<input type="hidden" name="action" value="list"/>
				<input type="hidden" name="area" value="{area}"/>
				<div
					class="row">
					<!--Block 1-->
					<div class="col-lg-3">
						<div class="form-group">
							<label>{l_month}</label>
							<select name="postdate" class="form-select">
								<option selected value="">- {l_all} -</option>
								{dateslist}
							</select>
						</div>
					</div>
					<!--Block 2-->
					<div class="col-lg-3">
						<div class="form-group ng-select">
							<label>{l_category}</label>
							{dirlistcat}
						</div>
					</div>
					<!--Block 3-->
					<div class="col-lg-3">
						<div class="form-group">
							[status]
							<label>{l_author}</label>
							<select name="author" class="form-select">
								<option value="">- {l_all} -</option>
								{authorlist}
							</select>
							[/status]
						</div>
					</div>
					<!--Block 4-->
					<div class="col-lg-3">
						<div class="form-group">
							<label>{l_per_page}</label>
							<input type="text" name="npp" value="{npp}" class="form-control"/>
						</div>
						<div class="form-group mt-2 text-right">
							<button type="submit" class="btn btn-outline-primary">{l_show}</button>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
<!-- Mass actions form: BEGIN -->
<form id="delform" name="imagedelete" action="{php_self}?mod=files" method="post">
	<input type="hidden" name="area" value="{area}"/>
	<div class="x_panel">
		<div class="x_title">
			<div class="row">
				<div class="col text-right">
					<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#uploadnewModal">{l_upload_file}</button>
					<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#uploadNewByUrlModal">{l_upload_file_url}</button>
					[status]
					<button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#categoriesModal" title="{l_categories}">
						<i class="fa fa-folder"></i>
					</button>
					[/status]
					<button type="button" class="btn btn-outline-primary" data-bs-toggle="collapse" data-bs-target="#collapseFilesFilter" aria-expanded="false" aria-controls="collapseFilesFilter">
						<i class="fa fa-filter"></i>
					</button>
				</div>
			</div>
		</div>
		<div class="table-responsive x_content">
			<table id="entries" class="table table-striped table-hover">
				<thead class="table-dark">
					<tr>
						<th width="5%">#</th>
						<th width="25%">{l_name}</th>
						<th>{l_size}</th>
						<th width="15%">{l_category}</th>
						<th width="10%">{l_author}</th>
						<th>{l_action}</th>
						<th width="5%">
							<input type="checkbox" name="master_box" class="form-check-input" title="{l_select_all}" onclick="check_uncheck_all(this.form, 'files[]')"/>
						</th>
					</tr>
				</thead>
				<tbody>
					{entries}
				</tbody>
			</table>
		</div>
		<div class="card-footer">
			<div class="row">
				<div class="col-lg-6 mb-2 mb-lg-0">{pagesss}</div>
				<div class="col-lg-6">
					[status]
					<div class="input-group">
						<select name="subaction" class="form-control">
							<option value="">-- {l_action} --</option>
							<option value="delete">{l_delete}</option>
							<option value="move">{l_move}</option>
						</select>
						{dirlist}
						<button type="submit" class="btn btn-outline-warning">OK</button>
					</div>
					[/status]
				</div>
			</div>
		</div>
	</div>
</form>
<div id="uploadnewModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="standard-modalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="standard-modalLabel">{l_uploadnew}</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<form id="uploadnew_form" action="{php_self}?mod=files" method="post" enctype="multipart/form-data" name="sn">
				<input type="hidden" name="subaction" value="upload"/>
				<input type="hidden" name="area" value="{area}"/>
				<div class="modal-body">
					<div class="form-group row">
						<label class="col-sm-4 col-form-label">{l_category}</label>
						<div class="col-sm-8 ng-select">{dirlistS}</div>
					</div>
					<div class="form-group row mb-2">
						<div class="col-sm-8 offset-4">
							<div class="form-check mt-2">
								<input type="checkbox" name="replace" value="1" class="form-check-input" id="flagReplace">
								<label class="form-check-label" for="flagReplace">{l_do_replace}</label>
							</div>
							<div class="form-check mt-2">
								<input type="checkbox" name="rand" value="1" class="form-check-input" id="flagRand">
								<label class="form-check-label" for="flagRand">{l_do_rand}</label>
							</div>
						</div>
					</div>
					<div class="table-responsive">
						<table id="fileup" class="table table-sm">
							<tbody>
								<tr id="row">
									<td width="10">1:</td>
									<td><input id="fileUploadInput" type="file" name="userfile[0]" class="form-control"></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div id="showRemoveAddButtoms" class="form-group text-right">
						<div class="btn-group btn-group-sm" role="group">
							<button type="button" onclick="AddFiles();return false;" class="btn btn-outline-success">{l_onemore}</button>
							<button type="button" onclick="RemoveFiles();return false;" class="btn btn-outline-danger">{l_delone}</button>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="submit" class="btn btn-outline-success">{l_upload}</button>
					<button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
				</div>
			</form>
		</div>
	</div>
</div>
<div id="uploadNewByUrlModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="standard-modalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="standard-modalLabel">{l_upload_file_url}</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<form action="{php_self}?mod=files" method="post" name="snup">
				<input type="hidden" name="subaction" value="uploadurl"/>
				<input type="hidden" name="area" value="{area}"/>
				<div class="modal-body">
					<div class="form-group row">
						<label class="col-sm-4 col-form-label">{l_category}</label>
						<div class="col-sm-8 ng-select">{dirlistS}</div>
					</div>
					<div class="form-group row mb-2">
						<div class="col-sm-8 offset-4">
							<div class="form-check mt-2">
								<input type="checkbox" name="replace" value="1" class="form-check-input" id="replace2">
								<label class="form-check-label" for="replace2">{l_do_replace}</label>
							</div>
							<div class="form-check mt-2">
								<input type="checkbox" name="rand2" value="1" class="form-check-input" id="rand2">
								<label class="form-check-label" for="rand2">{l_do_rand}</label>
							</div>
						</div>
					</div>
					<div class="table-responsive">
						<table id="fileup2" class="table table-sm">
							<tbody>
								<tr id="row">
									<td width="10">1:</td>
									<td><input type="text" name="userurl[0]" class="form-control"/></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="form-group text-right">
						<div class="btn-group btn-group-sm" role="group">
							<button type="button" onclick="AddFiles2();return false;" class="btn btn-outline-success">{l_onemore}</button>
							<button type="button" onclick="RemoveFiles2();return false;" class="btn btn-outline-danger">{l_delone}</button>
						</div>
					</div>
				</div>
				<div class="modal-footer text-right">
					<button type="submit" class="btn btn-outline-success">{l_upload}</button>
					<button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
				</div>
			</form>
		</div>
	</div>
</div>
[status]
<div id="categoriesModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="standard-modalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="standard-modalLabel">{l_categories}</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<form action="{php_self}?mod=files" method="post" name="newcat">
					<input type="hidden" name="subaction" value="newcat"/>
					<input type="hidden" name="area" value="{area}"/>
					<label class="form-label">{l_addnewcat}</label>
					<div class="input-group">
						<input type="text" name="newfolder" class="form-control"/>
						<button type="submit" class="btn btn-outline-success">OK</button>
					</div>
					<div class="form-group row">
						<label class="col-sm-4 col-form-label"></label>
					</div>
				</form>
				<form action="{php_self}?mod=files" method="post" name="delcat">
					<input type="hidden" name="subaction" value="delcat"/>
					<input type="hidden" name="area" value="{area}"/>
					<label class="form-label">{l_delcat}</label>
					<div class="input-group ng-select mb-2">
						{dirlist}
						<button type="submit" class="btn btn-outline-danger">OK</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
[/status]
<script language="javascript" type="text/javascript">
	function AddFiles() {
var tbl = document.getElementById('fileup');
var lastRow = tbl.rows.length;
var iteration = lastRow + 1;
var row = tbl.insertRow(lastRow);
var cellRight = row.insertCell(0);
cellRight.innerHTML = '<span>' + iteration + ': </span>';
cellRight = row.insertCell(1);
var el = document.createElement('input');
el.setAttribute('type', 'file');
el.setAttribute('name', 'userfile[' + iteration + ']');
el.setAttribute('size', '30');
el.setAttribute('value', iteration);
cellRight.appendChild(el);
}
function RemoveFiles() {
var tbl = document.getElementById('fileup');
var lastRow = tbl.rows.length;
if (lastRow > 1) {
tbl.deleteRow(lastRow - 1);
}
}
function AddFiles2() {
var tbl = document.getElementById('fileup2');
var lastRow = tbl.rows.length;
var iteration = lastRow + 1;
var row = tbl.insertRow(lastRow);
var cellRight = row.insertCell(0);
cellRight.innerHTML = '<span>' + iteration + ': </span>';
cellRight = row.insertCell(1);
var el = document.createElement('input');
el.setAttribute('type', 'text');
el.setAttribute('name', 'userurl[' + iteration + ']');
el.setAttribute('size', '30');
el.setAttribute('class', 'form-control');
cellRight.appendChild(el);
// document.getElementById('files_number').value = iteration;
}
function RemoveFiles2() {
var tbl = document.getElementById('fileup2');
var lastRow = tbl.rows.length;
if (lastRow > 1) {
tbl.deleteRow(lastRow - 1);
// document.getElementById('files_number').value =  document.getElementById('files_number').value - 1;
}
}
</script>
<!-- BEGIN: Init UPLOADIFY engine -->
<script type="text/javascript">
	$(document).ready(function () { // Ensure filter is collapsed by default and remove persisted expanded state
try {
var cs = JSON.parse(localStorage.getItem('collapseState') || '[]');
var idx = cs.indexOf('#collapseFilesFilter');
if (idx >= 0) {
cs.splice(idx, 1);
localStorage.setItem('collapseState', JSON.stringify(cs));
}
$('#collapseFilesFilter').removeClass('show');
} catch (e) {}
$('#delform').on('input', function (event) {
$(this.elements.category).toggle('move' === $(this.elements.subaction).val());
}).trigger('input');
$('#uploadnew_form').on('submit', function (event) {
event.preventDefault();
$('#uploadnewModal').on('hidden.bs.modal', function (e) {
document.location = document.location;
});
// Prepare script data
$('#fileUploadInput').uploadifive('upload');
});
var uploader = $('#fileUploadInput').uploadifive({
auto: false,
uploadScript: '{admin_url}/rpc.php?methodName=admin.files.upload',
cancelImg: '{skins_url}/images/up_cancel.png',
folder: '',
fileExt: '{listExt}',
fileDesc: '{descExt}',
sizeLimit: '{maxSize}',
multi: true,
buttonText: 'Select files ...',
width: 200,
// 'removeCompleted': true,
onInit: function () {
$('#showRemoveAddButtoms').hide();
},
onUpload: function (filesToUpload) {
uploader.data('uploadifive').settings.formData = {
ngAuthCookie: '{authcookie}',
uploadType: 'file',
category: $('#categorySelect').val(),
rand: $('#flagRand').is(':checked') ? 1 : 0,
replace: $('#flagReplace').is(':checked') ? 1 : 0
};
},
onUploadComplete: function (fileObj, data) { // Response should be in JSON format
var response = JSON.parse(data);
fileObj.queueItem.find('.fileinfo').replaceWith(response.status ? '<div class="text-info">' + response.errorText + '</div>' : '<div class="text-danger">(' + response.errorCode + ') ' + response.errorText + ' ' + response.errorDescription + '</div>');
}
});
});
</script>
<!-- END: Init UPLOADIFY engine -->
