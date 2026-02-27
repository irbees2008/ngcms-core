<h2 class="section-title">{{ lang['gallery:title'] }} {{ gallery.title }}</h2>

<section class="section">
    <p>{{ gallery.description }}</p>
    <div class="card-columns">
        {% for image in images %}
        <div class="card card-inverse">
            <img src="{{ image.src_thumb }}" alt="{{ image.name|e }}" class="card-img img-fluid" style="
                display: block;
                width: 100%;
                height: auto;
            " />
            <div class="card-img-overlay">
                <h4 class="card-title">
                    <a href="{{ image.url }}" title="{{ image.name|e }}">
                        {{ image.name }}
                    </a>
                </h4>
                <p class="card-text">
                    Просмотров: {{ image.views }}
                </p>
                <p class="card-text">{{ image.description }}</p>
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
