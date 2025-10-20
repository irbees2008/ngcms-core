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
				<a href="{php_self}?mod=extras">{{ lang['extras'] }}</a>
			</li>
			<li class="breadcrumb-item active" aria-current="page">{ {action }}:
				{{ plugin }}</li>
		</ol>
		<h4>{{action}}:
			{{ plugin }}</h4>
	</div>
</div>
<!-- end page title -->
<div class="alert alert-danger">
	{{ action_text }}
</div>
