@echo off
chcp 65001 >nul
echo ========================================
echo   Запуск сервера документации NGCMS
echo ========================================
echo.
echo Сервер запустится на http://localhost:8080
echo.
echo Для остановки нажмите Ctrl+C
echo.
echo ========================================

cd /d "%~dp0"
php -S localhost:8080

pause
