<noscript>
	<div class="ng-toast ng-toast--{{ ('error' == type) ? 'error' : 'info' }}">
		<span class="ng-toast__content">{{ message }}</span>
	</div>
</noscript>
<script>
document.addEventListener('DOMContentLoaded', function () {

	ngNotifySticker(`{{ message|raw }}`, {
		className: 'alert-{{ ('error' == type) ? 'danger' : 'info' }}',
		sticked: {{ 'error' == type ? 'true' : 'false' }},
		closeBTN: true
	});
});
</script>
