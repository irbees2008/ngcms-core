# Шаблон `lostpassword.tpl`

Данный шаблон отвечает за генерацию страницы восстановления утерянного пароля.
Следует учитывать, что за набор используемых переменных отвечают плагины авторизации и их настройки, поэтому в этом шаблоне вы не найдёте предопределённого набора переменных с использованием которых можно восстановить пароль.
Для генерации страницы восстановления утраченного пароля используется сразу 3 шаблона:

- `lostpassword.tpl` – Основной шаблон.
  Шаблон должен содержать форму (тег `<form>`, метод запроса – _POST_), которая позволит вводить данные, необходимые для восстановления пароля.

## Доступные блоки / переменные

### Поля ввода

В форме должны содержаться следующие поля ввода с именами:

- `vcode` (тип: `text`) – в это поле пользователь будет вводить значение защитного кода безопасности.

### Блоки:

- `flags` – блок переменных-флагов:
  - `hasCaptcha` – содержимое блока отображается, если включена поддержка защитного кода безопасности (_Настройки системы_ –> _Безопасность_ –> _Код безопасности_).

### Переменные:

- `entries` – используется для вставки списка строк с переменными, необходимыми для восстановления пароля;
- `captcha_source_url` – URL защитного кода безопасности.

### Доступные языковые переменные:

- `{{ lang['lostpassword'] }}` – заголовок блока «Напоминание пароля».
- `{{ lang['send_pass'] }}` – текст «Напомнить пароль!» для кнопки отправки формы.

## Пример заполнения шаблона

В примере показан минимально набор для полнофункциональной работы:

```html
<div class="block-title">{{ lang['lostpassword'] }}</div>
{{ entries }} {% if flags.hasCaptcha %}
<form name="lostpassword" action="{{ form_action }}" method="post">
  <input type="hidden" name="type" value="send" />
  {% if flags.hasCaptcha %}
  <div class="label label-table captcha pull-left">
    <label>{{ lang['captcha'] }}:</label>
    <input type="text" name="vcode" class="input" />
    <img
      id="img_captcha"
      onclick="reload_captcha();"
      src="{{ captcha_source_url }}?force=1"
      alt="{{ lang['captcha'] }}"
      style="cursor: pointer;" />
    <div class="label-desc">{{ lang['captcha_desc'] }}</div>
  </div>
  {% endif %}
  <div class="clearfix"></div>
  <div class="label">
    <input type="submit" value="{{ lang['send_pass'] }}" class="button" />
  </div>
</form>
{% endif %}
<script type="text/javascript">
  function reload_captcha() {
    var captcha = document.getElementById("img_captcha");
    if (captcha) {
      captcha.src = "{{ captcha_source_url }}?force=1&t=" + Date.now();
    }
  }
</script>
```
