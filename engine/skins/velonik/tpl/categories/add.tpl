<!-- start page title -->
<div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="admin.php">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item active">
				<a href="{{ php_self }}?mod=categories">{{ lang['categories_title'] }}</a>
			</li>
			<li class="breadcrumb-item active">{{ lang['addnew'] }}</li>
		</ol>
		<h4>{{ lang['addnew'] }}</h4>
	</div>
</div>
<!-- end page title -->
<form method="post" action="{{ php_self }}?mod=categories" enctype="multipart/form-data">
	<input type="hidden" name="token" value="{{ token }}"/>
	<input type="hidden" name="action" value="doadd"/>
	<div class="x_panel">
		<div class="x_title">
			<div class="row">
				<div class="col text-right">
					<div class="form-check form-switch">
						<input type="checkbox" name="cat_show" value="1" class="form-check-input" id="cat_show" checked>
						<label class="form-check-label" for="cat_show">{{ lang['show_main'] }}</label>
					</div>
				</div>
			</div>
		</div>
		<div class="x_content">
			<div class="row">
				<div class="col-lg-6">
					<div class="mb-3">
						<label for="title" class="form-label">{{ lang['title'] }}</label>
						<input type="text" name="name" value="" id="title" class="form-control">
					</div>
				</div>
				<div class="col-lg-6">
					<div class="mb-3">
						<label for="alt_name" class="form-label">{{ lang['alt_name'] }}</label>
						<input type="text" name="alt" value="" id="alt_name" class="form-control">
					</div>
				</div>
			</div>
			{% if (flags.haveMeta) %}
				<div class="row">
					<div class="col-lg-6">
						<div class="mb-3">
							<label for="cat_desc" class="form-label">{{ lang['cat_desc'] }}</label>
							<textarea name="description" cols="80" id="cat_desc" class="form-control"></textarea>
						</div>
					</div>
					<div class="col-lg-6">
						<div class="mb-3">
							<label for="cat_keys" class="form-label">{{ lang['cat_keys'] }}</label>
							<textarea name="keywords" cols="80" id="cat_keys" class="form-control"></textarea>
						</div>
					</div>
				</div>
			{% endif %}
			<div class="row">
				<div class="col-lg-6">
					<div class="mb-3">
						<label class="form-label">{{ lang['parent'] }}</label>
						<div class="ng-select">{{ parent }}</div>
					</div>
				</div>
				<div class="col-lg-6">
					<div class="mb-3">
						<label for="cat_number" class="form-label">{{ lang['cat_number'] }}</label>
						<input type="number" name="number" value="" id="cat_number" class="form-control">
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-lg-4">
					<div class="mb-3">
						<select name="show_link" class="form-select">
							<option value="0">{{ lang['link.always'] }}</option>
							<option value="1">{{ lang['link.ifnews'] }}</option>
							<option value="2">{{ lang['link.never'] }}</option>
						</select>
						<label class="form-label">{{ lang['show.link'] }}</label>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="mb-3">
						<select name="tpl" class="form-select">
							{{ tpl_list }}
						</select>
						<label class="form-label">{{ lang['cat_tpl'] }}</label>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="mb-3">
						<select name="template_mode" class="form-select">
							{{ template_mode }}
						</select>
						<label class="form-label">{{ lang['template_mode'] }}</label>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-lg-6">
					<div class="mb-3">
						<label class="form-label">{{ lang['icon'] }}</label>
						<input type="text" name="icon" value="" maxlength="255" class="form-control"/>
						<small class="form-text text-muted">{{ lang['icon#desc'] }}</small>
					</div>
				</div>
				<div class="col-lg-6">
					<div class="mb-3">
						<label class="form-label">{{ lang['attached_icon'] }}</label>
						<input type="file" name="image" class="form-control">
						<small class="form-text text-muted">{{ lang['attached_icon#desc'] }}</small>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-lg-6">
					<div class="mb-3">
						<label class="form-label">{{ lang['alt_url'] }}</label>
						<input type="text" name="alt_url" value="" class="form-control"/>
					</div>
				</div>
				<div class="col-lg-6">
					<div class="mb-3">
						<label class="form-label">{{ lang['orderby'] }}</label>
						<div class="ng-select">{{ orderlist }}</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-lg-12">
					<div class="mb-3">
						<label class="form-label">{{ lang['category.info'] }}</label>
						<textarea id="info" name="info" cols="80" class="form-control"></textarea>
						<small class="form-text text-muted">{{ lang['category.info#desc'] }}</small>
					</div>
				</div>
			</div>
			<table class="table table-sm">
				<tbody>
					{{ extend }}
				</tbody>
			</table>
		</div>
		<div class="card-footer">
			<div class="form-group text-center">
				<button type="submit" class="btn btn-outline-success">{{ lang['addnew'] }}</button>
			</div>
		</div>
	</div>
</form>
