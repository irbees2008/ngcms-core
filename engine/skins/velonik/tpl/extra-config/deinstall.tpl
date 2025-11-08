<div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="{{ php_self }}">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item">
				<a href="{{ php_self }}?mod=extras">{{ lang['extras'] }}</a>
			</li>
			<li class="breadcrumb-item active" aria-current="page">{{ lang['deinstall_text']|default('Деинсталляция') }}: {{ plugin }}</li>
		</ol>
		<h4>{{ lang['deinstall_text']|default('Деинсталляция') }}: {{ plugin }}</h4>
	</div>
</div>
<form method="post" action="{{ php_self }}?mod=extra-config">
	<input type="hidden" name="plugin" value="{{ plugin }}"/>
	<input type="hidden" name="stype" value="install"/>
	<input type="hidden" name="action" value="commit"/>
	<div class="x_panel">
		<h5 class="x_title">{{ plugin }}</h5>
		<div class="x_content">{{ install_text|raw }}</div>
		<div class="text-center">
			<button type="submit" class="btn btn-outline-success">{{ lang['commit_deinstall']|default('Подтвердить удаление') }}</button>
		</div>
	</div>
</form>
