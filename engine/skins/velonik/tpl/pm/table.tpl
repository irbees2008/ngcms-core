<!-- start page title --><div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="admin.php">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item active">{{ lang.pm }}</li>
		</ol>
		<h4>{{ lang.pm }}</h4>
	</div></div><!-- end page title --><form action="?mod=pm&action=delete" method="post" name="form">
	<input type="hidden" name="token" value="{{ token }}">
	<div class="x_panel">
		<div class="x_title text-right">
			<a href="?mod=pm&action=write" class="btn btn-outline-success">{{ lang.write }}</a>
		</div>
		<div class="table-responsive">
			<table class="table table-sm mb-0">
				<thead>
					<tr>
						<th width="15%">{{ lang.pmdate }}</th>
						<th width="40%">{{ lang.title }}</th>
						<th nowrap>{{ lang.from }}</th>
						<th width="15%">{{ lang.status }}</th>
						<th width="5%">
							<input type="checkbox" name="master_box" class="form-check-input" title="{{ lang.select_all }}" onclick="check_uncheck_all(this)">
						</th>
					</tr>
				</thead>
				<tbody>
					{% for entry in entries %}
						<tr>
							<td>{{ entry.date }}</td>
							<td>
								<a href="?mod=pm&action=read&pmid={{ entry.id }}&token={{ token }}">{{ entry.title }}</a>
							</td>
							<td nowrap>
								{% if entry.flags.haveSender %}
									<a href="{{ entry.senderProfileURL }}">{{ entry.senderName }}</a>
								{% else %}
									{{ entry.senderName }}
								{% endif %}
							</td>
							<td>
								{% if entry.flags.viewed %}
									{{ lang.viewed }}
								{% else %}
									{{ lang.unviewed }}
								{% endif %}
							</td>
							<td><input type="checkbox" name="selected_pm[]" class="form-check-input" value="{{ entry.id }}"/></td>
						</tr>
					{% endfor %}
				</tbody>
			</table>
		</div>
		<div class="text-right mt-2">
			<button type="submit" class="btn btn-outline-danger">{{ lang.delete }}</button>
		</div>
	</div></form><script>
	$(function () {
 $('input[name="master_box"]').on('change', function () {
 $('input[name="selected_pm[]"]').prop('checked', this.checked);
});
});
</script>
