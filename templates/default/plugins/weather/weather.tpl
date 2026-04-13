<div class="weather-widget">
	<div class="weather-header">
		<h3>Погода в
			{{ weather.city }}</h3>
	</div>
	<div class="weather-content">
		<div class="weather-main">
			<img src="{{ weather.icon }}" alt="{{ weather.description }}" title="{{ weather.description }}"/>
			<span class="temp">{{ weather.temp }}{{ weather.units }}</span>
		</div>
		<div class="weather-details">
			<p>{{ weather.description }}</p>
			<p>Влажность:
				{{ weather.humidity }}%</p>
			<p>Ветер:
				{{ weather.wind }}
				м/с</p>
		</div>
	</div>
</div>

<style>
	.weather-widget {
		border: 1px solid #ddd;
		border-radius: 5px;
		padding: 10px;
		margin: 10px 0;
		background: #f9f9f9;
	}
	.weather-header h3 {
		margin: 0 0 10px;
		color: #333;
	}
	.weather-main {
		display: flex;
		align-items: center;
		margin-bottom: 10px;
	}
	.weather-main img {
		width: 50px;
		height: 50px;
		margin-right: 10px;
	}
	.temp {
		font-size: 24px;
		font-weight: bold;
	}
	.weather-details p {
		margin: 5px 0;
		font-size: 14px;
	}
</style>
