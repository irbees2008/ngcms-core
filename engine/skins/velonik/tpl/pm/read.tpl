<!-- start page title -->
<div class="row mb-2">
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
	</div>
</div>
<!-- end page title -->
<form method="post" action="?mod=pm&action=reply&pmid={{ id }}">
	<input type="hidden" name="title" value="{{ title }}"/>
	<input type="hidden" name="from" value="{{ from }}"/>
	<div class="row">
		<div class="col-lg-8">
			<div class="x_panel">
				<h5 class="x_title">{{ title }}</h5>
				<div class="x_content">{{ content }}</div>
				<div class="text-center">
					<button type="submit" class="btn btn-outline-success">{{ lang.reply }}</button>
				</div>
			</div>
		</div>
		<div class="col-lg-4">
			<div class="x_panel mb-4">
				<div class="x_title">{{ lang.msgi_info }}</div>
				<div class="x_content">
					<ul class="list-unstyled mb-0">
						<li>{{ lang.from }}:
							<b>{{ fromID }}
								({{ fromName }})</b>
						</li>
						<li>{{ lang.receiver }}:
							<b>{{ toID }}
								({{ toName }})</b>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</form>
