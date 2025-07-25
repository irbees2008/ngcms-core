<?php
//
// Copyright (C) 2006-2016 Next Generation CMS (http://ngcms.ru)
// Name: install.php
// Description: System installer
// Author: Vitaly Ponomarev
//
@header('content-type: text/html; charset=utf-8');
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
@error_reporting(E_ALL ^ E_NOTICE);
define('NGCMS', 1);
// Basic variables
@define('root', __DIR__.'/');
@include_once root.'includes/inc/multimaster.php';
// ============================================================================
// Define global directory constants
// ============================================================================
define('NGCoreDir', __DIR__.'/');               // Location of Core directory
define('NGRootDir', dirname(__DIR__).'/');      // Location of SiteRoot
define('NGClassDir', NGCoreDir.'classes/');                     // Location of AutoLoaded classes
@define('NGVendorDir', NGRootDir.'vendor/');      // Location of Vendor classes
$loader = include_once NGVendorDir.'autoload.php';
// Autoloader for NEW STYLE Classes
spl_autoload_register(function ($className) {
    if (file_exists($fName = NGClassDir.$className.'.class.php')) {
        require_once $fName;
    }
});
// Magic function for immediate closure call
function NGInstall($f)
{
    $f();
}
// ============================================================================
// MODULE DEPs check + basic setup
// ============================================================================
NGInstall(function () {
    $depList = [
        'sql'      => ['pdo' => '', 'pdo_mysql' => ''],
        'zlib'     => 'ob_gzhandler',
        'iconv'    => 'iconv',
        'GD'       => 'imagecreatefromjpeg',
        'mbstring' => 'mb_internal_encoding',
    ];
    NGCoreFunctions::resolveDeps($depList);
    $sx = NGEngine::getInstance();
    $sx->set('events', new NGEvents());
    $sx->set('errorHandler', new NGErrorHandler());
    $sx->set('config', ['sql_error_show' => 2]);
});
multi_multisites();
@define('confroot', root.'conf/'.($multiDomainName && $multimaster && ($multiDomainName != $multimaster) ? 'multi/'.$multiDomainName.'/' : ''));
// Check if config file already exists
if ((@fopen(confroot.'config.php', 'r')) && (filesize(confroot.'config.php'))) {
    //printHeader();
    echo "<div style='color: red; font-weight: bold;'>Error: configuration file already exists!</div><br />Delete it and continue.<br />\n";
    return;
}
// =============================================================
// Fine, we're ready to start installation
// =============================================================
// Determine user's language (support only RUSSIAN/ENGLISH)
$currentLanguage = $_REQUEST['language'] ?? 'russian';
if ($currentLanguage !== 'russian') {
    $currentLanguage = 'english';
}
// Load language variables
global $lang;
$lang = parse_ini_file(root.'lang/'.$currentLanguage.'/install.ini', true);
@include_once 'includes/classes/templates.class.php';
$tpl = new tpl();
// Determine current admin working directory
list($adminDirName) = array_slice($ADN = preg_split('/(\\\|\/)/', root, -1, PREG_SPLIT_NO_EMPTY), -1, 1);
$installDir = ((substr(root, 0, 1) == '/') ? '/' : '').implode('/', array_slice($ADN, 0, -1));
$templateDir = root.'skins/default/install';
// Determine request protocol
$requestProtocol = 'http';
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && ($_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')) {
    $requestProtocol = 'https';
} elseif (isset($_SERVER['https']) && ($_SERVER['https'] == 'on')) {
    $requestProtocol = 'https';
} elseif (isset($_SERVER['REQUEST_SCHEME']) && ($_SERVER['REQUEST_SCHEME'] == 'https')) {
    $requestProtocol = 'https';
}
// Determine installation URL
$homeURL = $requestProtocol.'://'.$_SERVER['HTTP_HOST'].'/'.($a = implode('/', array_slice(preg_split('/(\\\|\/)/', $_SERVER['REQUEST_URI'], -1, PREG_SPLIT_NO_EMPTY), 0, -2))).($a ? '/' : '');
$templateURL = $homeURL.$adminDirName.'/skins/default/install';
$scriptLibrary = $homeURL.'lib';
$ERR = [];
$tvars = ['vars' => ['templateURL' => $templateURL, 'homeURL' => $homeURL, 'scriptLibrary' => $scriptLibrary]];
foreach (['begin', 'db', 'plugins', 'template', 'perm', 'common', 'install'] as $v) {
    $tvars['vars']['menu_'.$v] = '';
}
// If action is specified, but license is not accepted - stop installation
$action = $_POST['action'] ?? 'welcome';
$agree = $_POST['agree'] ?? false;
if ($action !== 'welcome' && !$agree) {
    notAgree();
}
// Flag if we need to do some configuration actions after install
$flagPendingChanges = false;
//
// Determine required action
//
switch ($action) {
    case 'config':
        doConfig();
        break;
    case 'install':
        $flagPendingChanges = doInstall();
        break;
    case 'welcome':
    default:
        doWelcome();
        break;
}
// If we made installations and have some pending changes
if ($flagPendingChanges) {
    include_once root.'core.php';
    include_once root.'includes/inc/extraconf.inc.php';
    include_once root.'includes/inc/extrainst.inc.php';
    $LOG = [];
    $ERROR = [];
    $error = 0;
    // Reinit INSTALL language file
    $lang = parse_ini_file(root.'lang/'.$currentLanguage.'/install.ini', true);
    // Now let's install plugins
    // First: Load informational `version` files
    $list = pluginsGetList();
    foreach ($pluginInstallList as $pName) {
        if ($list[$pName]['install']) {
            include_once root.'plugins/'.$pName.'/'.$list[$pName]['install'];
            $res = call_user_func('plugin_'.$pName.'_install', 'autoapply');
            if ($res) {
                array_push($LOG, $lang['msg.plugin.installation'].' <b>'.$pName.'</b> ... OK');
            } else {
                array_push($ERROR, $lang['msg.plugin.installation'].' <b>'.$pName.'</b> ... ERROR');
                $error = 1;
                break;
            }
        }
        array_push($LOG, $lang['msg.plugin.activation'].' <b>'.$pName.'</b> ... '.(pluginSwitch($pName, 'on') ? 'OK' : 'ERROR'));
    }
    echo '<div class="body"><p style="width: 99%;">';
    foreach ($LOG as $line) {
        echo $line."<br />\n";
    }
    if ($error) {
        foreach ($ERROR as $errText) {
            echo '<div class="errorDiv"><b><u>'.$lang['msg.error'].'</u>!</b><br/>'.$errText.'</div>';
        }
        echo '<div class="warningDiv">'.$lang['msg.errorInfo'].'</div>';
    } else {
        echo $lang['msg.complete1'].' <a href="'.$homeURL.$adminDirName.'/">'.$lang['msg.complete2'].'</a>.';
    }
    echo '</p></div>';
}
//
//
//
function printHeader()
{
    global $tpl, $templateDir, $tvars;
    // Print installation header
    $tpl->template('header', $templateDir);
    $tpl->vars('header', $tvars);
    echo $tpl->show('header');
}
function mkLanguageSelect($params)
{
    $values = '';
    if (isset($params['values']) && is_array($params['values'])) {
        foreach ($params['values'] as $k => $v) {
            $values .= '<option value="'.$k.'"'.(($k == $params['value']) ? ' selected="selected"' : '').'>'.$v.'</option>';
        }
    }
    $onchange = "window.location = document.location.protocol + '//' + document.location.hostname + document.location.pathname + '?language=' + this.options[this.selectedIndex].value;";
    return '<select '.((isset($params['id']) && $params['id']) ? 'id="'.$params['id'].'" ' : '').'name="'.$params['name'].'" onchange="'.$onchange.'">'.$values.'</select>';
}
function doWelcome()
{
    global $tpl, $tvars, $templateDir, $lang, $currentLanguage;
    include_once root.'includes/inc/functions.inc.php';
    // Print header
    $tvars['vars']['menu_begin'] = ' class="hover"';
    printHeader();
    $langs = ListFiles('lang', '');
    $lang_select = mkLanguageSelect(['values' => $langs, 'value' => $currentLanguage, 'id' => 'language', 'name' => 'language']);
    $tvars['vars']['lang_select'] = $lang_select;
    // Load license
    $license = @file_get_contents(root.'../license.html');
    if (!$license) {
        $license = $lang['msg.nolicense'];
        $tvars['vars']['ad'] = 'disabled="disabled" ';
    } else {
        $tvars['vars']['ad'] = '';
    }
    $tvars['vars']['license'] = $license;
    $tpl->template('welcome', $templateDir);
    $tpl->vars('welcome', $tvars);
    echo $tpl->show('welcome');
}
function notAgree()
{
    global $tpl, $tvars, $templateDir, $lang;
    $tvars['vars']['menu_begin'] = ' class="hover"';
    printHeader();
    $tpl->template('notagree', $templateDir);
    $tpl->vars('notagree', $tvars);
    echo $tpl->show('notagree');
    exit;
}
// Вывод формы для ввода параметров установки
function doConfig()
{
    switch ($_POST['stage']) {
        default:
            doConfig_db(0);
            break;
        case '1':
            if (!doConfig_db(1)) {
                break;
            }
            doConfig_perm();
            break;
        case '2':
            doConfig_plugins();
            break;
        case '3':
            doConfig_templates();
            break;
        case '4':
            doConfig_common();
            break;
    }
}
function doConfig_db($check)
{
    global $tvars, $tpl, $templateDir, $SQL_VERSION, $lang;
    $myparams = ['action', 'stage', 'reg_dbtype', 'reg_dbhost', 'reg_dbname', 'reg_dbuser', 'reg_dbpass', 'reg_dbprefix', 'reg_autocreate', 'reg_dbadminuser', 'reg_dbadminpass'];
    $DEFAULT = ['reg_dbhost' => 'localhost', 'reg_dbprefix' => 'ng'];
    // Show form
    $hinput = [];
    foreach ($_POST as $k => $v) {
        if (array_search($k, $myparams) === false) {
            $hinput[] = '<input type="hidden" name="'.$k.'" value="'.htmlspecialchars($v, ENT_COMPAT | ENT_HTML401, 'UTF-8').'"/>';
        }
    }
    $tvars['vars']['hinput'] = implode("\n", $hinput);
    $tvars['vars']['error_message'] = '';
    if ($check) {
        // Check passed parameters. Check for required params
        $error = 0;
        $ac = 0;
        foreach (['reg_dbtype', 'reg_dbhost', 'reg_dbname', 'reg_dbuser'] as $k) {
            if (!strlen($_POST[$k])) {
                $tvars['vars']['err:'.$k] = $lang['error.notfilled'];
                $error++;
            }
        }
        // Check for autocreate mode
        if (isset($_POST['reg_autocreate'])) {
            // Check for user filled
            if (!strlen($_POST['reg_dbadminuser'])) {
                $tvars['vars']['err:reg_dbadminuser'] = '<span style="color: red;">'.$lang['err.reg_dbadminuser'].'</span>';
                $error++;
            }
            $ac = 1;
        }
        try {
            $sx = NGEngine::getInstance();
            $sx->set('events', new NGEvents());
            $sx->set('errorHandler', new NGErrorHandler());
            $sx->set('db', new NGPDO(['host' => $_POST['reg_dbhost'], 'user' => $_POST['reg_db'.($ac ? 'admin' : '').'user'], 'pass' => $_POST['reg_db'.($ac ? 'admin' : '').'pass']]));
            $sx->set('legacyDB', new NGLegacyDB(false));
            $sx->getLegacyDB()->connect('', '', '');
            $mysql = $sx->getLegacyDB();
            $sqlr = $mysql->mysql_version();
            if (preg_match('/^(\d+)\.(\d+)/', $sqlr, $regex)) {
                $SQL_VERSION = [$sqlr, intval($regex[1]), intval($regex[2])];
            } else {
                $SQL_VERSION = $sqlr;
            }
        } catch (Exception $e) {
            $tvars['vars']['error_message'] = '<div class="errorDiv">'.$lang['error.dbconnect'].' "'.$_POST['reg_dbhost'].'":<br/> ('.$e->getCode().') '.$e->getMessage().'</div>';
            $error = 1;
        }
        if (isset($mysql) != null) {
            $mysql->close();
        }
        if (!$error) {
            return true;
        }
    }
    foreach ([
        'reg_dbtype', 'reg_dbhost', 'reg_dbuser', 'reg_dbpass', 'reg_dbname', 'reg_dbprefix',
        'reg_autocreate', 'reg_dbadminuser', 'reg_dbadminpass',
    ] as $k) {
        if ($k == 'reg_dbtype') {
            foreach (['pdo'] as $s) {
                $tvars['vars'][$k.'_'.$s] = isset($_POST[$k]) && $_POST[$k] == $s ? ' selected' : '';
            }
        } else {
            $tvars['vars'][$k] = htmlspecialchars($_POST[$k] ?? $DEFAULT[$k] ?? '', ENT_COMPAT | ENT_HTML401, 'UTF-8');
        }
        if (!isset($tvars['vars']['err:'.$k])) {
            $tvars['vars']['err:'.$k] = '';
        }
    }
    if (isset($_POST['reg_autocreate'])) {
        $tvars['vars']['reg_autocreate'] = 'checked="checked"';
    }
    $tvars['vars']['menu_db'] = ' class="hover"';
    printHeader();
    $tvars['regx']["'\[pdo\](.*?)\[/pdo\]'si"] = (extension_loaded('pdo') || extension_loaded('pdo_mysql')) ? '$1' : '';
    // Выводим форму проверки
    $tpl->template('config_db', $templateDir);
    $tpl->vars('config_db', $tvars);
    echo $tpl->show('config_db');
    return false;
}
function doConfig_perm()
{
    global $tvars, $tpl, $templateDir, $installDir, $adminDirName, $SQL_VERSION, $lang;
    $tvars['vars']['menu_perm'] = ' class="hover"';
    printHeader();
    // Error flag
    $error = 0;
    $warning = 0;
    $chmod = '';
    // Check file permissions
    $permList = [
        '.htaccess', 'uploads/', 'uploads/avatars/', 'uploads/files/',
        'uploads/images/', 'uploads/dsn/', $adminDirName.'/backups/',
        $adminDirName.'/cache/', $adminDirName.'/conf/',
    ];
    foreach ($permList as $dir) {
        $perms = (($x = @fileperms($installDir.'/'.$dir)) === false) ? 'n/a' : (decoct($x) % 1000);
        $chmod .= '<tr><td>./'.$dir.'</td><td>'.$perms.'</td><td>'.(is_writable($installDir.'/'.$dir) ? $lang['perm.access.on'] : '<span style="color: red; font-weight: bold;">'.$lang['perm.access.off'].'</span>').'</td></tr>';
        if (!is_writable($installDir.'/'.$dir)) {
            $error++;
        }
    }
    $tvars['vars']['chmod'] = $chmod;
    // PHP Version
    if (version_compare(phpversion(), '5.3') < 0) {
        $tvars['vars']['php_version'] = '<span style="color: red;">'.phpversion().'</span>';
        $error = 1;
    } else {
        $tvars['vars']['php_version'] = phpversion();
    }
    // SQL Version
    if (!is_array($SQL_VERSION)) {
        $tvars['vars']['sql_version'] = '<span style="color: red;">unknown</span>';
        $error = 1;
    } else {
        if (($SQL_VERSION[1] < 3) || (($SQL_VERSION[1] == 3) && ($SQL_VERSION[2] < 23))) {
            $tvars['vars']['sql_version'] = '<span style="color: red;">'.$SQL_VERSION[0].'</span>';
            $error = 1;
        } else {
            $tvars['vars']['sql_version'] = $SQL_VERSION[0];
        }
    }
    // GZIP support
    if (extension_loaded('zlib') && function_exists('ob_gzhandler')) {
        $tvars['vars']['gzip'] = $lang['perm.yes'];
    } else {
        $tvars['vars']['gzip'] = '<span style="color: red;">'.$lang['perm.no'].'</span>';
        $error = 1;
    }
    // PDO support
    if (extension_loaded('PDO') && extension_loaded('pdo_mysql') && class_exists('PDO')) {
        $tvars['vars']['pdo'] = $lang['perm.yes'];
    } else {
        $tvars['vars']['pdo'] = '<span style="color: red;">'.$lang['perm.no'].'</span>';
        $error = 0;
    }
    // XML support
    if (extension_loaded('mbstring')) {
        $tvars['vars']['mb'] = $lang['perm.yes'];
    } else {
        $tvars['vars']['mb'] = '<span style="color: red;">'.$lang['perm.no'].'</span>';
        $error = 1;
    }
    // GD support
    if (function_exists('imagecreatetruecolor')) {
        $tvars['vars']['gdlib'] = $lang['perm.yes'];
    } else {
        $tvars['vars']['gdlib'] = '<span style="color: red;">'.$lang['perm.no'].'</span>';
        $error = 1;
    }
    //
    // PHP features configuraton
    //
    // * flags that should be turned off
    foreach (['register_globals', 'magic_quotes_gpc', 'magic_quotes_runtime', 'magic_quotes_sybase'] as $flag) {
        $tvars['vars']['flag:'.$flag] = ini_get($flag) ? '<span style="color: red;">'.$lang['perm.php.on'].'</span>' : $lang['perm.php.off'];
        if (ini_get($flag)) {
            $warning++;
        }
    }
    if ($error) {
        $tvars['vars']['error_message'] .= '<div class="errorDiv">'.$lang['perm.error'].'</div>';
    }
    if ($warning) {
        $tvars['vars']['error_message'] .= '<div class="warningDiv">'.$lang['perm.warning'].'</div>';
    }
    $tvars['regx']["'\[error_button\](.*?)\[/error_button\]'si"] = ($error || $warning) ? '$1' : '';
    $myparams = ['action', 'stage'];
    // Show form
    $hinput = [];
    foreach ($_POST as $k => $v) {
        if (array_search($k, $myparams) === false) {
            $hinput[] = '<input type="hidden" name="'.$k.'" value="'.htmlspecialchars($v, ENT_COMPAT | ENT_HTML401, 'UTF-8').'"/>';
        }
    }
    $tvars['vars']['hinput'] = implode("\n", $hinput);
    // Выводим форму проверки
    $tpl->template('config_perm', $templateDir);
    $tpl->vars('config_perm', $tvars);
    echo $tpl->show('config_perm');
}
function doConfig_plugins()
{
    global $tvars, $tpl, $templateDir;
    $tvars['vars']['menu_plugins'] = ' class="hover"';
    printHeader();
    // Now we should scan plugins for preinstall configuration
    $pluglist = [];
    $pluginsDir = root.'plugins';
    if ($dRec = opendir($pluginsDir)) {
        while (($dName = readdir($dRec)) !== false) {
            if (($dName == '.') || ($dName == '..')) {
                continue;
            }
            if (is_dir($pluginsDir.'/'.$dName) && file_exists($vfn = $pluginsDir.'/'.$dName.'/version') && (filesize($vfn)) && ($vf = @fopen($vfn, 'r'))) {
                $pluginRec = [];
                while (!feof($vf)) {
                    $line = fgets($vf);
                    if (preg_match("/^(.+?) *\: *(.+?) *$/i", trim($line), $m)) {
                        if (in_array(strtolower($m[1]), ['id', 'title', 'information', 'preinstall', 'preinstall_vars', 'install'])) {
                            $pluginRec[strtolower($m[1])] = $m[2];
                        }
                    }
                }
                fclose($vf);
                if (isset($pluginRec['id']) && isset($pluginRec['title'])) {
                    array_push($pluglist, $pluginRec);
                }
            }
        }
        closedir($dRec);
    }
    // Prepare array for input list
    $hinput = [];
    // Collect data for all plugins
    $output = '';
    $tpl->template('config_prow', $templateDir);
    foreach ($pluglist as $plugin) {
        $tv = [
            'id'          => $plugin['id'],
            'title'       => $plugin['title'],
            'information' => $plugin['information'] ?? '',
            'enable'      => (in_array(strtolower($plugin['preinstall'] ?? 'no'), ['yes', 'no'])) ? ' disabled="disabled"' : '',
        ];
        // Add hidden field for DISABLED plugins
        if (strtolower($plugin['preinstall'] ?? 'no') == 'yes') {
            $output .= '<input type="hidden" name="plugin:'.$plugin['id'].'" value="1"/>'."\n";
        }
        if (isset($_POST['plugin:'.$plugin['id']])) {
            $tv['check'] = $_POST['plugin:'.$plugin['id']] ? ' checked="checked"' : '';
        } else {
            $tv['check'] = (in_array(strtolower($plugin['preinstall'] ?? 'no'), ['default_yes', 'yes'])) ? ' checked="checked"' : '';
        }
        //$hinput[] = '<input type="hidden" name="plugin:'.$plugin['id'].'" value="0"/>';
        $tpl->vars('config_prow', ['vars' => $tv]);
        $output .= $tpl->show('config_prow');
    }
    $tvars['vars']['plugins'] = $output;
    // Show form
    $myparams = ['action', 'stage'];
    foreach ($_POST as $k => $v) {
        if ((array_search($k, $myparams) === false) && (!preg_match('/^plugin\:/', $k))) {
            $hinput[] = '<input type="hidden" name="'.$k.'" value="'.htmlspecialchars($v, ENT_COMPAT | ENT_HTML401, 'UTF-8').'"/>';
        }
    }
    $tvars['vars']['hinput'] = implode("\n", $hinput);
    // Выводим форму проверки
    $tpl->template('config_plugins', $templateDir);
    $tpl->vars('config_plugins', $tvars);
    echo $tpl->show('config_plugins');
}
function doConfig_templates()
{
    global $tvars, $tpl, $templateDir, $installDir, $adminDirName, $homeURL, $SQL_VERSION;
    $tvars['vars']['menu_template'] = ' class="hover"';
    printHeader();
    // Now we should scan templates for version information
    $tlist = [];
    $tDir = $installDir.'/templates';
    if ($dRec = opendir($tDir)) {
        while (($dName = readdir($dRec)) !== false) {
            if (($dName == '.') || ($dName == '..')) {
                continue;
            }
            if (is_dir($tDir.'/'.$dName) && file_exists($vfn = $tDir.'/'.$dName.'/version') && (filesize($vfn)) && ($vf = @fopen($vfn, 'r'))) {
                $tRec = ['name' => $dName];
                while (!feof($vf)) {
                    $line = fgets($vf);
                    if (preg_match("/^(.+?) *\: *(.+?) *$/i", trim($line), $m)) {
                        if (in_array(strtolower($m[1]), ['id', 'title', 'author', 'version', 'reldate', 'plugins', 'image', 'imagepreview'])) {
                            $tRec[strtolower($m[1])] = $m[2];
                        }
                    }
                }
                fclose($vf);
                if (isset($tRec['id']) && isset($tRec['title'])) {
                    array_push($tlist, $tRec);
                }
            }
        }
        closedir($dRec);
    }
    usort($tlist, function ($a, $b) {
        return strcmp($a['id'], $b['id']);
    });
    // Set default template name
    if (!isset($_POST['template'])) {
        $_POST['template'] = 'default';
    }
    $output = '';
    foreach ($tlist as $trec) {
        $trvars = ['vars' => $trec];
        $trvars['vars']['checked'] = ($_POST['template'] == $trec['name']) ? ' checked="checked"' : '';
        $trvars['vars']['templateURL'] = $homeURL.'/templates';
        $tpl->template('config_templates_rec', $templateDir);
        $tpl->vars('config_templates_rec', $trvars);
        $output .= $tpl->show('config_templates_rec');
    }
    $tvars['vars']['templates'] = $output;
    $myparams = ['action', 'stage', 'template'];
    // Show form
    $hinput = [];
    foreach ($_POST as $k => $v) {
        if (array_search($k, $myparams) === false) {
            $hinput[] = '<input type="hidden" name="'.$k.'" value="'.htmlspecialchars($v, ENT_COMPAT | ENT_HTML401, 'UTF-8').'"/>';
        }
    }
    $tvars['vars']['hinput'] = implode("\n", $hinput);
    // Выводим форму проверки
    $tpl->template('config_templates', $templateDir);
    $tpl->vars('config_templates', $tvars);
    echo $tpl->show('config_templates');
}
function doConfig_common()
{
    global $tvars, $tpl, $templateDir, $installDir, $adminDirName, $SQL_VERSION, $homeURL, $lang;
    $tvars['vars']['menu_common'] = ' class="hover"';
    printHeader();
    $myparams = ['action', 'stage', 'admin_login', 'admin_password', 'admin_email', 'autodata', 'home_url', 'home_title'];
    // Show form
    $hinput = [];
    foreach ($_POST as $k => $v) {
        if (array_search($k, $myparams) === false) {
            $hinput[] = '<input type="hidden" name="'.$k.'" value="'.htmlspecialchars($v, ENT_COMPAT | ENT_HTML401, 'UTF-8').'"/>';
        }
    }
    $tvars['vars']['hinput'] = implode("\n", $hinput);
    // Preconfigure some paratemers
    if (!isset($_POST['home_url'])) {
        $_POST['home_url'] = $homeURL;
    }
    if (!isset($_POST['home_title'])) {
        $_POST['home_title'] = $lang['common.title.default'];
    }
    foreach (['admin_login', 'admin_password', 'admin_email', 'home_url', 'home_title'] as $k) {
        $tvars['vars'][$k] = isset($_POST[$k]) ? htmlspecialchars($_POST[$k], ENT_COMPAT | ENT_HTML401, 'UTF-8') : '';
    }
    $tvars['vars']['autodata_checked'] = (isset($_POST['autodata']) && ($_POST['autodata'] == '1')) ? ' checked="checked"' : '';
    // Выводим форму проверки
    $tpl->template('config_common', $templateDir);
    $tpl->vars('config_common', $tvars);
    echo $tpl->show('config_common');
}
// Генерация конфигурационного файла
function doInstall()
{
    global $tvars, $tpl, $templateDir, $installDir, $adminDirName, $pluginInstallList, $lang, $currentLanguage;
    $tvars['vars']['menu_install'] = ' class="hover"';
    printHeader();
    $myparams = ['action', 'stage'];
    // Show form
    $hinput = [];
    foreach ($_POST as $k => $v) {
        if (array_search($k, $myparams) === false) {
            $hinput[] = '<input type="hidden" name="'.$k.'" value="'.htmlspecialchars($v, ENT_COMPAT | ENT_HTML401, 'UTF-8').'"/>';
        }
    }
    $tvars['vars']['hinput'] = implode("\n", $hinput);
    // Error indicator
    $frec = [];
    $error = 0;
    $LOG = [];
    $ERROR = [];
    $sx = null;
    do {
        // Stage #01 - Try to create config files
        foreach (['config.php', 'plugins.php', 'plugdata.php'] as $k) {
            if (($frec[$k] = fopen(confroot.$k, 'w')) == null) {
                array_push($ERROR, $lang['err.createconfig1'].' <b>'.$k.'</b><br/>'.$lang['err.createconfig2']);
                $error = 1;
                break;
            }
            array_push($LOG, $lang['msg.fcreating'].' "<b>'.$k.'</b>" ... OK');
        }
        array_push($LOG, '');
        if ($error) {
            break;
        }
        // Stage #02 - Connect to DB
        // Если заказали автосоздание, то подключаемся рутом
        if (isset($_POST['reg_autocreate'])) {
            try {
                $sx = NGEngine::getInstance();
                switch ($_POST['reg_dbtype']) {
                    case 'pdo':
                        $sx->set('db', new NGPDO(['host' => $_POST['reg_dbhost'], 'user' => $_POST['reg_dbadminuser'], 'pass' => $_POST['reg_dbadminpass']]));
                        break;
                }
                $sx->set('legacyDB', new NGLegacyDB(false));
                $sx->getLegacyDB()->connect('', '', '');
                $mysql = $sx->getLegacyDB();
                // Успешно подключились
                array_push($LOG, 'Подключение к серверу БД "'.$_POST['reg_dbhost'].'" используя административный логин "'.$_POST['reg_dbadminuser'].'" ... OK');
                // 1. Создание БД
                if (count($mysql->select("show databases like '".$_POST['reg_dbname']."'")) < 1) {
                    // if ($mysql->select_db($_POST['reg_dbname']) === null) {
                    // БД нет. Пытаемся создать
                    if (!$mysql->query('CREATE DATABASE '.$_POST['reg_dbname'])) {
                        // Не удалось создать. Фатально.
                        array_push($ERROR, 'Не удалось создать БД "'.$_POST['reg_dbname'].'" используя административную учётную запись. Скорее всего у данной учётной записи нет прав на создание баз данных.');
                        $error = 1;
                        break;
                    } else {
                        array_push($LOG, 'Создание БД "'.$_POST['reg_dbname'].'" ... OK');
                    }
                } else {
                    array_push($LOG, 'БД "'.$_POST['reg_dbname'].'" уже существует ... OK');
                }
                // FIX: Starting with mysql 8 we cannot create a user with `grant privileges` command
                if (!$mysql->query("create user '".$_POST['reg_dbuser']."'@'%' identified by '".$_POST['reg_dbpass']."'")) {
                    array_push($ERROR, 'Невозможно создать пользователя  "'.$_POST['reg_dbuser'].'" в БД используя административные права');
                    $error = 1;
                    break;
                }
                // 2. Предоставление доступа к БД
                if (!$mysql->query('grant all privileges on '.$_POST['reg_dbname'].".* to '".$_POST['reg_dbuser']."'@'%'")) {
                    array_push($ERROR, 'Невозможно обеспечить доступ пользователя "'.$_POST['reg_dbuser'].'" к БД "'.$_POST['reg_dbname'].'" используя административные права.');
                    $error = 1;
                    break;
                } else {
                    array_push($LOG, 'Предоставление доступа пользователю "'.$_POST['reg_dbuser'].'" к БД "'.$_POST['reg_dbname'].'" ... OK');
                }
            } catch (Exception $e) {
                array_push($ERROR, 'Невозможно подключиться к серверу БД "'.$_POST['reg_dbhost'].'" используя административный логин "'.$_POST['reg_dbadminuser'].'"');
                $error = 1;
                break;
            }
            // Отключаемся от сервера
            if (isset($mysql) != null) {
                $mysql->close();
            }
        }
        try {
            $sx = NGEngine::getInstance();
            switch ($_POST['reg_dbtype']) {
                case 'pdo':
                    $sx->set('db', new NGPDO(['host' => $_POST['reg_dbhost'], 'user' => $_POST['reg_dbuser'], 'pass' => $_POST['reg_dbpass']]));
                    break;
            }
            $sx->set('legacyDB', new NGLegacyDB(false));
            $sx->getLegacyDB()->connect('', '', '');
            $mysql = $sx->getLegacyDB();
            array_push($LOG, 'Подключение к серверу БД "'.$_POST['reg_dbhost'].'" используя логин "'.$_POST['reg_dbuser'].'" ... OK');
            if ($mysql->select_db($_POST['reg_dbname']) === null) {
                array_push($ERROR, 'Невозможно открыть БД "'.$_POST['reg_dbname'].'"<br/>Вам необходимо создать эту БД самостоятельно.');
                $error = 1;
                break;
            }
        } catch (Exception $e) {
            array_push($ERROR, 'Невозможно подключиться к серверу БД "'.$_POST['reg_dbhost'].'" используя логин "'.$_POST['reg_dbuser'].'" (пароль: "'.$_POST['reg_dbpass'].'")');
            $error = 1;
            break;
        }
        // Check if different character set are supported [ version >= 4.1.1 ]
        $charsetEngine = 0;
        // Проверяем, поддерживает ли сервер utf8mb4
        if (($msq = $mysql->query("SHOW CHARACTER SET LIKE 'utf8mb4'")) && ($mysql->num_rows($msq))) {
            $charsetEngine = 1;
        }
        $charset = $charsetEngine ? ' DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci' : '';
        array_push($LOG, 'Ваша версия сервера БД mySQL '.((!$charsetEngine) ? 'не' : '').'поддерживает множественные кодировки.');
        // Создаём таблицы в mySQL
        // 1. Проверяем наличие пересекающихся таблиц
        // 1.1. Загружаем список таблиц из БД
        $list = [];
        if (!($query = $mysql->query('show tables'))) {
            array_push($ERROR, 'Внутренняя ошибка SQL при получении списка таблиц БД. Обратитесь к автору проект за разъяснениями.');
            $error = 1;
            break;
        }
        $SQL_table = [];
        foreach ($mysql->select('show tables') as $item) {
            foreach ($item as $tablename) {
                $SQL_table[$tablename] = 1;
            }
        }
        // 1.2. Парсим список таблиц
        $dbsql = explode(';', file_get_contents('trash/tables.sql'));
        // 1.3. Проверяем пересечения
        foreach ($dbsql as $dbCreateString) {
            if (!trim($dbCreateString)) {
                continue;
            }
            // Добавляем кодировку (если поддерживается)
            $dbCreateString .= $charset;
            // Получаем имя таблицы
            if (preg_match('/CREATE TABLE `(.+?)`/', $dbCreateString, $match)) {
                $tname = str_replace('XPREFIX_', $_POST['reg_dbprefix'].'_', $match[1]);
                if (isset($SQL_table[$tname])) {
                    array_push($ERROR, 'В БД "'.$_POST['reg_dbname'].'" уже существует таблица "'.$tname.'"<br/>Используйте другой префикс для создания таблиц!');
                    $error = 1;
                    break;
                }
            } else {
                array_push($ERROR, 'Внутренняя ошибка парсера SQL. Обратитесь к автору проект за разъяснениями ['.$dbCreateString.']');
                $error = 1;
                break;
            }
        }
        if ($error) {
            break;
        }
        array_push($LOG, 'Проверка наличия дублирующихся таблиц ... OK');
        array_push($LOG, '');
        $SUPRESS_CHARSET = 0;
        $SUPRESS_ENGINE = 0;
        // 1.4. Создаём таблицы
        for ($i = 0; $i < count($dbsql); $i++) {
            $dbCreateString = str_replace('XPREFIX_', $_POST['reg_dbprefix'].'_', $dbsql[$i]).$charset;
            if ($SUPRESS_CHARSET) {
                // Вместо удаления кодировки заменяем на utf8mb4 (если сервер поддерживает)
                $dbCreateString = str_replace('default charset=utf8', 'DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci', $dbCreateString);
            }
            if ($SUPRESS_ENGINE) {
                $dbCreateString = str_replace('ENGINE=InnoDB', '', $dbCreateString);
            }
            if (preg_match('/CREATE TABLE `(.+?)`/', $dbCreateString, $match)) {
                $tname = $match[1];
                $err = 0;
                $mysql->query($dbCreateString);
                if ($mysql->db_errno()) {
                    if (!$SUPRESS_CHARSET) {
                        $SUPRESS_CHARSET = 1;
                        array_push($LOG, 'Внимание! Попытка отключить настройки кодовой страницы');
                        $i--;
                        continue;
                    }
                    if (!$SUPRESS_ENGINE) {
                        $SUPRESS_ENGINE = 1;
                        array_push($LOG, 'Внимание! Попытка отключить настройки формата хранения данных');
                        $i--;
                        continue;
                    }
                    array_push($ERROR, 'Не могу создать таблицу "'.$tname.'"!<br>Обратитесь к автору проекта за разъяснениями<br>Код SQL запроса:<br>'.$dbCreateString);
                    $error = 1;
                    break;
                }
                array_push($LOG, 'Создание таблицы "<b>'.$tname.'</b>" ... OK');
            }
        }
        array_push($LOG, 'Все таблицы успешно созданы ... OK');
        array_push($LOG, '');
        // 1.5 Создание пользователя-администратора
        $query = 'insert into `'.$_POST['reg_dbprefix']."_users` (`name`, `pass`, `mail`, `status`, `reg`) VALUES ('".$mysql->db_quote($_POST['admin_login'])."', '".$mysql->db_quote(md5(md5($_POST['admin_password'])))."', '".$mysql->db_quote($_POST['admin_email'])."', '1', unix_timestamp(now()))";
        if (!@$mysql->query($query)) {
            array_push($LOG, 'Активация пользователя-администратора ... <span style="color: red;">FAIL</span>');
        } else {
            array_push($LOG, 'Активация пользователя-администратора ... OK');
        }
        // 1.6 Сохраняем конфигурационные переменные database.engine.version, database.engine.revision
        @$mysql->query('insert into `'.$_POST['reg_dbprefix']. "_config` (name, value) values ('database.engine.version', '0.9.7 RC-3')");
        @$mysql->query('insert into `'.$_POST['reg_dbprefix']."_config` (name, value) values ('database.engine.revision', '5')");
        // Вычищаем лишний перевод строки из 'home_url'
        if (substr($_POST['home_url'], -1, 1) == '/') {
            $_POST['home_url'] = substr($_POST['home_url'], 0, -1);
        }
        // 1.7. Формируем конфигурационный файл
        $newconf = [
            'dbtype'              => $_POST['reg_dbtype'],
            'dbhost'              => $_POST['reg_dbhost'],
            'dbname'              => $_POST['reg_dbname'],
            'dbuser'              => $_POST['reg_dbuser'],
            'dbpasswd'            => $_POST['reg_dbpass'],
            'prefix'              => $_POST['reg_dbprefix'],
            'home_url'            => $_POST['home_url'],
            'admin_url'           => $_POST['home_url'].'/'.$adminDirName,
            'images_dir'          => $installDir.'/uploads/images/',
            'files_dir'           => $installDir.'/uploads/files/',
            'attach_dir'          => $installDir.'/uploads/dsn/',
            'avatars_dir'         => $installDir.'/uploads/avatars/',
            'images_url'          => $_POST['home_url'].'/uploads/images',
            'files_url'           => $_POST['home_url'].'/uploads/files',
            'attach_url'          => $_POST['home_url'].'/uploads/dsn',
            'avatars_url'         => $_POST['home_url'].'/uploads/avatars',
            'home_title'          => $_POST['home_title'],
            'admin_mail'          => $_POST['admin_email'],
            'lock'                => '0',
            'lock_reason'         => 'Сайт на реконструкции!',
            'meta'                => '1',
            'description'         => 'Здесь описание вашего сайта',
            'keywords'            => 'Здесь ключевые слова, через запятую (,)',
            'skin'                => 'default',
            'theme'               => $_POST['template'],
            'default_lang'        => $currentLanguage,
            'auto_backup'         => '0',
            'auto_backup_time'    => '48',
            'use_gzip'            => '0',
            'use_captcha'         => '1',
            'captcha_font'        => 'verdana',
            'use_cookies'         => '0',
            'use_sessions'        => '1',
            'number'              => '5',
            'category_link'       => '1',
            'add_onsite'          => '1',
            'add_onsite_guests'   => '0',
            'date_adjust'         => '0',
            'timestamp_active'    => 'j Q Y',
            'timestamp_updated'   => 'j.m.Y - H:i',
            'smilies'             => 'smile, biggrin, tongue, wink, cool, angry, sad, cry, upset, tired, blush, surprise, thinking, shhh, kiss, crazy, undecide, confused, down, up',
            'blocks_for_reg'      => '1',
            'use_smilies'         => '1',
            'use_bbcodes'         => '1',
            'use_htmlformatter'   => '1',
            'forbid_comments'     => '0',
            'reverse_comments'    => '0',
            'auto_wrap'           => '50',
            'flood_time'          => '20',
            'timestamp_comment'   => 'j.m.Y - H:i',
            'users_selfregister'  => '1',
            'register_type'       => '4',
            'use_avatars'         => '1',
            'avatar_wh'           => '65',
            'avatar_max_size'     => '16',
            'images_ext'          => 'gif, jpg, jpeg, png',
            'images_max_size'     => '512',
            'thumb_size_x'        => '150',
            'thumb_size_y'        => '150',
            'thumb_quality'       => '80',
            'wm_image'            => 'stamp',
            'wm_image_transition' => '50',
            'files_ext'           => 'zip, rar, gz, tgz, bz2',
            'files_max_size'      => '128',
            'auth_module'         => 'basic',
            'auth_db'             => 'basic',
            'crypto_salt'         => substr(md5(uniqid(rand(), 1)), 0, 8),
            '404_mode'            => 0,
            'debug'               => 1,
            'news_multicat_url'   => '1',
            'UUID'                => md5(mt_rand().mt_rand()).md5(mt_rand().mt_rand()),
        ];
        array_push($LOG, 'Подготовка параметров конфигурационного файла ... OK');
        // Записываем конфиг
        $confData = "<?php\n".'$config = '.var_export($newconf, true).";\n";
        if (!fwrite($frec['config.php'], $confData)) {
            array_push($ERROR, 'Ошибка записи конфигурационного файла!');
            $error = 1;
            break;
        }
        // Активируем плагин auth_basic
        $plugConf = [
            'active' => [
                'auth_basic' => 'auth_basic',
            ],
            'actions' => [
                'auth' => [
                    'auth_basic' => 'auth_basic/auth_basic.php',
                ],
            ],
        ];
        $plugData = "<?php\n".'$array = '.var_export($plugConf, true).";\n";
        $plugData = mb_convert_encoding($plugData, 'UTF-8', 'auto');
        if (!fwrite($frec['plugins.php'], $plugData)) {
            array_push($ERROR, 'Ошибка записи конфигурационного файла [список активных плагинов]!');
            $error = 1;
            break;
        }
        // А теперь - включаем необходимые плагины
        $pluginInstallList = [];
        foreach ($_POST as $k => $v) {
            if (preg_match('/^plugin\:(.+?)$/', $k, $m) && ($v == 1)) {
                array_push($pluginInstallList, $m[1]);
            }
        }
        // Закрываем все файлы
        foreach (array_keys($frec) as $k) {
            fclose($frec[$k]);
        }
        array_push($LOG, 'Сохранение конфигурационного файла ... OK');
        // А теперь - включаем необходимые плагины
        include_once root.'core.php';
        include_once root.'includes/inc/extraconf.inc.php';
        include_once root.'includes/inc/extrainst.inc.php';
        // Now let's install plugins
        // First: Load informational `version` files
        $list = pluginsGetList();
        // Подготавливаем список плагинов для установки
        $pluginInstallList = [];
        foreach ($_POST as $k => $v) {
            if (preg_match('/^plugin\:(.+?)$/', $k, $m) && ($v == 1)) {
                array_push($pluginInstallList, $m[1]);
            }
        }
    } while (0);
    $output = implode("<br/>\n", $LOG);
    if ($error) {
        $output .= "<br/>\n";
        foreach ($ERROR as $errText) {
            $output .= '<div class="errorDiv"><b><u>Ошибка</u>!</b><br/>'.$errText.'</div>';
        }
        // Make navigation menu
        $output .= '<div class="warningDiv">';
        $output .= '<input type="button" style="width: 230px;" value="Вернуться к настройке БД" onclick="document.getElementById(\'stage\').value=\'0\'; form.submit();"/> - если Вы что-то неверно ввели в настройках БД, то Вы можете исправить ошибку.<br/>';
        $output .= '<input type="button" style="width: 230px;" value="Попробовать ещё раз" onclick="document.getElementById(\'action\').value=\'install\'; form.submit();"/> - если Вы самостоятельно устранили ошибку, то нажмите сюда.';
        $output .= '</div>';
    }
    $tvars['vars']['actions'] = $output;
    // Выводим форму проверки
    $tpl->template('config_process', $templateDir);
    $tpl->vars('config_process', $tvars);
    echo $tpl->show('config_process');
    return $error ? false : true;
}
