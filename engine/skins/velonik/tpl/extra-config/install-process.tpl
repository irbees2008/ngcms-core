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
			<li class="breadcrumb-item active" aria-current="page">{mode_text}: {plugin}</li>
		</ol>
		<h4>{mode_text}: {plugin}</h4>
	</div>
</div>
<!-- end page title -->
<form action="{php_self}?mod=extras" method="get">
	<input type="hidden" name="mod" value="extras"/>
	<div class="x_panel">
		<h5 class="x_title">{plugin}</h5>
		<div class="table-responsive">
			<table class="table table-sm">
				<tbody>
					{entries}
				</tbody>
			</table>
		</div>
		<div class="text-center">
			<button type="submit" class="btn btn-outline-success">{msg}</button>
		</div>
	</div>
</form>
