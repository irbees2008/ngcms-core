# Руководство по разработке плагинов NGCMS

## 1. Назначение

Документ описывает стандартную структуру, жизненный цикл, API и лучшие практики создания плагинов для Next Generation CMS.

## 2. Минимальный набор файлов

```
engine/plugins/<pluginID>/
  <pluginID>.php        # Основная логика, регистрация хуков/страниц
  config.php            # Страница настроек в админке
  install.php           # Установка (миграции БД, дефолтные параметры)
  uninstall.php         # Деинсталляция (очистка/удаление таблиц)
  version               # Метаданные плагина
  lang/<locale>/main.ini# Локализация (site, config секции)
  tpl/*.tpl             # Шаблоны вывода
  lib/                  # (опц.) Дополнительные классы/утилиты
  inc/                  # (опц.) Вспомогательные обработчики
```

Минимум: `version`, основной файл, `config.php`.

## 3. Файл `version`

Поля: `ID`, `Name/Name_EN`, `Version`, `Acts` (где работает: index, news_short, news_full, ppages, twig), `File`, `Config`, `Install`, `Deinstall`, `Description`, `Author`, `MinEngineBuild`, `Icons`. Используется системой для отображения и активации плагина.

## 4. Жизненный цикл

- Установка: `install.php` с функцией `plugin_<id>_install($action)`
  - `confirm` → страница подтверждения через `generate_install_page()`
  - `autoapply|apply` → вызов `fixdb_plugin_install('<id>', $db_update, 'install')`, выставление параметров через `extra_set_param()`, финал `plugin_mark_installed('<id>')`.
- Деинсталляция: `uninstall.php` (рекомендуемый нейминг) — аналогично, но `action = 'deinstall'`, удаляем таблицы (`action'=>'drop'`) и вызываем `plugin_mark_deinstalled()`.

## 5. Описание миграций БД

Массив `$db_update`:

```php
$db_update = [
  [
    'table'  => 'mytable',
    'action' => 'cmodify',  // create/modify объединённый
    'key'    => 'primary key(id)',
    'fields' => [
      ['action'=>'cmodify','name'=>'id','type'=>'int','params'=>'not null auto_increment'],
      ['action'=>'cmodify','name'=>'title','type'=>'varchar(200)','params'=>'not null default ""'],
    ],
  ],
];
fixdb_plugin_install('pluginID', $db_update, 'install');
```

Типы `action` внутри записи таблицы: `create`, `modify`, `cmodify`, `drop`. Поля: `create` или `cmodify`.

## 6. Конфигурация плагина (`config.php`)

Паттерн:

```php
pluginsLoadConfig();
$cfg = [];$grp=[];
array_push($grp,[
  'name'=>'option','title'=>'Заголовок','descr'=>'Описание','type'=>'select','values'=>['0'=>'Нет','1'=>'Да'],
  'value'=>extra_get_param($plugin,'option')
]);
array_push($cfg,['mode'=>'group','title'=>'<b>Настройки</b>','entries'=>$grp]);
if ($_REQUEST['action']=='commit') {
  commit_plugin_config_changes($plugin,$cfg);
  print_commit_complete($plugin);
} else {
  generate_config_page($plugin,$cfg);
}
```

Типы элементов: `input`, `textarea`, `select`, `checkbox`, группы (`mode'=>'group'`). После сохранения значения доступны через `extra_get_param('<id>', '<name>')`.

## 7. Локализация

INI: секции `[site]`, `[config]`. Доступ: `LoadPluginLang('<id>', 'site')`. Ключи формируют массив `$lang['<id>:<key>']` или напрямую `$lang['<key>']` (зависит от загрузчика). Рекомендуется префикс `<id>_` в названиях для уникальности.

## 8. Регистрация страниц и фильтров

- Страница плагина: `register_plugin_page('<id>', '<url_part>', 'function_handler', <flag>);`
  - Пример: `register_plugin_page('rating', '', 'plugin_rating_screen', 0);` → `/plugin/rating/`
