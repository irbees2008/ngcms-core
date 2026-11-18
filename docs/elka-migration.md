# Замена плагина Elka на Twig

Плагин `elka` больше не нужен для условного вывода: NGCMS предоставляет Twig-функции `isHandler()` и `isCategory()`. Маркеры `[elka_*]` удалены из шаблонов `football_stats`; сам плагин выведен из эксплуатации.

## Проверка маршрута

Используйте `isHandler()` с именем плагина, `плагин:обработчик` или несколькими альтернативами через `|`:

```twig
{% if isHandler('news:main') %}
    Только на главной странице новостей.
{% endif %}

{% if isHandler('news:by.category|news:news') %}
    На странице категории или полной новости.
{% endif %}

{% if not isHandler('news:main|news:by.category|news:news') %}
    На остальных страницах.
{% endif %}
```

Старые маркеры Elka заменяются такими условиями:

| Старый маркер | Twig-условие |
|---|---|
| `[elka_morda]` | `isHandler('news:main')` |
| `[elka_category]` | `isHandler('news:by.category')` |
| `[elka_calendar]` | `isHandler('news:by.day\|news:by.month\|news:by.year')` |
| `[elka_full-news]` | `isHandler('news:news')` |
| `[elka_static]` | `isHandler('static')` |
| `[elka_search]` | `isHandler('search')` |
| `[elka_uprofile]` | `isHandler('uprofile:show\|uprofile:edit')` |
| `[elka_login]` | `isHandler('core:login')` |
| `[elka_registration]` | `isHandler('core:registration')` |
| `[elka_activation]` | `isHandler('core:activation')` |
| `[elka_lostpassword]` | `isHandler('core:lostpassword')` |
| `[elka_tags-tag]` | `isHandler('tags:tag')` |
| `[elka_plugin]` | `not isHandler('news:main\|news:by.category\|news:news')` |

Например:

```text
[elka_morda]Этот блок только на главной[/elka_morda]
```

становится:

```twig
{% if isHandler('news:main') %}Этот блок только на главной{% endif %}
```

Для категории используйте `isCategory()`:

```twig
{% if isCategory('sport') %}
    Блок для категории sport.
{% endif %}
```

Функция принимает ID или alt-имя одной либо нескольких категорий. Она возвращает `false` вне страницы категории новостей.

## Шаблоны Football Stats

Условия в шаблонах [`plugin.main.show.games.tpl`](../engine/plugins/football_stats/tpl/main/plugin.main.show.games.tpl) и [`plugin.main.show.games.row.tpl`](../engine/plugins/football_stats/tpl/main/plugin.main.show.games.row.tpl) переведены на Twig. Остальные переменные в них оставлены в совместимом формате `{variable}`: плагин пока использует старый `$tpl` для подстановки данных, а `$tpl` в текущем движке обрабатывает Twig-условия в шаблоне.

При переносе других шаблонов сначала убедитесь, что их рендерер обрабатывает Twig. В старом шаблонизаторе следует использовать поддерживаемый NGCMS синтаксис `{% if ... %}` для условий, не полагаясь на повторную обработку уже сформированного HTML.

## Страница 404

Для шаблона ошибки можно проверить заголовок страницы, который выставляет движок:

```twig
{% if system_flags.info.title.group == lang['404.title'] %}
    Страница не найдена.
{% endif %}
```
