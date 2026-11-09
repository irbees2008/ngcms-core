<div class="last-comments-widget">
	<header class="last-comments-header">
		<h2 class="last-comments-title">Последние комментарии</h2>
	</header>

	<div class="last-comments-content">
		{% if comnum == 0 %}
			<p class="last-comments-empty">Комментариев пока что нет.</p>
		{% else %}
			<div class="last-comments-list">
				{% for entry in entries %}
					<article class="last-comment {{ entry.alternating }}">
						{% if entry.avatar %}
							<div class="last-comment-avatar">
								{% if entry.author_link %}
									<a href="{{ entry.author_link }}">{{ entry.avatar|raw }}</a>
								{% else %}
									{{ entry.avatar|raw }}
								{% endif %}
							</div>
						{% endif %}

						<div class="last-comment-body">
							<header class="last-comment-meta">
								<span class="last-comment-author">
									{% if entry.author_link %}
										<a href="{{ entry.author_link }}">{{ entry.author }}</a>
									{% else %}
										{{ entry.author }}
									{% endif %}
								</span>
								<span class="last-comment-date">{{ entry.date }}</span>
							</header>

							<h3 class="last-comment-news-title">
								<a href="{{ entry.link }}">{{ entry.title }}</a>
							</h3>

							<div class="last-comment-text">
								{{ entry.text|raw }}
							</div>

							{% if entry.answer %}
								<div class="last-comment-answer">
									<strong>Ответ
										{{ entry.name }}:</strong>
									<div>{{ entry.answer|raw }}</div>
								</div>
							{% endif %}
						</div>
					</article>
				{% endfor %}
			</div>
		{% endif %}
	</div>

	<footer class="last-comments-footer">

<a href="{{ lastcomments_url }}" title="{{ lang['lastcomments:lastcomments_desc'] }}">{{ lang['lastcomments:lastcomments_desc'] }}</a>

	</footer>

</div>

<style>
	.last-comments-widget {
		border-radius: 5px;
		overflow: hidden;
		box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
		margin-bottom: 20px;
	}

	.last-comments-header {
		background: #2c3e50;
		color: #fff;
		padding: 10px 15px;
	}

	.last-comments-title {
		margin: 0;
		font-size: 1.2em;
	}

	.last-comments-content {
		background: white;
		padding: 15px;
	}

	.last-comments-empty {
		margin: 0;
		color: #666;
		text-align: center;
	}

	.last-comment {
		display: flex;
		margin-bottom: 15px;
		padding-bottom: 15px;
		border-bottom: 1px solid #eee;
	}

	.last-comment:last-child {
		margin-bottom: 0;
		padding-bottom: 0;
		border-bottom: none;
	}

	.last-comment-avatar {
		flex: 0 0 50px;
		margin-right: 15px;
	}

	.last-comment-avatar img {
		max-width: 100%;
		height: auto;
		border-radius: 3px;
	}

	.last-comment-body {
		flex: 1;
	}

	.last-comment-meta {
		display: flex;
		justify-content: space-between;
		margin-bottom: 5px;
		font-size: 0.9em;
		color: #666;
	}

	.last-comment-news-title {
		margin: 0 0 5px;
		font-size: 1em;
	}

	.last-comment-text {
		font-size: 0.9em;
		line-height: 1.4;
	}

	.last-comment-answer {
		margin-top: 10px;
		padding: 10px;
		background: #f9f9f9;
		border-left: 3px solid #ddd;
		font-size: 0.85em;
	}

	.last-comments-footer {
		height: 11px;
		background: linear-gradient(to right, #f5f5f5, #ddd, #f5f5f5);
	}

	/* Четные/нечетные комментарии */
	.last-comments-even {
		background-color: #f9f9f9;
	}
	.last-comments-odd {
		background-color: white;
	}
</style>
