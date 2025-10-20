<!-- Оставляем эти скрипты и формы так как ими могут пользоваться плагины -->
<script type="text/javascript" src="{{ home }}/lib/ajax.js"></script>
<script type="text/javascript" src="{{ home }}/lib/libsuggest.js"></script>
<!-- Preload JS/CSS for plugins -->
{{ preloadRAW }}
<!-- /end preload -->
<!-- Hidden SUGGEST div -->
<!-- <div id="suggestWindow" class="suggestWindow">
	<table id="suggestBlock" cellspacing="0" cellpadding="0" width="100%"></table>
	<a href="#" align="right" id="suggestClose">close</a>
</div> -->
	<script>
$(function () {
$("#newsTitle").on({
blur: function () {
if ($(this).val().length > 2) {
$.post('/engine/actions/news_relates.php', {
title: $(this).val()
}, function (data) {
$('#news_relates').fadeIn(300).html(data);
});
} else 
$('#news_relates').fadeOut(300);
return false;
}
});
})
</script>
	<form name="DATA_tmp_storage" action="" id="DATA_tmp_storage"> <input type="hidden" name="area" value=""/>
</form>
<!-- start page title -->
<div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="admin.php">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item">
				<a href="{{ php_self }}?mod=news">{{ lang.addnews['news_title'] }}</a>
			</li>
			<li class="breadcrumb-item">{{ lang.addnews['addnews_title'] }}</li>
		</ol>
		<h4>{{ lang.addnews['addnews_title'] }}</h4>
	</div>
