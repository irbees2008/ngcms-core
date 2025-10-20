<div class="col-lg-4 col-md-6 col-sm-12 mb-4 gallery-item">
	<div class="card gallery-card h-100">
		<div class="gallery-image-container">
			{preview_img}
			<div class="gallery-overlay">
				<div class="gallery-actions">
					<a data-toggle="tooltip" class="btn btn-light btn-sm me-2" href="javascript:insertimage('[img=&quot;/uploads/images/{folder}/{file_name}&quot; border=&quot;0&quot; width=&quot;{width}&quot; height=&quot;{height}&quot; align=&quot;&quot;]{file_name} ({size})[/img]', '')" title="Полное изображение">
						<i class="fa fa-share"></i>
					</a>
					<a data-toggle="tooltip" class="btn btn-light btn-sm me-2" href="javascript:insertimage('[url=&quot;/uploads/images/{folder}/{file_name}&quot; target=&quot;_blank&quot;][img=&quot;/uploads/images/{folder}/thumb/{file_name}&quot; border=&quot;0&quot; align=&quot;&quot;]{file_name} ({size})[/img][/url]', '')" title="Вставка превью">
						<i class="fa fa-search-plus"></i>
					</a>
					<a data-toggle="tooltip" class="btn btn-light btn-sm" href="javascript:insertimage('[img=&quot;/uploads/images/{folder}/thumb/{file_name}&quot; border=&quot;0&quot; align=&quot;&quot;]{file_name}[/img]', '')" title="Вставка уменьшенного изображения">
						<i class="fa fa-search-minus"></i>
					</a>
				</div>
			</div>
		</div>
		<div class="card-body">
			<h6 class="card-title mb-2">
				<input type="checkbox" name="files[]" class="form-check-input" value="{id}" class="check" data-toggle="tooltip" title="Выбрать"/>
				{file_name}
				<a data-toggle="tooltip" href="{edit_link}" title="{l_edit}">
					<i class="fa fa-pencil"></i>
				</a>
			</h6>
			<p class="card-text text-muted small">
				Загрузил: {user} [SIZE: <span class="img-width">{width}</span>x<span class="img-height">{height}</span> {size}]
			</p>
			<div class="d-flex justify-content-between align-items-center">
				<span class="badge bg-primary">Категория: {folder}</span>
				<small class="text-muted">
					Просмотр:
					<a data-toggle="tooltip" target="_blank" href="/uploads/images/{folder}/{file_name}" data-fancybox title="Полное изображение">
						<i class="fa fa-search-plus"></i>
					</a>
					<a data-toggle="tooltip" target="_blank" href="/uploads/images/{folder}/thumb/{file_name}" data-fancybox title="Уменьшенное изображение">
						<i class="fa fa-search-minus"></i>
					</a>
				</small>
			</div>
		</div>
	</div>
</div>