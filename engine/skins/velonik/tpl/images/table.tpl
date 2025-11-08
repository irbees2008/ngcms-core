<link href="{{ skins_url }}/public/css/jquery.fancybox.min.css" type="text/css" rel="stylesheet">
<script src="{{ skins_url }}/public/js/jquery.fancybox.min.js" type="text/javascript"></script>
<!-- Uploadifive (multi-upload) assets: load explicitly for default3 -->
<link href="{{ skins_url }}/assets/vendor/uploadifive/uploadifive.css" type="text/css" rel="stylesheet">
<!-- start page title -->
<div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="{{ php_self }}">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item active">{{ lang['images_title'] }}</li>
		</ol>
		<h4>{{ lang['images_title'] }}</h4>
	</div>
</div>
<!-- end page title -->
<!-- Filter form: BEGIN -->
<div id="collapseImagesFilter" class="collapse">
	<div class="x_panel mb-4">
		<div class="x_content">
			<form action="{{ php_self }}" method="get" name="options_bar">
				<input type="hidden" name="mod" value="images"/>
				<input type="hidden" name="action" value="list"/>
				<input type="hidden" name="area" value="{{ area }}"/>
				<div
					class="row">
					<!--Block 1-->
					<div class="col-lg-3">
						<div class="form-group">
							<label>{{ lang['month'] }}</label>
							<select name="postdate" class="form-select">
								<option selected value="">- {{ lang['all'] }} -</option>
								{{ dateslist|raw }}
							</select>
						</div>
					</div>
					<!--Block 2-->
					<div class="col-lg-3">
						<div class="form-group">
							<label>{{ lang['category'] }}</label>
							<div class="ng-select">{{ dirlistcat|raw }}</div>
						</div>
					</div>
					<!--Block 3-->
					<div class="col-lg-3">
						<div class="form-group">
							{% if status %}
							<label>{{ lang['author'] }}</label>
							<select name="author" class="form-select">
								<option value="">- {{ lang['all'] }} -</option>
								{{ authorlist|raw }}
							</select>
							{% endif %}
						</div>
					</div>
					<!--Block 4-->
					<div class="col-lg-3">
						<div class="form-group">
							<label>{{ lang['per_page'] }}</label>
							<input type="text" name="npp" value="{{ npp }}" class="form-control"/>
						</div>
						<div class="form-group mt-2 text-right">
							<button type="submit" class="btn btn-outline-primary">{{ lang['show'] }}</button>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
<!-- Mass actions form: BEGIN -->
<form id="delform" name="imagedelete" action="{{ php_self }}?mod=images" method="post">
	<input type="hidden" name="area" value="{{ area }}"/>
	<div class="row mb-3">
		<div class="col-md-12">
			<div class="x_panel">
				<div class="x_content">
					<div class="d-flex justify-content-between align-items-center flex-wrap">
						<div class="gallery-filters mb-3 mb-md-0">
							<div class="d-flex">
								<div class="custom-control custom-switch py-3 mr-auto">
									<input id="masterCheck" type="checkbox" class="form-check-input" name="master_box" title="{{ lang['select_all'] }}" onclick="javascript:check_uncheck_all(imagedelete)"/>
									<label for="masterCheck" class="form-check-label">{{ lang['select_all_images']|default('Выделить все изображения') }}</label>
								</div>
								<button type="button" class="btn btn-outline-success m-1" data-bs-toggle="modal" data-bs-target="#uploadnewModal" data-backdrop="static">{{ lang['upload_img'] }}</button>
								<button type="button" class="btn btn-outline-success m-1" data-bs-toggle="modal" data-bs-target="#uploadNewByUrlModal" data-backdrop="static">{{ lang['upload_img_url'] }}</button>
								{% if status %}
								<button type="button" class="btn btn-outline-primary m-1" data-bs-toggle="modal" data-bs-target="#categoriesModal" data-backdrop="static" title="{{ lang['categories'] }}">
									<i class="fa fa-folder"></i>
								</button>
								{% endif %}
								<button type="button" class="btn btn-outline-primary m-1" data-bs-toggle="collapse" data-bs-target="#collapseImagesFilter" aria-expanded="false" aria-controls="collapseImagesFilter">
									<i class="fa fa-filter"></i>
								</button>
							</div>
						</div>
						<div class="gallery-view-toggle">
							<div class="btn-group" role="group">
								<button type="button" class="btn btn-outline-secondary active" data-view="grid">
									<i class="fa fa-th"></i>
								</button>
								<button type="button" class="btn btn-outline-secondary" data-view="list">
									<i class="fa fa-list"></i>
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row" id="entries">
		{{ entries|raw }}
	</div>
	<div class="row mt-2">
	<div class="col-lg-6 mb-2 mb-lg-0">{{ pagesss|raw }}</div>
		<div class="col-lg-6">
			{% if status %}
			<div class="input-group">
				<select name="subaction" class="form-select">
					<option value="">-- {{ lang['action'] }} --</option>
					<option value="delete">{{ lang['delete'] }}</option>
					<option value="move">{{ lang['move'] }}</option>
				</select>
				{{ dirlist|raw }}
				<button type="submit" class="btn btn-outline-warning">OK</button>
			</div>
			{% endif %}
		</div>
	</div>