</div>
<!-- end page title -->
<!-- Main content form -->
<form id="postForm" name="form" enctype="multipart/form-data" method="post" action="{{ php_self }}" target="_self">
	<input type="hidden" name="token" value="{{ token }}"/>
	<input type="hidden" name="mod" value="news"/>
	<input type="hidden" name="action" value="add"/>
	<input type="hidden" name="subaction" value="submit"/>
	<div
		class="row">
		<!-- Left edit column -->
		<div
			class="col-lg-8">
			<!-- MAIN CONTENT -->
			<div id="maincontent" class="x_panel mb-4">
				<div class="x_title">
					<i class="fa fa-th-list"></i>
					{{ lang.addnews['bar.maincontent'] }}
				</div>
				<div class="x_content">
					<div class="form-row mb-3">
						<label class="form-label">{{ lang.addnews['title'] }}</label>
						<input id="newsTitle" type="text" name="title" value="" class="form-control"/>
						<ul id="news_relates"></ul>
					</div>
					{% if not flags['altname.disabled'] %}
						<div class="form-row mb-3">
							<label class="form-label">{{ lang.addnews['alt_name'] }}</label>
							<input type="text" name="alt_name" value="" class="form-control"/>
						</div>
					{% endif %}
					<div class="form-row mb-3">
						<label for="category-select" class="form-label">{{ lang.addnews['category'] }}
							{% if (flags.mondatory_cat) %}
								<span style="font-size: 16px; color: red;">
									<b>*</b>
								</span>
							{% endif %}
						</label>
						<div class="ng-select">{{ mastercat }}</div>
					</div>
					{% if (not flags.disableTagsSmilies) %}
						<!-- SMILES -->
						<div id="modal-smiles" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="smiles-modal-label" aria-hidden="true">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<h4 class="modal-title" id="smiles-modal-label">Вставить смайл</h4>
										<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
									</div>
									<div class="modal-body">
										{{ smilies }}
									</div>
									<div class="modal-footer">
										<button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
									</div>
								</div>
							</div>
						</div>
					{% endif %}
					{% if (flags.edit_split) %}
						<div id="container.content.short" class="mb-3 bb-editor">
							{{ quicktags }}
							<textarea id="ng_news_content_short" name="ng_news_content_short" onclick="changeActive('short');" onfocus="changeActive('short');" class="{{ editorClassName ? editorClassName : 'form-control' }}" rows="10"></textarea>
						</div>
						{% if (flags.extended_more) %}
							<div class="mb-3">
								<label for="simpleinput" class="form-label">{{ lang.addnews['editor.divider'] }}</label>
								<input type="text" name="content_delimiter" value="" class="form-control"/>
							</div>
						{% endif %}
						<div id="container.content.full" class="mb-3 bb-editor">
							{{ quicktags }}
							<textarea id="ng_news_content_full" name="ng_news_content_full" onclick="changeActive('full');" onfocus="changeActive('full');" class="{{ editorClassName ? editorClassName : 'form-control' }}" rows="10"></textarea>
						</div>
					{% else %}
						<div id="container.content" class="mb-3 bb-editor">
							{{ quicktags }}
							<textarea id="ng_news_content" name="ng_news_content" class="{{ editorClassName ? editorClassName : 'form-control' }}" rows="10"></textarea>
						</div>
					{% endif %}
					{% if (flags.meta) %}
						<div class="mb-3">
							<label for="example-textarea" class="form-label">{{ lang.addnews['description'] }}</label>
							<textarea name="description" cols="80" class="form-control"></textarea>
						</div>
						<div class="mb-3">
							<label for="example-textarea" class="form-label">{{ lang.addnews['keywords'] }}</label>
							<textarea name="keywords" cols="80" class="form-control"></textarea>
						</div>
						{% if (pluginIsActive('autokeys')) %}
							{{ plugin.autokeys }}
						{% endif %}
					{% endif %}
				</div>
				{% if (pluginIsActive('xfields')) %}
					<table class="table table-sm mb-0 ng-select">
						<tbody>
							<!-- XFields -->
							{{ plugin.xfields[1] }}
							<!-- /XFields -->
						</tbody>
					</table>
				{% endif %}
			</div>
			<!-- ADDITIONAL -->
			<div class="accordion mb-2" id="additional">
				<div class="accordion-item">
					<h2 class="accordion-header" id="panelsStayOpen-headingTwo">
						<button class="accordion-button fw-medium collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseNewsAdditional" aria-expanded="false" aria-controls="collapseNewsAdditional">
							{{ lang.addnews['bar.additional'] }}
						</button>
					</h2>
					<div id="collapseNewsAdditional" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingTwo">
						<div class="accordion-body">
							<table class="table table-sm mb-0 ng-select">
								<tbody>
									{% if (pluginIsActive('xfields')) %}
										<!-- XFields -->
										{{ plugin.xfields[0] }}
										<!-- /XFields -->
									{% endif %}
									{% if (pluginIsActive('nsched')) %}
										{{ plugin.nsched }}
									{% endif %}
									{% if (pluginIsActive('finance')) %}
										{{ plugin.finance }}
									{% endif %}
									{% if (pluginIsActive('tags')) %}
										{{ plugin.tags }}
									{% endif %}
									{% if (pluginIsActive('tracker')) %}
										{{ plugin.tracker }}
									{% endif %}
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<!-- ATTACHES -->
			<div class="accordion mb-2" id="attaches">
				<div class="accordion-item">
					<h2 class="accordion-header" id="panelsStayOpen-headingThree">
						<button class="accordion-button fw-medium collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseNewsAttaches" aria-expanded="false" aria-controls="collapseNewsAttaches">
							{{ lang.addnews['bar.attaches'] }}
						</button>
					</h2>
					<div id="collapseNewsAttaches" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingThree">
						<div class="accordion-body">
							<table id="attachFilelist" class="table table-sm mb-0">
								<thead>
									<tr>
										<th>#</th>
										<th width="80">{{ lang.editnews['attach.date'] }}</th>
										<th>{{ lang.editnews['attach.filename'] }}</th>
										<th width="90">{{ lang.editnews['attach.size'] }}</th>
										<th width="40">DEL</th>
									</tr>
								</thead>
								<tbody>
									<!-- <tr><td>*</td><td>New file</td><td colspan="2"><input type="file"/></td><td><input type="button" size="40" value="-"/></td></tr> -->
									<tr>
										<td colspan="5" class="text-right">
											<input type="button" value="{{ lang.editnews['attach.more_rows'] }}" class="btn btn-sm btn-outline-primary" onclick="attachAddRow();"/>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- Right edit column -->
		<div id="rightBar" class="col col-lg-4">
			{% if flags['multicat.show'] and extcat is not empty %}
				<div class="x_panel mb-4">
					<div class="x_title">{{ lang['editor.extcat'] }}</div>
					<div class="x_content">
						<div style="overflow: auto; height: 150px;">{{ extcat }}</div>
					</div>
				</div>
			{% endif %}
			<div class="x_panel mb-4">
				<div class="x_title">{{ lang['editor.configuration'] }}</div>
				<div class="x_content">
					<div class="form-check mb-2">
						<input id="mainpage" type="checkbox" name="mainpage" value="1" class="form-check-input" {% if (flags.mainpage) %} checked {% endif %} {% if flags['mainpage.disabled'] %} disabled {% endif %}>
						<label class="form-check-label" for="mainpage">{{ lang.addnews['mainpage'] }}</label>
					</div>
					<div class="form-check mb-2">
						<input id="pinned" type="checkbox" name="pinned" value="1" class="form-check-input" {% if (flags.pinned) %} checked {% endif %} {% if flags['pinned.disabled'] %} disabled {% endif %}>
						<label class="form-check-label" for="pinned">{{ lang.addnews['add_pinned'] }}</label>
					</div>
					<div class="form-check mb-2">
						<input id="catpinned" type="checkbox" name="catpinned" value="1" class="form-check-input" {% if (flags.catpinned) %} checked {% endif %} {% if flags['catpinned.disabled'] %} disabled {% endif %}>
						<label class="form-check-label" for="catpinned">{{ lang.addnews['add_catpinned'] }}</label>
					</div>
					<div class="form-check mb-2">
						<input id="favorite" type="checkbox" name="favorite" value="1" class="form-check-input" {% if (flags.favorite) %} checked {% endif %} {% if flags['favorite.disabled'] %} disabled {% endif %}>
						<label class="form-check-label" for="favorite">{{ lang.addnews['add_favorite'] }}</label>
					</div>
					<div class="form-check mb-2">
						<input id="flag_HTML" type="checkbox" name="flag_HTML" value="1" class="form-check-input" {% if (flags['html']) %} checked {% endif %} {% if (flags['html.disabled']) %} disabled {% endif %}>
						<label class="form-check-label" for="flag_HTML">{{ lang.addnews['flag_html'] }}</label>
					</div>
					<div class="form-check mb-2">
						<input id="flag_RAW" type="checkbox" name="flag_RAW" value="1" class="form-check-input" {% if (flags['raw']) %} checked {% endif %} {% if (flags['html.disabled']) %} disabled {% endif %}>
						<label class="form-check-label" for="flag_RAW">{{ lang.addnews['flag_raw'] }}</label>
					</div>
				</div>
			</div>
			{% if not flags['customdate.disabled'] %}
				<div class="x_panel mb-4">
					<div class="x_title">{{ lang.addnews['custom_date'] }}</div>
					<div class="x_content">
						<div class="form-check mb-2">
							<input type="checkbox" id="customdate" name="customdate" value="1" class="form-check-input" onclick="var el=document.getElementById('setdate_current');if(el)el.checked=false;">
							<label class="form-check-label" for="customdate">{{ lang.editnews['date.setdate'] }}</label>
						</div>
						<div class="form-group">
							<input id="cdate" type="text" name="cdate" value="" class="form-control" pattern="[0-9]{2}\.[0-9]{2}\.[0-9]{4} [0-9]{2}:[0-9]{2}" placeholder="{{ "now" | date('d.m.Y H:i') }}" autocomplete="off">
						</div>
					</div>
				</div>
			{% endif %}
			{% if (pluginIsActive('comments')) %}
				<div class="x_panel mb-4">
					<div class="x_title">{{ lang['comments:mode.header'] }}</div>
					<div class="x_content">
						<select name="allow_com">
							<option value="0" {{ plugin.comments['acom:0'] }}>{{ lang['comments:mode.disallow'] }}</option>
							<option value="1" {{ plugin.comments['acom:1'] }}>{{ lang['comments:mode.allow'] }}</option>
							<option value="2" {{ plugin.comments['acom:2'] }}>{{ lang['comments:mode.default'] }}</option>
						</select>
					</div>
				</div>
			{% endif %}
			<script>
				$(function () {
if ($.fn.datetimepicker) { // Инициализируем, но не показываем сразу
$('#cdate').datetimepicker({
format: 'd.m.Y H:i',
lang: 'ru',
step: 5,
lazyInit: true,
inline: false,
closeOnDateSelect: false,
validateOnBlur: false
}).datetimepicker('hide');
// Показываем пикер только при фокусе поля
$('#cdate').on('focus', function () {
$(this).datetimepicker('show');
});
}
});
			</script>
			<div class="input-group">
				<select class="form-select" name="approve">
					{% if flags['can_publish'] %}
						<option value="1">{{ lang.addnews['publish'] }}</option>
					{% endif %}
					<option value="0">{{ lang.addnews['send_moderation'] }}</option>
					<option value="-1">{{ lang.addnews['save_draft'] }}</option>
				</select>
				<button class="btn btn-outline-primary" type="submit">
					<span class="d-xl-none">
						<i class="fa fa-floppy-o"></i>
					</span>
					<span class="d-none d-xl-block">{{ lang.addnews['addnews'] }}</span>
				</button>
			</div>
			<button type="button" class="btn btn-outline-success" onclick="return preview();">
				<span class="d-xl-none">
					<i class="fa fa-eye"></i>
				</span>
				<span class="d-none d-xl-block">{{ lang.addnews['preview'] }}</span>
			</button>
		</div>
	</div>
	{% if (pluginIsActive('xfields')) %}
		<!-- XFields [GENERAL] -->
		{{ plugin.xfields.general }}
		<!-- /XFields [GENERAL] -->
	{% endif %}
