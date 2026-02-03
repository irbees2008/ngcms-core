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
<div class="mb-3">
	<div class="custom-control custom-switch py-2">
		<input id="tableViewSwitch" type="checkbox" class="custom-control-input"/>
		<label for="tableViewSwitch" class="custom-control-label">Табличный вид</label>
	</div>
</div>
<!-- Карточный вид -->
<div id="cardsView" class="container">
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
	<div class="row" id="plugin-cards">
		{% for entry in entries %}
			<div class="col-md-6 col-lg-4 mb-4 plugin-card {{ entry.style }}" data-status="{{ entry.status }}">
				<div class="card border-dark">
					<div class="card-header">
						<h5 class="card-title">
							{{ entry.id }}
							-
							{{ entry.title }}
							<span class="badge badge-secondary float-right" title="Version {{ entry.version }}" data-bs-toggle="tooltip">v-{{ entry.version }}</span>
						</h5>
					</div>
					<div class="card-body">
						<div class="card-icon">
							{{ entry.icons }}
						</div>
						<p class="card-text">{{ entry.description }}</p>
						<span class="badge badge-{{ entry.flags.isCompatible ? 'success' : 'warning' }}">
							{{ entry.flags.isCompatible ? 'Совместим' : 'Не совместим' }}
						</span>
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
<!-- Табличный вид -->
<div id="tableView" style="display: none;">
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
			<tbody id="plugin-table">
				{% for entry in entries %}
					<tr class="{{ entry.style }} all" id="plugin_{{ entry.id }}">
						<td>
							{% if entry.flags.isCompatible %}
								<i class="fa fa-check-circle-o" aria-hidden="true" style="color: green;"></i>
							{% else %}
								<i class="fa fa-window-close-o" aria-hidden="true" style="color: red;"></i>
							{% endif %}
						</td>
						<td nowrap>{{ entry.id }}
							{{ entry.new }}</td>
						<td>{{ entry.url }}</td>
						<td>{{ entry.type }}</td>
						<td>{{ entry.version }}</td>
						<td nowrap>
							<a href="#" class="mr-2 open-modal" data-toggle="modal" data-target="#readmeModal" data-url="{{ entry.readme }}" title="{{ lang['entry.readme'] }}">
								<i class="fa fa-file-word-o" aria-hidden="true"></i>
							</a>|
							<a href="#" class="open-modal" data-toggle="modal" data-target="#historyModal" data-url="{{ entry.history }}" title="{{ lang['entry.history'] }}">
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
	// Функция для работы с cookie
	function setCookie(name, value, days) {
		let expires = '';
		if (days) {
			const date = new Date();
			date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
			expires = '; expires=' + date.toUTCString();
		}
		document.cookie = name + '=' + (value || '') + expires + '; path=/';
	}
	function getCookie(name) {
		const nameEQ = name + '=';
		const ca = document.cookie.split(';');
		for (let i = 0; i < ca.length; i++) {
			let c = ca[i];
			while (c.charAt(0) === ' ') c = c.substring(1, c.length);
			if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length);
		}
		return null;
	}
	document.addEventListener('DOMContentLoaded', function () {
		const cardsView = document.getElementById('cardsView');
		const tableView = document.getElementById('tableView');
		const tableSwitch = document.getElementById('tableViewSwitch');
		// Проверяем сохраненное значение
		const savedView = getCookie('extras_table_view');
		if (savedView === 'table') {
			tableSwitch.checked = true;
			cardsView.style.display = 'none';
			tableView.style.display = 'block';
		}
		// Обработчик переключателя
		tableSwitch.addEventListener('change', function () {
			if (this.checked) {
				setCookie('extras_table_view', 'table', 365);
				cardsView.style.display = 'none';
				tableView.style.display = 'block';
			} else {
				setCookie('extras_table_view', 'cards', 365);
				cardsView.style.display = 'block';
				tableView.style.display = 'none';
			}
		});
		// Обработчик для README в карточках
		const readmeLinks = document.querySelectorAll('.open-modal[data-target="#readmeModal"]');
		readmeLinks.forEach(link => {
			link.addEventListener('click', function () {
				const url = this.getAttribute('data-url');
				document.getElementById('readmeContent').src = url;
			});
		});
		// Обработчик для истории в карточках
		const historyLinks = document.querySelectorAll('.open-modal[data-target="#historyModal"]');
		historyLinks.forEach(link => {
			link.addEventListener('click', function () {
				const url = this.getAttribute('data-url');
				document.getElementById('historyContent').src = url;
			});
		});
		// Фильтр вкладок - работает для обоих видов
		const filterButtons = document.querySelectorAll('.nav-tabs .nav-link');
		const pluginCards = document.querySelectorAll('.plugin-card');
		const pluginRows = document.querySelectorAll('#plugin-table tr');
		function saveSelectedFilter(filter) {
			localStorage.setItem('selectedFilter', filter);
		}
		function getSavedFilter() {
			return localStorage.getItem('selectedFilter') || 'pluginEntryActive';
		}
		// Применяем сохраненный фильтр
		filterButtons.forEach(btn => btn.classList.remove('active'));
		const savedFilter = getSavedFilter();
		const activeButtons = document.querySelectorAll(`.nav-tabs .nav-link[data-filter="${savedFilter}"]`);
		activeButtons.forEach(btn => btn.classList.add('active'));
		filterCards(savedFilter);
		// Обработчик кликов по вкладкам
		filterButtons.forEach(button => {
			button.addEventListener('click', function (e) {
				e.preventDefault();
				document.querySelectorAll('.nav-tabs .nav-link').forEach(btn => btn.classList.remove('active'));
				document.querySelectorAll(`.nav-tabs .nav-link[data-filter="${this.dataset.filter}"]`).forEach(btn => btn.classList.add('active'));
				const filter = this.dataset.filter;
				saveSelectedFilter(filter);
				filterCards(filter);
			});
		});
		function filterCards(filter) {
			// Фильтр для карточек
			pluginCards.forEach(card => {
				if (filter === 'all' || card.classList.contains(filter)) {
					card.style.display = 'block';
				} else {
					card.style.display = 'none';
				}
			});
			// Фильтр для таблицы
			pluginRows.forEach(row => {
				if (filter === 'all' || row.classList.contains(filter)) {
					row.style.display = '';
				} else {
					row.style.display = 'none';
				}
			});
		}
		// Поиск
		const searchInput = document.getElementById('searchInput');
		if (searchInput) {
			searchInput.addEventListener('input', function () {
				const query = this.value.toLowerCase();
				// Поиск в карточках
				pluginCards.forEach(card => {
					const title = card.querySelector('.card-title').textContent.toLowerCase();
					if (title.includes(query)) {
						card.style.display = 'block';
					} else {
						card.style.display = 'none';
					}
				});
				// Поиск в таблице
				pluginRows.forEach(row => {
					const titleCell = row.cells && row.cells[2] ? row.cells[2] : row.querySelector('td:nth-child(3)');
					const text = (titleCell ? titleCell.textContent : row.textContent) || '';
					if (text.toLowerCase().includes(query)) {
						row.style.display = '';
					} else {
						row.style.display = 'none';
					}
				});
			});
		}
	});
</script>
