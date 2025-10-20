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
				<a href="{{ php_self }}?mod=ugroup">{{ lang['user_groups'] }}</a>
			</li>
			<li class="breadcrumb-item active" aria-current="page">
				{% if (flags.editMode) %}
					{{ entry.identity }}
				{% else %}
					{{ lang['add_group'] }}
				{% endif %}
			</li>
		</ol>
		<h4>
			{% if (flags.editMode) %}
				{{ entry.identity }}
			{% else %}
				{{ lang['add_group'] }}
			{% endif %}
		</h4>
	</div>
</div>
<!-- end page title -->
<form action="{{ php_self }}?mod=ugroup" method="post">
	<input type="hidden" name="token" value="{{ token }}"/>
	{% if (flags.editMode) %}
		<input type="hidden" name="action" value="edit"/>
		<input type="hidden" name="id" value="{{ entry.id }}"/>
	{% else %}
		<input type="hidden" name="action" value="add"/>
	{% endif %}
	<!-- MAIN CONTENT -->
	<div id="maincontent" class="x_panel mb-4">
		<div class="x_title">{{ lang['edit_group'] }}</div>
		<div class="x_content">
			<div class="row">
				<div class="col-lg-6">
					<div class="mb-3">
						<label class="col-form-label">ID</label>
						<input type="text" readonly class="form-control" value="{{ entry.id }}"/>
					</div>
					<div class="mb-3">
						<label class="col-form-label">{{ lang['identifier'] }}</label>
						<input type="text" name="identity" value="{{ entry.identity }}" class="form-control"/>
					</div>
				</div>
				<div class="col-lg-6">
					{% for eLang,eLValue in entry.langName %}
						<div class="mb-3">
							<label class="col-form-label">{{ lang['name_group_lang'] }}
								[{{ eLang }}]</label>
							<input type="text" name="langname[{{ eLang }}]" value="{{ eLValue }}" class="form-control"/>
						</div>
					{% endfor %}
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col col-lg-8">
			<div class="row">
				{% if (flags.canModify) %}
					<div class="col-md-6 mb-4">
						<button type="button" class="btn btn-outline-dark" onclick="history.back();">
							{{ lang['cancel'] }}
						</button>
					</div>
					<div class="col-md-6 mb-4 text-right">
						<button type="submit" class="btn btn-outline-success">
							<span class="d-xl-none">
								<i class="ri-save-line"></i>
							</span>
							<span class="d-none d-xl-block">{{ lang['save'] }}</span>
						</button>
					</div>
				{% endif %}
			</div>
		</div>
	</div>
</form>
