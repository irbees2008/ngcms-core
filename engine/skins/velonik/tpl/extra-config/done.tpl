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
				<a href="{php_self}?mod=extras">{l_extras}</a>
			</li>
			<li class="breadcrumb-item active" aria-current="page">{plugin}</li>
		</ol>
		<h4>{plugin}</h4>
	</div>
</div>
<!-- end page title -->
<div class="x_panel">
	<div class="x_content">
		{l_commited}
	</div>
	<a href="{php_self}?mod=extra-config&plugin={plugin}" class="btn btn-outline-success">{plugin}</a>
</div>
