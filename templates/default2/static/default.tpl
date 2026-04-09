<!-- Page Header -->
<header class="intro-header" style="background-image: url('{tpl_url}/img/home-bg.jpg')">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-lg-8 col-md-10">
				<div class="post-heading">
					{% if havePermission %}
						<a href="{{ edit_static_url }}" class="pull-right ">
							<i class="fa fa-pencil"></i>
						</a>
					{% endif %}
					<h1>{{ Title }}</h1>
					<hr class="small">
				</div>
			</div>
		</div>
	</div>
</header>
<!-- Page Content -->
<div class="container">
	<div class="row justify-content-center">
		<div class="col-lg-8 col-md-10">
			<article>
				{{ content }}
				<hr class="alert-info"/>
				<small title="{{ Date }}">
					<i class="fa fa-calendar"></i>&nbsp;{{ Date | date  }}</small>
				<a href="{{ print_static_url }}" rel="nofollow" class="pull-right btn btn-sm btn-outline-secondary">
					<i class="fa fa-print"></i>
				</a>
			</article>
		</div>
	</div>
</div>
