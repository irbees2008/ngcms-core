<script language="javascript">
	function sw_update() {
    var x = document.getElementById('switcher_selector');
    var date = new Date();
    
    // Устанавливаем дату на 1 год вперед
    date.setTime(date.getTime() + (365 * 24 * 60 * 60 * 1000)); // 365 дней * 24 часа * 60 минут * 60 секунд * 1000 миллисекунд

    // Преобразуем дату в формат UTCString для использования в куках
    var expires = "expires=" + date.toUTCString();

    // Устанавливаем куку с указанным значением и сроком действия
    document.cookie = 'sw_template=' + x.value + '; ' + expires + '; path=/';

    // Перезагружаем страницу, чтобы изменения вступили в силу
    document.location = document.location;
}
</script>
<div class="block archive-block">
	<div class="block-title">Выбор профиля</div>
	<select id="switcher_selector">{list}</select>
	<input type=button onclick="sw_update();" class="button" value="Выбрать">
</div>