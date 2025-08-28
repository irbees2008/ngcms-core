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

<div
	class="container">
	<!-- Фильтр -->
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

	<!-- Карточки плагинов -->
	<div class="row" id="plugin-list">
		{% for entry in entries %}
			<div class="col-md-6 col-lg-4 mb-4 plugin-card {{ entry.style }}" data-status="{{ entry.status }}">
<div class="card border-dark">
	<div class="card-header">
		<h5 class="card-title">
{{ entry.id }}
-
{{ entry.title }}

			<span class="badge badge-secondary float-right">{{ entry.version }}</span>
		</h5>
	</div>
	<div
		class="card-body">
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
				<a href="#" class="mr-2 open-modal" data-toggle="modal" data-target="#readmeModal" data-url="{{ entry.readme }}" title="{{ lang['entry.readme'] }}">
					<i class="fa fa-book"></i>
					{{ lang['entry.readme'] }}
				</a>
			{% endif %}
			{% if entry.history %}
				<a href="#" class="open-modal" data-toggle="modal" data-target="#historyModal" data-url="{{ entry.history }}" title="{{ lang['entry.history'] }}">
					<i class="fa fa-clock-o"></i>
					{{ lang['entry.history'] }}
				</a>
			{% endif %}
		</div>
	</div>
	<div class="card-footer text-muted">
		{{ entry.url }}
		{{ entry.link }}
		{{ entry.install }}
	</div>
</div>

			</div>
		{% endfor %}
	</div>
</div>
<!-- Модальное окно для README -->
<div class="modal fade" id="readmeModal" tabindex="-1" role="dialog" aria-labelledby="readmeModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="readmeModalLabel">{{ lang['entry.readme'] }}</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<iframe id="readmeContent" src="" style="width: 100%; height: 500px; border: none;"></iframe>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">{{ lang['action.close'] }}</button>
			</div>
		</div>
	</div>
</div>

<!-- Модальное окно для истории -->
<div class="modal fade" id="historyModal" tabindex="-1" role="dialog" aria-labelledby="historyModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="historyModalLabel">{{ lang['entry.history'] }}</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<iframe id="historyContent" src="" style="width: 100%; height: 500px; border: none;"></iframe>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">{{ lang['action.close'] }}</button>
			</div>
		</div>
	</div>
</div>

<script>
	document.addEventListener('DOMContentLoaded', function () { // Обработчик для README
const readmeLinks = document.querySelectorAll('.open-modal[data-target="#readmeModal"]');
readmeLinks.forEach(link => {
link.addEventListener('click', function () {
const url = this.getAttribute('data-url');
document.getElementById('readmeContent').src = url;
});
});

// Обработчик для истории
const historyLinks = document.querySelectorAll('.open-modal[data-target="#historyModal"]');
historyLinks.forEach(link => {
link.addEventListener('click', function () {
const url = this.getAttribute('data-url');
document.getElementById('historyContent').src = url;
});
});
});
document.addEventListener('DOMContentLoaded', function () { // Получаем элементы интерфейса
const filterButtons = document.querySelectorAll('.nav-tabs .nav-link');
const pluginCards = document.querySelectorAll('.plugin-card');

// Функция для сохранения выбранного фильтра в localStorage
function saveSelectedFilter(filter) {
localStorage.setItem('selectedFilter', filter);
}

// Функция для получения сохраненного фильтра из localStorage
function getSavedFilter() {
return localStorage.getItem('selectedFilter') || 'pluginEntryActive'; // По умолчанию "активные"
}

// Применяем сохраненный фильтр при загрузке страницы
const savedFilter = getSavedFilter();
const activeButton = document.querySelector(`.nav-tabs .nav-link[data-filter="${savedFilter}"]`);
if (activeButton) {
activeButton.classList.add('active');
filterCards(savedFilter);
} else { // Если сохраненного фильтра нет, активируем первую вкладку по умолчанию
const defaultButton = document.querySelector('.nav-tabs .nav-link[data-filter="pluginEntryActive"]');
if (defaultButton) {
defaultButton.classList.add('active');
filterCards('pluginEntryActive');
}
}

// Обработчик кликов по вкладкам
filterButtons.forEach(button => {
button.addEventListener('click', function (e) {
e.preventDefault();

// Убираем класс 'active' у всех кнопок
filterButtons.forEach(btn => btn.classList.remove('active'));
this.classList.add('active');

const filter = this.dataset.filter;

// Сохраняем выбранный фильтр
saveSelectedFilter(filter);

// Фильтруем карточки
filterCards(filter);
});
});

// Функция для фильтрации карточек
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
