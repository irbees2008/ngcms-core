<noscript>
	<div class="ng-toast ng-toast--{{ ('error' == type) ? 'error' : 'info' }}">
		<span class="ng-toast__content">{{ message }}</span>
	</div>
</noscript>
<script>
	// Выводим тост при наличии движка тостов (подключается в public/js/notify.js)
document.addEventListener('DOMContentLoaded', function () {
if (typeof window.showToast !== 'function') {
return;
}
var cmsType = '{{ type }}';
var cfg = {
type: 'info',
title: 'Info',
sticked: {{ 'error' == type ? 'true' : 'false' }}
};
if (cmsType === 'error') {
cfg.type = 'error';
cfg.title = 'Ошибка';
} else if (cmsType === 'success') {
cfg.type = 'success';
cfg.title = 'Готово';
} else if (cmsType === 'warn' || cmsType === 'warning') {
cfg.type = 'warning';
cfg.title = 'Внимание';
}
window.showToast(`{{ message|raw }}`, cfg);
});
</script>
