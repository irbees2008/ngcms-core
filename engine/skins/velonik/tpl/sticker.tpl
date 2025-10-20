<noscript>
	<div class="alert alert-{{('error' == type)?'danger':'info'}}">
		{{ message }}
	</div></noscript><script>
	 document.addEventListener('DOMContentLoaded', function (event) {
ngNotifySticker(`{{ message|raw }}`, {
className: 'alert alert- {{ (type == "error") ? "danger" : "info" }}',
sticked: {{ (type == "error") ? "true" : "false" }},
closeBTN: true,
html: true
});
});
</script>
