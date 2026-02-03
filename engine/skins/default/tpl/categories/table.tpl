<div class="container-fluid">
	<div class="row mb-2">
		<div class="col-sm-6 d-none d-md-block ">
			<h1 class="m-0 text-dark">{{ lang['categories_title'] }}</h1>
		</div>
		<!-- /.col -->
		<div class="col-sm-6">
			<ol class="breadcrumb float-sm-right">
				<li class="breadcrumb-item">
					<a href="admin.php">
						<i class="fa fa-home"></i>
					</a>
				</li>
				<li class="breadcrumb-item active" aria-current="page">{{ lang['categories_title'] }}</li>
			</ol>
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
</div>
<!-- /.container-fluid -->

<!-- Info content -->
<form action="{{ php_self }}" method="get" name="categories">
	<input type="hidden" name="token" value="{{ token }}"/>
	<input type="hidden" name="mod" value="categories"/>
	<input type="hidden" name="action" value="add"/>

	<div class="card">
		{% if (flags.canModify) %}
			<div class="card-header">
				<div class="row">
					<div class="col text-right">
						<button type="submit" class="btn btn-outline-success">{{ lang['addnew'] }}</button>
					</div>
				</div>
			</div>
		{% endif %}

		<div class="table-responsive">
			<table class="table table-sm mb-0">
				<thead>
					<tr>
						<th></th>
						<th>ID</th>
						<th></th>
						<th>{{ lang['title'] }}</th>
						<th nowrap>{{ lang['alt_name'] }}</th>
						<th>{{ lang['category.header.menushow'] }}</th>
						<th>{{ lang['category.header.template'] }}</th>
						<th>{{ lang['news'] }}</th>
						<th>{{ lang['action'] }}</th>
					</tr>
				</thead>
				<tbody id="admCatList">
					{% include localPath(0)~"entries.tpl" %}
				</tbody>
			</table>
		</div>
	</div>
</form>

 <script type="text/javascript">
	// Process RPC requests for categories
	function categoryModifyRequest(cmd, cid) {
		var rpcCommand = '';
		var rpcParams = [];

		switch (cmd) {
			case 'up':
			case 'down':
			case 'del':
				rpcCommand = 'admin.categories.modify';
				rpcParams = {
					'mode': cmd,
					'id': cid,
					'token': $('input[name="token"]').val()
				};
				break;
		}

		if (rpcCommand == '') {
			alert('No RPC command');

			return false;
		}

		post(rpcCommand, rpcParams, false)
			.then(function(response) {
				// Проверяем, что ответ вообще пришел
				if (!response || typeof response !== 'object') {
					if (typeof window.showToast === 'function') {
						window.showToast('Некорректный ответ от сервера', {
							type: 'error'
						});
					}
					return;
				}

				// Проверяем статус ответа (может быть 0, "0", false или отсутствовать)
				if (!response.status && response.errorText) {
					// Ошибка - показываем красное уведомление
					if (typeof window.showToast === 'function') {
						window.showToast(response.errorText, {
							type: 'error',
							title: 'Ошибка'
						});
					} else if (typeof ngNotifySticker === 'function') {
						ngNotifySticker(response.errorText, {
							className: 'alert-danger',
							closeBTN: true
						});
					} else {
						alert(response.errorText);
					}
					// Не обновляем список при ошибке
					return;
				}

				// Успех - показываем зеленое уведомление
				if (response.status && response.infoText) {
					if (typeof window.showToast === 'function') {
						window.showToast(response.infoText, {
							type: 'success',
							title: 'Готово'
						});
					} else if (typeof ngNotifySticker === 'function') {
						ngNotifySticker(response.infoText, {
							className: response.infoCode ? 'alert-success' : 'alert-danger',
							closeBTN: true
						});
					}
				}

				// Обновляем список категорий только при успехе
				if (response.content) {
					document.getElementById('admCatList').innerHTML = response.content;
				}
			})
			.catch(function(error) {
				// Извлекаем сообщение об ошибке
				var errorMsg = 'Произошла ошибка связи с сервером';

				if (error && typeof error === 'object') {
					if (error.errorText) {
						errorMsg = error.errorText;
					} else if (error.message) {
						// Убираем префикс "Error [XX]: " из сообщения
						errorMsg = error.message.replace(/^Error\s*\[\d+\]:\s*/i, '');
					} else if (error.responseText) {
						errorMsg = 'Ошибка сервера: ' + error.responseText;
					}
				}

				if (typeof window.showToast === 'function') {
					window.showToast(errorMsg, {
						type: 'error',
						title: 'Ошибка'
					});
				} else {
					alert(errorMsg);
				}
			});

		return false;
	}
</script>
