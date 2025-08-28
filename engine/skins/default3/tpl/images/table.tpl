<div class="container-fluid">
	<div class="row mb-2">
		<div class="col-sm-6 d-none d-md-block ">
			<h1 class="m-0 text-dark">{l_images_title}</h1>
		</div>
		<!-- /.col -->
		<div class="col-sm-6">
			<ol class="breadcrumb float-sm-right">
				<li class="breadcrumb-item">
					<a href="{php_self}">
						<i class="fa fa-home"></i>
					</a>
				</li>
				<li class="breadcrumb-item active" aria-current="page">{l_images_title}</li>
			</ol>
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</div>
<!-- /.container-fluid -->
<!-- Filter form: BEGIN -->
<div id="collapseImagesFilter" class="collapse">
	<div class="card mb-4">
		<div class="card-body">
			<form action="{php_self}" method="get" name="options_bar">
				<input type="hidden" name="mod" value="images"/>
				<input type="hidden" name="action" value="list"/>
				<input type="hidden" name="area" value="{area}"/>
				<div
					class="row">
					<!--Block 1-->
					<div class="col-lg-3">
						<div class="form-group">
							<label>{l_month}</label>
							<select name="postdate" class="custom-select">
								<option selected value="">- {l_all} -</option>
								{dateslist}
							</select>
						</div>
					</div>
					<!--Block 2-->
					<div class="col-lg-3">
						<div class="form-group">
							<label>{l_category}</label>
							{dirlistcat}
						</div>
					</div>
					<!--Block 3-->
					<div class="col-lg-3">
						<div class="form-group">
							[status]
							<label>{l_author}</label>
							<select name="author" class="custom-select">
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
						<div class="form-group mb-0 text-right">
							<button type="submit" class="btn btn-outline-primary">{l_show}</button>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
<!-- Mass actions form: BEGIN -->
<form id="delform" name="imagedelete" action="{php_self}?mod=images" method="post">
	<input type="hidden" name="area" value="{area}"/>
	<div class="card">
		<div class="card-header">
			<div class="d-flex">
				<div class="custom-control custom-switch py-2 mr-auto">
					<input id="entries" type="checkbox" class="custom-control-input" name="master_box" title="{l_select_all}" onclick="javascript:check_uncheck_all(imagedelete)"/>
					<label for="entries" class="custom-control-label">Выделить все изображения</label>
				</div>
				<button type="button" class="btn btn-outline-success ml-1" data-toggle="modal" data-target="#uploadnewModal" data-backdrop="static">{l_upload_img}</button>
				<button type="button" class="btn btn-outline-success ml-1" data-toggle="modal" data-target="#uploadNewByUrlModal" data-backdrop="static">{l_upload_img_url}</button>
				[status]
				<button type="button" class="btn btn-outline-primary ml-1" data-toggle="modal" data-target="#categoriesModal" data-backdrop="static" title="{l_categories}">
					<i class="fa fa-folder-open-o"></i>
				</button>
				[/status]
				<button type="button" class="btn btn-outline-primary ml-1" data-toggle="collapse" data-target="#collapseImagesFilter">
					<i class="fa fa-filter"></i>
				</button>
			</div>
		</div>
		<div class="row" id="entries">
			<div class="col-md-12">
				<div class="panel-body">
					<div class="row">
						{entries}
					</div>
				</div>
			</div>
		</div>
		<div class="card-footer">
			<div class="row">
				<div class="col-lg-6 mb-2 mb-lg-0">{pagesss}</div>
				<div class="col-lg-6">
					[status]
					<div class="input-group">
						<select name="subaction" class="custom-select">
							<option value="">-- {l_action} --</option>
							<option value="delete">{l_delete}</option>
							<option value="move">{l_move}</option>
						</select>
						{dirlist}
						<div class="input-group-append">
							<button type="submit" class="btn btn-outline-warning">OK</button>
						</div>
					</div>
					[/status]
				</div>
			</div>
		</div>
	</div>
