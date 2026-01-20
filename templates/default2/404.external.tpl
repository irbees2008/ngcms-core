<!DOCTYPE html>
<html lang="ru">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>{{ lang['404.title']|default('404 - Страница не найдена') }}</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
		<style>
			body {
				background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
				min-height: 100vh;
				display: flex;
				align-items: center;
				justify-content: center;
				font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
				overflow-x: hidden;
			}
			.error-container {
				text-align: center;
				padding: 40px 20px;
			}
			.error-code {
				font-size: 180px;
				font-weight: 900;
				color: #fff;
				text-shadow: 5px 5px 15px rgba(0, 0, 0, 0.3);
				animation: bounce 2s infinite;
				line-height: 1;
				margin-bottom: 20px;
			}
			@keyframes bounce {
				0,
				100% {
					transform: translateY(0);
				}
				50% {
					transform: translateY(-20px);
				}
			}
			.error-title {
				font-size: 36px;
				color: #fff;
				font-weight: 700;
				margin-bottom: 20px;
				text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.2);
			}
			.error-description {
				font-size: 18px;
				color: rgba(255, 255, 255, 0.9);
				margin-bottom: 40px;
				max-width: 600px;
				margin-left: auto;
				margin-right: auto;
				line-height: 1.6;
			}
			.btn-home {
				background: #fff;
				color: #667eea;
				border: none;
				padding: 15px 40px;
				font-size: 18px;
				font-weight: 600;
				border-radius: 50px;
				box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
				transition: all 0.3s ease;
				text-decoration: none;
				display: inline-block;
			}
			.btn-home:hover {
				background: #f0f0f0;
				color: #667eea;
				transform: translateY(-3px);
				box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
			}
			.icon-wrapper {
				font-size: 120px;
				color: rgba(255, 255, 255, 0.3);
				margin-bottom: 30px;
				animation: float 3s ease-in-out infinite;
			}
			@keyframes float {
				0,
				100% {
					transform: translateY(0px) rotate(0deg);
				}
				50% {
					transform: translateY(-20px) rotate(5deg);
				}
			}
			.particles {
				position: fixed;
				top: 0;
				left: 0;
				width: 100%;
				height: 100%;
				overflow: hidden;
				z-index: -1;
			}
			.particle {
				position: absolute;
				background: rgba(255, 255, 255, 0.3);
				border-radius: 50%;
				animation: rise 15s infinite ease-in;
			}
			@keyframes rise {
				0% {
					transform: translateY(100vh) scale(0);
					opacity: 0;
				}
				50% {
					opacity: 1;
				}
				100% {
					transform: translateY(-100vh) scale(1);
					opacity: 0;
				}
			}
			.search-box {
				max-width: 500px;
				margin: 30px auto;
			}
			.search-box input {
				border-radius: 50px;
				padding: 12px 24px;
				border: 2px solid rgba(255, 255, 255, 0.3);
				background: rgba(255, 255, 255, 0.1);
				color: #fff;
				font-size: 16px;
			}
			.search-box input::placeholder {
				color: rgba(255, 255, 255, 0.6);
			}
			.search-box input:focus {
				outline: none;
				border-color: #fff;
				background: rgba(255, 255, 255, 0.2);
				box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
			}
		</style>
	</head>
	<body>
		<div class="particles">
			<div class="particle" style="left: 10%; width: 10px; height: 10px; animation-delay: 0s;"></div>
			<div class="particle" style="left: 20%; width: 15px; height: 15px; animation-delay: 2s;"></div>
			<div class="particle" style="left: 30%; width: 8px; height: 8px; animation-delay: 4s;"></div>
			<div class="particle" style="left: 40%; width: 12px; height: 12px; animation-delay: 1s;"></div>
			<div class="particle" style="left: 50%; width: 10px; height: 10px; animation-delay: 3s;"></div>
			<div class="particle" style="left: 60%; width: 14px; height: 14px; animation-delay: 5s;"></div>
			<div class="particle" style="left: 70%; width: 9px; height: 9px; animation-delay: 2s;"></div>
			<div class="particle" style="left: 80%; width: 11px; height: 11px; animation-delay: 4s;"></div>
			<div class="particle" style="left: 90%; width: 13px; height: 13px; animation-delay: 1s;"></div>
		</div>
		<div class="error-container">
			<div class="icon-wrapper">
				<i class="fas fa-ghost"></i>
			</div>
			<div class="error-code">404</div>
			<h1 class="error-title">{{ lang['404.title']|default('Страница не найдена') }}</h1>
			<p class="error-description">
				{{ lang['404.description']|default('К сожалению, запрашиваемая страница не существует. Возможно, она была перемещена или удалена.') }}
			</p>
			<div class="search-box">
				<input type="text" class="form-control" id="searchInput" placeholder="Попробуйте найти что-нибудь...">
			</div>
			<div class="mt-4">
				<a href="/" class="btn-home">
					<i class="fas fa-home me-2"></i>На главную
				</a>
			</div>
		</div>
		 <script>
		        document.getElementById('searchInput').addEventListener('keypress', function(e) {
		            if (e.key === 'Enter') {
		                var query = this.value;
		                if (query) {
		                    window.location.href = '/index.php?do=search&subaction=search&story=' + encodeURIComponent(query);
		                }
		            }
		        });
		    </script>
	</body>
</html>