</form>
<div id="uploadnewModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="uploadnewModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="uploadnewModalLabel">{{ lang['uploadnew'] }}</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<form id="uploadnew_form" action="{{ php_self }}?mod=images" method="post" enctype="multipart/form-data" name="sn">
				<input type="hidden" name="subaction" value="upload"/>
				<input type="hidden" name="area" value="{{ area }}"/>
				<div class="modal-body">
					<div class="form-group row mb-2">
						<label class="col-sm-4 col-form-label">{{ lang['category'] }}</label>
						<div class="col-sm-8 ng-select">{{ dirlistS|raw }}</div>
					</div>
					<div class="form-group row">
						<div class="col-sm-8 offset-4">
							<div class="form-check mb-2">
								<input id="flagReplace" type="checkbox" name="replace" value="1" class="form-check-input">
								<label class="form-check-label" for="flagReplace">{{ lang['do_replace'] }}</label>
							</div>
							<div class="form-check mb-2">
								<input id="flagRand" type="checkbox" name="rand" value="1" class="form-check-input">
								<label class="form-check-label" for="flagRand">{{ lang['do_rand'] }}</label>
							</div>
							<div class="form-check mb-2">
								<input id="flagStamp" type="checkbox" name="stamp" value="1" class="form-check-input" {{ stamp_mode }}{{ stamp_checked }}>
								<label class="form-check-label" for="flagStamp">{{ lang['do_wmimage'] }}</label>
							</div>
							<!-- Always create thumbnails -->
							<input type="hidden" name="thumb" value="1">
						</div>
					</div>
					<div class="table-responsive">
						<table id="imageup" class="table table-sm">
							<tbody>
								<tr id="row">
									<td width="10">1:</td>
									<td><input id="fileUploadInput" type="file" name="userfile[0]" class="form-control"/></td>
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
					<button type="submit" class="btn btn-outline-success">{{ lang['upload'] }}</button>
					<button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
				</div>
			</form>
		</div>
	</div>
</div>
<div id="uploadNewByUrlModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="uploadnewModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="uploadnewModalLabel">{{ lang['upload_img_url'] }}</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<form action="{{ php_self }}?mod=images" method="post" name="snup">
				<input type="hidden" name="subaction" value="uploadurl"/>
				<input type="hidden" name="area" value="{{ area }}"/>
				<div class="modal-body">
					<div class="form-group row mb-2">
						<label class="col-sm-4 col-form-label">{{ lang['category'] }}</label>
						<div class="col-sm-8 ng-select">{{ dirlistS|raw }}</div>
					</div>
					<div class="form-group row">
						<div class="col-sm-8 offset-4">
							<div class="form-check mb-2">
								<input id="replace2" type="checkbox" name="replace" value="1" class="form-check-input">
								<label class="form-check-label" for="replace2">{{ lang['do_replace'] }}</label>
							</div>
							<div class="form-check mb-2">
								<input id="rand2" type="checkbox" name="rand" value="1" class="form-check-input">
								<label class="form-check-label" for="rand2">{{ lang['do_rand'] }}</label>
							</div>
							<div class="form-check mb-2">
								<input id="stamp2" type="checkbox" name="stamp" value="1" class="form-check-input" {stamp_mode}{stamp_checked}>
								<label class="form-check-label" for="stamp2">{l_do_wmimage}</label>
							</div>
							<!-- Always create thumbnails for URL uploads too -->
							<input type="hidden" name="thumb" value="1">
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
					<button type="submit" class="btn btn-outline-success">{{ lang['upload'] }}</button>
					<button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
				</div>
			</form>
		</div>
	</div>
