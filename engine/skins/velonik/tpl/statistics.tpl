<!-- start page title -->
<div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="admin.php">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item active">{{ lang['statistics'] }}</li>
		</ol>
		<h4>{{ lang['statistics'] }}</h4>
	</div>
</div>
<!-- end page title -->
<!-- Configuration errors -->
{% if (flags.confError) %}
	<div class="alert alert-danger" role="alert">
		<h4 class="alert-heading mb-0">{{ lang['pconfig.error'] }}</h4>
		<p>
			<table class="table table-danger table-bordered">
				<thead>
					<tr>
						<th>{{ lang['perror.parameter'] }}</th>
						<th>{{ lang['perror.shouldbe'] }}</th>
						<th>{{ lang['perror.set'] }}</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>Register Globals</td>
						<td>{{ lang['perror.off'] }}</td>
						<td>{{ flags.register_globals }}</td>
					</tr>
					<tr>
						<td>Magic Quotes GPC</td>
						<td>{{ lang['perror.off'] }}</td>
						<td>{{ flags.magic_quotes_gpc }}</td>
					</tr>
					<tr>
						<td>Magic Quotes Runtime</td>
						<td>{{ lang['perror.off'] }}</td>
						<td>{{ flags.magic_quotes_runtime }}</td>
					</tr>
					<tr>
						<td>Magic Quotes Sybase</td>
						<td>{{ lang['perror.off'] }}</td>
						<td>{{ flags.magic_quotes_sybase }}</td>
					</tr>
				</tbody>
			</table>
		</p>
		<button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#perror_resolve">{{ lang['perror.howto'] }}</button>
	</div>
	<div id="perror_resolve" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="perrorModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-full-width">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="perrorModalLabel">{{ lang['perror.howto'] }}</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<p>{{ lang['perror.descr'] }}</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->
{% endif %}
<!-- top tiles -->
<div class="row g-3 mb-4">
	<div class="col-xl-3 col-md-6">
		<div class="card border-0 shadow-sm h-100">
			<div class="card-body d-flex align-items-center">
				<div class="d-flex align-items-center">
					<div class="flex-shrink-0 me-3">
						<div class="rounded-circle bg-primary bg-opacity-10 d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
							<i class="fa fa-newspaper-o text-primary fs-5"></i>
						</div>
					</div>
					<div class="flex-grow-1">
						<h6 class="small text-muted mb-1">{{ lang['news'] }}</h6>
						<h4 class="h4 mb-1 fw-bold">{{ news_draft + news_unapp + news }}</h4>
						<div class="small text-muted">
							<a href="{{ php_self }}?mod=news">Больше информации</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="col-xl-3 col-md-6">
		<div class="card border-0 shadow-sm h-100">
			<div class="card-body d-flex align-items-center">
				<div class="d-flex align-items-center">
					<div class="flex-shrink-0 me-3">
						<div class="rounded-circle bg-success bg-opacity-10 d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
							<i class="fa fa-picture-o text-success fs-5"></i>
						</div>
					</div>
					<div class="flex-grow-1">
						<h6 class="small text-muted mb-1">{{ lang['images'] }}</h6>
						<h4 class="h4 mb-1 fw-bold">{{ images }}</h4>
						<div class="small text-muted">
							<a href="{{ php_self }}?mod=images">Больше информации</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="col-xl-3 col-md-6">
		<div class="card border-0 shadow-sm h-100">
			<div class="card-body d-flex align-items-center">
				<div class="d-flex align-items-center">
					<div class="flex-shrink-0 me-3">
						<div class="rounded-circle bg-info bg-opacity-10 d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
							<i class="fa fa-file text-info fs-5"></i>
						</div>
					</div>
					<div class="flex-grow-1">
						<h6 class="small text-muted mb-1">{{ lang['files'] }}</h6>
						<h4 class="h4 mb-1 fw-bold">{{ files }}</h4>
						<div class="small text-muted">
							<a href="{{ php_self }}?mod=files">Больше информации</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="col-xl-3 col-md-6">
		<div class="card border-0 shadow-sm h-100">
			<div class="card-body d-flex align-items-center">
				<div class="d-flex align-items-center">
					<div class="flex-shrink-0 me-3">
						<div class="rounded-circle bg-warning bg-opacity-10 d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
							<i class="fa fa-users text-warning fs-5"></i>
						</div>
					</div>
					<div class="flex-grow-1">
						<h6 class="small text-muted mb-1">{{ lang['users'] }}</h6>
						<h4 class="h4 mb-1 fw-bold">{{ users }}</h4>
						<div class="small text-muted">
							<a href="{{ php_self }}?mod=users">Больше информации</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- /top tiles -->
