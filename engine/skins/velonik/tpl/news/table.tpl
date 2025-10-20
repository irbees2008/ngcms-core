<!-- start page title -->
<div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="admin.php">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item">{{ lang.addnews['news_title'] }}</li>
		</ol>
		<h4>{{ lang.editnews['news_title'] }}</h4>
	</div>
</div>
<!-- end page title -->
<!-- Filter form: BEGIN -->
<div id="collapseNewsFilter" class="collapse">
	<div class="x_panel mb-4">
		<div class="x_content">
			<form action="{{ php_self }}?mod=news" method="post" name="options_bar">
				<div
					class="row">
					<!--Block 1-->
					<div class="col-lg-4">
						<div class="mb-1">
							<label class="form-label">{{ lang.editnews['header.search'] }}</label>
							<input name="sl" type="text" value="{{ sl }}" class="form-control"/>
						</div>
						<div class="form-group">
							<label class="form-label">{{ lang.editnews.author }}</label>
							<div class="input-group mb-3">
								<input name="an" id="an" class="form-control" type="text" value="{{ an }}" autocomplete="off"/>
							</div>
							<select name="st" class="form-select">
								<option value="0" {{ not(selected) ? 'selected' : '' }}>{{ lang.editnews['header.stitle'] }}</option>
								<option value="1" {{ selected ? 'selected' : '' }}>{{ lang.editnews['header.stext'] }}</option>
							</select>
						</div>
					</div>
					<!--Block 2-->
					<div class="col-lg-4">
						<div class="mb-1">
							<label class="form-label">{{ lang.editnews['category'] }}</label>
							<div class="ng-select">{{ category_select }}</div>
						</div>
						<div class="form-group">
							<label class="form-label">{{ lang.editnews['header.date'] }}</label>
							<div class="input-group mb-3">
								<span class="input-group-text">&nbsp;&nbsp;{{ lang.editnews['header.date_since'] }}&nbsp;</span>
								<input type="text" id="dr1" name="dr1" value="{{ dr1 }}" class="form-control" pattern="[0-9]{2}\.[0-9]{2}\.[0-9]{4}" placeholder="{{ "now" | date('d.m.Y') }}" autocomplete="off"/>
							</div>
							<div class="input-group">
								<span class="input-group-text">{{ lang.editnews['header.date_till'] }}</span>
								<input type="text" id="dr2" name="dr2" value="{{ dr2 }}" class="form-control" pattern="[0-9]{2}\.[0-9]{2}\.[0-9]{4}" placeholder="{{ "now" | date('d.m.Y') }}" autocomplete="off"/>
							</div>
						</div>
					</div>
					<!--Block 3-->
					<div class="col-lg-4">
						<div class="mb-1">
							<label class="form-label">{{ lang.editnews['sort'] }}</label>
							<select name="sort" class="form-select">{{ sortlist }}</select>
						</div>
						<div class="form-group mb-3">
							<div class="row">
								<div class="col-6">
									<label class="form-label">{{ lang.editnews['header.status'] }}</label>
									<select name="status" class="form-select">
										<option value="">{{ lang.editnews['smode_all'] }}</option>
										{{ statuslist }}
									</select>
								</div>
								<div class="col-6">
									<label class="form-label">{{ lang.editnews['header.perpage'] }}</label>
									<input type="number" name="rpp" value="{{ rpp }}" size="3" class="form-control"/>
								</div>
							</div>
						</div>
						<button type="submit" class="btn btn-block btn-outline-primary">{{ lang.editnews['do_show'] }}</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
