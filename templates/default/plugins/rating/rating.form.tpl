 <script type="text/javascript">
$(document).ready(function() {
	function rating(rating, post_id) {
		console.log('Sending rating:', rating, 'for post:', post_id);
		$.ajax({
			url: "{home}/plugin/rating/",
			method: "POST",
			dataType: "json",
			data: {
				rating: rating,
				post_id: post_id
			},
			success: function(response) {
				console.log('Rating AJAX response:', response);
				console.log('showToast available:', typeof showToast);
				if (response.status === 'success') {
					$('#ratingdiv_' + post_id).html(response.html);
					if (response.notify && typeof showToast !== 'undefined') {
						console.log('Showing notification:', response.notify);
						showToast(response.notify.message, { type: response.notify.type });
					}
				} else if (response.status === 'error') {
					console.log('Error response:', response.notify);
					if (response.notify && typeof showToast !== 'undefined') {
						showToast(response.notify.message, { type: response.notify.type });
					}
				}
			},
			error: function(xhr, status, error) {
				console.error('AJAX error:', status, error);
				console.log('Response text:', xhr.responseText);
				if (typeof showToast !== 'undefined') {
					showToast('Ошибка при отправке оценки', { type: 'error' });
				} else {
					alert('Ошибка при отправке оценки');
				}
			}
		});
	}
	// Привязываем обработчики к ссылкам (делегирование событий)
	$(document).on('click', '.rating a[data-rating]', function(e) {
		e.preventDefault();
		var $this = $(this);
		var ratingValue = $this.data('rating');
		var postId = $this.closest('.rating').data('post-id');
		console.log('Rating clicked - value:', ratingValue, 'postId:', postId);
		if (ratingValue && postId) {
			rating(ratingValue, postId);
		}
	});
});
</script>
<div id="ratingdiv_{post_id}">
	<div class="rating" data-post-id="{post_id}" style="float:left;">
		<ul class="uRating">
			<li class="r{rating}">{rating}</li>
			<li>
				<a href="#" title="{l_rating_1}" class="r1u" data-rating="1"></a>
			</li>
			<li>
				<a href="#" title="{l_rating_2}" class="r2u" data-rating="2"></a>
			</li>
			<li>
				<a href="#" title="{l_rating_3}" class="r3u" data-rating="3"></a>
			</li>
			<li>
				<a href="#" title="{l_rating_4}" class="r4u" data-rating="4"></a>
			</li>
			<li>
				<a href="#" title="{l_rating_5}" class="r5u" data-rating="5"></a>
			</li>
		</ul>
	</div>
</div>
