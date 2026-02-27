<h2 class="section-title">{{ lang['gallery:title'] }}</h2>

<section class="section">
    <div class="card-columns">
        {% for gallery in galleries %}
        <div class="card card-inverse">
            <img src="{{ gallery.icon_thumb }}" alt="{{ gallery.title|e }}" class="card-img-top img-fluid" />
            <div class="card-img-overlay">
                <h4 class="card-title">
                    <a href="{{ gallery.url }}" title="{{ gallery.title|e }}">
                        {{ gallery.title }}
                    </a>
                </h4>
                <p class="card-text">Количество изображений: {{ gallery.count }}</p>
            </div>
        </div>
        {% endfor %}
    </div>
</section>

<nav class="section justify-content-center">
    <ul class="pagination">
        {{ pagesss }}
    </ul>
</nav>
