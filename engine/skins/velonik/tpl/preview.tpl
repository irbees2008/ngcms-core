{% extends 'main.tpl' %}
{#
	Preview template.
	Исправлено: убраны текстовые маркеры [TWIG] [/TWIG], т.к. любой текст вне блока при наличии extends
	приводил к ошибке "content outside Twig blocks".
	Переменная mainblock формируется локально и передаётся в родительский шаблон через parent().
#}
{% block body %}
	{% set mainblock %}
	{{ short|raw }}
	{{ full|raw }}
	{% endset %}
	{{ parent() }}
{% endblock %}
