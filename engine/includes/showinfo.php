<?php

//
// Copyright (C) 2008 Next Generation CMS (http://ngcms.ru/)
// Name: showinfo.php
// Description: Show different informational blocks
// Author: Vitaly Ponomarev
//

// Validate include path to prevent directory traversal
$corePath = realpath('../core.php');
if ($corePath === false || !str_starts_with($corePath, realpath('../'))) {
    exit('Invalid path');
}
include_once $corePath;

// Protect against hack attempts
if (!defined('NGCMS')) {
    throw new Exception('HAL');
}

header('Content-Type: text/html; charset=utf-8');

if ($_REQUEST['mode'] == 'plugin') {
    $extras = pluginsGetList();
    $plugin = str_replace(['/', '\\', '..'], '', $_REQUEST['plugin']);
    if (!is_array($extras[$plugin])) {
        return;
    }

    if ($_REQUEST['item'] == 'readme') {
        $filePath = realpath(root.'plugins/'.$plugin.'/readme');
        $basePath = realpath(root.'plugins/');
        if ($filePath && $basePath && str_starts_with($filePath, $basePath) && file_exists($filePath)) {
            echo '<pre>';
            echo htmlspecialchars(file_get_contents($filePath), ENT_QUOTES, 'UTF-8');
            echo '</pre>';
        }
    }
    if ($_REQUEST['item'] == 'history') {
        $filePath = realpath(root.'plugins/'.$plugin.'/history');
        $basePath = realpath(root.'plugins/');
        if ($filePath && $basePath && str_starts_with($filePath, $basePath) && file_exists($filePath)) {
            echo '<pre>';
            echo htmlspecialchars(file_get_contents($filePath), ENT_QUOTES, 'UTF-8');
            echo '</pre>';
        }
    }
}
