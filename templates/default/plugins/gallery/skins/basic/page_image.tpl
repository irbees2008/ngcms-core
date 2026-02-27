<h2 class="section-title">{{ image.name }}</h2>

<section class="section">
    <div class="card">
        <img src="{{ image.src }}" alt="{{ image.name }}" class="card-img-top img-fluid" style="
            display: block;
            width: 100%;
            height: auto;
        " />
        <div class="card-body">
            <p class="card-text">
                {{ image.description }}
            </p>
            <p class="card-text">
                <small class="text-muted pull-left">Загружено: {{ image.date }}</small>
                <small class="text-muted pull-right">
                    Просмотров: {{ image.views }}
                </small>
            </p>
        </div>
    </div>
</section>

<nav class="section">
    <ul class="pagination justify-content-center">
        <li>{{ prevlink }}
        <li>{{ gallerylink }}
        <li>{{ nextlink }}
    </ul>
</nav>
