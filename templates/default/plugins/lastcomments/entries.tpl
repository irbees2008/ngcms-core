<article class="comment-item">
	<div class="comment-avatar">
		<img src="{{ entry.avatar_url }}" alt="Аватар {{ entry.author }}" class="comment-avatar-img">
	</div>
	<div class="comment-content">
		<p class="comment-text">
			&raquo; #{{ entry.comnum }}
			{{ entry.text|raw }}
			<small class="comment-date">({{ entry.date }})</small>
		</p>
		{% if entry.answer %}
			<div class="comment-answer">
				<p>{{ lang['lastcomments_reply'] }}</p>
				<strong>{{ entry.name }}</strong>
			</p>
			<div class="answer-text">{{ entry.answer|raw }}</div>
		</div>
	{% endif %}
	<div class="comment-meta">
		<small class="news-link">
			//
			<a href="{{ entry.link }}" title="{{ entry.title }}">{{ entry.title }}</a>
		</small>
		<p class="comment-author">
			Автор
			{% if entry.author_id and pluginIsActive('uprofile') %}
				<a href="{{ entry.author_link }}" target="_blank" class="author-link">{{ entry.author }}</a>
			{% else %}
				<span class="author-name">{{ entry.author }}</span>
			{% endif %}
		</p>
	</div>
</div>
</article>
<style>
.comment-item {
    display: flex;
    margin-bottom: 1.5rem;
    padding-bottom: 1.5rem;
    border-bottom: 1px solid #eee;
    clear: both;
}

.comment-item:last-child {
    margin-bottom: 0;
    padding-bottom: 0;
    border-bottom: none;
}

.comment-avatar {
    flex: 0 0 42px;
    padding: 5px;
    margin-right: 15px;
}

.comment-avatar-img {
    width: 100%;
    height: auto;
    border-radius: 3px;
}

.comment-content {
    flex: 1;
}

.comment-text {
    margin: 0 0 0.5rem 0;
    line-height: 1.4;
}

.comment-date {
    color: #666;
    font-size: 0.85em;
}

.comment-answer {
    margin: 0.8rem 0;
    padding: 0.8rem;
    background-color: #f8f9fa;
    border-left: 3px solid #dee2e6;
}

.comment-answer p {
    margin: 0 0 0.3rem 0;
    font-weight: bold;
}

.answer-text {
    font-size: 0.9em;
    line-height: 1.4;
}

.comment-meta {
    margin-top: 0.5rem;
}

.news-link {
    display: block;
    margin-bottom: 0.3rem;
}

.comment-author {
    margin: 0;
    font-size: 0.9em;
    color: #555;
}

.author-link {
    color: #007bff;
    text-decoration: none;
}

.author-link:hover {
    text-decoration: underline;
}

.author-name {
    font-weight: bold;
}
</style>