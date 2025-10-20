<!-- start page title -->
<div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="admin.php">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item active">{{ lang['docs'] }}</li>
		</ol>
		<h4>{{ lang['docs'] }}</h4>
	</div>
</div>
<!-- end page title -->
<div class="x_panel">
	<div
		class="container-fluid">
		<!-- Small boxes (Stat box) -->
		<div class="row">
			<div class="col-md-3">
				<div class="docs__menu mx-2 my-5 py-4" style="border: 1px solid #ccc;">{{ menu }}</div>
			</div>
			<div class="col-md-9">
				<div class="docs__contents mx-2 my-5">
					{% if docs %}
						{{ docs }}
					{% else %}
						404
					{% endif %}
				</div>
			</div>
		</div>
	</div>
	<!-- /.container-fluid -->
</div>
