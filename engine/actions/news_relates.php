<?php
@error_reporting(E_ALL ^ E_WARNING ^ E_NOTICE);
@ini_set('display_errors', true);
@ini_set('html_errors', false);
@ini_set('error_reporting', E_ALL ^ E_WARNING ^ E_NOTICE);
@include_once $_SERVER['DOCUMENT_ROOT'] . '/engine/core.php';
if (!$userROW) die("error");
$title = isset($_POST['title']) && is_string($_POST['title']) ? trim($_POST['title']) : '';
if (mb_strlen($title, 'UTF-8') < 3) die();
$titlePrefix = strtr($title, ['\\' => '\\\\', '%' => '\\%', '_' => '\\_']);
$buffer = "";
foreach ($mysql->select(
	'SELECT id, title, alt_name, catid, postdate FROM ' . prefix . '_news WHERE title LIKE '
		. db_squote($titlePrefix . '%') . ' ORDER BY id LIMIT 0,5'
) as $row) {
	$url = newsGenerateLink($row, false, 0, true);
	$buffer .= '<li><span title="ИД новости">#' . intval($row['id']) . '</span><a href="'
		. htmlspecialchars($url, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8') . '" target="_blank">'
		. htmlspecialchars($row['title'], ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8') . '</a></li>';
}
@header("Content-type: text/html; charset=utf-8");
if (!$buffer) $buffer = "<li>Совпадений не найдено</li>";
echo $buffer;
