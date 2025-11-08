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
			<li class="breadcrumb-item active" aria-current="page">{{ action }}: {{ plugin }}</li>
		</ol>
		<h4>{{ action }}: {{ plugin }}</h4>
	</div>
</div>
<div class="alert alert-danger">
	{{ action_text|raw }}
</div>
