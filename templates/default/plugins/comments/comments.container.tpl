{% if is_external %}
	<article class="full-post">
		<h1 class="title">
			<a href="{{ link }}">{{ title }}</a>
		</h1>
		<p><br/>
			{% if entries %}
				{{ lang['comments:external.title'] }}
			{% endif %}
		</p>
	</article>
{% endif %}
<div class="comments" id="comments">
	<ul id="comments_list">
		<div id="new_comments_rev"></div>
		{{ entries|raw }}
		<div id="new_comments"></div>
	</ul>
</div>
{# Вынесено в отдельный шаблон comments.pagination.tpl. Если нужен кастом - переопределите его в теме. #}
{% if pagination and pagination.total > 1 %}
	<div class="pagination" id="comments_pagination">
		<ul>
			{# Ссылка «предыдущая» #}
			{% if pagination.prev.exists %}
				<li class="page-prev">
					<a href="{{ pagination.prev.url }}" rel="prev" aria-label="Previous" data-page="{{ pagination.prev.num }}">‹</a>
				</li>
			{% endif %}
			{# Основные элементы #}
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
			{# Ссылка «следующая» #}
			{% if pagination.next.exists %}
				<li class="page-next">
					<a href="{{ pagination.next.url }}" rel="next" aria-label="Next" data-page="{{ pagination.next.num }}">›</a>
				</li>
			{% endif %}
		</ul>
	</div>
{% endif %}
{{ form|raw }}
{% if regonly %}
	<div class="alert alert-info">
		{{ lang['comments:alert.regonly']|raw }}
	</div>
{% endif %}
{% if commforbidden %}
	<div class="alert alert-info">
		{{ lang['comments:alert.forbidden'] }}
	</div>
{% endif %}
{% if not is_external %}
	 <script>
			// Встроенная пагинация комментариев (AJAX подгрузка страниц внутри новости)
			// Inline версия скрипта (внешний файл дал 403). Повторная инициализация предотвращается.
			if(!window.__commentsPaginationInit){
				window.__commentsPaginationInit = true;
				(function(){
					var root = document;
					function findPagination(){ return root.getElementById('comments_pagination'); }
					function insertComments(html){
						var list = root.getElementById('comments_list'); if(!list){ return; }
						var anchorBottom = root.getElementById('new_comments');
						if(!anchorBottom){ anchorBottom = document.createElement('div'); anchorBottom.id='new_comments'; list.appendChild(anchorBottom); }
	
					// ИСПРАВЛЕНИЕ: Очищаем все старые комментарии перед вставкой новых
					var oldComments = list.querySelectorAll('li[id^="comment"]');
					oldComments.forEach(function(li){ li.remove(); });
	
					var temp = document.createElement('div'); temp.innerHTML = html || '';
					var items = temp.querySelectorAll('li[id^="comment"]');
					items.forEach(function(li){
						if(!li.id){ return; }
							list.insertBefore(li, anchorBottom);
						});
					}
					function replacePagination(html){
						var pag = findPagination(); if(!pag){ return; }
						if(html && /id=["']comments_pagination["']/.test(html)){
							pag.outerHTML = html;
						} else {
							pag.innerHTML = html || '';
						}
					}
					function onClick(e){
						var a = e.target.closest ? e.target.closest('#comments_pagination a') : null;
						if(!a){ return; }
						// Отключаем обычный переход
						e.preventDefault();
						// Если активная или loading - игнор
						var liParent = a.closest('li');
						if((liParent && liParent.classList.contains('active')) || a.classList.contains('loading')){ return; }
						var url = a.getAttribute('href'); if(!url){ return; }
						var originalHTML = a.innerHTML; a.classList.add('loading'); a.innerHTML='⏳';
						url += (url.indexOf('?') >= 0 ? '&' : '?') + 'ajax=1&embedded=1';
						fetch(url, {headers:{'X-Requested-With':'XMLHttpRequest'}})
							.then(function(r){ return r.json(); })
							.then(function(data){
								if(!data || !data.status){ return; }
								insertComments(data.entries || '');
								replacePagination(data.pagination || '');
							})
							.finally(function(){ a.classList.remove('loading'); a.innerHTML = originalHTML; });
					}
					root.addEventListener('click', onClick, false);
				})();
			}
			</script>
{% endif %}
