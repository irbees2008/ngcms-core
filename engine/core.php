<?php

//
// Copyright (C) 2006-2017 Next Generation CMS (http://ngcms.ru)
// Name: core.php
// Description: core
// Author: NGCMS project team
//

// Configure error display mode
error_reporting(E_ALL ^ E_NOTICE);

// Define global directory constants
if (!defined('NGCoreDir')) {
    define('NGCoreDir', __DIR__ . '/'); // Location of Core directory
}

if (!defined('NGRootDir')) {
    define('NGRootDir', dirname(__DIR__) . '/'); // Location of SiteRoot
}

if (!defined('NGClassDir')) {
    define('NGClassDir', NGCoreDir . 'classes/'); // Location of AutoLoaded classes
}

if (!defined('NGVendorDir')) {
    define('NGVendorDir', NGRootDir . 'vendor/'); // Location of Vendor classes
}

$loader = require NGVendorDir . 'autoload.php';

// Autoloader for NEW STYLE Classes
spl_autoload_register(function ($className) {
    $fName = NGClassDir . $className . '.class.php';
    if (file_exists($fName)) {
        require_once $fName;
    }
});

// Magic function for immediate closure call
function NGRun($f)
{
    $f();
}

// ============================================================================
// MODULE DEPs check + basic setup
// ============================================================================
NGRun(function () {
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
});

// ============================================================================
// Global variables definition
// ============================================================================
global $PLUGINS, $EXTRA_HTML_VARS, $EXTRA_CSS;
global $AUTH_METHOD, $AUTH_CAPABILITIES, $PPAGES, $PFILTERS, $RPCFUNC, $TWIGFUNC;
global $RPCADMFUNC, $SUPRESS_TEMPLATE_SHOW, $SUPRESS_MAINBLOCK_SHOW, $SYSTEM_FLAGS;
global $DSlist, $PERM, $confPerm, $confPermUser, $systemAccessURL, $cron;
global $timer, $mysql, $ip, $parse, $tpl, $lang, $config;
global $TemplateCache, $siteDomainName;
global $currentHandler, $ngTrackID, $ngCookieDomain;
global $twigGlobal, $twig, $twigLoader, $twigStringLoader;
global $multiDomainName;

// Initialize global variables
$EXTRA_HTML_VARS = [];
$EXTRA_CSS = [];

$AUTH_METHOD = [];
$AUTH_CAPABILITIES = [];

$PPAGES = [];
$PFILTERS = [];
$RPCFUNC = [];
$TWIGFUNC = [];
$RPCADMFUNC = [];

$PERM = [];
$UGROUP = [];

$SUPRESS_TEMPLATE_SHOW = 0;
$SUPRESS_MAINBLOCK_SHOW = 0;

$CurrentHandler = [];
$TemplateCache = [];
$lang = [];
$SYSTEM_FLAGS = [
    'actions.disabled' => [],
    'http.headers'     => [
        'content-type'  => 'text/html; charset=utf-8',
        'cache-control' => 'private',
    ],
];

$twigGlobal = [
    'flags' => [
        'isLogged' => 0,
    ],
];

// List of DataSources
$DSlist = [
    'news'           => 1,
    'categories'     => 2,
    'comments'       => 3,
    'users'          => 4,
    'files'          => 10,
    'images'         => 11,
    '#xfields:tdata' => 51,
];

$PLUGINS = [
    'active'        => [],
    'active:loaded' => 0,
    'loaded'        => [],
    'loaded:files'  => [],
    'config'        => [],
    'config:loaded' => 0,
];

// Set internal encoding and HTTP output to UTF-8
mb_internal_encoding('UTF-8');
mb_http_output('UTF-8');

// Define global constants "root", "site_root"
if (!defined('root')) {
    define('root', __DIR__ . '/');
}

if (!defined('site_root')) {
    define('site_root', dirname(__DIR__) . '/');
}

// Define domain name for cookies
// Определяем cookie-домен в формате `.ngcms.org`
$host = strtolower($_SERVER['HTTP_HOST']);
if (preg_match("#^(.+?):\d+$#", $host, $m)) {
    $host = $m[1]; // убираем порт
}
$hostParts = explode('.', $host);
if (count($hostParts) >= 2) {
    $ngCookieDomain = '.' . $hostParts[count($hostParts) - 2] . '.' . $hostParts[count($hostParts) - 1];
} else {
    $ngCookieDomain = '.' . $host; // fallback
}
// Manage trackID cookie - can be used for plugins that don't require authentication,
// but need to track the user according to their ID
if (!isset($_COOKIE['ngTrackID'])) {
    $ngTrackID = md5(md5(uniqid(rand(), 1)));
    setcookie('ngTrackID', $ngTrackID, time() + 86400 * 365, '/', $ngCookieDomain, 0, 1);
} else {
    $ngTrackID = $_COOKIE['ngTrackID'];
}

