<?php

//
// Copyright (C) 2006-2011 Next Generation CMS (http://ngcms.ru)
// Name: captcha.php
// Description: printing captcha
// Author: NGCMS project team
//

@require_once 'core.php';
@include_once root.'includes/classes/captcha.class.php';

// Print HTTP headers
@header('Content-type: image/png');
@header('Expires: '.gmdate('D, d M Y H:i:s', time() + 30).' GMT');
@header('last-modified: '.gmdate('D, d M Y H:i:s', time()).' GMT');

// Determine captcha block identifier
$blockName = $_REQUEST['id'] ?? '';

// Determine captcha number to show
$cShowNumber = 'n/c';

// Check if special block is requested
if ($blockName !== '') {
    // Check if captchaID is prepared for this block
    if (!empty($_SESSION['captcha.'.$blockName])) {
        $cShowNumber = $_SESSION['captcha.'.$blockName];
    } else {
        // No captcha is set, but we can generate it dynamically for ACTIVE plugins
        if (getPluginStatusActive($blockName)) {
            $cShowNumber = rand(0, 99999);
            $_SESSION['captcha.'.$blockName] = $cShowNumber;
        }
    }
} else {
    // Prepare general captcha
    $cShowNumber = $_SESSION['captcha'] ?? $cShowNumber;
}

$captc = new captcha();
$captc->makeimg($cShowNumber);