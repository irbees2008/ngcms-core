<!-- start page title -->
<div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item"><a href="admin.php"><i class="fa fa-home"></i></a></li>
			<li class="breadcrumb-item"><a href="{php_self}?mod=images">{l_images_title}</a></li>
			<li class="breadcrumb-item active" aria-current="page">{orig_name}</li>
		</ol>
		<h4>{orig_name}</h4>
	</div>
</div>
<!-- end page title -->
<form method="post" action="admin.php">
	<input type="hidden" name="mod" value="images"/>
	<input type="hidden" name="subaction" value="editApply"/>
	<input type="hidden" name="id" value="{id}"/>
	<input type="hidden" name="back" value="{link_back}"/>
	<div class="x_panel mb-3">
		<div class="x_title">{l_edit_title}</div>
		<div class="x_content">
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">{l_original_name}</label>
				<div class="col-sm-9">
					<input type="text" class="form-control-plaintext" value="{orig_name}" readonly />
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">{l_name}</label>
				<div class="col-sm-9">
					<div class="input-group mb-3">
						<input id="editImageName" type="text" value="{name}" class="form-control" readonly />
						<span class="input-group-text">
							<a id="markNameEdit" href="#" title="{l_rename}"><i class="fa fa-pencil"></i></a>
						</span>
					</div>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">{l_url}</label>
				<div class="col-sm-9">
					<div class="input-group mb-3">
						<input type="text" value="{fileurl}" class="form-control" readonly />
						<span class="input-group-text">
							<a target="_blank" href="{fileurl}"><i class="fa fa-external-link"></i></a>
						</span>
					</div>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">{l_date}</label>
				<div class="col-sm-9">
					<input type="text" class="form-control-plaintext" value="{date}" readonly />
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">{l_author}</label>
				<div class="col-sm-9">
					<input type="text" class="form-control-plaintext" value="{author}" readonly />
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">{l_img_size}</label>
				<div class="col-sm-9">
					<input type="text" class="form-control-plaintext" value="{width} x {height} ( {size} )" readonly />
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">{l_category}</label>
				<div class="col-sm-9">
					<input type="text" class="form-control-plaintext" value="{category}" readonly />
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">{l_wmimage}</label>
				<div class="col-sm-9">
					[have_stamp]
					<input type="text" class="form-control-plaintext" value="{l_added}" readonly />
					[/have_stamp]
					[no_stamp]
						<div class="form-check">
							<input id="createStamp" type="checkbox" name="createStamp" value="1" class="form-check-input">
							<label class="form-check-label" for="createStamp">{l_add}</label>
						</div>
					[/no_stamp]
				</div>
			</div>
			<div class="form-group row mb-0">
				<label class="col-sm-3 col-form-label">{l_description}</label>
				<div class="col-sm-9">
					<textarea name="description" class="form-control" cols="80" rows="2">{description}</textarea>
				</div>
			</div>
		</div>
	</div>
	<div class="x_panel mb-3">
		<div class="x_title">{l_preview}</div>
		<div class="x_content">
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">{l_status}</label>
				<div class="col-sm-9">
					<input type="text" class="form-control-plaintext" value="{preview_status}" readonly />
				</div>
			</div>
			[preview]
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">{l_s_size}</label>
				<div class="col-sm-9">
					<input type="text" class="form-control-plaintext" value="{preview_width} x {preview_height} ( {preview_size} )" readonly />
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">{l_url_preview}</label>
				<div class="col-sm-9">
					<div class="input-group mb-3">
						<input type="text" value="{thumburl}" class="form-control" readonly />
						<span class="input-group-text">
							<a target="_blank" href="{thumburl}"><i class="fa fa-external-link"></i></a>
						</span>
					</div>
				</div>
			</div>
			<div class="form-group row">
				<div class="col-sm-9 offset-sm-3">
					<img src="{thumburl}" class="mr-3" alt="...">
				</div>
			</div>
			[/preview]
			<div class="form-group row mt-2">
				<div class="col-sm-9 offset-sm-3">
					<div class="form-check" data-toggle="collapse" data-target="#collapseEditPreview">
						<input id="edit_preview" type="checkbox" name="flagPreview" value="1" class="form-check-input" />
						<label for="edit_preview" class="form-check-label">{l_create_edit_preview}</label>
					</div>
				</div>
			</div>
			<div class="collapse mt-2" id="collapseEditPreview">
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">{l_size_max}, {l_pixels}</label>
					<div class="col-sm-4">
						<div class="input-group mb-2">
							<input type="number" name="thumbSizeX" value="{thumb_size_x}" class="form-control" />
							<span class="input-group-text">x</span>
							<input type="number" name="thumbSizeY" value="{thumb_size_y}" class="form-control" />
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">{l_quality_jpeg}</label>
					<div class="col-sm-4">
						<div class="input-group mb-2">
							<input type="number" name="thumbQuality" value="{thumb_quality}" class="form-control" />
							<span class="input-group-text">%</span>
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">{l_s_wmimage}</label>
					<div class="col-sm-4">
						<div class="form-check mb-2">
							<input id="flagStamp" type="checkbox" name="flagStamp" value="1" class="form-check-input">
							<label class="form-check-label" for="flagStamp">{l_set_up}</label>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="x_panel mb-5">
		<div class="x_content text-center">
			<button type="submit" class="btn btn-outline-success">{l_save}</button>
		</div>
	</div>
</form>
<script type="text/javascript">
	$(document).ready(function() {
		$('#markNameEdit').on('click', function(event) {
			event.preventDefault();
			$('#editImageName').removeAttr('readonly')
				.attr('name', 'newname');
			$(this).parents('.input-group-append').remove();
		});
	});
</script>
