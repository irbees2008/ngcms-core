<?php

@error_reporting(E_ALL ^ E_WARNING ^ E_NOTICE);
@ini_set('display_errors', true);
@ini_set('html_errors', false);
@ini_set('error_reporting', E_ALL ^ E_WARNING ^ E_NOTICE);

@include_once $_SERVER['DOCUMENT_ROOT'] . '/engine/core.php';

if (!$userROW) die("error");

if ($_POST['title'] < 3) die();

$title = $_POST['title'];
$buffer = "";

foreach ($mysql->select("SELECT * FROM " . prefix . "_news WHERE title LIKE '%{$title}%' ORDER BY id LIMIT 0,5") as $row) {

	$url = newsGenerateLink($row, false, 0, true);
	$buffer .= "<li><span title=\"ИД новости\">#{$row['id']}</span><a href=\"{$url}\" target=\"_blank\">{$row['title']}</a></li>";
}

@header("Content-type: text/html; charset=utf-8");
if (!$buffer) $buffer = "<li>Совпадений не найдено</li>";
echo $buffer;
