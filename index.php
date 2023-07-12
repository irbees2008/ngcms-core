<?php

//
// Copyright (C) 2006-2016 Next Generation CMS (http://ngcms.ru)
// Name: index.php
// Description: core index file
// Author: NGCMS project team
//

<?php

// Include core module at the beginning
include_once 'engine/core.php';

// Override charset
@header('Content-Type: text/html; charset=utf-8');

// Check for minimum supported PHP version
if (version_compare(PHP_VERSION, '7.2.0') < 0) {
    exitWithError('NGCMS required PHP version 7.2+ / Необходима версия PHP 7.2 или выше');
}

// Initialize GZip handler
initGZipHandler();

// Load configuration and user data
$config = getConfig();
$userROW = getUserData();
$systemAccessURL = getSystemAccessURL();

// Check if site access is locked [ for everyone except admins ]
if (isSiteAccessLocked($config, $userROW)) {
    displaySiteLockPage($config);
}

// Start generating page
executeActionHandler('index_pre');

// Generate fatal 404 error [NOT FOUND] if URL handler didn't find any task for execution
if (!executeURLHandler($systemAccessURL)) {
    error404();
}

executeActionHandler('index');

// Generate additional informational blocks
$template = generateTemplateData();
$template['vars']['categories'] = generateCategoryMenu();
$template['vars']['titles'] = implode(' : ', array_values($SYSTEM_FLAGS['info']['title']));
$template['vars']['category'] = isset($_REQUEST['category']) && ($_REQUEST['category'] != '') ? secure_html($_REQUEST['category']) : '';

executeActionHandler('index_post');

// Prepare JS/CSS/RSS references
$template['vars']['htmlvars'] = generateHTMLVars();

// Add support of blocks [is-logged] .. [/isnt-logged] in main template
$template = applyUserBlocks($template, $userROW);

// Calculate script execution time
$template['vars']['queries'] = getDatabaseQueryCount();
$template['vars']['exectime'] = getExecutionTime();

// Fill debug information (if it is requested)
if ($config['debug']) {
    $template = generateDebugInfo($template, $config, $userROW);
}

// Generate template for main page
$mainTemplateName = getMainTemplateName();
$mainTemplatePath = getMainTemplatePath();
$output = generateTemplateOutput($mainTemplateName, $mainTemplatePath, $template);

// Print the final output
printHTTPHeaders();
echo $output;

// Maintanance activities
session_write_close();
runCronTasks();
coreNormalTerminate();

// Helper functions

function exitWithError($errorMessage) {
    exit("<html><head><title>Error</title></head><body><div>$errorMessage</div></body></html>");
}

function isSiteAccessLocked($config, $userROW) {
    return $config['lock'] && (!is_array($userROW) || (!checkPermission(['plugin' => '#admin', 'item' => 'system'], null, 'lockedsite.view')));
}

function displaySiteLockPage($config) {
    if (file_exists(tpl_site.'sitelock.tpl')) {
        $tVars = ['lock_reason' => $config['lock_reason']];
        $xt = $twig->loadTemplate('sitelock.tpl');
        echo $xt->render($tVars);
    } else {
        exitWithError('Site is disabled with reason: '.$config['lock_reason']);
    }
}

