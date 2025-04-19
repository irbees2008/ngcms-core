<!DOCTYPE html>
<html lang="ru">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>{{ lang.theme['404.title'] }}</title>

		<style>
			@import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;600;700 &display=swap');:root {
				--primary: #6c5ce7;
				--secondary: #a29bfe;
				--dark: #2d3436;
				--light: #f5f6fa;
				--error: #ff7675;
			}

			* {
				margin: 0;
				padding: 0;
				box-sizing: border-box;
			}

			body {
				font-family: 'Montserrat', sans-serif;
				background-color: var(--light);
				color: var(--dark);
				height: 100vh;
				display: flex;
				flex-direction: column;
				align-items: center;
				justify-content: center;
				text-align: center;
				padding: 20px;
				background-image: radial-gradient(circle at 10% 20%, rgba(108, 92, 231, 0.1) 0%, rgba(162, 155, 254, 0.05) 90%);
			}

			.container {
				max-width: 600px;
				width: 100%;
			}

			.error-code {
				font-size: 120px;
				font-weight: 700;
				color: var(--primary);
				margin-bottom: 20px;
				position: relative;
				display: inline-block;
				animation: float 3s ease-in-out infinite;
			}

			.error-code::after {
				content: '';
				position: absolute;
				width: 100%;
				height: 5px;
				bottom: 0;
				left: 0;
				background: linear-gradient(90deg, var(--primary), var(--secondary));
				border-radius: 5px;
				transform: scaleX(0);
				transform-origin: right;
				animation: underline 2s ease-in-out infinite;
			}

			h1 {
				font-size: 32px;
				margin-bottom: 20px;
				color: var(--dark);
			}

			p {
				font-size: 18px;
				line-height: 1.6;
				margin-bottom: 30px;
				color: #636e72;
			}

			.btn {
				display: inline-block;
				padding: 12px 30px;
				background: linear-gradient(135deg, var(--primary), var(--secondary));
				color: white;
				text-decoration: none;
				border-radius: 50px;
				font-weight: 600;
				transition: all 0.3s ease;
				box-shadow: 0 4px 15px rgba(108, 92, 231, 0.3);
				position: relative;
				overflow: hidden;
			}

			.btn:hover {
				transform: translateY(-3px);
				box-shadow: 0 6px 20px rgba(108, 92, 231, 0.4);
			}

			.btn:active {
				transform: translateY(1px);
			}

			.btn::before {
				content: '';
				position: absolute;
				top: 0;
				left: -100%;
				width: 100%;
				height: 100%;
				background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
				transition: 0.5s;
			}

			.btn:hover::before {
				left: 100%;
			}

			.illustration {
				width: 200px;
				height: 200px;
				margin: 0 auto 30px;
				position: relative;
			}

			.box {
				position: absolute;
				width: 100px;
				height: 100px;
				background-color: var(--primary);
				border-radius: 20px;
				opacity: 0.8;
			}

			.box-1 {
				top: 0;
				left: 0;
				animation: move1 4s ease-in-out infinite;
			}

			.box-2 {
				bottom: 0;
				right: 0;
				animation: move2 4s ease-in-out infinite;
			}

			@keyframes float {
				0,
				100% {
					transform: translateY(0);
				}
				50% {
					transform: translateY(-15px);
				}
			}

			@keyframes underline {
				0% {
					transform: scaleX(0);
					transform-origin: right;
				}
				50% {
					transform: scaleX(1);
					transform-origin: right;
				}
				51% {
					transform-origin: left;
				}
				100% {
					transform: scaleX(0);
					transform-origin: left;
				}
			}

			@keyframes move1 {
				0,
				100% {
					transform: translate(0, 0) rotate(0deg);
				}
				25% {
					transform: translate(50px, 50px) rotate(90deg);
				}
				50% {
					transform: translate(100px, 0) rotate(180deg);
				}
				75% {
					transform: translate(50px, -50px) rotate(270deg);
				}
			}

			@keyframes move2 {
				0,
				100% {
					transform: translate(0, 0) rotate(0deg);
				}
				25% {
					transform: translate(-50px, -50px) rotate(-90deg);
				}
				50% {
					transform: translate(-100px, 0) rotate(-180deg);
				}
				75% {
					transform: translate(-50px, 50px) rotate(-270deg);
				}
			}

			@media(max-width: 768px) {
				.error-code {
					font-size: 80px;
				}

				h1 {
					font-size: 24px;
				}

				p {
					font-size: 16px;
				}

				.illustration {
					width: 150px;
					height: 150px;
				}

				.box {
					width: 70px;
					height: 70px;
				}
			}
		</style>
	</head>
	<body>
		<div class="container">
			<div class="illustration">
				<div class="box box-1"></div>
				<div class="box box-2"></div>
			</div>
			<div class="error-code">404</div>
			<h1>Упс! Страница не найдена</h1>
			<p>{{ lang.theme['404.description'] }}</p>

			<a href="/" class="btn">Вернуться на главную</a>
		</div>
	</body>
</html>
