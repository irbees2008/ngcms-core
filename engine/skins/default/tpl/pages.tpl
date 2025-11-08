<nav aria-label="Page navigation example">
	<ul class="pagination mb-0">
		{% if flags.previous_page %}
			{{ previous_page|raw }}
		{% endif %}
		{{ pages|raw }}
		{% if flags.next_page %}
			{{ next_page|raw }}
		{% endif %}
	</ul>
</nav>