<div class="clearfix"></div>
<div class="row mb-4">
	<div class="col-lg-6">
		<div class="x_panel">
			<div class="x_title">
				<h4>{{ lang['server'] }}</h4>
				<div class="clearfix"></div>
			</div>
			<div id="server-collapse" class="x_content">
				<table class="table table-sm mb-0">
					<tbody>
						<tr>
							<td>{{ lang['os'] }}</td>
							<td>{{ php_os }}</td>
						</tr>
						<tr>
							<td>{{ lang['php_version'] }}</td>
							<td>{{ php_version }}</td>
						</tr>
						<tr>
							<td>{{ lang['mysql_version'] }}</td>
							<td>{{ mysql_version }}</td>
						</tr>
						<tr>
							<td>{{ lang['pdo_support'] }}</td>
							<td>{{ pdo_support }}</td>
						</tr>
						<tr>
							<td>{{ lang['gd_version'] }}</td>
							<td>{{ gd_version }}</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!-- end col-->
	<div class="col-lg-6">
		<div class="x_panel">
			<div class="x_title">
				<h4>Next Generation CMS</h4>
				<div class="clearfix"></div>
			</div>
			<div id="ng-collapse" class="x_content">
				<table class="table table-sm mb-0">
					<tbody>
						<tr>
							<td>{{ lang['current_version'] }}</td>
							<td>{{ currentVersion }}</td>
						</tr>
						<tr>
							<td>{{ lang['last_version'] }}</td>
							<td>
								<span id="syncLastVersion">loading..</span>
							</td>
						</tr>
						<tr>
							<td>{{ lang['git_version'] }}</td>
							<td>
								<span id="syncSVNVersion">loading..</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!-- end col-->
</div>
<!-- end row -->
<div class="row mb-4">
	<div class="col-lg-6">
		<div class="x_panel">
			<div class="x_title">
				<h4>{{ lang['size'] }}</h4>
				<div class="clearfix"></div>
			</div>
			<div id="ng-collapse" class="x_content table-responsive">
				<table id="datatable-responsive" class="table table-sm mb-0">
					<thead>
						<tr>
							<th>{{ lang['group'] }}</th>
							<th>{{ lang['amount'] }}</th>
							<th>{{ lang['volume'] }}</th>
							<th>{{ lang['permissions'] }}</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>{{ lang['group_images'] }}</td>
							<td>{{ image_amount }}</td>
							<td>{{ image_size }}</td>
							<td>{{ image_perm }}</td>
						</tr>
						<tr>
							<td>{{ lang['group_files'] }}</td>
							<td>{{ file_amount }}</td>
							<td>{{ file_size }}</td>
							<td>{{ file_perm }}</td>
						</tr>
						<tr>
							<td>{{ lang['group_avatars'] }}</td>
							<td>{{ avatar_amount }}</td>
							<td>{{ avatar_size }}</td>
							<td>{{ avatar_perm }}</td>
						</tr>
						<tr>
							<td>{{ lang['group_backup'] }}</td>
							<td>{{ backup_amount }}</td>
							<td>{{ backup_size }}</td>
							<td>{{ backup_perm }}</td>
						</tr>
						<tr>
							<td colspan="2">{{ lang['allowed_size'] }}</td>
							<td colspan="2">{{ allowed_size }}</td>
						</tr>
						<tr>
							<td colspan="2">{{ lang['mysql_size'] }}</td>
							<td colspan="2">{{ mysql_size }}</td>
						</tr>
						<tr>
							<td>{{ lang['cache.size'] }}</td>
							<td id="cacheFileCount">-</td>
							<td id="cacheSize">-</td>
							<td class="text-right">
								<div class="btn-group btn-group-sm" role="group">
									<button type="button" onclick="return getCacheSize();" class="btn btn-outline-primary">{{ lang['cache.calculate'] }}</button>
									<button type="button" onclick="return clearCache();" class="btn btn-outline-primary">{{ lang['cache.clean']}}</button>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!-- end col-->
	<div class="col-lg-6">
		<div class="x_panel">
			<div class="x_title">
				<h4>{{ lang['system'] }}</h4>
				<div class="clearfix"></div>
			</div>
			<div id="system-collapse" class="x_content">
				<table class="table table-sm mb-0">
					<tbody>
						<tr>
							<td>{{ lang['all_cats'] }}</td>
							<td>{{ categories }}</td>
						</tr>
						<tr>
							<td>{{ lang['all_news'] }}</td>
							<td>
								<a href="{{ php_self }}?mod=news&status=1">{{ news_draft }}</a>
								/
								<a href="{{ php_self }}?mod=news&status=2">{{ news_unapp }}</a>
								/
								<a href="{{ php_self }}?mod=news&status=3">{{ news }}</a>
							</td>
						</tr>
						<tr>
							<td>{{ lang['all_comments'] }}</td>
							<td>{{ comments }}</td>
						</tr>
						<tr>
							<td>{{ lang['all_users'] }}</td>
							<td>{{ users }}</td>
						</tr>
						<tr>
							<td>{{ lang['all_users_unact'] }}</td>
							<td>{{ users_unact }}</td>
						</tr>
						<tr>
							<td>{{ lang['all_images'] }}</td>
							<td>{{ images }}</td>
						</tr>
						<tr>
							<td>{{ lang['all_files'] }}</td>
							<td>{{ files }}</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!-- end col-->
