<div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="{{ php_self }}">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item active">{{ lang['page-title']|default(lang['page_title']) }}</li>
		</ol>
		<h4>{{ lang['page-title']|default(lang['page_title']) }}</h4>
	</div>
</div>
<form name="form" method="post" action="{{ php_self }}?mod=editcomments">
	<input type="hidden" name="mod" value="editcomments"/>
	<input type="hidden" name="newsid" value="{{ newsid }}"/>
	<input type="hidden" name="comid" value="{{ comid }}"/>
	<input type="hidden" name="poster" value="{{ author }}"/>
	<input type="hidden" name="subaction" value="doeditcomment"/>
	<div class="row">
		<div class="col-lg-8">
			<div id="maincontent" class="x_panel mb-4">
				<div class="x_title">{{ lang['maincontent'] }}</div>
				<div class="x_content">
					<div class="form-group">
						<label class="">{{ lang['comment'] }}</label>
						<textarea name="comment" class="form-control" rows="10" cols="70">{{ text }}</textarea>
					</div>
					{{ quicktags|raw }}
					<div id="modal-smiles" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="smiles-modal-label" aria-hidden="true">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<h5 id="smiles-modal-label" class="modal-title">Вставить смайл</h5>
									<button type="button" class="btn-close" data-dismiss="modal" aria-label="Close"></button>
								</div>
								<div class="modal-body">
									{{ smilies|raw }}
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-outline-dark" data-dismiss="modal">Cancel</button>
								</div>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="">{{ lang['answer'] }}</label>
						<textarea id="content" name="content" class="form-control" rows="10" cols="70">{{ answer }}</textarea>
					</div>
				</div>
			</div>
		</div>
		<div id="additional" class="col col-lg-4">
			<div class="x_panel mb-4">
				<div class="x_title">{{ lang['additional'] }}</div>
				<div class="x_content">
					<ul class="list-unstyled">
						<li>{{ lang['date'] }}:
							<b>{{ comdate }}</b>
						</li>
						<li>{{ lang['ip'] }}:
							<b>
								<a href="http://www.nic.ru/whois/?ip={{ ip }}" target="_blank">{{ ip }}</a>
							</b>
						</li>
						<li>{{ lang['name'] }}:
							<b>{{ author }}</b>
						</li>
					</ul>
					<div class="form-group">
						<label>{{ lang['email'] }}:</label>
						<input type="text" name="mail" value="{{ mail }}" class="form-control"/>
					</div>
					<div class="form-group mb-0">
						<button type="button" onclick="document.location='{{ php_self }}?mod=ipban&iplock={{ ip }}'" class="btn btn-outline-danger">{{ lang['block_ip'] }}</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col col-lg-8">
			<div class="row">
				<div class="col-6 mb-4">
					<button type="button" class="btn btn-outline-danger" onclick="confirmit('{{ php_self }}?mod=editcomments&subaction=deletecomment&newsid={{ newsid }}&comid={{ comid }}&poster={{ author }}', '{{ lang['sure_del'] }}')">
						<span class="d-xl-none">
							<i class="fa fa-trash"></i>
						</span>
						<span class="d-none d-xl-block">{{ lang['delete'] }}</span>
					</button>
				</div>
				<div class="col-6 mb-4 text-right">
					<div class="form-group">
						<button type="submit" class="btn btn-outline-success" accesskey="s">
							<span class="d-xl-none">
								<i class="fa fa-floppy-o"></i>
							</span>
							<span class="d-none d-xl-block">{{ lang['save'] }}</span>
						</button>
					</div>
					<div class="form-group">
						<label class="d-block">
							<input type="checkbox" name="send_notice" value="send_notice"/>
							{{ lang['send_notice'] }}
						</label>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>