- Фильтр новостей: класс наследует `NewsFilter` и регистрируется `register_filter('news','<id>', new MyFilterClass);`
  - Метод `showNews($newsID,$SQLnews,&$tvars,$mode)` позволяет добавлять блоки в шаблон: `$tvars['vars']['plugin_<id>'] = '...';`

## 9. Шаблоны

Поиск: `locatePluginTemplates(array('templateA','templateB'), '<id>', <localsource>, <localskin>)`.

- `localsource=0` → пытаться взять из активного шаблона сайта.
- `localsource=1` → из директории плагина `tpl/`.
  Возврат: ассоциативный массив путей (`$tpath['templateA']`). После подготовки:

```php
$tpl->template('templateA',$tpath['templateA']);
$tpl->vars('templateA',$tvars);
$output = $tpl->show('templateA');
```

Подключение CSS: `register_stylesheet($tpath['url::<file>'] . '/file.css');`.

## 10. Безопасность и практики

- Проверка `if (!defined('NGCMS')) die ('HAL');` в каждом PHP файле.
- Валидация входных данных: `intval`, фильтрация строк, лимиты длины.
- Защита от повторных действий: cookie (пример `rating`), CSRF (если в движке есть токены).
- Логика прав: проверять `$userROW` или группы (роли) перед изменениями.
- Избегать прямых echo; использовать шаблоны и язык для многоязычия.
- Не хранить секреты в `config.php` открыто; использовать параметры или защищённые storage API.

## 11. Производительность

- Кэширование тяжёлых вычислений в памяти (если движок предоставляет API).
- Минимизация запросов: агрегирующие запросы вместо цикла многократных `SELECT`.
- Подгрузка CSS/JS только при необходимости (`register_stylesheet` условно).

## 12. Пример: HelloWorld (полный код)

Цель: продемонстрировать минимальный, но законченный плагин (страница + фильтр новостей + настройка + локализация + миграция БД).

### 12.1 Структура каталогов

```
engine/plugins/helloworld/
  helloworld.php        # Основная логика: страница + фильтр NewsFilter
  config.php            # Одна настройка add_suffix
  install.php           # Создаёт таблицу счётчика и дефолтный параметр
  uninstall.php         # Удаляет таблицу
  version               # Метаданные плагина
  lang/russian/main.ini # Локализация (site + config секции)
  tpl/helloworld.tpl    # Шаблон страницы плагина
```

### 12.2 Файл `version`

```plaintext
;
; Version description file for plugin @@ Next Generation CMS
;
ID: helloworld
Name: Пример HelloWorld
Name_EN: HelloWorld Example
Version: 0.1.0
Acts: index, news_short, news_full
File: helloworld.php
Config: config.php
Install: install.php
Deinstall: uninstall.php
Type: plugin
Description: Демонстрационный плагин: страница + суффикс заголовков новостей + счётчик посещений.
Description_EN: Demo plugin: page + news title suffix + visit counter.
Author: Demo Author
Title: HelloWorld
Information: Показывает базовые приёмы создания плагинов.
Preinstall: no
MinEngineBuild: 23b3116
Icons: <i class="fa fa-smile-o fa-3x" aria-hidden="true"></i>
```

Ключевые поля: `ID` (должен совпадать с названием директории), `Acts` определяет области, где плагин активен.

### 12.3 Файл `install.php`

```php
<?php
// Protect against hack attempts
if (!defined('NGCMS')) die ('HAL');
function plugin_helloworld_install($action) {
  $db_update = array(
    array(
      'table'  => 'helloworld_hits',
      'action' => 'cmodify',
      'key'    => 'primary key(id)',
      'fields' => array(
        array('action' => 'cmodify', 'name' => 'id',  'type' => 'int', 'params' => 'not null auto_increment'),
        array('action' => 'cmodify', 'name' => 'cnt', 'type' => 'int', 'params' => "not null default '0'"),
      ),
    ),
  );
  switch ($action) {
    case 'confirm':
      generate_install_page('helloworld', 'Будет установлена таблица счётчика посещений.');
      break;
    case 'autoapply':
    case 'apply':
      if (fixdb_plugin_install('helloworld', $db_update, 'install', ($action == 'autoapply'))) {
        extra_set_param('helloworld', 'add_suffix', 1);
        extra_commit_changes();
        plugin_mark_installed('helloworld');
      } else {
        return false;
      }
      break;
  }
  return true;
}
```

