<div class="widget widget-gallery">

    <div class="widget-body">
        <div class="row">
            {% for img in images %}
            <p class="col-sm-12">
                <img src="{{ img.src_thumb }}" alt="{{ img.title }}" class="card-img img-fluid" style="max-width: 400px;" />
            </p>
            {% endfor %}
        </div>
    </div>

</div>