</div>
{% if status %}
<div id="categoriesModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="categoriesModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="categoriesModalLabel">{l_categories}</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<form action="{{ php_self }}?mod=images" method="post" name="newcat">
					<input type="hidden" name="subaction" value="newcat"/>
					<input type="hidden" name="area" value="{{ area }}"/>
					<label class="col-form-label">{{ lang['addnewcat'] }}</label>
					<div class="input-group mb-3">
						<input type="text" name="newfolder" class="form-control"/>
						<button type="submit" class="btn btn-outline-success">OK</button>
					</div>
				</form>
				<form action="{{ php_self }}?mod=images" method="post" name="delcat">
					<input type="hidden" name="subaction" value="delcat"/>
					<input type="hidden" name="area" value="{{ area }}"/>
					<label class="col-form-label">{{ lang['delcat'] }}</label>
					<div class="input-group mb-3 ng-select">
						{{ dirlist|raw }}
						<button type="submit" class="btn btn-outline-danger">OK</button>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
{% endif %}
<script type="module">
	document.addEventListener('DOMContentLoaded', () => { // Gallery filtering
const filterButtons = document.querySelectorAll('[data-filter]');
const galleryItems = document.querySelectorAll('.gallery-item');
filterButtons.forEach(button => {
button.addEventListener('click', () => {
const filter = button.getAttribute('data-filter');
// Update active filter button
filterButtons.forEach(btn => btn.classList.remove('active'));
button.classList.add('active');
// Filter gallery items
galleryItems.forEach(item => {
const category = item.getAttribute('data-category');
if (filter === 'all' || category === filter) {
item.style.display = 'block';
item.classList.add('fade-in');
} else {
item.style.display = 'none';
item.classList.remove('fade-in');
}
});
});
});
// View toggle (grid/list)
const viewButtons = document.querySelectorAll('[data-view]');
const galleryContainer = document.getElementById('entries');
viewButtons.forEach(button => {
button.addEventListener('click', () => {
const view = button.getAttribute('data-view');
// Update active view button
viewButtons.forEach(btn => btn.classList.remove('active'));
button.classList.add('active');
// Apply view changes
if (view === 'list') {
galleryContainer.classList.add('list-view');
galleryItems.forEach(item => {
item.className = 'col-12 mb-3 gallery-item';
});
} else {
galleryContainer.classList.remove('list-view');
galleryItems.forEach(item => {
item.className = 'col-lg-4 col-md-6 col-sm-12 mb-4 gallery-item';
});
}
});
});
// Image modal functionality
const imageModal = document.getElementById('imageModal');
const modalTitle = document.getElementById('imageModalLabel');
const modalImage = document.getElementById('modalImage');
const modalDescription = document.getElementById('modalDescription');
// Handle image clicks for lightbox
document.querySelectorAll('.gallery-image').forEach(img => {
img.addEventListener('click', (e) => {
e.preventDefault();
const title = img.getAttribute('data-title');
const description = img.getAttribute('data-description');
const src = img.src;
modalTitle.textContent = title;
modalImage.src = src;
modalDescription.textContent = description;
// Show the modal
const modal = new bootstrap.Modal(imageModal);
modal.show();
});
});
// Also handle clicks on the expand buttons in overlay
document.querySelectorAll('.gallery-actions .btn').forEach(btn => {
if (btn.title === 'View Full Size' || btn.getAttribute('data-bs-original-title') === 'View Full Size') {
btn.addEventListener('click', (e) => {
e.preventDefault();
e.stopPropagation();
const img = btn.closest('.gallery-image-container').querySelector('.gallery-image');
const title = img.getAttribute('data-title');
const description = img.getAttribute('data-description');
const src = img.src;
modalTitle.textContent = title;
modalImage.src = src;
modalDescription.textContent = description;
// Show the modal
const modal = new bootstrap.Modal(imageModal);
modal.show();
});
}
});
// Search functionality
const searchInput = document.querySelector('input[placeholder="Search gallery..."]');
if (searchInput) {
searchInput.addEventListener('input', (e) => {
const searchTerm = e.target.value.toLowerCase();
galleryItems.forEach(item => {
const title = item.querySelector('.card-title').textContent.toLowerCase();
const description = item.querySelector('.card-text').textContent.toLowerCase();
const category = item.getAttribute('data-category').toLowerCase();
if (title.includes(searchTerm) || description.includes(searchTerm) || category.includes(searchTerm)) {
item.style.display = 'block';
} else {
item.style.display = 'none';
}
});
});
}
// Hover effects for gallery cards
document.querySelectorAll('.gallery-card').forEach(card => {
card.addEventListener('mouseenter', () => {
card.style.transform = 'translateY(-5px)';
card.style.boxShadow = '0 8px 25px rgba(0,0,0,0.15)';
});
card.addEventListener('mouseleave', () => {
card.style.transform = 'translateY(0)';
card.style.boxShadow = '0 2px 10px rgba(0,0,0,0.1)';
});
});
});
</script>
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
	// Дожидаемся полной загрузки страницы (включая нижний jquery.min.js), затем инициализируем uploadifive