</form>
<script type="text/javascript">
	// Global variable: ID of current active input area (must match existing textarea ID)
var currentInputAreaID = "{{ flags.edit_split ? 'ng_news_content_short' : 'ng_news_content' }}";
console.log('currentInputAreaID:', currentInputAreaID, 'element:', document.getElementById(currentInputAreaID));
function preview() {
var form = document.getElementById("postForm");
if (form.querySelector('[name*=ng_news_content]').value == '' || form.title.value == '') {
alert('{{ lang.addnews['msge_preview'] }}');
return false;
}
form['mod'].value = "preview";
form.target = "_blank";
form.submit();
form['mod'].value = "news";
form.target = "_self";
return true;
}
function changeActive(name) {
if (name == 'full') {
var fullBox = document.getElementById('container.content.full');
var shortBox = document.getElementById('container.content.short');
if (fullBox && shortBox) {
fullBox.className = 'contentActive';
shortBox.className = 'contentInactive';
}
currentInputAreaID = 'ng_news_content_full';
} else {
var shortBox2 = document.getElementById('container.content.short');
var fullBox2 = document.getElementById('container.content.full');
if (shortBox2 && fullBox2) {
shortBox2.className = 'contentActive';
fullBox2.className = 'contentInactive';
}
currentInputAreaID = 'ng_news_content_short';
}
}
</script>
<script type="text/javascript">
	// Helper to get current textarea for BBCode