Особенности: единая миграция `cmodify`, запись дефолтного параметра через `extra_set_param`.

### 12.4 Файл `uninstall.php`

```php
<?php
if (!defined('NGCMS')) die ('HAL');
pluginsLoadConfig();
$db_update = array([
  'table'  => 'helloworld_hits',
  'action' => 'drop',
]);
if ($_REQUEST['action'] == 'commit') {
  if (fixdb_plugin_install('helloworld', $db_update, 'deinstall')) {
    plugin_mark_deinstalled('helloworld');
  }
} else {
  generate_install_page('helloworld', 'Плагин будет удалён, таблица счётчика удалена.', 'deinstall');
}
```

Удаление: таблица помечается на `drop`, затем плагин помечается как деинсталлирован.

### 12.5 Файл `config.php`

```php
<?php
if (!defined('NGCMS')) die ('HAL');
pluginsLoadConfig();
$cfg = [];$group = [];
array_push($group, [
  'name' => 'add_suffix',
  'title' => 'Добавлять суффикс к заголовкам новостей',
  'descr' => 'Если включено, к заголовку добавляется слово из локализации (helloworld_suffix).',
  'type' => 'select',
  'values' => ['0' => 'Нет', '1' => 'Да'],
  'value' => extra_get_param($plugin, 'add_suffix'),
]);
array_push($cfg, ['mode' => 'group', 'title' => '<b>Настройки HelloWorld</b>', 'entries' => $group]);
if (isset($_REQUEST['action']) && $_REQUEST['action'] == 'commit') {
  commit_plugin_config_changes($plugin, $cfg);
  print_commit_complete($plugin);
} else {
  generate_config_page($plugin, $cfg);
}
```

Настройка: селектор (Да/Нет) читается через `extra_get_param('helloworld','add_suffix')`.

### 12.6 Файл `helloworld.php`

```php
<?php
if (!defined('NGCMS')) die ('HAL');
function plugin_helloworld_screen() {
  global $mysql, $tpl, $template;
  LoadPluginLang('helloworld', 'site');
  $mysql->query("insert into " . prefix . "_helloworld_hits (id, cnt) values (1,1) on duplicate key update cnt = cnt + 1");
  $rec = $mysql->record("select cnt from " . prefix . "_helloworld_hits where id = 1");
  $tpath = locatePluginTemplates(['helloworld'], 'helloworld', 1);
  $tvars = [];
  $tvars['vars']['title'] = $GLOBALS['lang']['helloworld_page_title'] ?? 'HelloWorld';
  $tvars['vars']['body']  = $GLOBALS['lang']['helloworld_page_body'] ?? 'Demo plugin body';
  $tvars['vars']['hits']  = intval($rec['cnt']);
  $tpl->template('helloworld', $tpath['helloworld']);
  $tpl->vars('helloworld', $tvars);
  $template['vars']['mainblock'] = $tpl->show('helloworld');
}
class HelloWorldNewsFilter extends NewsFilter {
  public function showNews($newsID, $SQLnews, &$tvars, $mode = []) {
    LoadPluginLang('helloworld', 'site');
    if (extra_get_param('helloworld', 'add_suffix') && isset($tvars['vars']['title'])) {
      $suffix = $GLOBALS['lang']['helloworld_suffix'] ?? 'Hello';
      $tvars['vars']['title'] .= ' ' . $suffix;
    }
  }
}
register_filter('news', 'helloworld', new HelloWorldNewsFilter);
register_plugin_page('helloworld', '', 'plugin_helloworld_screen', 0);
```

Здесь: страница инкрементирует счётчик, фильтр добавляет суффикс при показе новости.

### 12.7 Локализация `lang/russian/main.ini`

