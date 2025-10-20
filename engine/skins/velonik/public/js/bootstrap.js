import * as helpers from "./functions.js";
// Регистрируем импортируемые функции в window
for (const helper in helpers) {
  window[helper] = helpers[helper];
}
// Библиотека `jquery.uploadifive` имеет одно обращение
// к устаревшей jQuery-функции. Делаем заглушку для этого.
jQuery.fn.extend({
  size: function () {
    return this.length;
  },
});
$(document).ready(function () {
  // Если на странице нет токена, то просто проинформируем об этом.
  if (!$('input[name="token"]')) {
    console.info("CSRF token not found");
  }
  // Устанавливаем локаль для `datetimepicker`.
  $.datetimepicker.setLocale(NGCMS.langcode);
});
