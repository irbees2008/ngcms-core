<ul class="xmenu menu-{{ menu_id }}">
	{% for item in items %}
		<li class="{% if item.active %}active{% endif %}">
			<a href="{{ item.url }}">{{ item.name }}</a>
			{% if item.news_count %}
				<span class="count">({{ item.news_count }})</span>
			{% endif %}
		</li>
	{% endfor %}
</ul>
