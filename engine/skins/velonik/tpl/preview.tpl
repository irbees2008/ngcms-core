{% extends 'main.tpl' %}\n
{% block body %}\n{% set mainblock %}\n{{ short }}\n{{ full }}\n{% endset %}\n{{ parent() }}\n
{% endblock %}\n