// Initialize last variables
$confArray = [
    // Pre-defined init values
    'predefined' => [
        'HTTP_REFERER' => $_SERVER['HTTP_REFERER'] ?? '',
        'PHP_SELF'     => $_SERVER['PHP_SELF'] ?? '',
        'REQUEST_URI'  => $_SERVER['REQUEST_URI'] ?? '',
        'config'       => [],
        'catz'         => [],
        'catmap'       => [],
        'is_logged'    => false,
    ],
];

// Load pre-defined variables
$predefinedUnsetArray = ['_GET', '_POST', '_SESSION', '_COOKIE', '_ENV'];
foreach ($confArray['predefined'] as $key => $value) {
    foreach ($predefinedUnsetArray as $arr) {
        if (isset($$arr[$key])) {
            unset($$arr[$key]);
        }
    }
    $$key = $value;
}

// Prepare variable with access URL
$systemAccessURL = $_SERVER['REQUEST_URI'];
if (($tmp_pos = strpos($systemAccessURL, '?')) !== false) {
    $systemAccessURL = mb_substr($systemAccessURL, 0, $tmp_pos);
}

// Initialize system libraries
// ** Time measurement functions
include_once root . 'includes/classes/timer.class.php';
$timer = new microTimer();
$timer->start();

// ** Multisite engine
include_once root . 'includes/inc/multimaster.php';
multi_multisites();
/**
 * @var $multiDomainName
 * @var $multimaster
 */
if (!defined('confroot')) {
    define('confroot', root . 'conf/' . ($multiDomainName && $multimaster && ($multiDomainName != $multimaster) ? 'multi/' . $multiDomainName . '/' : ''));
}

// Проверка наличия файла конфигурации
if (!file_exists(confroot . 'config.php') || filesize(confroot . 'config.php') < 10) {
    $scriptPath = $_SERVER['PHP_SELF'] ?? '';

    // Проверяем, соответствует ли путь ожидаемым шаблонам
    if (preg_match("#^(.*?)(/index\.php|/engine/admin\.php)$#", $scriptPath, $matches)) {
        $redirectUrl = $matches[1] . '/engine/install.php';
    } else {
        $redirectUrl = adminDirName . '/install.php';
    }

    // Выполняем переадресацию
    header('Location: ' . $redirectUrl);
    echo 'NGCMS: Engine is not installed yet. Please run installer from /engine/install.php';
    exit;
}

// ** Load system config
include_once confroot . 'config.php';
// [[FIX config variables]]
if (!isset($config['uprefix'])) {
    $config['uprefix'] = $config['prefix'];
}

// Set up default timezone [ default: Europe/Moscow ]
date_default_timezone_set($config['timezone'] ?? 'Europe/Moscow');

// [[MARKER]] Configuration file is loaded
$timer->registerEvent('Config file is loaded');

// Call multidomains processor
multi_multidomains();
//print "siteDomainName [".$siteDomainName."]<br/>\n";

// Initiate session - take care about right domain name for sites with/without www. prefix
//print "<pre>".var_export($_SERVER, true).var_export($_COOKIE, true)."</pre>";
session_set_cookie_params([
    'lifetime' => 86400,
    'path' => '/',
    'domain' => $ngCookieDomain,
    'secure' => true,        // только если HTTPS!
    'httponly' => true,
    'samesite' => 'None',    // обязательно для работы на поддоменах
]);
session_start();

// Load system libraries
include_once root . 'includes/inc/consts.inc.php';
include_once root . 'includes/inc/functions.inc.php';
include_once root . 'includes/inc/extras.inc.php';

include_once 'includes/classes/templates.class.php';
include_once 'includes/classes/parse.class.php';

include_once 'includes/classes/uhandler.class.php';

// [[MARKER]] All system libraries are loaded
$timer->registerEvent('Core files are included');

// Activate URL processing library
$UHANDLER = new urlHandler();
$UHANDLER->loadConfig();

// Other libraries
$parse = new parse();
$tpl = new tpl();
$ip = checkIP();

// Load user groups
loadGroups();

// Init our own exception handler
set_exception_handler('ngExceptionHandler');
set_error_handler('ngErrorHandler');
register_shutdown_function('ngShutdownHandler');

// Initialize TWIG engine
$twigLoader = new NGTwigLoader(root);

// Configure environment and general parameters
$twig = new NGTwigEnvironment($twigLoader, [
    'cache'       => root . 'cache/twig/',
    'auto_reload' => true,
    'autoescape'  => false,
    'charset'     => 'UTF-8',
]);

// [[MARKER]] TWIG template engine is loaded
$timer->registerEvent('Template engine is activated');

