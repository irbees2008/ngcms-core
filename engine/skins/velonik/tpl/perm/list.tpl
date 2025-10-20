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
<style>
	.pChanged {
		border-color: var(--warning);
	}
</style>
<script type="text/javascript">
	var permDefault = {{ DEFAULT_JSON }};
function onUpdatePerm(name) {
var f = document.getElementById('permSubmit');
var v = permDefault[name];
f[name].classList.toggle('pChanged', f[name].value != v);
}
// Перехватываем submit и сохраняем права через AJAX, чтобы не открывать страницу с JSON
document.addEventListener('DOMContentLoaded', function () {
var form = document.getElementById('permSubmit');
if (! form) 
return;
form.addEventListener('submit', function (e) {
e.preventDefault();
var fd = new FormData(form);
fd.append('ajax', '1');
var btn = form.querySelector('button[type="submit"]');
if (btn) {
btn.disabled = true;
btn.dataset._old = btn.innerHTML;
btn.innerHTML = '{{ lang['saving']|default('Сохранение...')|e('js') }}';
}
fetch('admin.php?mod=perm', {
method: 'POST',
body: fd,
credentials: 'same-origin'
}).then(function (r) {
return r.json();
}).then(function (data) {
if (data && data.success) {
var header = '{{ lang['permissions']|e('js') }}:   {{ lang['success']|e('js') }}';
var lines = [];
var maxLines = 12;
if (Array.isArray(data.changes) && data.changes.length) {
for (var i = 0; i < data.changes.length && i < maxLines; i++) {
var ch = data.changes[i];
var groupTitle = ch.groupTitle || ch.group;
var title = ch.title || ch.id;
var line = '[' + groupTitle + '] ' + title + ': ' + ch.displayOld + ' → ' + ch.displayNew;
lines.push(line);
}
if (data.changes.length > maxLines) {
lines.push('… +' + (
data.changes.length - maxLines
) + '   {{ lang['other']|default('ещё')|e('js') }}');
}
} else {
lines.push('{{ lang['no_changes']|default('Изменений нет')|e('js') }}');
}
// Сформируем HTML для стикера
var listHtml = '<div style="max-width:560px">' + '<div style="font-weight:600;margin:0 0 6px">' + header + ' (' + (
data.updated || 0
) + ')</div>' + '<div style="max-height:300px;overflow:auto;border:1px solid #e2e6ea;border-radius:4px;padding:6px;background:#fff">' + '<ol style="margin:0;padding-left:18px;max-width:100%">' + lines.map(function (l) {
return '<li style="margin:2px 0;word-wrap:break-word">' + l.replace(/</g, '&lt;') + '</li>';
}).join('') + '</ol></div></div>';
if (window.ngNotifySticker) {
ngNotifySticker(listHtml, {
className: 'alert-success',
closeBTN: true,
html: true,
time: 8000
});
} else {
alert(header + '\n' + lines.join('\n'));
}
// Обновим permDefault и снимем подсветку изменений
if (Array.isArray(data.changes)) {
data.changes.forEach(function (ch) {
if (ch.formName && form.elements[ch.formName]) {
permDefault[ch.formName] = form.elements[ch.formName].value;
form.elements[ch.formName].classList.remove('pChanged');
}
});
}
} else {
var errTitle = '{{ lang['result']|e('js') }}:   {{ lang['error']|e('js') }}';
if (window.ngNotifySticker) {
ngNotifySticker(errTitle, {
className: 'alert-danger',
closeBTN: true
});
} else {
alert(errTitle);
}
}
}).catch(function (err) {
console.error('Permissions save error', err);
var msg = 'Network/JS error';
if (window.ngNotifySticker) {
ngNotifySticker(msg, {
className: 'alert-danger',
closeBTN: true
});
} else {
alert(msg);
}
}). finally(function () {
if (btn) {
btn.disabled = false;
btn.innerHTML = btn.dataset._old || '{{ lang['save']|e('js') }}';
}
});
});
});
</script>
<!-- Form header -->
<form id="permSubmit" name="permSubmit" method="post">
	<input type="hidden" name="token" value="{{ token }}"/>
	<input
	type="hidden" name="save" value="1"/>
	<!-- /Form header -->
	<div class="x_panel mb-4">
		<div
			class="x_content">
			<!-- Group menu header -->
			<ul class="nav nav-pills mb-3 d-md-flex d-block" role="tablist">
				{% for group in GRP %}
					<li class="nav-item">
						<a href="#userTabs-{{ group.id }}" class="nav-link {{ loop.first ? 'active' : '' }}" data-toggle="tab">{{ group.title }}</a>
					</li>
				{% endfor %}
			</ul>
			<!-- Group content header -->
			<div id="userTabs" class="tab-content">
				{% for group in GRP %}
					<!-- Content for group [{{ group.id }}] {{ group.title }} -->
					<div id="userTabs-{{ group.id }}" class="tab-pane {{ loop.first ? 'show active' : '' }}">
						<div class="alert alert-info">
							{{ lang['permissions_for_user_group'] }}:
							<b>{{ group.title }}</b>
						</div>
						{% for block in CONFIG %}
							<div class="pconf">
								<h3>{{ block.title }}</h3>
								{% if (block.description) %}
									<div class="alert alert-info">{{ block.description }}</div>
								{% endif %}
								{% for area in block.items %}
									<h4>{{ area.title }}</h4>
									{% if (area.description) %}
										<div class="alert alert-info">{{ area.description }}</div>
									{% endif %}
									<table class="table table-sm">
										<thead>
											<tr>
												<th>#ID</th>
												<th>{{ lang['description'] }}</th>
												<th>{{ lang['access'] }}</th>
											</tr>
										</thead>
										<tbody>
											{% for entry in area.items %}
												<tr>
													<td width="220">
														<b>{{ entry.id }}</b>
													</td>
													<td>{{ entry.title }}</td>
													<td width="110">
														<select name="{{ entry.name }}|{{ group.id }}" onchange="onUpdatePerm('{{ entry.name }}|{{ group.id }}');" class="form-select custom-select-sm">
															<option value="-1">--</option>
															<option value="0" {{ isSet(entry.perm[group.id]) and (not entry.perm[group.id]) ? 'selected' : '' }}>{{ lang['noa'] }}</option>
															<option value="1" {{ isSet(entry.perm[group.id]) and (entry.perm[group.id]) ? 'selected' : '' }}>{{ lang['yesa'] }}</option>
														</select>
													</td>
												</tr>
											{% endfor %}
										</tbody>
									</table>
									<br/>
								{% endfor %}
							</div>
						{% endfor %}
					</div>
					<!-- /Content for group [{{ group.id }}] {{ group.title }} -->
				{% endfor %}
			</div>
		</div>
	</div>
	<div class="form-group my-3 text-center">
		<button type="submit" class="btn btn-outline-success">{{ lang['save'] }}</button>
	</div>
</form>
