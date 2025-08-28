<?php
// Защита от прямого доступа
if (!defined('NGCMS')) die ('HAL');

// Обработчик добавления комментариев через стандартную систему модулей NGCMS

global $config, $template, $tpl, $lang;

// Проверяем, что плагин comments активен
if (!getPluginStatusActive('comments')) {
    msg(array("type" => "error", "text" => "Плагин комментариев не активен"));
    return;
}

// Подключаем файлы плагина
$includeFile1 = root . "/plugins/comments/inc/comments.show.php";
$includeFile2 = root . "/plugins/comments/inc/comments.add.php";

if (file_exists($includeFile1)) {
    include_once($includeFile1);
}
if (file_exists($includeFile2)) {
    include_once($includeFile2);
}

// Проверяем, что функция существует
if (!function_exists('comments_add')) {
    msg(array("type" => "error", "text" => "Функция добавления комментариев не найдена"));
    return;
}

// Проверяем метод запроса
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    msg(array("type" => "error", "text" => "Неверный метод запроса"));
    return;
}

// Вызываем функцию добавления комментария
$addResult = comments_add();

if (is_array($addResult)) {
    // Успешно добавлен
    if (isset($_REQUEST['ajax']) && $_REQUEST['ajax']) {
        // AJAX режим
        $SQLnews = $addResult[0];
        $commentId = $addResult[1];
        
        $callingCommentsParams = array('outprint' => true);
        $output = array(
            'status' => 1,
            'rev' => intval(pluginGetVariable('comments', 'backorder')),
            'data' => comments_show($SQLnews['id'], $commentId, $SQLnews['com'] + 1, $callingCommentsParams),
        );
        
        header('Content-Type: application/json');
        echo json_encode($output);
        exit;
    } else {
        // Обычный режим - перенаправляем на новость
        $nlink = newsGenerateLink($addResult[0]);
        header("Location: " . $nlink);
        exit;
    }
} else {
    // Ошибка при добавлении
    if (isset($_REQUEST['ajax']) && $_REQUEST['ajax']) {
        $output = array(
            'status' => 0,
            'data' => isset($template['vars']['mainblock']) ? $template['vars']['mainblock'] : 'Ошибка при добавлении комментария',
        );
        header('Content-Type: application/json');
        echo json_encode($output);
        exit;
    }
    // Для обычного режима показываем ошибку
    $template['vars']['mainblock'] = isset($template['vars']['mainblock']) ? $template['vars']['mainblock'] : 'Ошибка при добавлении комментария';
}
?>