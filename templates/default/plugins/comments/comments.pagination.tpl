{% if pagination and pagination.total > 1 %}
	<div class="pagination" id="comments_pagination">
		<ul>
			{% if pagination.prev.exists %}
				<li class="page-prev">
					<a href="{{ pagination.prev.url }}" rel="prev" aria-label="Previous" data-page="{{ pagination.prev.num }}">‹</a>
				</li>
			{% endif %}
			{% for p in pagination.pages %}
				{% if p.type == 'dots' %}
					<li class="page-dots">
						<span>...</span>
					</li>
				{% elseif p.type == 'current' %}
					<li class="page-current active">
						<span data-page="{{ p.num }}">{{ p.num }}</span>
					</li>
				{% elseif p.type == 'link' %}
					<li class="page-item">
						<a href="{{ p.url }}" data-page="{{ p.num }}">{{ p.num }}</a>
					</li>
				{% endif %}
			{% endfor %}
			{% if pagination.next.exists %}
				<li class="page-next">
					<a href="{{ pagination.next.url }}" rel="next" aria-label="Next" data-page="{{ pagination.next.num }}">›</a>
				</li>
			{% endif %}
		</ul>
	</div>
{% endif %}
