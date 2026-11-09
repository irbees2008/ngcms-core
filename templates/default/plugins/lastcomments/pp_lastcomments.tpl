<style>
	.comments-widget {
    width: 100%;
    margin: 0 auto;
    background: transparent;
}

.comments-widget__header {
    display: flex;
    height: 36px;
    align-items: center;
}

.comments-widget__header-decoration {
    height: 36px;
    flex: 0 0 7px;
}

.comments-widget__title {
    flex: 1;
    margin: 0;
    padding: 0 10px;
    height: 36px;
    line-height: 36px;
    
    font-weight: bold;
    font-size: 1em;
}
.comments-widget__content {
    display: flex;
   
}

.comments-widget__content-decoration {
    flex: 0 0 7px;
}

.comments-widget__main {
    flex: 1;
    padding: 15px;
}

.comments-widget__empty {
    margin: 0;
    color: #666;
    text-align: center;
}

.comments-widget__footer {
    display: flex;
    height: 11px;
}

.comments-widget__footer-decoration {
    height: 11px;
}

.comments-widget__footer-decoration--left {
    flex: 0 0 7px;

}

.comments-widget__footer-decoration--middle {
    flex: 1;

}

.comments-widget__footer-decoration--right {
    flex: 0 0 7px;
   
}
</style>

<div class="comments-widget">
	<header class="comments-widget__header">
		
<h2 class="comments-widget__title">{{ lang['lastcomments:lastcomments'] }}</h2>

	</header>

	<div class="comments-widget__content">
		
		<div class="comments-widget__main">
			{% if comnum == 0 %}
<p class="comments-widget__empty">{{ lang['lastcomments:lastcomments_no'] }}</p>

			{% else %}
				<div class="comments-list">
					{% for entry in entries %}
						{% include localPath(0) ~ "entries.tpl" %}
					{% endfor %}
				</div>
			{% endif %}
		</div>

	</div>

</div>
