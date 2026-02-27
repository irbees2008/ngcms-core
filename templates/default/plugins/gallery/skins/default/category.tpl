<div class="widget widget-gallery">
    <div class="widget-header">
        <h4 class="widget-title">{{ lang['gallery:title'] }}</h4>
    </div>
    <div class="widget-body">
        <ul class="list-unstyled">
            {% for gallery in galleries %}
                <li><a href="{{ gallery.url }}" title="{{ gallery.title }}">{{ gallery.title }} <span class="pull-right">{{ gallery.count }}</span></a></li>
            {% endfor %}
        </ul>
    </div>
    <div class="widget-footer">
        <p><a href="{{ url_main }}" title="Страница плагина" class="text-muted pull-right">Страница плагина &raquo;</a></p>
    </div>
</div>