<!-- Mass actions form: BEGIN -->
<form action="{{ php_self }}?mod=news" method="post" name="editnews">
	<input type="hidden" name="token" value="{{ token }}"/>
	<input type="hidden" name="mod" value="news"/>
	<input type="hidden" name="action" value="manage"/>
	<div class="x_panel">
		<div class="x_title">
			<div class="row">
				<div class="col text-right">
					<a href="{{ php_self }}?mod=news&action=add" class="btn btn-outline-success">{{ lang.addnews['addnews_title'] }}</a>
					<button type="button" class="btn btn-outline-primary" data-bs-toggle="collapse" data-bs-target="#collapseNewsFilter" aria-expanded="false" aria-controls="collapseNewsFilter">
						<i class="fa fa-file"></i>
					</button>
				</div>
			</div>
		</div>
		<div class="table-responsive x_content">
			<table class="table table-sm mb-0">
				<thead>
					<tr>
						<th width="40" nowrap>{{ lang.editnews['postid_short'] }}</th>
						<th width="60" nowrap>{{ lang.editnews['date'] }}</th>
						<th width="48">&nbsp;</th>
						<th width="45%">{{ lang.editnews['title'] }}</th>
						{% if (pluginIsActive('comments')) %}
							{% if flags.comments %}
								<th width="50">
									<i class="ri-message-3-line"></i>
								</th>
							{% endif %}
						{% endif %}
						<th width="50">
							<i class="ri-eye-line"></i>
						</th>
						<th width="25%">{{ lang.editnews['category'] }}</th>
						<th width="10%">{{ lang.editnews['author'] }}</th>
						<th width="16">{{ lang.editnews['status'] }}</th>
						<th width="1%">
							<div class="form-check"><input type="checkbox" name="master_box" class="form-check-input" title="{{ lang.editnews['select_all'] }}" onclick="check_uncheck_all(this.form, 'selected_news[]')"></div>
						</th>
					</tr>
				</thead>
				<tbody>
					{% for entry in entries %}
						<tr>
							<td width="30">{{ entry.newsid }}</td>
							<td width="60">{{ entry.itemdate }}</td>
							<td width="48" nowrap>
								{% if entry.flags.mainpage %}
									<i class="fa fa-home" title="{{ lang['on_main'] }}"></i>
								{% endif %}
								{% if (entry.attach_count > 0) %}
									<i class="fa fa-paperclip" title="{{ lang['attach.count'] }}: {{ entry.attach_count }}"></i>
								{% endif %}
								{% if (entry.images_count > 0) %}
									<i class="fa fa-picture-o" title="{{ lang['images.count'] }}: {{ entry.images_count }}"></i>
								{% endif %}
							</td>
							<td nowrap>
								{% if entry.flags.editable %}
									<a href="{{ php_self }}?mod=news&action=edit&id={{ entry.newsid }}">
									{% endif %}
									{{ entry.title }}
									{% if entry.flags.editable %}
									</a>
								{% endif %}
							</td>
							{% if (pluginIsActive('comments')) %}
								{% if entry.flags.comments %}
									<td>
										{% if (entry.comments > 0) %}
											{{ entry.comments }}
										{% endif %}
									</td>
								{% endif %}
							{% endif %}
							<td>
								{% if entry.flags.isActive %}
									<a href="{{ entry.link }}" target="_blank">
									{% endif %}
									{% if (entry.views > 0) %}
										{{ entry.views }}{% else %}-
									{% endif %}
									{% if entry.flags.isActive %}
									</a>
								{% endif %}
							</td>
							<td nowrap>{{ entry.allcats }}</td>
							<td>
								<a href="{{ php_self }}?mod=users&action=editForm&id={{ entry.userid }}">{{ entry.username }}</a>
							</td>
							<td>
								{% if (entry.state == 1) %}
									<i class="fa fa-check text-success" title="{{ lang['state.published'] }}"></i>
								{% elseif (entry.state == 0) %}
									<i class="fa fa-times text-warning" title="{{ lang['state.unpiblished'] }}"></i>
								{% else %}
									<i class="fa fa-book text-danger" title="{{ lang['state.draft'] }}"></i>
								{% endif %}
							</td>
							<td>
								<div class="form-check"><input type="checkbox" name="selected_news[]" class="form-check-input" value="{{ entry.newsid }}"/></div>
							</td>
						</tr>
					{% else %}
						<tr>
							<td colspan="6">
								<p>-{{ lang.editnews['not_found'] }}-</p>
							</td>
						</tr>
					{% endfor %}
				</tbody>
			</table>
		</div>
		<div class="card-footer">
			<div class="row">
				<div class="col-lg-6 mb-2 mb-lg-0">
					{{ pagesss }}
				</div>
				<div class="col-lg-6">
					{% if flags.allow_modify %}
						<div class="input-group">
							<select name="subaction" class="form-select">
								<option value="">--{{ lang.editnews['action'] }}--</option>
								<option value="mass_approve">{{ lang.editnews['approve'] }}</option>
								<option value="mass_forbidden">{{ lang.editnews['forbidden'] }}</option>
								<option value="" class="bg-light" disabled>===================</option>
								<option value="mass_mainpage">{{ lang.editnews['massmainpage'] }}</option>
								<option value="mass_unmainpage">{{ lang.editnews['massunmainpage'] }}</option>
								<option value="" class="bg-light" disabled>===================</option>
								<option value="mass_currdate">{{ lang.editnews['modify.mass.currdate'] }}</option>
								<option value="" class="bg-light" disabled>===================</option>
								{% if flags.comments %}
									<option value="mass_com_approve">{{ lang.editnews['com_approve'] }}</option>
									<option value="mass_com_forbidden">{{ lang.editnews['com_forbidden'] }}</option>
									<option value="" class="bg-light" disabled>===================</option>
								{% endif %}
								<option value="mass_delete">{{ lang.editnews['delete'] }}</option>
							</select>
							<button type="submit" class="btn btn-outline-warning">{{ lang.editnews['submit'] }}</button>
						</div>
					{% endif %}
				</div>
			</div>
		</div>
	</div>
</form>
<script type="text/javascript" src="{{ scriptLibrary }}/ajax.js"></script>
<script type="text/javascript" src="{{ scriptLibrary }}/libsuggest.js"></script>
<script type="text/javascript">
	$('#dr1, #dr2').datetimepicker({format: "d.m.Y"});
$(document).ready(function () {
var aSuggest = new ngSuggest('an', {
'localPrefix': '{{ localPrefix }}',
'reqMethodName': 'core.users.search',
'lId': 'loading-layer',
'hlr': 'true',
'iMinLen': 1,
'stCols': 2,
'stColsClass': [
'cleft', 'cright'
],
'stColsHLR': [true, false]
});
});
</script>
