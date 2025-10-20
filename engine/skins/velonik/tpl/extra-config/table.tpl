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
<form method="post" action="{php_self}?mod=extra-config" name="form">
	<input type="hidden" name="token" value="{token}"/>
	<input type="hidden" name="plugin" value="{plugin}"/>
	<input type="hidden" name="action" value="commit"/>
	<div class="x_panel">
		<h5 class="x_title">{plugin}</h5>
		<table class="table table-sm extra-config">
			<tbody>
				{entries}
			</tbody>
		</table>
		<div class="text-center">
			<button type="submit" class="btn btn-outline-success">{l_commit_change}</button>
		</div>
	</div>
</form>
