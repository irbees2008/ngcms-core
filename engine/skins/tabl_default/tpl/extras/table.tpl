<div class="container-fluid">
	<div class="row mb-2">
		<div class="col-sm-6 d-none d-md-block ">
			<h1 class="m-0 text-dark">{{ lang['extras'] }}</h1>
		</div>
		<!-- /.col -->
		<div class="col-12 col-sm-6">
			<ol class="breadcrumb float-sm-right">
				<li class="breadcrumb-item">
					<a href="admin.php">
						<i class="fa fa-home"></i>
					</a>
				</li>
				<li class="breadcrumb-item active" aria-current="page">{{ lang['extras'] }}</li>
			</ol>
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</div>
<!-- /.container-fluid -->
<div class="input-group mb-3">
	<input type="text" id="searchInput" class="form-control" placeholder="{{ lang['extras.search'] }}">
	<div class="input-group-append">
		<span class="input-group-text">
			<i class="fa fa-search"></i>
		</span>
	</div>
</div>
<ul class="nav nav-tabs nav-fill mb-3 d-md-flex d-block">
	<li class="nav-item">
		<a href="#" class="nav-link active" data-filter="pluginEntryActive">{{ lang['list.active'] }}
			<span class="badge badge-light">{{ cntActive }}</span>
		</a>
	</li>
	<li class="nav-item">
		<a href="#" class="nav-link" data-filter="pluginEntryInactive">{{ lang['list.inactive'] }}
			<span class="badge badge-light">{{ cntInactive }}</span>
		</a>
	</li>
	<li class="nav-item">
		<a href="#" class="nav-link" data-filter="pluginEntryUninstalled">{{ lang['list.needinstall'] }}
			<span class="badge badge-light">{{ cntUninstalled }}</span>
		</a>
	</li>
	<li class="nav-item">
		<a href="#" class="nav-link" data-filter="all">{{ lang['list.all'] }}
			<span class="badge badge-light">{{ cntAll }}</span>
		</a>
	</li>
</ul>
<div class="table-responsive">
	<table class="table table-sm">
		<thead>
			<tr>
				<th></th>
				<th>{{ lang['id'] }}</th>
				<th>{{ lang['title'] }}</th>
				<th>{{ lang['type'] }}</th>
				<th>{{ lang['version'] }}</th>
				<th>&nbsp;</th>
				<th>{{ lang['description'] }}</th>
				<th>{{ lang['author'] }}</th>
				<th>{{ lang['action'] }}</th>
			</tr>
		</thead>
		<tbody id="entryList">
			{% for entry in entries %}
				<tr class="{{ entry.style }} all" id="plugin_{{ entry.id }}">
					<td>
						{% if entry.flags.isCompatible %}<img src="{{ skins_url }}/images/msg.png">
							{% else %}
						{% endif %}
					</td>
					<td nowrap>{{ entry.id }}
						{{ entry.new }}</td>
					<td>{{ entry.url }}</td>
					<td>{{ entry.type }}</td>
					<td>{{ entry.version }}</td>
					<td nowrap>
						<a href="{{ entry.readme }}" title="Документация">
							<i class="fa fa-file-word-o" aria-hidden="true"></i>
						</a>|
						<a href="{{ entry.history }}" title="История">
							<i class="fa fa-history" aria-hidden="true"></i>
						</a>
					</td>
					<td>{{ entry.description }}</td>
					<td>{{ entry.author_url }}</td>
					<td nowrap>{{ entry.link }}
						{{ entry.install }}</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
</div>
<script>
	document.addEventListener('DOMContentLoaded', function () { // Обработчик для README
const readmeLinks = document.querySelectorAll('.open-modal[data-bs-target="#readmeModal"]');
readmeLinks.forEach(link => {
link.addEventListener('click', function () {
const url = this.getAttribute('data-url');
document.getElementById('readmeContent').src = url;
});
});
// Обработчик для истории
const historyLinks = document.querySelectorAll('.open-modal[data-bs-target="#historyModal"]');
historyLinks.forEach(link => {
link.addEventListener('click', function () {
const url = this.getAttribute('data-url');
document.getElementById('historyContent').src = url;
});
});
// --- Фильтр вкладок ---
const filterButtons = document.querySelectorAll('.nav-tabs .nav-link');
const pluginRows = document.querySelectorAll('#entryList tr');
const LS_KEY = 'extrasSelectedFilter';
let currentFilter = 'pluginEntryActive';
let currentQuery = '';
function saveSelectedFilter(filter) {
try {
localStorage.setItem(LS_KEY, filter);
} catch (_) {}
}
function getSavedFilter() {
try {
return localStorage.getItem(LS_KEY) || 'pluginEntryActive';
} catch (_) {
return 'pluginEntryActive';
}
}
function applyFilters() {
pluginRows.forEach(row => {
if (!(row && row.classList)) 
return;

const matchFilter = (currentFilter === 'all') || row.classList.contains(currentFilter);
let matchQuery = true;
if (currentQuery) {
const titleCell = row.cells && row.cells[2] ? row.cells[2] : row.querySelector('td:nth-child(3)');
const text = (titleCell ? titleCell.textContent : row.textContent) || '';
matchQuery = text.toLowerCase().includes(currentQuery);
}
row.style.display = (matchFilter && matchQuery) ? '' : 'none';
});
}
// Инициализация активной вкладки
filterButtons.forEach(btn => btn.classList.remove('active'));
const savedFilter = getSavedFilter();
const activeButton = document.querySelector(`.nav-tabs .nav-link[data-filter="${savedFilter}"]`);
if (activeButton) {
activeButton.classList.add('active');
currentFilter = savedFilter;
} else {
const defaultButton = document.querySelector('.nav-tabs .nav-link[data-filter="pluginEntryActive"]');
if (defaultButton) 
defaultButton.classList.add('active');

currentFilter = 'pluginEntryActive';
} applyFilters();
// Обработчик кликов по вкладкам
filterButtons.forEach(button => {
button.addEventListener('click', function (e) {
e.preventDefault();
filterButtons.forEach(btn => btn.classList.remove('active'));
this.classList.add('active');
currentFilter = this.dataset.filter;
saveSelectedFilter(currentFilter);
applyFilters();
});
});
// Поиск по названию плагина (3-й столбец)
const searchInput = document.getElementById('searchInput');
if (searchInput) {
searchInput.addEventListener('input', function () {
currentQuery = (this.value || '').toLowerCase();
applyFilters();
});
}
});
</script>