</div>
<!-- end row -->
<div class="row mb-4">
	<div class="col-lg-12">
		<div class="x_panel">
			<div class="x_title">
				<h4>{{ lang['note'] }}</h4>
				<div class="clearfix"></div>
			</div>
			<div id="note-collapse" class="x_content">
				<form method="post" action="{{ php_self }}?mod=statistics">
					<input type="hidden" name="action" value="save"/>
					<textarea name="note" rows="6" cols="70" class="form-control mb-3" style="background-color: lightyellow;" placeholder="{{ lang['no_notes'] }}">{{ admin_note }}</textarea>
					<button type="submit" class="btn btn-outline-success">{{ lang['save_note'] }}</button>
				</form>
			</div>
		</div>
	</div>
	<!-- end col-->
</div>
<!-- end row -->
<!-- Не понятно, что это и откуда. -->
<style>
	#modalmsgDialog {
		position: absolute;
		left: 0;
		top: 0;
		width: 100%;
		height: 100%;
		display: none;
	}
	#modalmsgWindow {
		margin: 5px;
		padding: 5px;
		border: 1px solid #CCCCCC;
		background-color: #F0F0F0;
		width: 400px;
		position: absolute;
		left: 40%;
		top: 40%;
	}
	#modalmsgWindowText {
		background-color: #FFFFFF;
	}
	#modalmsgWindowButton {
		background-color: #FFFFFF;
		text-align: center;
		padding: 5px;
	}
</style>
<script type="text/javascript">
	function showModal(text) {
document.getElementById('modalmsgDialog').style.display = 'block';
document.getElementById('modalmsgWindowText').innerHTML = text;
}
function _modal_close() {
document.getElementById('modalmsgDialog').style.display = 'none';
}
</script>
<div id="modalmsgDialog" onclick="_modal_close();">
	<span id="modalmsgWindow">
		<div id="modalmsgWindowText"></div>
		<div id="modalmsgWindowButton">
			<input type="button" value="OK"/>
		</div>
	</span>
