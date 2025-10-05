<div class="container-fluid">
	<div class="row mb-2">
		<div class="col-sm-6 d-none d-md-block ">
			<h1 class="m-0 text-dark">{{ lang['permissions'] }}</h1>
		</div>
		<!-- /.col -->
		<div class="col-sm-6">
			<ol class="breadcrumb float-sm-right">
				<li class="breadcrumb-item">
					<a href="admin.php">
						<i class="fa fa-home"></i>
					</a>
				</li>
				<li class="breadcrumb-item active" aria-current="page">{{ lang['permissions'] }}</li>
			</ol>
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</div>
<!-- /.container-fluid -->

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

// AJAX сохранение без перехода на страницу результата
document.addEventListener('DOMContentLoaded', function () {
var form = document.getElementById('permSubmit');
if (! form) 
return;


form.addEventListener('submit', function (e) {
e.preventDefault();
var fd = new FormData(form);
fd.append('ajax', '1');

const btn = form.querySelector('button[type="submit"]');
if (btn) {
btn.disabled = true;
btn.dataset._old = btn.innerHTML;
btn.innerHTML = '{{ lang['saving']|default('Сохранение...')|e('js') }}';
}

fetch('admin.php?mod=perm', {
method: 'POST',
body: fd,
credentials: 'same-origin'
}).then(r => r.json()).then(data => {
if (data.success) {
let header = '{{ lang['permissions']|e('js') }}:  {{ lang['success']|e('js') }}';
let bodyMsg = '';
if (Array.isArray(data.changes) && data.changes.length) {
const maxLines = 12; // ограничим подробный вывод
let lines = [];
for (let i = 0; i < data.changes.length; i++) {
if (i >= maxLines) 
break;

const ch = data.changes[i];
// Формат: [Group] Title: OLD -> NEW
let line = '[' + (
ch.groupTitle || ch.group
) + '] ' + (
ch.title || ch.id
) + ': ' + ch.displayOld + ' → ' + ch.displayNew;
lines.push(line);
}
if (data.changes.length > maxLines) {
lines.push('… +' + (
data.changes.length - maxLines
) + '  {{ lang['other']|default('ещё')|e('js') }}');
}
bodyMsg = lines.join('\n');
} else {
bodyMsg = '{{ lang['no_changes']|default('Изменений нет')|e('js') }}';
}
// Формируем HTML для notify (showToast)
let htmlList = '';
if (bodyMsg) {
let items = bodyMsg.split('\n').map(l => '<li style="margin:2px 0;word-wrap:break-word">' + l.replace(/</g, '&lt;') + '</li>').join('');
htmlList = '<div class="perm-toast-wrapper" style="max-width:560px">' + '<div style="font-weight:600;margin:0 0 6px">' + header + ' (' + (
data.updated || 0
) + ')</div>' + '<div class="perm-toast-scroll" style="max-height:300px;overflow:auto;border:1px solid #e2e6ea;border-radius:4px;padding:6px;background:#fff">' + '<ol style="margin:0;padding-left:18px;max-width:100%">' + items + '</ol>' + '</div>' + '<div style="margin-top:8px;display:flex;gap:6px;flex-wrap:wrap">' + '<button type="button" class="btn btn-sm btn-outline-secondary perm-copy-btn">Copy</button>' + '<button type="button" class="btn btn-sm btn-outline-secondary perm-close-btn"> {{ lang['close']|default('Закрыть')|e('js') }}</button>' + '</div>' + '</div>';
}
try {
if (window.showToast) {
let toast = showToast(htmlList, {
type: 'success',
title: '{{ lang['permissions']|e('js') }}',
sticked: true,
timeout: 0
});
// Навешиваем обработчики на кнопки внутри тоста
setTimeout(() => {
if (! toast) 
return;

let copyBtn = toast.querySelector('.perm-copy-btn');
let closeBtn = toast.querySelector('.perm-close-btn');
if (copyBtn) {
copyBtn.addEventListener('click', () => {
try {
navigator.clipboard.writeText(bodyMsg);
copyBtn.textContent = 'OK';
setTimeout(() => copyBtn.textContent = 'Copy', 1500);
} catch (e) {}
});
}
if (closeBtn) {
closeBtn.addEventListener('click', () => {
try {
toast.parentNode && toast.parentNode.removeChild(toast);
} catch (e) {}
});
}
}, 30);
} else if (window.show_info) {
show_info(bodyMsg);
} else {
alert(header + '\n' + bodyMsg);
}
} catch (ex) {}
// Сбрасываем подсветку изменённых полей и обновляем permDefault
if (Array.isArray(data.changes)) {
data.changes.forEach(ch => {
if (ch.formName && form.elements[ch.formName]) {
permDefault[ch.formName] = form.elements[ch.formName].value;
form.elements[ch.formName].classList.remove('pChanged');
}
});
}
} else {
try {
if (window.show_error) {
show_error('{{ lang['result']|e('js') }}:  {{ lang['error']|e('js') }}');
} else {
alert('{{ lang['result']|e('js') }}:  {{ lang['error']|e('js') }}');
}
} catch (ex) {}
}
}).catch(err => {
console.error('Permissions save error', err);
try {
if (window.show_error) {
show_error('Network/JS error');
} else {
alert('Network/JS error');
}
} catch (ex) {}
}). finally(() => {
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
	<input type="hidden" name="save" value="1"/>
	<!-- /Form header -->

	<!-- Group menu header -->
		<ul class="nav nav-pills mb-3 d-md-flex d-block" role="tablist"> {% for group in GRP %}
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
										<tr class="contentEntry1">
											<td width="220">
												<b>{{ entry.id }}</b>
											</td>
											<td>{{ entry.title }}</td>
											<td width="110">
												<select name="{{ entry.name }}|{{ group.id }}" onchange="onUpdatePerm('{{ entry.name }}|{{ group.id }}');" class="custom-select custom-select-sm">
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

	<div class="form-group my-3 text-center">
		<button type="submit" class="btn btn-outline-success">{{ lang['save'] }}</button>
	</div>
</form>
