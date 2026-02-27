<ul>
    {% for img in images %}
    <li><a data-fancybox="group" data-caption="Шахтинск" href="{{ img.src }}" title="Шахтинск">
        <img src="{{ img.src_thumb }}" alt="Шахтинск" /></a></li>
    {% endfor %}
</ul>