</div>
<script type="text/javascript">
	function getCacheSize() {
$("#cacheFileCount").html('-');
$("#cacheSize").html('-');
post('admin.statistics.getCacheSize', {
'token':'{{ token }}'
}, false).then(function (response) {
if (response.numFiles) {
$("#cacheFileCount").html(response.numFiles);
$("#cacheSize").html(response.size);
}
});
return false;
}
function clearCache() {
$("#cacheFileCount").html('-');
$("#cacheSize").html('-');
post('admin.statistics.cleanCache', {
'token':'{{ token }}'
}, false).then(function (response) {
getCacheSize();
});
return false;
}
function coreVersionSync() {
post('admin.statistics.coreVersionSync', {
'token':'{{ token }}'
}, false).then(function (response) {});
return false;
}
</script>
<script>
	$(function () {
var reqReleas = "https://api.github.com/repos/irbees2008/ngcms-core/releases/latest";
requestJSON(reqReleas, function (json) {
try {
if (! json || json.message === 'Not Found') {
$('#syncLastVersion').text('No Info Found');
return;
}
var currentVersion = '{{ currentVersion }}';
var engineVersionBuild = '{{ engineVersionBuild }}';
var publish = json.published_at || '';
if (currentVersion && publish && currentVersion >= json.tag_name && engineVersionBuild >= publish.split('T')[0]) {
$('#needUpdate').text('Обновление не требуется');
} else {
$('#needUpdate').text('Обновите CMS');
}
if (json.tag_name) {
$('#syncLastVersion').html('<a href="' + (
json.zipball_url || '#'
) + '">' + json.tag_name + '</a>' + (
json.published_at ? ' [ ' + json.published_at.slice(0, 10) + ' ]' : ''
));
} else {
$('#syncLastVersion').text('No Info Found');
}
} catch (e) {
$('#syncLastVersion').text('No Info Found');
}
});
var reqCommit = "https://api.github.com/repos/irbees2008/ngcms-core/commits";
requestJSON(reqCommit, function (json) {
try {
if (! json || json.message === 'Not Found') {
$('#syncSVNVersion').text('No Info Found');
return;
}
if (Array.isArray(json) && json.length > 0) {
var c = json[0];
var sha = (c && c.sha) ? c.sha.slice(0, 7) : '';
var html = (c && c.html_url) ? c.html_url : '#';
var committer = (c && c.committer && c.committer.login) ? c.committer.login : (c && c.commit && c.commit.author && c.commit.author.name) ? c.commit.author.name : '';
var committerUrl = (c && c.committer && c.committer.html_url) ? c.committer.html_url : '#';
var date = (c && c.commit && c.commit.author && c.commit.author.date) ? c.commit.author.date.slice(0, 10) : '';
$('#syncSVNVersion').html('<a href="' + html + '" target="_blank">' + sha + '</a> <b>@</b> <a href="' + committerUrl + '" target="_blank">' + committer + '</a>' + (
date ? ' [ ' + date + ' ]' : ''
));
} else if (json && json.message) {
$('#syncSVNVersion').text('No Info Found');
} else {
$('#syncSVNVersion').text('No Info Found');
}
} catch (e) {
$('#syncSVNVersion').text('No Info Found');
}
});
coreVersionSync();
function requestJSON(url, callback) {
$.ajax({
url: url,
dataType: 'json',
headers: {
'Accept': 'application/vnd.github+json'
},
beforeSend: function (jqXHR) {
try {
jqXHR.overrideMimeType && jqXHR.overrideMimeType('application/json; charset=UTF-8');
} catch (e) {}
// Repeat send header ajax
try {
jqXHR.setRequestHeader && jqXHR.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
} catch (e) {}
}
}).done(function (data) {
if (data && (Array.isArray(data) || typeof data === 'object')) {
callback.call(null, data);
} else {
if (window.$ && $.notify) {
$.notify({
message: '<i><b>Bad reply from server</b></i>'
}, {type: 'danger'});
}
}
}).fail(function () { // При ошибке не оставляем вечный `loading..`
if ($('#syncLastVersion').text().indexOf('loading') !== -1) {
$('#syncLastVersion').text('No Info Found');
}
if ($('#syncSVNVersion').text().indexOf('loading') !== -1) {
$('#syncSVNVersion').text('No Info Found');
}
if (window.$ && $.notify) {
$.notify({
message: '<i><b>Bad reply from server</b></i>'
}, {type: 'danger'});
}
});
}
});
</script>
