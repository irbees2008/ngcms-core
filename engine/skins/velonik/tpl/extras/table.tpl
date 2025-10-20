<!-- start page title --><div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="admin.php">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item active">{{ lang['extras'] }}</li>
		</ol>
		<h4>{{ lang['extras'] }}</h4>
	</div>
</div><!-- end page title --><div class="input-group mb-3">
	<input type="text" id="searchInput" class="form-control" placeholder="{{ lang['extras.search'] }}">
	<span class="input-group-text">
		<i class="fa fa-search"></i>
	</span>
</div><!-- Фильтр --><ul class="nav nav-pills bg-nav-pills nav-justified mb-3">
	<li class="nav-item">
		<a href="#" data-toggle="tab" aria-expanded="true" class="nav-link rounded-0 active" data-filter="pluginEntryActive">
			{{ lang['list.active'] }}
			<span class="badge bg-light text-dark ms-1">{{ cntActive }}</span>
		</a>
	</li>
	<li class="nav-item">
		<a href="#" data-toggle="tab" aria-expanded="false" class="nav-link rounded-0" data-filter="pluginEntryInactive">
			{{ lang['list.inactive'] }}
			<span class="badge bg-light text-dark ms-1">{{ cntInactive }}</span>
		</a>
	</li>
	<li class="nav-item">
		<a href="#" data-toggle="tab" aria-expanded="false" class="nav-link rounded-0" data-filter="pluginEntryUninstalled">
			{{ lang['list.needinstall'] }}
			<span class="badge bg-light text-dark ms-1">{{ cntUninstalled }}</span>
		</a>
	</li>
	<li class="nav-item">
		<a href="#" data-toggle="tab" aria-expanded="false" class="nav-link rounded-0" data-filter="all">
			{{ lang['list.all'] }}
			<span class="badge bg-light text-dark ms-1">{{ cntAll }}</span>
		</a>
	</li>
</ul><!-- Карточки плагинов --><div class="row" id="plugin-list">
	{% for entry in entries %}
		<div class="col-md-6 col-lg-4 mb-4 plugin-card {{ entry.style }}" data-status="{{ entry.status }}">
			<div class="x_panel">
				<div class="x_title">
					<h5>
						{{ entry.id }}
						-
						{{ entry.title }}
						<span class="badge badge-secondary float-right">{{ entry.version }}</span>
					</h5>
				</div>
				<div
					class="x_content">
					<!-- Блок с иконкой -->
					<div class="card-icon">
						{{ entry.icons }}
					</div>
					<p class="card-text">{{ entry.description }}</p>
					<span class="badge badge-{{ entry.flags.isCompatible ? 'success' : 'warning' }}">
						{{ entry.flags.isCompatible ? 'Совместим' : 'Не совместим' }}
					</span>
					<!-- Дополнительные ссылки (readme, history) -->
					<div class="mt-2">
						{% if entry.readme %}
							<a href="#" class="mr-2 open-modal" data-bs-toggle="modal" data-bs-target="#readmeModal" data-url="{{ entry.readme }}" title="{{ lang['entry.readme'] }}">
								<i class="fa fa-book"></i>
								{{ lang['entry.readme'] }}
							</a>
						{% endif %}
						{% if entry.history %}
							<a href="#" class="open-modal" data-bs-toggle="modal" data-bs-target="#historyModal" data-url="{{ entry.history }}" title="{{ lang['entry.history'] }}">
								<i class="fa fa-clock-o"></i>
								{{ lang['entry.history'] }}
							</a>
						{% endif %}
					</div>
				</div>
				<div class="text-muted">
					{{ entry.url }}
					{{ entry.link }}
					{{ entry.install }}
				</div>
			</div>
		</div>
	{% endfor %}
</div><!-- Модальное окно для README --><div class="modal fade" id="readmeModal" tabindex="-1" role="dialog" aria-labelledby="readmeModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="readmeModalLabel">{{ lang['entry.readme'] }}</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<iframe id="readmeContent" src="" style="width: 100%; height: 500px; border: none;"></iframe>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div><!-- Модальное окно для истории --><div class="modal fade" id="historyModal" tabindex="-1" role="dialog" aria-labelledby="historyModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="historyModalLabel">{{ lang['entry.history'] }}</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<iframe id="historyContent" src="" style="width: 100%; height: 500px; border: none;"></iframe>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
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
const filterButtons = document.querySelectorAll('.nav-pills .nav-link');
const pluginCards = document.querySelectorAll('.plugin-card');
function saveSelectedFilter(filter) {
localStorage.setItem('selectedFilter', filter);
}
function getSavedFilter() {
return localStorage.getItem('selectedFilter') || 'pluginEntryActive';
}
// Сначала убрать active у всех вкладок
filterButtons.forEach(btn => btn.classList.remove('active'));
// Применяем сохраненный фильтр при загрузке страницы
const savedFilter = getSavedFilter();
const activeButton = document.querySelector(`.nav-pills .nav-link[data-filter="${savedFilter}"]`);
if (activeButton) {
activeButton.classList.add('active');
filterCards(savedFilter);
} else { // Если сохраненного фильтра нет, активируем первую вкладку по умолчанию
const defaultButton = document.querySelector('.nav-pills .nav-link[data-filter="pluginEntryActive"]');
if (defaultButton) {
defaultButton.classList.add('active');
filterCards('pluginEntryActive');
}
}
// Обработчик кликов по вкладкам
filterButtons.forEach(button => {
button.addEventListener('click', function (e) {
e.preventDefault();
filterButtons.forEach(btn => btn.classList.remove('active'));
this.classList.add('active');
const filter = this.dataset.filter;
saveSelectedFilter(filter);
filterCards(filter);
});
});
function filterCards(filter) {
pluginCards.forEach(card => {
if (filter === 'all' || card.classList.contains(filter)) {
card.style.display = 'block';
} else {
card.style.display = 'none';
}
});
}
// Поиск по названию плагина
const searchInput = document.getElementById('searchInput');
if (searchInput) {
searchInput.addEventListener('input', function () {
const query = this.value.toLowerCase();
pluginCards.forEach(card => {
const title = card.querySelector('.card-title').textContent.toLowerCase();
if (title.includes(query)) {
card.style.display = 'block';
} else {
card.style.display = 'none';
}
});
});
}
});
</script>