window.addEventListener('load', function () { // Ensure filter is collapsed by default and remove persisted expanded state
try {
var cs = JSON.parse(localStorage.getItem('collapseState') || '[]');
var idx = cs.indexOf('#collapseImagesFilter');
if (idx >= 0) {
cs.splice(idx, 1);
localStorage.setItem('collapseState', JSON.stringify(cs));
}
$('#collapseImagesFilter').removeClass('show');
} catch (e) {}
$('#delform').on('input', function (event) {
$(this.elements.category).toggle('move' === $(this.elements.subaction).val());
}).trigger('input');
$('#uploadnew_form').on('submit', function (event) { // Если у uploadifive есть файлы в очереди — грузим через него
var hasPlugin = !!(window.jQuery && $.fn && $.fn.uploadifive && $('#fileUploadInput').data('uploadifive'));
var queueCount = $('.uploadifive-queue-item').length;
if (hasPlugin && queueCount > 0) {
event.preventDefault();
$('#fileUploadInput').uploadifive('upload');
}
});
// Counter for sequential numbering
var fileCounter = 1;
// Вспомогательная функция получения категории
function getUploadCategory() {
var el = document.getElementById('categorySelect') || document.querySelector('#uploadnewModal select[name="category"], #uploadnewModal .ng-select select');
return el ? el.value : '';
}
// Динамическая загрузка скрипта uploadifive для текущего экземпляра jQuery,
// если плагин ещё не подхвачен ($.fn.uploadifive отсутствует)
function loadScript(src) {
return new Promise(function (resolve, reject) {
var s = document.createElement('script');
s.src = src;
s.async = true;
s.onload = function () {
resolve(true);
};
s.onerror = function () {
reject(new Error('Failed to load ' + src));
};
document.head.appendChild(s);
});
}
	function ensureUploadifive() {
if (window.jQuery && $.fn && $.fn.uploadifive) {
return Promise.resolve(true);
}
// Пытаемся подгрузить из скина, затем из lib
		var skinSrc = '{{ skins_url }}/assets/vendor/uploadifive/jquery.uploadifive.js';
		var libSrc = '{{ home }}/lib/jq/plugins/uploadifive/jquery.uploadifive.min.js';
return loadScript(skinSrc).catch(function () {
return loadScript(libSrc);
});
}
	function initUploader() {
var uploader = $('#fileUploadInput').uploadifive({
auto: false,
			uploadScript: '{{ admin_url }}/rpc.php?methodName=admin.files.upload',
			cancelImg: '{{ skins_url }}/images/up_cancel.png',
folder: '',
			fileExt: '{{ listExt }}',
			fileDesc: '{{ descExt }}',
			sizeLimit: '{{ maxSize }}',
multi: true,
buttonText: 'Выбрать изображение ...',
width: 200,
onInit: function () { // Прячем ручные кнопки добавления/удаления, так как используем uploadifive
$('#showRemoveAddButtoms').hide();
},
			onUpload: function (filesToUpload) { // Подготовка данных для отправки
var formData = {
					ngAuthCookie: '{{ authcookie }}',
uploadType: 'image',
category: getUploadCategory(),
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
onAddQueueItem: function (file) {
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
onQueueComplete: function () {
try {
var modalEl = document.getElementById('uploadnewModal');
var m = window.bootstrap && window.bootstrap.Modal ? window.bootstrap.Modal.getInstance(modalEl) : null;
if (m) {
m.hide();
} else { // jQuery fallback
$('#uploadnewModal').modal && $('#uploadnewModal').modal('hide');
}
} catch (e) {}
// Обновим страницу после закрытия модалки
setTimeout(function () {
document.location = document.location;
}, 150);
},
onError: function (errorType, file) {
console.error('Upload error:', errorType, file);
}
});
}
ensureUploadifive().then(function () {
if ($.fn && $.fn.uploadifive) {
initUploader();
} else {
$('#showRemoveAddButtoms').show();
}
}).catch(function () { // Не удалось загрузить плагин — используем фолбэк
$('#showRemoveAddButtoms').show();
});
});
</script>
<!-- END: Init UPLOADIFY engine -->
<script type="text/javascript">
	// Fallback: mass check/uncheck within the images form if global function is not defined
if (typeof window.check_uncheck_all !== 'function') {
window.check_uncheck_all = function (frm) {
if (! frm) {
return;
}
var master = frm.querySelector('input[name="master_box"]');
var state = master && master.checked;
if (state === undefined) {
return;
}
var boxes = frm.querySelectorAll('input[type="checkbox"][name="files[]"]');
if (! boxes || ! boxes.length) {
return;
}
// Toggle only image selection checkboxes
if (typeof boxes.forEach === 'function') {
boxes.forEach(function (cb) {
cb.checked = state;
});
} else {
for (var i = 0; i < boxes.length; i++) {
boxes[i].checked = state;
}
}
};
}
</script>
