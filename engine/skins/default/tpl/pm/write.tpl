<div class="container-fluid">
	<div class="row mb-2">
	  <div class="col-sm-6 d-none d-md-block ">
			<h1 class="m-0 text-dark">{{ lang.pm }}</h1>
	  </div><!-- /.col -->
	  <div class="col-sm-6">
		<ol class="breadcrumb float-sm-right">
			<li class="breadcrumb-item"><a href="admin.php"><i class="fa fa-home"></i></a></li>
			<li class="breadcrumb-item active" aria-current="page">{{ lang.pm }}</li>
		</ol>
	  </div><!-- /.col -->
	</div><!-- /.row -->
  </div><!-- /.container-fluid -->
<!-- Auto-suggest styles -->
<style>
	.suggestWindow {
		background: #ffffff;
		border: 1px solid #dee2e6;
		border-radius: 0.25rem;
		box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
		position: absolute;
		display: block;
		visibility: hidden;
		padding: 0;
		font: normal 14px -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
		z-index: 1050;
		max-width: 400px;
		min-width: 250px;
	}
	#suggestBlock {
		padding: 0.25rem 0;
		width: 100%;
		border: 0;
	}
	#suggestBlock td {
		padding: 0.375rem 0.75rem;
		border: 0;
	}
	#suggestBlock tr {
		background: transparent;
		cursor: pointer;
	}
	#suggestBlock tr:hover,
	#suggestBlock .suggestRowHighlight {
		background: #007bff;
		color: white;
	}
	#suggestBlock .cleft {
		text-align: left;
	}
	.suggestClose {
		display: block;
		text-align: right;
		font: normal 12px -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
		background: #f8f9fa;
		padding: 0.375rem 0.75rem;
		cursor: pointer;
		border-top: 1px solid #dee2e6;
		color: #6c757d;
	}
	.suggestClose:hover {
		background: #e9ecef;
	}
</style>
<form name="form" action="?mod=pm&action=send" method="post">
	<input type="hidden" name="token" value="{{ token }}" />
	<div class="row">
		<!-- Left edit column -->
		<div class="col-lg-8">
			<!-- MAIN CONTENT -->
			<div id="maincontent" class="card">
				<div class="card-body">
					<div class="form-row mb-3">
						<label class="col-lg-4 col-form-label">
							{{ lang.receiver }}
						</label>
						<div class="col-lg-8 position-relative">
							<input type="text" name="sendto" id="sendto" value="" class="form-control" maxlength="70" autocomplete="off" required />
							<span id="suggestLoader" style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); visibility: hidden;">
								<div class="spinner-border spinner-border-sm text-primary" role="status">
									<span class="sr-only">Loading...</span>
								</div>
							</span>
							<small class="form-text text-muted">{{ lang.receiver_desc }} Начните вводить имя пользователя для автодополнения.</small>
						</div>
					</div>
					<div class="form-row mb-3">
						<label class="col-lg-4 col-form-label">{{ lang.title }}</label>
						<div class="col-lg-8">
							<input type="text" name="title" value="" class="form-control" maxlength="50" required />
						</div>
					</div>
					{{ quicktags }}
					<!-- SMILES -->
					<div id="modal-smiles" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="smiles-modal-label" aria-hidden="true">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<h5 id="smiles-modal-label" class="modal-title">Вставить смайл</h5>
									<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
								</div>
								<div class="modal-body">
									{{ smilies }}
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-outline-dark" data-dismiss="modal">Cancel</button>
								</div>
							</div>
						</div>
					</div>
					<div class="mb-3">
						<!-- {{ lang.content }} -->
						<textarea id="content" name="content" rows="10" cols="60" maxlength="3000" class="form-control" required></textarea>
					</div>
				</div>
				<div class="card-footer text-center">
					<button type="submit" class="btn btn-outline-success">{{ lang.send }}</button>
				</div>
			</div>
		</div>
	</div>
</form>
<!-- Auto-suggest JavaScript -->
<script type="text/javascript">
// Simple SACK API compatibility layer using modern fetch
function sack() {
    this.requestFile = '';
    this.method = 'POST';
    this.vars = {};
    this.responseStatus = [0];
    this.response = '';
    this.onComplete = null;
}
sack.prototype.setVar = function(name, value) {
    this.vars[name] = value;
};
sack.prototype.runAJAX = function() {
    var self = this;
    var formData = new FormData();
    // Add all variables to form data
    for (var key in this.vars) {
        if (this.vars.hasOwnProperty(key)) {
            formData.append(key, this.vars[key]);
        }
    }
    var options = {
        method: this.method,
        body: formData
    };
    fetch(this.requestFile, options)
        .then(function(response) {
            self.responseStatus = [response.status];
            return response.text();
        })
        .then(function(text) {
            self.response = text;
            if (self.onComplete && typeof self.onComplete === 'function') {
                self.onComplete();
            }
        })
        .catch(function(error) {
            console.error('AJAX Error:', error);
            self.responseStatus = [500];
            self.response = '';
            if (self.onComplete && typeof self.onComplete === 'function') {
                self.onComplete();
            }
        });
};
</script>
<script type="text/javascript" src="{{ scriptLibrary }}/libsuggest.js"></script>
<script type="text/javascript">
function initUserAutoComplete() {
	if (typeof ngSuggest !== 'undefined') {
		new ngSuggest('sendto', {
			'localPrefix': '',
			'postURL': '/engine/rpc.php',
			'iMinLen': 1,
			'stCols': 1,
			'stColsClass': ['cleft'],
			'lId': 'suggestLoader',
			'hlr': 'true',
			'stColsHLR': [true],
			'reqMethodName': 'pm_get_username'
		});
	} else {
		console.error('ngSuggest library not loaded');
	}
}
// Initialize auto-complete when page loads
if (document.readyState === 'loading') {
	document.addEventListener('DOMContentLoaded', initUserAutoComplete);
} else {
	initUserAutoComplete();
}
</script>
