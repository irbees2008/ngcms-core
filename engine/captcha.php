<?php

@require_once 'core.php';
@include_once root . 'includes/classes/captcha.class.php';

// Заголовки, отключающие кэш
@header('Content-type: image/png');
@header('Expires: 0');
@header('Cache-Control: no-store, no-cache, must-revalidate');
@header('Cache-Control: post-check=0, pre-check=0', false);
@header('Pragma: no-cache');

session_start();

// ID блока и флаг форсированной перегенерации
$blockName = $_REQUEST['id'] ?? '';
$force = isset($_GET['force']) ? true : false;

// Генерация нового капча-кода
function generateCaptchaCode($length = 5)
{
    return str_pad(rand(0, pow(10, $length) - 1), $length, '0', STR_PAD_LEFT);
}

// Значение по умолчанию
$cShowNumber = 'n/c';

// Логика выбора/генерации кода
if ($blockName !== '') {
    if ($force || empty($_SESSION['captcha.' . $blockName])) {
        $cShowNumber = generateCaptchaCode();
        $_SESSION['captcha.' . $blockName] = $cShowNumber;
    } else {
        $cShowNumber = $_SESSION['captcha.' . $blockName];
    }
} else {
    if ($force || empty($_SESSION['captcha'])) {
        $cShowNumber = generateCaptchaCode();
        $_SESSION['captcha'] = $cShowNumber;
    } else {
        $cShowNumber = $_SESSION['captcha'];
    }
}

// Отрисовка изображения
$captc = new captcha();
$captc->makeimg($cShowNumber);
