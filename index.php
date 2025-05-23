<?php

//
// Copyright (C) 2006-2016 Next Generation CMS (http://ngcms.ru)
// Name: index.php
// Description: core index file
// Author: NGCMS project team
//

// Override charset
@header('content-type: text/html; charset=utf-8');

// Check for minimum supported PHP version
if (version_compare(PHP_VERSION, '8.1.0') < 0) {
    @header('Content-Type: text/html; charset=utf-8');
    $current_version = PHP_VERSION;
    echo <<<HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NGCMS | PHP Version Requirement</title>
    <style>
        :root {
            --primary: #4361ee;
            --error: #ef233c;
            --light: #f8f9fa;
            --dark: #212529;
            --gray: #6c757d;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: #f1f3f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
            line-height: 1.6;
        }
        
        .container {
            max-width: 800px;
            width: 100%;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .header {
            background: var(--primary);
            color: white;
            padding: 20px;
            text-align: center;
        }
        
        .content {
            padding: 30px;
        }
        
        h1 {
            color: var(--error);
            margin-bottom: 20px;
            font-size: 28px;
        }
        
        .message {
            margin-bottom: 25px;
        }
        
        .message h2 {
            font-size: 20px;
            color: var(--dark);
            margin-bottom: 10px;
        }
        
        .message p {
            color: var(--gray);
            margin-bottom: 15px;
        }
        
        .current-version {
            background: #fff8e1;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            border-left: 4px solid #ffc107;
        }
        
        .version {
            font-weight: bold;
            color: var(--primary);
        }
        
        .required {
            font-weight: bold;
            color: #2e7d32;
        }
        
        .divider {
            height: 1px;
            background: #e0e0e0;
            margin: 25px 0;
        }
        
        .footer {
            text-align: center;
            color: var(--gray);
            font-size: 14px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>NGCMS System Requirement Error</h1>
        </div>
        
        <div class="content">
            <div class="message">
                <h2>FATAL ERROR / Фатальная ошибка</h2>
                <p>Your PHP version doesn't meet the system requirements for NGCMS.</p>
                
                <div class="current-version">
                    Current PHP version: <span class="version">$current_version</span><br>
                    Required PHP version: <span class="required">8.1.0 or higher</span>
                </div>
                
                <h2>English</h2>
                <p>NGCMS requires PHP version <b>8.1.0</b> or higher to run properly.</p>
                <p>Please contact your hosting provider and ask them to upgrade your PHP version.</p>
                
                <div class="divider"></div>
                
                <h2>Русский</h2>
                <p>Для работы NGCMS требуется PHP версии <b>8.1.0</b> или выше.</p>
                <p>Пожалуйста, обратитесь к вашему хостинг-провайдеру с просьбой обновить версию PHP.</p>
            </div>
            
            <div class="footer">
                NGCMS &copy; 2023 | PHP Engine Requirement
            </div>
        </div>
    </div>
</body>
</html>
HTML;
    exit;
}
// Load CORE module
include_once 'engine/core.php';

/**
 * @var $config
 * @var $userROW
 * @var $twig
 * @var $timer
 * @var $systemAccessURL
 * @var $UHANDLER
 * @var $EXTRA_CSS
 * @var $mysql
 * @var $tpl
 * @var $SUPRESS_TEMPLATE_SHOW
 * @var $SUPRESS_MAINBLOCK_SHOW
 * @var $cron
 */

// Init GZip handler
initGZipHandler();

// Define default TITLE
$SYSTEM_FLAGS['info']['title'] = [];
$SYSTEM_FLAGS['info']['title']['header'] = home_title;

// Initialize main template array
$template = [
    'vars' => [
        'what'       => engineName,
        'version'    => engineVersion,
        'home'       => home,
        'titles'     => home_title,
        'home_title' => home_title,
        'mainblock'  => '',
        'htmlvars'   => '',
    ],
];

// ===================================================================
// Check if site access is locked [ for everyone except admins ]
// ===================================================================
if ($config['lock'] && (!is_array($userROW) || (!checkPermission(['plugin' => '#admin', 'item' => 'system'], null, 'lockedsite.view')))) {
    // Generate sitelock.tpl instead of content page
    if (!file_exists(tpl_site.'sitelock.tpl')) {
        echo 'Site is disabled with reason: '.$config['lock_reason'];
    } else {
        $tVars = $template['vars'];
        $tVars['lock_reason'] = $config['lock_reason'];

        $xt = $twig->loadTemplate('sitelock.tpl');
        echo $xt->render($tVars);
    }

    // STOP SCRIPT EXECUTION
    exit;
}

// ===================================================================
// Start generating page
// ===================================================================

// External call: before executing URL handler
executeActionHandler('index_pre');

// Deactivate block [sitelock] ... [/sitelock]
$template['vars']['[sitelock]'] = '';
$template['vars']['[/sitelock]'] = '';

// /////////////////////////////////////////////////////////// //
// You may modify variable $systemAccessURL here (for hacks)   //
// /////////////////////////////////////////////////////////// //

// /////////////////////////////////////////////////////////// //
$timer->registerEvent('Search route for URL "'.$systemAccessURL.'"');

// Give domainName to URL handler engine for generating absolute links
$UHANDLER->setOptions(['domainPrefix' => $config['home_url']]);

// Check if engine is installed in subdirectory
if (preg_match('#^http\:\/\/([^\/])+(\/.+)#', $config['home_url'], $match)) {
    $UHANDLER->setOptions(['localPrefix' => $match[2]]);
}
$runResult = $UHANDLER->run($systemAccessURL, ['debug' => false]);

// [[MARKER]] URL handler execution is finished
$timer->registerEvent('URL handler execution is finished');

// Generate fatal 404 error [NOT FOUND] if URL handler didn't found any task for execution
if (!$runResult) {
    error404();
}

// External call: after executing URL handler
executeActionHandler('index');

// ===================================================================
// Generate additional informational blocks
// ===================================================================
$timer->registerEvent('General plugins execution is finished');

// Generate category menu
$template['vars']['categories'] = generateCategoryMenu();
$timer->registerEvent('Category menu created');

// Generate page title
$template['vars']['titles'] = implode(' : ', array_values($SYSTEM_FLAGS['info']['title']));

// Generate user menu
coreUserMenu();

// Generate search form
coreSearchForm();

// Save 'category' variable
$template['vars']['category'] = (isset($_REQUEST['category']) && ($_REQUEST['category'] != '')) ? secure_html($_REQUEST['category']) : '';

// ====================================================================
// External call: All variables for main template are generated
// ===================================================================
executeActionHandler('index_post');

// ===================================================================
// Prepare JS/CSS/RSS references

// Make empty OLD STYLE variables
$template['vars']['metatags'] = '';
$template['vars']['extracss'] = '';

// Fill extra CSS links
foreach ($EXTRA_CSS as $css => $null) {
    $EXTRA_HTML_VARS[] = ['type' => 'css', 'data' => $css];
}

// Generate metatags
$EXTRA_HTML_VARS[] = ['type' => 'plain', 'data' => GetMetatags()];

// Fill additional HTML vars
$htmlrow = [];
$dupCheck = [];
foreach ($EXTRA_HTML_VARS as $htmlvar) {
    // Skip empty
    if (!$htmlvar['data']) {
        continue;
    }

    // Check for duplicated rows
    if (in_array($htmlvar['data'], $dupCheck)) {
        continue;
    }
    $dupCheck[] = $htmlvar['data'];

    switch ($htmlvar['type']) {
        case 'css':
            $htmlrow[] = '<link href="'.$htmlvar['data'].'" rel="stylesheet" type="text/css" />';
            break;
        case 'js':
            $htmlrow[] = '<script type="text/javascript" src="'.$htmlvar['data'].'"></script>';
            break;
        case 'rss':
            $htmlrow[] = '<link href="'.$htmlvar['data'].'" rel="alternate" type="application/rss+xml" title="RSS" />';
            break;
        case 'plain':
            $htmlrow[] = $htmlvar['data'];
            break;
    }
}
if (count($htmlrow)) {
    $template['vars']['htmlvars'] .= implode("\n", $htmlrow);
}

// Add support of blocks [is-logged] .. [/isnt-logged] in main template
$template['regx']['#\[is-logged\](.+?)\[/is-logged\]#is'] = is_array($userROW) ? '$1' : '';
$template['regx']['#\[isnt-logged\](.+?)\[/isnt-logged\]#is'] = is_array($userROW) ? '' : '$1';

// ***** EXECUTION TIME CATCH POINT *****
// Calculate script execution time
$template['vars']['queries'] = $mysql->qcnt();
$template['vars']['exectime'] = $timer->stop();

// Fill debug information (if it is requested)
if ($config['debug']) {
    $timer->registerEvent('Templates generation time: '.$tpl->execTime.' ('.$tpl->execCount.' times called)');
    $timer->registerEvent('Generate DEBUG output');
    if (checkPermission(['plugin' => '#admin', 'item' => 'system'], $userROW, 'debug.view')) {
        $template['vars']['debug_queries'] = ($config['debug_queries']) ? ('<b><u>SQL queries:</u></b><br>'.implode("<br />\n", $mysql->query_list).'<br />') : '';
        $template['vars']['debug_profiler'] = ($config['debug_profiler']) ? ('<b><u>Time profiler:</u></b>'.$timer->printEvents(1).'<br />') : '';
        $template['vars']['[debug]'] = '';
        $template['vars']['[/debug]'] = '';
    } else {
        $template['regx']["#\[debug\].*?\[/debug\]#si"] = '';
    }
}

// ===================================================================
// Generate template for main page
// ===================================================================
// 0. Calculate memory PEAK usage
$template['vars']['memPeakUsage'] = sprintf('%7.3f', (memory_get_peak_usage() / 1024 / 1024));

// 1. Determine template name & path
$mainTemplateName = isset($SYSTEM_FLAGS['template.main.name']) ? $SYSTEM_FLAGS['template.main.name'] : 'main';
$mainTemplatePath = isset($SYSTEM_FLAGS['template.main.path']) ? $SYSTEM_FLAGS['template.main.path'] : tpl_site;

// 2. Load & show template
$tpl->template($mainTemplateName, $mainTemplatePath);
$tpl->vars($mainTemplateName, $template);
if (!$SUPRESS_TEMPLATE_SHOW) {
    printHTTPheaders();
    echo $tpl->show($mainTemplateName);
} elseif (!$SUPRESS_MAINBLOCK_SHOW) {
    printHTTPheaders();
    echo $template['vars']['mainblock'];
}

// ===================================================================
// Maintanance activities
// ===================================================================
// Close opened sessions to avoid blocks
session_write_close();

// Run CRON
$cron->run();

// Terminate execution of script
coreNormalTerminate();
