<nav class="section">
	<ul class="pagination justify-content-center">
		{% if (flags.previous_page) %}
			{{ previous_page }}
		{% endif %}
		{{ pages }}
		{% if (flags.next_page) %}
			{{ next_page }}
		{% endif %}
	</ul>
</nav>
