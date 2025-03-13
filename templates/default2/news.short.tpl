[TWIG]
<article class="post-preview">
    <a href="{{ news.url.full }}"><h2 class="post-title">{{ news.title }}</h2></a>
    <p class="post-meta">{% if pluginIsActive('uprofile') %}<a href="{{ news.author.url }}">{% endif %}{{ news.author.name }}{% if pluginIsActive('uprofile') %}</a>{% endif %} &nbsp;&nbsp;•&nbsp;&nbsp; {{ news.date }} &nbsp;&nbsp;•&nbsp;&nbsp; {{ news.categories.masterText }}</p>
    
    <p class="post-img">
<img src="{{ (p.xfields.poster.entries[0].purl ?? null) ?: (news.embed.images[0] ?? null) ?: tpl_url ~ '/img/img-none.png' }}" class="img-fluid"/>

    </p>
     
    <p class="post-body">{{ news.short|truncateHTML(450,'...')|striptags }} <a href="{{ news.url.full }}"><b>[подробнее...]</b></a></p>
</article>
<hr>
[/TWIG]