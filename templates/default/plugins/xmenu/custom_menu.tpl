<ul>
	{% for item in items %}
		<li class="{% if item.active %}active{% endif %}">
			<a href="{{ item.url }}">{{ item.name }}</a>
			{% if item.news_count and show_news %}
				<span class="news-count">({{ item.news_count }})</span>
			{% endif %}
		</li>
	{% endfor %}
</ul>
<ul>
	{% for item in items %}
		<li class="{% if item.current %}current-category{% endif %}">
			{% if item.current %}
				<span class="menu-item">{{ item.name }}</span>
			{% else %}
				<a href="{{ item.url }}" class="menu-item">{{ item.name }}</a>
			{% endif %}
			{% if item.news_count and show_news %}
				<span class="news-count">({{ item.news_count }})</span>
			{% endif %}
		</li>
	{% endfor %}
</ul>
<ul>
	{% for item in items %}
		<li class="{% if item.is_current %}current-item{% endif %}">
			{% if item.is_current %}
				<span class="current-category">{{ item.name }}</span>
			{% else %}
				<a href="{{ item.url }}">{{ item.name }}</a>
			{% endif %}
			{% if item.news_count and show_news %}
				<span class="news-count">({{ item.news_count }})</span>
			{% endif %}
		</li>
	{% endfor %}
</ul>
<ul>
	{% for item in items %}
		<li class="{% if item.is_current %}current-category{% endif %}">
			{% if item.url %}
				<a href="{{ item.url }}">{{ item.name }}</a>
			{% else %}
				<span>{{ item.name }}</span>
			{% endif %}
			{% if item.news_count and show_news %}
				<span class="news-count">({{ item.news_count }})</span>
			{% endif %}
		</li>
	{% endfor %}
</ul>
<ul class="xmenu menu-{{ menu_id }}">
	{% for item in items %}
		<li class="{% if item.active or item.is_current %}active{% endif %}">
			{% if item.url and not (item.active or item.is_current) %}
				<a href="{{ item.url }}">{{ item.name }}</a>
				{% if item.news_count %}
					<span class="count">({{ item.news_count }})</span>
				{% endif %}
			{% else %}
				<span class="current-item">{{ item.name }}</span>
				{% if item.news_count %}
					<span class="count">({{ item.news_count }})</span>
				{% endif %}
			{% endif %}
		</li>
	{% endfor %}
</ul>
<style>
.xmenu li.active span.current-item {
    font-weight: bold;
    color: #ff0000; /* или ваш цвет акцентного элемента */
}
</style>
<!-- Debug: currentCategory = {{ currentCategory }}, item.id = {{ item.id }} -->