function executeURLHandler($systemAccessURL) {
    global $UHANDLER;
    <?php

// Include core module at the beginning
include_once 'engine/core.php';

// Override charset
@header('Content-Type: text/html; charset=utf-8');

// Check for minimum supported PHP version
if (version_compare(PHP_VERSION, '7.2.0') < 0) {
    exitWithError('NGCMS required PHP version 7.2+ / Необходима версия PHP 7.2 или выше');
}

// Initialize GZip handler
initGZipHandler();

// Load configuration and user data
$config = getConfig();
$userROW = getUserData();
$systemAccessURL = getSystemAccessURL();

// Check if site access is locked [ for everyone except admins ]
if (isSiteAccessLocked($config, $userROW)) {
    displaySiteLockPage($config);
}

// Start generating page
executeActionHandler('index_pre');

// Generate fatal 404 error [NOT FOUND] if URL handler didn't find any task for execution
if (!executeURLHandler($systemAccessURL)) {
    error404();
}

executeActionHandler('index');

// Generate additional informational blocks
$template = generateTemplateData();
$template['vars']['categories'] = generateCategoryMenu();
$template['vars']['titles'] = implode(' : ', array_values($SYSTEM_FLAGS['info']['title']));
$template['vars']['category'] = isset($_REQUEST['category']) && ($_REQUEST['category'] != '') ? secure_html($_REQUEST['category']) : '';

executeActionHandler('index_post');

// Prepare JS/CSS/RSS references
$template['vars']['htmlvars'] = generateHTMLVars();

// Add support of blocks [is-logged] .. [/isnt-logged] in main template
$template = applyUserBlocks($template, $userROW);

// Calculate script execution time
$template['vars']['queries'] = getDatabaseQueryCount();
$template['vars']['exectime'] = getExecutionTime();

// Fill debug information (if it is requested)
if ($config['debug']) {
    $template = generateDebugInfo($template, $config, $userROW);
}

// Generate template for main page
$mainTemplateName = getMainTemplateName();
$mainTemplatePath = getMainTemplatePath();
$output = generateTemplateOutput($mainTemplateName, $mainTemplatePath, $template);

// Print the final output
printHTTPHeaders();
echo $output;

// Maintanance activities
session_write_close();
runCronTasks();
coreNormalTerminate();

// Helper functions

function exitWithError($errorMessage) {
    exit("<html><head><title>Error</title></head><body><div>$errorMessage</div></body></html>");
}

function isSiteAccessLocked($config, $userROW) {
    return $config['lock'] && (!is_array($userROW) || (!checkPermission(['plugin' => '#admin', 'item' => 'system'], null, 'lockedsite.view')));
}

function displaySiteLockPage($config) {
    if (file_exists(tpl_site.'sitelock.tpl')) {
        $tVars = ['lock_reason' => $config['lock_reason']];
        $xt = $twig->loadTemplate('sitelock.tpl');
        echo $xt->render($tVars);
    } else {
        exitWithError('Site is disabled with reason: '.$config['lock_reason']);
    }
}

function executeURLHandler($systemAccessURL) {
    global $UHANDLER;
    $UHANDLER->setOptions(['domainPrefix' => $config['home_url']]);
    if (preg_match('#^http\:\/\/([^\/])+(\/.+)#', $config['home_url'], $match)) {
        $UHANDLER->setOptions(['localPrefix' => $match[2]]);
    }
    return $UHANDLER->run($systemAccessURL, ['debug' => false]);
}

function generateTemplateData() {
    global $template, $twig, $SYSTEM_FLAGS, $EXTRA_CSS, $EXTRA_HTML_VARS;
    $template = [
        'vars' => [
            'what' => engineName,
            'version' => engineVersion,
            'home' => home,
            'titles' => home_title,
            'home_title' => home_title,
            'mainblock' => '',
            'htmlvars' => '',
        ],
        'regx' => [
            '#\[is-logged\](.+?)\[/is-logged\]#is' => '',
            '#\[isnt-logged\](.+?)\[/isnt-logged\]#is' => '',
        ],
    ];
    return $template;
}

function generateCategoryMenu() {
    // Generate category menu logic here
}

function generateHTMLVars() {
    global $EXTRA_CSS, $EXTRA_HTML_VARS;
    $htmlrow = [];
    $dupCheck = [];
    foreach ($EXTRA_HTML_VARS as $htmlvar) {
        if (!$htmlvar['data']) {
            continue;
        }
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
    return implode("\n", $htmlrow);
}

function applyUserBlocks($template, $userROW) {
    if (is_array($userROW)) {
        $template['regx']['#\[is-logged\](.+?)\[/is-logged\]#is'] = '$1';
    } else {
        $template['regx']['#\[isnt-logged\](.+?)\[/isnt-logged\]#is'] = '$1';
    }
    return $template;
}

function getDatabaseQueryCount() {
    global $mysql;
    return $mysql->qcnt();
}

function getExecutionTime() {
    global $timer;
    return $timer->stop();
}

function generateDebugInfo($template, $config, $userROW) {
    global $mysql, $timer;
    $timer->registerEvent('Templates generation time: '.$tpl->execTime.' ('.$tpl->execCount.' times called)');
    $timer->registerEvent('Generate DEBUG output');
    if (checkPermission(['plugin' => '#admin', 'item' => 'system'], $userROW, 'debug.view')) {
        $template['vars']['debug_queries'] = $config['debug_queries'] ? ('<b><u>SQL queries:</u></b>'.implode("<br />", $mysql->debug_q).'Total: '.$mysql->qcnt()) : '';
        $template['vars']['debug_exectime'] = '<b><u>Execution time:</u></b>'.$timer->show();
        return $template;
    }
    
    function getMainTemplateName() {
        // Logic to determine the main template name
    }
    
    function getMainTemplatePath() {
        // Logic to determine the main template path
    }
    
    function generateTemplateOutput($mainTemplateName, $mainTemplatePath, $template) {
        global $tpl;
        $tpl->loadTemplate($mainTemplateName, $mainTemplatePath);
        $output = $tpl->render($template['vars']);
        $output = preg_replace(array_keys($template['regx']), array_values($template['regx']), $output);
        return $output;
    }
    
    function printHTTPHeaders() {
        header('Content-type: text/html; charset=utf-8');
        header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
        header('Last-Modified: '.gmdate('D, d M Y H:i:s').' GMT');
        header('Cache-Control: no-store, no-cache, must-revalidate');
        header('Cache-Control: post-check=0, pre-check=0', false);
        header('Pragma: no-cache');
    }
    
    function runCronTasks() {
        // Logic to run cron tasks
    }
    
    function coreNormalTerminate() {
        global $timer, $mysql, $dbClose;
        $timer->registerEvent('End of script');
        if ($mysql) {
            $mysql->stop();
        }
        if ($dbClose) {
            mysql_close($dbClose);
        }
    }
    
    ?>