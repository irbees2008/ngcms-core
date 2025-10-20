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
<form name="form" action="?mod=pm&action=send" method="post">
	<input type="hidden" name="sendto" value="{{ toID }}"/>
	<input type="hidden" name="token" value="{{ token }}"/>
	<div id="maincontent" class="x_panel">
		<div class="x_content">
			<div class="row">
				<div class="col-lg-6">
					<label class="col-form-label">{{ lang.from }}</label>
					<input type="text" value="{{ fromID }} ({{ fromName }})" class="form-control" readonly/>
				</div>
				<div class="col-lg-6">
					<label class="col-form-label">{{ lang.receiver }}</label>
					<input type="text" value="{{ toID }} ({{ toName }})" class="form-control" readonly/>
				</div>
			</div>
			<div class="mb-3">
				<label class="col-form-label">{{ lang.title }}</label>
				<input type="text" name="title" value="{{ title }}" class="form-control" maxlength="50"/>
			</div>
			<!-- SMILES -->
			<div id="modal-smiles" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="smiles-modal-label" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title" id="smiles-modal-label">Вставить смайл</h4>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="modal-body">
							{{ smilies }}
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
						</div>
					</div>
				</div>
			</div>
			<div class="mb-3 bb-editor">
				{{ quicktags }}
				<textarea id="content" name="content" rows="10" cols="60" maxlength="3000" class="form-control" required></textarea>
			</div>
		</div>
		<div class="card-footer text-center">
			<button type="submit" class="btn btn-outline-success">{{ lang.send }}</button>
		</div>
	</div>
</form>
