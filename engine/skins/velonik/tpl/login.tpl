<!DOCTYPE html>
<html lang="{{ lang['langcode'] }}">
	<head>
		<meta charset="{{ lang['encoding'] }}">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>{{ home_title }}
			-
			{{ lang['admin_panel'] }}</title>
		<link href="{{ skins_url }}/public/css/bootstrap.min.css" rel="stylesheet" type="text/css" id="app-style"/>
		<link href="{{ skins_url }}/public/css/custom.min.css.css" rel="stylesheet" type="text/css" id="app-style"/>
		<link href="{{ skins_url }}/public/css/fontawesome.css" rel="stylesheet" type="text/css" id="app-style"/>
		<style>
			.login-bg {
				background: linear-gradient(135deg, #2A3F54 0%, #34495e 100%);
				min-height: 100vh;
			}
			.brand-logo {
				color: #1ABB9C;
				border: 2px solid #1ABB9C;
				padding: 8px 10px;
				border-radius: 50%;
				font-size: 1.2rem;
				margin-right: 10px;
			}
			.login-input-group .form-control,
			.login-input-group .input-group-text,
			.login-input-group .btn {
				height: 38px;
				line-height: 1.5;
			}
			.login-input-group .form-control {
				border-radius: 0;
			}
			.login-input-group .input-group-text {
				border-radius: 0.375rem 0 0 0.375rem;
			}
			.login-input-group .btn {
				border-radius: 0 0.375rem 0.375rem 0;
				border-color: rgb(222, 226, 230) !important;
			}
			.login-input-group .btn:hover {
				background: rgba(0, 0, 0, 0.05) !important;
			}
			.login-input-group .form-control:focus {
				box-shadow: none;
				border-color: #86b7fe;
			}
			.login-input-group .form-control::placeholder {
				padding-left: 8px;
			}
			.eye-btn {
				border-color: rgb(222, 226, 230) !important;
				color: rgb(222, 226, 230) !important;
			}
		</style>
		<script src="{{ skins_url }}/public/js/manifest.js"></script>
		<script src="{{ skins_url }}/public/js/vendor.js"></script>
		<script src="{{ skins_url }}/public/js/login.js"></script>
	</head>
	<body class="login-bg">
		<div class="container-fluid d-flex align-items-center justify-content-center min-vh-100">
			<div class="row justify-content-center w-100">
				<div
					class="col-xl-4 col-lg-5 col-md-6 col-sm-8 col-10">
					<!-- Login Form Card -->
					<div class="card shadow-lg border-0" id="loginCard">
						<div
							class="card-body p-5">
							<!-- Brand Header -->
							<div class="text-center mb-4">
								<div class="d-flex align-items-center justify-content-center mb-3">
									<h3 class="mb-0 fw-bold text-dark">
										<i class="fa fa-rocket"></i>
										<span>Next Generation</span>
									</h3>
								</div>
								<p class="text-muted">Пожалуйста, войдите в свою учетную запись</p>
							</div>
							<!-- Login Form -->
							<form name="login" method="post" action="{{ php_self }}">
								<input type="hidden" name="redirect" value="{{ redirect }}">
								<input type="hidden" name="action" value="login">
								<div class="mb-3">
									<label for="username" class="form-label text-muted">{{ lang['name'] }}</label>
									<div class="input-group login-input-group">
										<span class="input-group-text bg-light border-end-0">
											<i class="fa fa-user text-muted"></i>
										</span>
										<input type="text" class="form-control border-start-0 ps-0" id="username" name="username" placeholder="Введите ваш логин" required>
									</div>
								</div>
								<div class="mb-3">
									<label for="password" class="form-label text-muted">{{ lang['password'] }}</label>
									<div class="input-group login-input-group">
										<span class="input-group-text bg-light border-end-0">
											<i class="fa fa-lock text-muted"></i>
										</span>
										<input type="password" class="form-control border-start-0 ps-0" id="password" name="password" placeholder="Введите ваш пароль" required>
										<button class="btn btn-outline-secondary border-start-0" type="button" id="togglePassword">
											<i class="fa fa-eye" id="eyeIcon"></i>
										</button>
									</div>
								</div>
								<div class="d-grid mb-3">
									<button type="submit" class="btn btn-primary btn-lg">
										<i class="fa fa-sign-in-alt me-2"></i>
										{{ lang['login'] }}
									</button>
								</div>
							</form>
						</div>
					</div>
					<!-- Footer -->
					<div class="text-center mt-4">
						<p class="text-light opacity-75 mb-2">
							2008-{{ year }}
							©
							<a href="http://ngcms.org" style="color:#fafafa;" target="_blank">Next Generation CMS</a>
						</p>
					</div>
				</div>
			</div>
		</div>
		<!-- JavaScript for form switching and password toggle -->
		<script>
			document.addEventListener('DOMContentLoaded', function () {
const loginCard = document.getElementById('loginCard');
const togglePassword = document.getElementById('togglePassword');
const passwordInput = document.getElementById('password');
const eyeIcon = document.getElementById('eyeIcon');
// Password toggle
togglePassword.addEventListener('click', function () {
const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
passwordInput.setAttribute('type', type);
eyeIcon.classList.toggle('fa-eye');
eyeIcon.classList.toggle('fa-eye-slash');
});
});
		</script>
	</body>
</html>