</form>
<div id="uploadnewModal" class="modal fade" tabindex="-1" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="uploadnewModalLabel" class="modal-title">{l_uploadnew}</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<form id="uploadnew_form" action="{php_self}?mod=images" method="post" enctype="multipart/form-data" name="sn">
				<input type="hidden" name="subaction" value="upload"/>
				<input type="hidden" name="area" value="{area}"/>
				<div class="modal-body">
					<div class="form-group row">
						<label class="col-sm-4 col-form-label">{l_category}</label>
						<div class="col-sm-8">{dirlistS}</div>
					</div>
					<div class="form-group row">
						<div class="col-sm-8 offset-4">
							<label class="col-form-label d-block"><input id="flagReplace" type="checkbox" name="replace" value="1"/>
								{l_do_replace}</label>
							<label class="col-form-label d-block"><input id="flagRand" type="checkbox" name="rand" value="1"/>
								{l_do_rand}</label>
							<label class="col-form-label d-block"><input id="flagThumb" type="checkbox" name="thumb" value="1" {thumb_mode}{thumb_checked}/>
								{l_do_preview}</label>
							<label class="col-form-label d-block"><input id="flagStamp" type="checkbox" name="stamp" value="1" {stamp_mode}{stamp_checked}/>
								{l_do_wmimage}</label>
						</div>
					</div>
					<div class="table-responsive">
						<table id="imageup" class="table table-sm">
							<tbody>
								<tr id="row">
									<td width="10">1:</td>
									<td><input id="fileUploadInput" type="file" name="userfile[0]"/></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div id="showRemoveAddButtoms" class="form-group text-right">
						<div class="btn-group btn-group-sm" role="group">
							<button type="button" onclick="AddImages();return false;" class="btn btn-outline-success">{l_onemore}</button>
							<button type="button" onclick="RemoveImages();return false;" class="btn btn-outline-danger">{l_delone}</button>
						</div>
					</div>
				</div>
				<div class="modal-footer text-right">
					<button type="submit" class="btn btn-outline-success">{l_upload}</button>
				</div>
			</form>
		</div>
	</div>
</div>
<div id="uploadNewByUrlModal" class="modal fade" tabindex="-1" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="uploadnewModalLabel" class="modal-title">{l_upload_img_url}</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<form action="{php_self}?mod=images" method="post" name="snup">
				<input type="hidden" name="subaction" value="uploadurl"/>
				<input type="hidden" name="area" value="{area}"/>
				<div class="modal-body">
					<div class="form-group row">
						<label class="col-sm-4 col-form-label">{l_category}</label>
						<div class="col-sm-8">
							{dirlistS}
						</div>
					</div>
					<div class="form-group row">
						<div class="col-sm-8 offset-sm-4">
							<label class="col-form-label d-block"><input id="replace2" type="checkbox" name="replace" value="1"/>
								{l_do_replace}</label>
							<label class="col-form-label d-block"><input id="rand2" type="checkbox" name="rand" value="1"/>
								{l_do_rand}</label>
							<label class="col-form-label d-block"><input id="thumb2" type="checkbox" name="thumb" value="1" {thumb_mode}{thumb_checked}/>
								{l_do_preview}</label>
							<label class="col-form-label d-block"><input id="stamp2" type="checkbox" name="stamp" value="1" {stamp_mode}{stamp_checked}/>
								{l_do_wmimage}</label>
						</div>
					</div>
					<div class="table-responsive">
						<table id="imageup2" class="table table-sm">
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
							<button type="button" onclick="AddImages2();return false;" class="btn btn-outline-success">{l_onemore}</button>
							<button type="button" onclick="RemoveImages2();return false;" class="btn btn-outline-danger">{l_delone}</button>
						</div>
					</div>
				</div>
				<div class="modal-footer text-right">
					<button type="submit" class="btn btn-outline-success">{l_upload}</button>
				</div>
			</form>
		</div>
	</div>
</div>
[status]
<div id="categoriesModal" class="modal fade" tabindex="-1" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="categoriesModalLabel" class="modal-title">{l_categories}</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<form action="{php_self}?mod=images" method="post" name="newcat">
					<input type="hidden" name="subaction" value="newcat"/>
					<input type="hidden" name="area" value="{area}"/>
					<div class="form-group row">
						<label class="col-sm-4 col-form-label">{l_addnewcat}</label>
						<div class="col-sm-8">
							<div class="input-group mb-3">
								<input type="text" name="newfolder" class="form-control"/>
								<div class="input-group-append">
									<button type="submit" class="btn btn-outline-success">OK</button>
								</div>
							</div>
						</div>
					</div>
				</form>
				<form action="{php_self}?mod=images" method="post" name="delcat">
					<input type="hidden" name="subaction" value="delcat"/>
					<input type="hidden" name="area" value="{area}"/>
					<div class="form-group row">
						<label class="col-sm-4 col-form-label">{l_delcat}</label>
						<div class="col-sm-8">
							<div class="input-group mb-3">
								{dirlist}
								<div class="input-group-append">
									<button type="submit" class="btn btn-outline-danger">OK</button>
								</div>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