// Give domainName to URL handler engine for generating absolute links
$UHANDLER->setOptions(['domainPrefix' => $config['home_url']]);

// Check if engine is installed in subdirectory
if (preg_match('#^http\:\/\/([^\/])+(\/.+)#', $config['home_url'], $match)) {
    $UHANDLER->setOptions(['localPrefix' => $match[2]]);
}

// Load cache engine
include_once root . 'includes/classes/cache.class.php';

// NEW :: PDO driver with global classes handler
NGRun(function () use ($config) {
    global $mysql;

    $sx = NGEngine::getInstance();
    $sx->set('db', new NGPDO(['host' => $config['dbhost'], 'user' => $config['dbuser'], 'pass' => $config['dbpasswd'], 'db' => $config['dbname'], 'charset' => 'utf8']));

    $sx->set('config', $config);
    $sx->set('legacyDB', new NGLegacyDB(false));
    $sx->getLegacyDB()->connect('', '', '');
    $mysql = $sx->getLegacyDB();

    // Sync PHP <=> MySQL timezones
    $mysql->query('SET @@session.time_zone = "' . date('P') . '"');
});

// [[MARKER]] MySQL connection is established
$timer->registerEvent('DB connection established');

// Load categories from DB
ngLoadCategories();

// [[MARKER]] Categories are loaded
$timer->registerEvent('DB category list is loaded');

// Load compatibility engine [ rewrite old links ] if enabled
if ($config['libcompat']) {
    include_once root . 'includes/inc/libcompat.php';
    compatRedirector();
}

//
/// Special way to pass authentication cookie via POST params
if (!isset($_COOKIE['zz_auth']) && isset($_POST['ngAuthCookie'])) {
    $_COOKIE['zz_auth'] = $_POST['ngAuthCookie'];
}

// [[MARKER]] Ready to load auth plugins
$timer->registerEvent('Ready to load auth plugins');
loadActionHandlers('auth');

// Load user's permissions DB
loadPermissions();

// ============================================================================
// Initialize system libraries
// ============================================================================
// System protection
if (!$AUTH_CAPABILITIES[$config['auth_module']]['login']) {
    $config['auth_module'] = 'basic';
}
if (!$AUTH_CAPABILITIES[$config['auth_db']]['db']) {
    $config['auth_db'] = 'basic';
}

if (isset($AUTH_METHOD[$config['auth_module']]) && isset($AUTH_METHOD[$config['auth_db']])) {
    // Auth subsystem is activated
    // Choose default or user-defined auth module
    $auth = &$AUTH_METHOD[$config['auth_module']];
    $auth_db = &$AUTH_METHOD[$config['auth_db']];

    $xrow = $auth_db->check_auth();
    $CURRENT_USER = $xrow;

    if (is_array($xrow)) {
        NGEngine::getInstance()->set('currentUser', new NGUser($xrow));
    }

    if (isset($xrow['name']) && $xrow['name']) {
        $is_logged_cookie = true;
        $is_logged = true;
        $username = $xrow['name'];
        $userROW = $xrow;
        if ($config['x_ng_headers']) {
            header('X-NG-UserID: ' . (int) $userROW['id']);
            header('X-NG-Login: ' . htmlentities($username));
        }

        // Now every TWIG template will know if user is logged in
        $twigGlobal['flags']['isLogged'] = 1;
        $twigGlobal['user'] = $userROW;
    }
} else {
    echo "Fatal error: No auth module is found.<br />Configuration is damaged, please restore from backup or perform manual fix.<br />\n";
}

// [[MARKER]] Authentication process is complete
$timer->registerEvent('Auth procedure is finished');

if ($is_logged) {
    define('name', $userROW['name']);
}

// Init internal cron module
$cron = new cronManager();

// Load action handlers for action 'all'
loadActionHandlers('all');
$timer->registerEvent('ALL core-related plugins are loaded');

// Execute 'core' action handler
executeActionHandler('core');
$timer->registerEvent('ALL core-related plugins are executed');

// Define last consts
define('tpl_site', site_root . 'templates/' . $config['theme'] . '/');
define('tpl_url', home . '/templates/' . $config['theme']);

// Reconfigure allowed template paths in TWIG - site template is also available
$twigLoader->setPaths([tpl_site, root]);

// Add global variables `tpl_url` and `scriptLibrary` in TWIG
$twig->addGlobal('tpl_url', tpl_url);
$twig->addGlobal('scriptLibrary', scriptLibrary);

// Load lang files after executing core scripts. This is done for the switcher plugin.
$lang = LoadLang('common');
$lang = LoadLangTheme();

$langShortMonths = explode(',', $lang['short_months']);
$langMonths = explode(',', $lang['months']);

$timer->registerEvent('* CORE.PHP is complete');
