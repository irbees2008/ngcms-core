<article class="comments">
	<div class="comments__avatar">
		<img src="{{ entry.avatar_url }}" alt="Аватар {{ entry.author }}" class="comment__avatar-img">
	</div>

	<div class="comments__body">
		<div class="comments__content">
			<span class="comments__number">&raquo; #{{ entry.comnum }}</span>
			<div class="comments__text">{{ entry.text|raw }}</div>
			<time class="comments__date">({{ entry.date }})</time>
		</div>

		{% if entry.answer %}
			<div class="comments__reply">
				<div class="comments__reply-header">Ответ от
					<strong>{{ entry.name }}</strong>
				</div>
				<div class="comments__reply-text">{{ entry.answer|raw }}</div>
			</div>
		{% endif %}

		<div class="comments__footer">
			<a href="{{ entry.link }}" class="comments__news-link" title="{{ entry.title }}">
				//
				{{ entry.title }}
			</a>

			<div class="comments__author">
				Автор
				{% if entry.author_id and pluginIsActive('uprofile') %}
					<a href="{{ entry.author_link }}" class="comments__author-link" target="_blank" rel="noopener">{{ entry.author }}</a>
				{% else %}
					<span class="comments__author-name">{{ entry.author }}</span>
				{% endif %}
			</div>
		</div>
	</div>
</article>

<style>
.comments {
    display: flex;
    gap: 12px;
    margin-bottom: 20px;
    padding-bottom: 20px;
    border-bottom: 1px solid #eee;
}

.comments:last-child {
    margin-bottom: 0;
    padding-bottom: 0;
    border-bottom: none;
}

.comments__avatar {
    flex: 0 0 42px;
    padding: 5px;
}

.comments__avatar-img {
    width: 100%;
    height: auto;
    border-radius: 4px;
    display: block;
}

.comments__body {
    flex: 1;
}

.comments__content {
    margin-bottom: 8px;
    line-height: 1.4;
}

.comments__number {
    color: #666;
    margin-right: 5px;
}

.comments__text {
    display: inline;
}

.comments__date {
    color: #999;
    font-size: 0.85em;
}

.comments__reply {
    margin: 10px 0;
    padding: 10px;
    background: #f8f9fa;
    border-left: 3px solid #e1e4e8;
    border-radius: 0 4px 4px 0;
}

.comments__reply-header {
    font-weight: 600;
    margin-bottom: 5px;
}

.comments__reply-text {
    font-size: 0.9em;
}

.comments__footer {
    margin-top: 8px;
    font-size: 0.9em;
}

.comments__news-link {
    color: #555;
    text-decoration: none;
    display: inline-block;
    margin-bottom: 5px;
}

.comments__news-link:hover {
    color: #333;
    text-decoration: underline;
}

.comments__author {
    color: #666;
}

.comments__author-link {
    color: #2a5885;
    text-decoration: none;
}

.comments__author-link:hover {
    text-decoration: underline;
}

.comments__author-name {
    font-weight: 500;
}</style>