function getCurrentTextarea() {
var el = document.getElementById(currentInputAreaID);
if (! el) { // try fallback order
el = document.getElementById('ng_news_content_short') || document.getElementById('ng_news_content_full') || document.getElementById('ng_news_content');
if (el) {
currentInputAreaID = el.id;
}
}
return el;
}
// Restore variables if needed
var jev = {{ JEV }};
var form = document.getElementById('postForm');
for (i in jev) { // try { alert(i+' ('+form[i].type+')'); } catch (err) {;}
if (typeof(jev[i]) == 'object') {
for (j in jev[i]) { // alert(i+'['+j+'] = '+ jev[i][j]);
try {
form[i + '[' + j + ']'].value = jev[i][j];
} catch (err) {;
}
}
} else {
try {
if ((form[i].type == 'text') || (form[i].type == 'textarea') || (form[i].type == 'select-one')) {
form[i].value = jev[i];
} else if (form[i].type == 'checkbox') {
form[i].checked = (jev[i] ? true : false);
}
} catch (err) {;
}
}
}
</script>
<script type="text/javascript">
	function attachAddRow() {
var tbl = document.getElementById('attachFilelist');
var lastRow = tbl.rows.length;
var row = tbl.insertRow(lastRow - 1);
// Add cells
row.insertCell(0).innerHTML = '*';
row.insertCell(1).innerHTML = '{{ lang.editnews['attach.new_file'] }}';
// Add file input
var el = document.createElement('input');
el.setAttribute('type', 'file');
el.setAttribute('name', 'userfile[' + (
++ attachAbsoluteRowID
) + ']');
el.setAttribute('size', '80');
var xCell = row.insertCell(2);
xCell.colSpan = 2;
xCell.appendChild(el);
el = document.createElement('input');
el.setAttribute('type', 'button');
el.setAttribute('onclick', 'document.getElementById("attachFilelist").deleteRow(this.parentNode.parentNode.rowIndex);');
el.setAttribute('value', '-');
el.setAttribute('class', 'btn btn-sm btn-outline-danger');
row.insertCell(3).appendChild(el);
}
// Add first row
var attachAbsoluteRowID = 0;
attachAddRow();
</script>