```ini
[site]
helloworld_suffix = Привет
helloworld_page_title = Пример страницы HelloWorld
helloworld_page_body = Это демонстрационная страница плагина HelloWorld.
[config]
helloworld:descr = Демонстрационный плагин (пример структуры)
helloworld:add_suffix_title = Добавлять суффикс к заголовкам новостей
helloworld:add_suffix_descr = Включите, чтобы к заголовку новости добавлялось слово из локализации
```

Секции: `[site]` для фронтенд, `[config]` для панели настроек.

### 12.8 Шаблон `tpl/helloworld.tpl`

```twig
<div class="helloworld-wrapper">
  <h1>{{ title }}</h1>
  <p>{{ body }}</p>
  <p><small>Просмотров страницы: {{ hits }}</small></p>
</div>
<style>
.helloworld-wrapper {max-width:600px;margin:30px auto;font-family:Arial,sans-serif;}
.helloworld-wrapper h1 {margin:0 0 10px;font-size:28px;}
.helloworld-wrapper p {line-height:1.5;}
</style>
```

Шаблон выводит заголовок, текст и количество просмотров; стили можно вынести в отдельный CSS + подключить через `register_stylesheet`.

### 12.9 Ключевые точки для адаптации

- Для Ajax: добавить обработчик и зарегистрировать страницу с отдельным параметром.
- Для блоков: создать `block_helloworld.php` и в нём генерировать виджет.
- Для скинов: добавить `tpl/skins/<skinName>/helloworld.tpl` и переключать через параметры `localsource/localskin`.

### 12.10 Итог

Плагин покрывает: миграции, локализацию, конфиг, фильтр, страницу, шаблон. Можно расширять, добавляя новые таблицы, права доступа и кэш.

## 13. Чеклист перед публикацией

1. Файл `version` корректен (ID совпадает с директорией).
2. Защита `defined('NGCMS')` в каждом PHP.
3. Все языковые строки вынесены в `lang/`.
4. Нет жёстких путей; используется API движка (`prefix`, `generateLink`).
5. Миграции чистые: `install.php` создаёт, `uninstall.php` удаляет.
6. Конфиг сохраняется и значения читаются через `extra_get_param`.
7. Шаблоны без inline PHP.
8. Кодировка файлов UTF-8 без BOM (рекомендуется).
9. По необходимости — регистрация CSS/JS.
10. Документация/README (опционально) описывает цель и параметры.

## 14. Расширения

- Дополнительные блоки: `block_<id>.php` могут размещаться для виджетов.
- Ajax обработчики: отдельные файлы с проверкой доступа.
- Скины: подкаталог `tpl/skins/<skinName>` + параметры `localsource/localskin`.

## 15. Типовые ошибки

- Отсутствует вызов `pluginsLoadConfig()` → настройки не отображаются.
- Неверный ID в `version` → плагин не активируется.
- Не зарегистрирована страница через `register_plugin_page` → 404 при обращении.
- Пропущена деинсталляция таблиц → «мусор» в БД.

## 16. Рекомендации по стилю

- Имена опций: короткие, без пробелов, латиница (`add_suffix`).
- Локализация: ключи с префиксом (`helloworld_suffix`).
- Отсутствие бизнес-логики внутри шаблонов.
- Небольшие функции: каждая отвечает за одну задачу (обновить рейтинг, показать форму, обработать отправку и т.п.).

## 17. Быстрый старт

1. Скопируйте пример `helloworld`.
2. Переименуйте директорию/ID и скорректируйте файл `version`.
3. Измените таблицы и параметры в `install.php`.
4. Добавьте свои фильтры/страницы.
5. Установите плагин через админку.
6. Проверьте работу страниц и опций.

## 18. Дополнительно

## Изучите плагины `rating`, `guestbook`, `pm`, `xfields` для продвинутых паттернов: скины, динамические поля, фильтры, хуки новостей, расширение пользовательских данных.

Документ можно расширять разделами по безопасности, тестированию и интеграции с внешними сервисами.