[/status]
<script type="text/javascript">
	function AddImages() {
var tbl = document.getElementById('imageup');
var lastRow = tbl.rows.length;
var iteration = lastRow + 1;
var row = tbl.insertRow(lastRow);
var cellRight = row.insertCell(0);
cellRight.innerHTML = '<span>' + iteration + ': <' + '/' + 'span>';
cellRight = row.insertCell(1);
var el = document.createElement('input');
el.setAttribute('type', 'file');
el.setAttribute('name', 'userfile[' + iteration + ']');
el.setAttribute('size', '60');
el.setAttribute('value', iteration);
cellRight.appendChild(el);
}
function RemoveImages() {
var tbl = document.getElementById('imageup');
var lastRow = tbl.rows.length;
if (lastRow > 1) {
tbl.deleteRow(lastRow - 1);
}
}
function AddImages2() {
var tbl = document.getElementById('imageup2');
var lastRow = tbl.rows.length;
var iteration = lastRow + 1;
var row = tbl.insertRow(lastRow);
var cellRight = row.insertCell(0);
cellRight.innerHTML = '<span">' + iteration + ': <' + '/' + 'span>';
cellRight = row.insertCell(1);
var el = document.createElement('input');
el.setAttribute('type', 'text');
el.setAttribute('name', 'userurl[' + iteration + ']');
el.setAttribute('size', '60');
el.setAttribute('class', 'form-control');
cellRight.appendChild(el);
}
function RemoveImages2() {
var tbl = document.getElementById('imageup2');
var lastRow = tbl.rows.length;
if (lastRow > 1) {
tbl.deleteRow(lastRow - 1);
}
}
</script>
<script type="text/javascript">
	$(document).ready(function () {
$('#delform').on('input', function (event) {
$(this.elements.category).toggle('move' === $(this.elements.subaction).val());
}).trigger('input');
$('#uploadnew_form').on('submit', function (event) {
event.preventDefault();
$('#uploadnewModal').on('hidden.bs.modal', function (e) {
document.location = document.location;
});
$('#fileUploadInput').uploadifive('upload');
});
// Counter for sequential numbering
var fileCounter = 1;
var uploader = $('#fileUploadInput').uploadifive({
auto: false,
uploadScript: '{admin_url}/rpc.php?methodName=admin.files.upload',
cancelImg: '{skins_url}/images/up_cancel.png',
folder: '',
fileExt: '{listExt}',
fileDesc: '{descExt}',
sizeLimit: '{maxSize}',
multi: true,
buttonText: 'Выбрать изображение ...',
width: 200,
onInit: function () {
$('#showRemoveAddButtoms').hide();
// Делаем чекбокс thumb обязательным и скрываем его
$('#flagThumb').prop('checked', true).prop('disabled', true).parent().hide();
},
onUpload: function (filesToUpload) { // Подготовка данных для отправки
var formData = {
ngAuthCookie: '{authcookie}',
uploadType: 'image',
category: $('#categorySelect').val(),
rand: $('#flagRand').is(':checked') ? 1 : 0,
replace: $('#flagReplace').is(':checked') ? 1 : 0,
thumb: 1, // Всегда 1 (обязательные thumbnails)
stamp: $('#flagStamp').is(':checked') ? 1 : 0,
forceRename: 1 // Добавляем флаг принудительного переименования
};
// Добавляем новые имена файлов
$.each(this.fileQueue, function (index, file) {
if (file.newName) {
formData['newFilename_' + index] = file.newName;
}
});
uploader.data('uploadifive').settings.formData = formData;
},
onAdd: function (file) {
try { // Получаем расширение файла
var originalName = file.name;
var extension = originalName.split('.').pop().toLowerCase().substring(0, 4);
// Генерируем новое имя с ведущими нулями (3 цифры + расширение)
var newName = (fileCounter++).toString().padStart(3, '0') + '.' + extension;
// Убедимся, что длина не превышает 22 символов
if (newName.length > 22) {
newName = newName.substring(0, 22);
}
// Сохраняем новое имя в объекте файла
file.newName = newName;
// Для отображения в интерфейсе можно изменить file.name
file.name = newName;
return true;
} catch (e) {
console.error('Error renaming file:', e);
return true;
}
},
onUploadComplete: function (fileObj, data) {
try {
var response = JSON.parse(data);
fileObj.queueItem.find('.fileinfo').replaceWith(response.status ? '<div class="text-info">' + response.errorText + '</div>' : '<div class="text-danger">(' + response.errorCode + ') ' + response.errorText + ' ' + response.errorDescription + '</div>');
} catch (e) {
console.error('Error processing upload response:', e);
}
},
onError: function (errorType, file) {
console.error('Upload error:', errorType, file);
}
});
});
</script>
<!-- END: Init UPLOADIFY engine -->
