<?php
//
// Copyright (C) 2006-2014 Next Generation CMS (http://ngcms.org/)
// Name: configuration.php
// Description: Configuration managment
// Author: Vitaly Ponomarev, Alexey Zinchenko
//
// Protect against hack attempts
if (!defined('NGCMS')) {
    exit('HAL');
}
$lang = LoadLang('configuration', 'admin');
function twigmkSelect($params)
{
    $values = '';
    if (isset($params['values']) && is_array($params['values'])) {
        foreach ($params['values'] as $k => $v) {
            $values .= '<option value="' . $k . '"' . (($k == $params['value']) ? ' selected="selected"' : '') . '>' . $v . '</option>';
        }
    }
    return '<select ' . ((isset($params['id']) && $params['id']) ? 'id="' . $params['id'] . '" ' : '') . 'name="' . $params['name'] . '">' . $values . '</select>';
}
function twigmkSelectYN($params)
{
    global $lang;
    $params['values'] = [1 => $lang['yesa'], 0 => $lang['noa']];
    return twigmkSelect($params);
}
function twigmkSelectNY($params)
{
    global $lang;
    $params['values'] = [0 => $lang['noa'], 1 => $lang['yesa']];
    return twigmkSelect($params);
}
$twig->addFunction(new \Twig\TwigFunction('mkSelect', 'twigmkSelect'));
$twig->addFunction(new \Twig\TwigFunction('mkSelectYN', 'twigmkSelectYN'));
$twig->addFunction(new \Twig\TwigFunction('mkSelectNY', 'twigmkSelectNY'));
//
// Save system config
function systemConfigSave()
{
    global $lang, $config, $mysql, $notify;
    // Check for permissions
    if (!checkPermission(['plugin' => '#admin', 'item' => 'configuration'], null, 'modify')) {
        msg(['type' => 'error', 'text' => $lang['perm.denied']], 1, 1);
        ngSYSLOG(['plugin' => '#admin', 'item' => 'configuration', 'ds_id' => $id], ['action' => 'saveConfig'], null, [0, 'SECURITY.PERM']);
        return false;
    }
    // Check for security token
    if ((!isset($_REQUEST['token'])) || ($_REQUEST['token'] != genUToken('admin.configuration'))) {
        msg(['type' => 'error', 'text' => $lang['error.security.token'], 'info' => $lang['error.security.token#desc']]);
        ngSYSLOG(['plugin' => '#admin', 'item' => 'configuration', 'ds_id' => $id], ['action' => 'saveConfig'], null, [0, 'SECURITY.TOKEN']);
        return false;
    }
    $save_con = $_REQUEST['save_con'];
    if (is_null($save_con) || !is_array($save_con)) {
        return false;
    }
    // Determine which config to save
    $siteId = trim($_REQUEST['site_id'] ?? '');
    $configFile = confroot . 'config.php';
    if ($siteId) {
        // Validate site ID
        if (!preg_match('/^[a-zA-Z0-9_]+$/', $siteId)) {
            msg(['type' => 'error', 'text' => $lang['multisite_invalid_id']]);
            return false;
        }
        // Check if site exists in multiconfig
        $multiconfig = [];
        if (is_file(confroot . 'multiconfig.php')) {
            include confroot . 'multiconfig.php';
        }
        if (!isset($multiconfig[$siteId])) {
            msg(['type' => 'error', 'text' => $lang['multisite_not_found']]);
            return false;
        }
        // Use site-specific config
        $configFile = confroot . 'multi/' . $siteId . '/config.php';
        // Create directory if not exists
        $siteConfigDir = confroot . 'multi/' . $siteId;
        if (!is_dir($siteConfigDir)) {
            if (!@mkdir($siteConfigDir, 0755, true)) {
                msg(['type' => 'error', 'text' => $lang['multisite_mkdir_error']]);
                return false;
            }
        }
    }
    // Check if DB connection params are correct (only for main config)
    if (!$siteId) {
        try {
            $sx = NGEngine::getInstance();
            $sx->set('db', new NGPDO(['host' => $save_con['dbhost'], 'user' => $save_con['dbuser'], 'pass' => $save_con['dbpasswd'], 'db' => $save_con['dbname']]));
            $sx->set('legacyDB', new NGLegacyDB(false));
            $sx->getLegacyDB()->connect('', '', '');
            $sqlTest = $sx->getLegacyDB();
        } catch (Exception $e) {
            msgSticker($lang['dbcheck_error'], 'error');
            return false;
        }
    }
    // Save our UUID or regenerate LOST UUID
    $save_con['UUID'] = $config['UUID'];
    if ($save_con['UUID'] == '') {
        $save_con['UUID'] = md5(mt_rand() . mt_rand()) . md5(mt_rand() . mt_rand());
    }
    // Manage "load_profiler" variable
    $save_con['load_profiler'] = intval($save_con['load_profiler']);
    if (($save_con['load_profiler'] > 0) && ($save_con['load_profiler'] < 86400)) {
        $save_con['load_profiler'] = time() + $save_con['load_profiler'];
    } else {
        $save_con['load_profiler'] = 0;
    }
    // Prepare resulting config content
    $fcData = "<?php\n" . '$config = ' . var_export($save_con, true) . "\n;?>";
    // Try to save config
    $fcHandler = @fopen($configFile, 'w');
    if ($fcHandler) {
        fwrite($fcHandler, $fcData);
        fclose($fcHandler);
        msgSticker($lang['msgo_saved']);
        //msg(array("text" => $lang['msgo_saved']));
    } else {
        msg(['type' => 'error', 'text' => $lang['msge_save_error'], 'info' => $lang['msge_save_error#desc']]);
        return false;
    }
    ngSYSLOG(['plugin' => '#admin', 'item' => 'configuration', 'ds_id' => $id], ['action' => 'saveConfig', 'list' => $fcData], null, [1, '']);
    return true;
}
//
// Show configuration form
function systemConfigEditForm()
{
    global $lang, $AUTH_CAPABILITIES, $PHP_SELF, $twig, $multiconfig, $multiDomainName;
    // Check for token
    if (!checkPermission(['plugin' => '#admin', 'item' => 'configuration'], null, 'details')) {
        msg(['type' => 'error', 'text' => $lang['perm.denied']], 1, 1);
        ngSYSLOG(['plugin' => '#admin', 'item' => 'configuration', 'ds_id' => $id], ['action' => 'showConfig'], null, [0, 'SECURITY.PERM']);
        return false;
    }
    $auth_modules = [];
    $auth_dbs = [];
    foreach ($AUTH_CAPABILITIES as $k => $v) {
        if ($v['login']) {
            $auth_modules[$k] = $k;
        }
        if ($v['db']) {
            $auth_dbs[$k] = $k;
        }
    }
    // Determine which config to load
    $siteId = trim($_REQUEST['site_id'] ?? '');
    $configFile = confroot . 'config.php';
    $currentSite = '';
    if ($siteId) {
        // Validate site ID
        if (!preg_match('/^[a-zA-Z0-9_]+$/', $siteId)) {
            msg(['type' => 'error', 'text' => $lang['multisite_invalid_id']]);
            $siteId = '';
        } else {
            // Load multiconfig to check if site exists
            $multiconfig = [];
            if (is_file(confroot . 'multiconfig.php')) {
                include confroot . 'multiconfig.php';
            }
            if (!isset($multiconfig[$siteId])) {
                msg(['type' => 'error', 'text' => $lang['multisite_not_found']]);
                $siteId = '';
            } else {
                // Use site-specific config
                $siteConfigFile = confroot . 'multi/' . $siteId . '/config.php';
                if (is_file($siteConfigFile)) {
                    $configFile = $siteConfigFile;
                    $currentSite = $siteId;
                } else {
                    msg(['type' => 'warning', 'text' => $lang['multisite_config_not_found']]);
                }
            }
        }
    }
    // Load config file from configuration
    // Now in $config we have original version of configuration data
    include $configFile;
    // Load multiconfig if exists
    $multiconfig = [];
    $multimaster = '';
    if (is_file(confroot . 'multiconfig.php')) {
        @include confroot . 'multiconfig.php';
    }
    // UI change: lock selection of auth modules in configuration.
    // Ensure non-empty fallback values so select is not blank.
    $currentAuthModule = (isset($config['auth_module']) && $config['auth_module']) ? $config['auth_module'] : 'basic';
    $currentAuthDB     = (isset($config['auth_db']) && $config['auth_db']) ? $config['auth_db'] : 'basic';
    $auth_modules = [$currentAuthModule => $currentAuthModule];
    $auth_dbs     = [$currentAuthDB => $currentAuthDB];
    $load_profiler = $config['load_profiler'] - time();
    if (($load_profiler < 0) || ($load_profiler > 86400)) {
        $config['load_profiler'] = 0;
    }
    $mConfig = [];
    if (is_array($multiconfig)) {
        foreach ($multiconfig as $k => $v) {
            $v['key'] = $k;
            $mConfig[] = $v;
        }
    }
    // Set default timeZone if it's empty
    if (!$config['timezone']) {
        $config['timezone'] = 'Europe/Moscow';
    }
    // Use a copy of config with sane defaults for template binding
    $cfgForTpl = $config;
    $cfgForTpl['auth_module'] = $currentAuthModule;
    $cfgForTpl['auth_db'] = $currentAuthDB;
    // Format timezone list with UTC offset
    $timezoneList = [];
    foreach (timezone_identifiers_list() as $timezone) {
        try {
            $dateTime = new DateTime('now', new DateTimeZone($timezone));
            $offset = $dateTime->format('P');
            $displayName = "(UTC{$offset}) " . str_replace('_', ' ', $timezone);
            $timezoneList[$timezone] = $displayName;
        } catch (Exception $e) {
            $timezoneList[$timezone] = $timezone;
        }
    }
    $tVars = [
        //	SYSTEM CONFIG is available via `config` variable
        'config'                => $cfgForTpl,
        'list'                  => [
            'captcha_font' => ListFiles('trash', 'ttf'),
            'theme'        => ListFiles('../templates', ''),
            'admin_skin'   => ListFiles('skins', ''),
            'default_lang' => ListFiles('lang', ''),
            'wm_image'     => ListFiles('trash', ['gif', 'png'], 2),
            'auth_module'  => $auth_modules,
            'auth_db'      => $auth_dbs,
            'timezoneList' => $timezoneList,
        ],
        'php_self'              => $PHP_SELF,
        'timestamp_active_now'  => LangDate($config['timestamp_active'], time()),
        'timestamp_updated_now' => LangDate($config['timestamp_updated'], time()),
        'timestamp_admin_news_now' => date($config['timestamp_admin_news'] ?: 'd.m.Y H:i', time()),
        'token'                 => genUToken('admin.configuration'),
        'multiConfig'           => $mConfig,
        'currentSite'           => $currentSite,
        'siteId'                => $siteId,
        'multiDomainName'       => $multiDomainName ?? 'main',
        'isMainSite'            => empty($multiDomainName) || $multiDomainName === 'main',
    ];
    //
    // Fill parameters for multiconfig
    //
    $multiList = [];
    $tmpline = '';
    if (is_array($multiconfig)) {
        foreach ($multiconfig as $mid => $mline) {
            $tmpdom = implode("\n", $mline['domains']);
            $tmpline .= "<tr class='contentEntry1'><td>" . ($mline['active'] ? 'On' : 'Off') . "</td><td>$mid</td><td>" . ($tmpdom ? $tmpdom : '-не указано-') . "</td><td>&nbsp;</td></tr>\n";
        }
    }
    $tvars['vars']['multilist'] = $tmpline;
    $tvars['vars']['defaultSection'] = (isset($_REQUEST['selectedOption']) && $_REQUEST['selectedOption']) ? htmlspecialchars($_REQUEST['selectedOption'], ENT_COMPAT | ENT_HTML401, 'UTF-8') : 'news';
    $xt = $twig->loadTemplate('skins/' . $config['admin_skin'] . '/tpl/configuration.tpl');
    return $xt->render($tVars);
}
//
// Add new multisite
//
function multisiteAdd()
{
    global $lang, $twig, $config, $multiDomainName;
    // Check permissions
    if (!checkPermission(['plugin' => '#admin', 'item' => 'configuration'], null, 'modify')) {
        msg(['type' => 'error', 'text' => $lang['perm.denied']], 1, 1);
        return false;
    }
    // Multisite management is only available on main site
    if (!empty($multiDomainName) && $multiDomainName !== 'main') {
        msg(['type' => 'error', 'text' => 'Управление мультисайтами доступно только на основном сайте.']);
        return false;
    }
    // Check for security token
    if ((!isset($_REQUEST['token'])) || ($_REQUEST['token'] != genUToken('admin.multisite'))) {
        msg(['type' => 'error', 'text' => $lang['error.security.token']]);
        return false;
    }
    $siteId = trim($_POST['site_id'] ?? '');
    $domains = trim($_POST['domains'] ?? '');
    $active = intval($_POST['active'] ?? 1);
    $dbPrefix = trim($_POST['db_prefix'] ?? '');
    // Validate site ID (only alphanumeric and underscore)
    if (!preg_match('/^[a-zA-Z0-9_]+$/', $siteId)) {
        msg(['type' => 'error', 'text' => $lang['multisite_invalid_id']]);
        return false;
    }
    // Validate db_prefix
    if (!preg_match('/^[a-zA-Z0-9_]+$/', $dbPrefix)) {
        msg(['type' => 'error', 'text' => 'Неверный префикс базы данных. Используйте только латиницу, цифры и подчеркивание.']);
        return false;
    }
    // Check if prefix already exists in database
    global $mysql;
    try {
        $testTable = $dbPrefix . '_plugins';
        $result = $mysql->select("SHOW TABLES LIKE " . db_squote($testTable));
        if (!empty($result)) {
            msg(['type' => 'error', 'text' => "Префикс '{$dbPrefix}' уже используется в базе данных."]);
            return false;
        }
    } catch (Exception $e) {
        // Continue if table check fails
    }
    // Parse domains (one per line)
    $domainList = array_filter(array_map('trim', explode("\n", str_replace("\r", "", $domains))));
    if (empty($domainList)) {
        msg(['type' => 'error', 'text' => $lang['multisite_no_domains']]);
        return false;
    }
    // Load current multiconfig
    $multiconfig = [];
    $multimaster = 'main';
    if (is_file(confroot . 'multiconfig.php')) {
        include confroot . 'multiconfig.php';
    }
    // Ensure main site exists in multiconfig with current domain
    if (!isset($multiconfig['main']) || empty($multiconfig['main']['domains'])) {
        // Extract domain from config home_url
        $mainDomain = parse_url($config['home_url'], PHP_URL_HOST);
        if (!$mainDomain) {
            $mainDomain = $_SERVER['HTTP_HOST'] ?? 'localhost';
        }
        $multiconfig['main'] = [
            'domains' => [$mainDomain],
            'active' => 1
        ];
    }
    // Check if site already exists
    if (isset($multiconfig[$siteId])) {
        msg(['type' => 'error', 'text' => $lang['multisite_already_exists']]);
        return false;
    }
    // Add new site to config
    $multiconfig[$siteId] = [
        'domains' => $domainList,
        'active' => $active
    ];
    // Save multiconfig.php
    $configContent = "<?php\n\n";
    $configContent .= "// Multisite configuration\n";
    $configContent .= "// Generated: " . date('Y-m-d H:i:s') . "\n\n";
    $configContent .= '$multimaster = ' . var_export($multimaster, true) . ";\n\n";
    $configContent .= '$multiconfig = ' . var_export($multiconfig, true) . ";\n";
    if (!@file_put_contents(confroot . 'multiconfig.php', $configContent)) {
        msg(['type' => 'error', 'text' => $lang['multisite_save_error']]);
        return false;
    }
    // Create config directory for new site
    $siteConfigDir = confroot . 'multi/' . $siteId;
    if (!is_dir($siteConfigDir)) {
        if (!@mkdir($siteConfigDir, 0755, true)) {
            msg(['type' => 'warning', 'text' => $lang['multisite_mkdir_error']]);
        }
    }
    // Copy all configuration files to new site
    if (is_dir($siteConfigDir)) {
        $configFiles = [
            'config.php',
            'plugdata.php',
            'cron.php',
            'perm.default.php',
            'perm.rules.php',
            'rewrite.php',
            'urlconf.php',
            'robots.txt'
        ];
        foreach ($configFiles as $file) {
            if (is_file(confroot . $file)) {
                @copy(confroot . $file, $siteConfigDir . '/' . $file);
            }
        }
        // Copy extras directory with plugin settings
        if (is_dir(confroot . 'extras')) {
            $extrasSource = confroot . 'extras';
            $extrasTarget = $siteConfigDir . '/extras';
            // Recursive copy function
            $copyDir = function ($src, $dst) use (&$copyDir) {
                if (!is_dir($dst)) {
                    @mkdir($dst, 0755, true);
                }
                $files = @scandir($src);
                if ($files) {
                    foreach ($files as $file) {
                        if ($file != '.' && $file != '..') {
                            if (is_dir($src . '/' . $file)) {
                                $copyDir($src . '/' . $file, $dst . '/' . $file);
                            } else {
                                @copy($src . '/' . $file, $dst . '/' . $file);
                            }
                        }
                    }
                }
            };
            $copyDir($extrasSource, $extrasTarget);
        }
        // Create minimal plugins.php for new multisite (only essential plugins)
        $minimalPlugins = [
            'active' => [
                'auth_basic' => 'auth_basic',
                'ng-helpers' => 'ng-helpers',
                'uprofile' => 'uprofile',
            ],
            'actions' => [
                'auth' => [
                    'auth_basic' => 'auth_basic/auth_basic.php',
                ],
                'core' => [
                    'ng-helpers' => 'ng-helpers/src/helpers.php',
                ],
                'ppages' => [
                    'uprofile' => 'uprofile/uprofile.php',
                ],
                'rpc' => [
                    'uprofile' => 'uprofile/uprofile.php',
                ],
            ],
            'installed' => [
                'auth_basic' => 1,
                'ng-helpers' => 1,
                'uprofile' => 1,
            ],
        ];
        $pluginsContent = "<?php \$array = " . var_export($minimalPlugins, true) . ";\n";
        @file_put_contents($siteConfigDir . '/plugins.php', $pluginsContent);
        // Create upload directories for multisite
        $uploadsBasePath = rtrim($config['images_dir'], '/\\');
        $uploadsBasePath = dirname($uploadsBasePath); // Go from /uploads/images to /uploads
        $multisiteUploadsPath = $uploadsBasePath . '/multi/' . $siteId;
        $uploadDirs = ['avatars', 'files', 'dsn', 'images'];
        foreach ($uploadDirs as $dir) {
            $dirPath = $multisiteUploadsPath . '/' . $dir;
            if (!is_dir($dirPath)) {
                @mkdir($dirPath, 0755, true);
            }
        }
        // Update config.php with new db prefix, URLs and title
        $configFile = $siteConfigDir . '/config.php';
        if (is_file($configFile)) {
            $configContent = file_get_contents($configFile);
            // Update prefix
            $configContent = preg_replace(
                "/'prefix'\s*=>\s*'[^']*'/",
                "'prefix' => '{$dbPrefix}'",
                $configContent
            );
            // Update URLs (use first domain from list)
            $firstDomain = $domainList[0];
            $siteUrl = 'http://' . $firstDomain;
            $configContent = preg_replace(
                "/'home_url'\s*=>\s*'[^']*'/",
                "'home_url' => '{$siteUrl}'",
                $configContent
            );
            $configContent = preg_replace(
                "/'admin_url'\s*=>\s*'[^']*'/",
                "'admin_url' => '{$siteUrl}/engine'",
                $configContent
            );
            // Update title (use site_id as title)
            $configContent = preg_replace(
                "/'home_title'\s*=>\s*'[^']*'/",
                "'home_title' => '{$siteId}'",
                $configContent
            );
            // Get uploads base path from config
            $uploadsBasePath = rtrim($config['images_dir'], '/\\');
            $uploadsBasePath = dirname($uploadsBasePath); // Go from /uploads/images to /uploads
            $multisiteUploadsDir = $uploadsBasePath . '/multi/' . $siteId;
            // Update upload URLs and directories (avatars, files, attach, images)
            $configContent = preg_replace(
                "/'avatars_url'\s*=>\s*'[^']*'/",
                "'avatars_url' => '{$siteUrl}/uploads/multi/{$siteId}/avatars'",
                $configContent
            );
            $configContent = preg_replace(
                "/'avatars_dir'\s*=>\s*'[^']*'/",
                "'avatars_dir' => '{$multisiteUploadsDir}/avatars/'",
                $configContent
            );
            $configContent = preg_replace(
                "/'files_url'\s*=>\s*'[^']*'/",
                "'files_url' => '{$siteUrl}/uploads/multi/{$siteId}/files'",
                $configContent
            );
            $configContent = preg_replace(
                "/'files_dir'\s*=>\s*'[^']*'/",
                "'files_dir' => '{$multisiteUploadsDir}/files/'",
                $configContent
            );
            $configContent = preg_replace(
                "/'attach_url'\s*=>\s*'[^']*'/",
                "'attach_url' => '{$siteUrl}/uploads/multi/{$siteId}/dsn'",
                $configContent
            );
            $configContent = preg_replace(
                "/'attach_dir'\s*=>\s*'[^']*'/",
                "'attach_dir' => '{$multisiteUploadsDir}/dsn/'",
                $configContent
            );
            $configContent = preg_replace(
                "/'images_url'\s*=>\s*'[^']*'/",
                "'images_url' => '{$siteUrl}/uploads/multi/{$siteId}/images'",
                $configContent
            );
            $configContent = preg_replace(
                "/'images_dir'\s*=>\s*'[^']*'/",
                "'images_dir' => '{$multisiteUploadsDir}/images/'",
                $configContent
            );
            file_put_contents($configFile, $configContent);
        }
    }
    // Create clean database tables from template (engine/trash/tables.sql)
    try {
        global $mysql, $config;
        $targetPrefix = $dbPrefix;
        // Load MAIN site config to get source prefix
        $mainConfigFile = root . 'conf/config.php';
        if (is_file($mainConfigFile)) {
            // Save current config, load main config temporarily
            $currentConfig = $config;
            include $mainConfigFile;
            $sourcePrefix = $config['prefix'];
            $config = $currentConfig; // Restore current config
        } else {
            $sourcePrefix = 'ng'; // Default fallback
        }
        // Load SQL template
        $sqlFile = dirname(__DIR__) . '/trash/tables.sql'; // engine/trash/tables.sql
        if (!file_exists($sqlFile)) {
            msg(['type' => 'error', 'text' => 'Файл шаблона БД не найден: ' . $sqlFile]);
            msg(['type' => 'info', 'text' => 'Текущий каталог: ' . __DIR__]);
            return false;
        }
        $sqlContent = file_get_contents($sqlFile);
        if ($sqlContent === false) {
            msg(['type' => 'error', 'text' => 'Ошибка чтения файла tables.sql']);
            return false;
        }
        // Split SQL by semicolon (simple approach like install.php)
        $dbsql = explode(';', $sqlContent);
        $createdCount = 0;
        $failedTables = [];
        $createdTables = [];
        // Create tables (same logic as install.php)
        for ($i = 0; $i < count($dbsql); $i++) {
            $dbCreateString = str_replace('XPREFIX_', $targetPrefix . '_', $dbsql[$i]);
            if (!trim($dbCreateString)) {
                continue;
            }
            // Check if this is a CREATE TABLE statement
            if (preg_match('/CREATE TABLE `(.+?)`/', $dbCreateString, $match)) {
                $tname = $match[1];
                $mysql->query($dbCreateString);
                if ($mysql->db_errno()) {
                    $failedTables[] = $tname . ': ' . $mysql->db_error();
                } else {
                    $createdCount++;
                    $createdTables[] = $tname;
                }
            }
        }
        // Verify tables were actually created
        if ($createdCount > 0) {
            $verifyResult = $mysql->select("SHOW TABLES LIKE " . db_squote($targetPrefix . '_%'));
            $actualCount = count($verifyResult);
            if ($actualCount > 0) {
                msg(['type' => 'info', 'text' => "Создано таблиц: {$actualCount} (попыток: {$createdCount})"]);
            } else {
                msg(['type' => 'error', 'text' => 'Таблицы не были созданы в БД! Проверьте права доступа к базе данных.']);
                if (!empty($createdTables)) {
                    msg(['type' => 'info', 'text' => 'Попытка создать: ' . implode(', ', array_slice($createdTables, 0, 5)) . '...']);
                }
                return false; // Stop if no tables created
            }
        } else {
            msg(['type' => 'error', 'text' => 'Запросы CREATE TABLE не выполнены. Файл tables.sql может быть поврежден.']);
            return false; // Stop if no CREATE TABLE statements found
        }
        if (!empty($failedTables)) {
            msg(['type' => 'warning', 'text' => 'Ошибки создания таблиц: ' . implode(' | ', array_slice($failedTables, 0, 3)) . (count($failedTables) > 3 ? '...' : '')]);
        }
        // Copy admin user from main site
        try {
            $sourceUsersTable = $sourcePrefix . '_users';
            $targetUsersTable = $targetPrefix . '_users';
            // Get target table structure to filter fields
            $targetColumns = [];
            $columnsResult = $mysql->select("SHOW COLUMNS FROM `{$targetUsersTable}`");
            foreach ($columnsResult as $col) {
                $targetColumns[] = $col['Field'];
            }
            // Find admin user (status = 1)
            $adminResult = $mysql->select("SELECT * FROM `{$sourceUsersTable}` WHERE `status` = 1 LIMIT 1");
            if (!empty($adminResult)) {
                $admin = $adminResult[0];
                // Filter fields: only use fields that exist in target table
                $filteredAdmin = [];
                foreach ($admin as $field => $value) {
                    if (in_array($field, $targetColumns)) {
                        $filteredAdmin[$field] = $value;
                    }
                }
                if (!empty($filteredAdmin)) {
                    // Insert admin into new database
                    $fields = array_keys($filteredAdmin);
                    $values = array_map(function ($v) {
                        return db_squote($v);
                    }, array_values($filteredAdmin));
                    $insertSQL = "INSERT INTO `{$targetUsersTable}` (`" . implode('`, `', $fields) . "`) VALUES (" . implode(', ', $values) . ")";
                    $mysql->query($insertSQL);
                    msg(['type' => 'info', 'text' => "Скопирован администратор: {$admin['name']}"]);
                } else {
                    msg(['type' => 'warning', 'text' => 'Нет совместимых полей для копирования администратора']);
                }
            } else {
                msg(['type' => 'warning', 'text' => 'Администратор не найден в основной базе']);
            }
        } catch (Exception $e) {
            msg(['type' => 'warning', 'text' => 'Ошибка копирования администратора: ' . $e->getMessage()]);
        }
    } catch (Exception $e) {
        msg(['type' => 'error', 'text' => 'Ошибка создания базы данных: ' . $e->getMessage()]);
        return false;
    }
    // Create OSPanel structure for multisite domain
    if (DIRECTORY_SEPARATOR == '\\' && !empty($domainList)) {
        // Windows environment - create junction links for each domain
        $baseDir = dirname(dirname(dirname(__DIR__))); // Go up to /home/it parent
        $itPath = $baseDir;
        foreach ($domainList as $domain) {
            $domainPath = dirname($baseDir) . DIRECTORY_SEPARATOR . $domain;
            // Create junction link if not exists
            if (!file_exists($domainPath)) {
                // Using exec to create junction
                $command = 'mklink /J "' . $domainPath . '" "' . $itPath . '"';
                @exec($command, $output, $returnCode);
                if ($returnCode === 0) {
                    // Create .osp directory and project.ini
                    $ospDir = $domainPath . DIRECTORY_SEPARATOR . '.osp';
                    if (!is_dir($ospDir)) {
                        @mkdir($ospDir, 0755, true);
                    }
                    $projectIni = "[{$domain}]\n\nphp_engine = PHP-8.3\n";
                    @file_put_contents($ospDir . DIRECTORY_SEPARATOR . 'project.ini', $projectIni);
                    msg(['type' => 'info', 'text' => "Создан домен в OSPanel: {$domain}"]);
                } else {
                    msg(['type' => 'warning', 'text' => "Не удалось создать папку для домена: {$domain}"]);
                }
            }
        }
    }
    msgSticker($lang['multisite_added']);
    return true;
}
//
// Delete multisite
//
function multisiteDelete()
{
    global $lang, $multiDomainName;
    // Check permissions
    if (!checkPermission(['plugin' => '#admin', 'item' => 'configuration'], null, 'modify')) {
        msg(['type' => 'error', 'text' => $lang['perm.denied']], 1, 1);
        return false;
    }
    // Multisite management is only available on main site
    if (!empty($multiDomainName) && $multiDomainName !== 'main') {
        msg(['type' => 'error', 'text' => 'Управление мультисайтами доступно только на основном сайте.']);
        return false;
    }
    // Check for security token
    if ((!isset($_REQUEST['token'])) || ($_REQUEST['token'] != genUToken('admin.multisite'))) {
        msg(['type' => 'error', 'text' => $lang['error.security.token']]);
        return false;
    }
    $siteId = trim($_GET['site_id'] ?? '');
    // Load current multiconfig
    $multiconfig = [];
    $multimaster = 'main';
    if (is_file(confroot . 'multiconfig.php')) {
        include confroot . 'multiconfig.php';
    }
    // Ensure main site exists in multiconfig with current domain
    global $config;
    if (!isset($multiconfig['main']) || empty($multiconfig['main']['domains'])) {
        // Extract domain from config home_url
        $mainDomain = parse_url($config['home_url'], PHP_URL_HOST);
        if (!$mainDomain) {
            $mainDomain = $_SERVER['HTTP_HOST'] ?? 'localhost';
        }
        $multiconfig['main'] = [
            'domains' => [$mainDomain],
            'active' => 1
        ];
    }
    // Check if site exists
    if (!isset($multiconfig[$siteId])) {
        msg(['type' => 'error', 'text' => $lang['multisite_not_found']]);
        return false;
    }
    // Don't allow deleting master site
    if ($siteId == $multimaster) {
        msg(['type' => 'error', 'text' => $lang['multisite_cannot_delete_master']]);
        return false;
    }
    // Delete all database tables with this site's prefix
    try {
        // Load site config to get db prefix
        $siteConfigFile = confroot . 'multi/' . $siteId . '/config.php';
        if (is_file($siteConfigFile)) {
            // Read config to get prefix
            $siteConfig = [];
            include $siteConfigFile;
            $sitePrefix = $siteConfig['prefix'] ?? $siteId;
            global $mysql;
            // Get all tables with this prefix
            $result = $mysql->select("SHOW TABLES LIKE " . db_squote($sitePrefix . '_%'));
            $droppedCount = 0;
            foreach ($result as $row) {
                $tableName = reset($row);
                try {
                    $mysql->query("DROP TABLE IF EXISTS `{$tableName}`");
                    $droppedCount++;
                } catch (Exception $e) {
                    // Continue even if one table fails
                }
            }
            if ($droppedCount > 0) {
                msg(['type' => 'info', 'text' => "Удалено таблиц из БД: {$droppedCount}"]);
            }
        }
        // Delete config directory
        if (is_dir(confroot . 'multi/' . $siteId)) {
            $deleteDir = function ($dir) use (&$deleteDir) {
                if (!is_dir($dir)) return;
                $files = array_diff(scandir($dir), ['.', '..']);
                foreach ($files as $file) {
                    $path = $dir . '/' . $file;
                    is_dir($path) ? $deleteDir($path) : @unlink($path);
                }
                @rmdir($dir);
            };
            $deleteDir(confroot . 'multi/' . $siteId);
        }
    } catch (Exception $e) {
        msg(['type' => 'warning', 'text' => 'Ошибка удаления данных: ' . $e->getMessage()]);
    }
    // Remove site from config
    unset($multiconfig[$siteId]);
    // Save multiconfig.php
    $configContent = "<?php\n\n";
    $configContent .= "// Multisite configuration\n";
    $configContent .= "// Generated: " . date('Y-m-d H:i:s') . "\n\n";
    $configContent .= '$multimaster = ' . var_export($multimaster, true) . ";\n\n";
    $configContent .= '$multiconfig = ' . var_export($multiconfig, true) . ";\n";
    if (!@file_put_contents(confroot . 'multiconfig.php', $configContent)) {
        msg(['type' => 'error', 'text' => $lang['multisite_save_error']]);
        return false;
    }
    msgSticker($lang['multisite_deleted']);
    return true;
}
//
// Show multisite management page
//
function multisiteManage()
{
    global $lang, $twig, $config, $PHP_SELF, $multiDomainName;
    // Check permissions
    if (!checkPermission(['plugin' => '#admin', 'item' => 'configuration'], null, 'details')) {
        msg(['type' => 'error', 'text' => $lang['perm.denied']], 1, 1);
        return false;
    }
    // Multisite management is only available on main site
    if (!empty($multiDomainName) && $multiDomainName !== 'main') {
        msg(['type' => 'error', 'text' => 'Управление мультисайтами доступно только на основном сайте.']);
        return false;
    }
    // Load multiconfig
    $multiconfig = [];
    $multimaster = 'main';
    if (is_file(confroot . 'multiconfig.php')) {
        include confroot . 'multiconfig.php';
    }
    // Ensure main site exists in multiconfig with current domain
    if (!isset($multiconfig['main']) || empty($multiconfig['main']['domains'])) {
        // Extract domain from config home_url
        $mainDomain = parse_url($config['home_url'], PHP_URL_HOST);
        if (!$mainDomain) {
            $mainDomain = $_SERVER['HTTP_HOST'] ?? 'localhost';
        }
        $multiconfig['main'] = [
            'domains' => [$mainDomain],
            'active' => 1
        ];
        // Save updated multiconfig.php
        $configContent = "<?php\n\n";
        $configContent .= "// Multisite configuration\n";
        $configContent .= "// Generated: " . date('Y-m-d H:i:s') . "\n\n";
        $configContent .= '$multimaster = ' . var_export($multimaster, true) . ";\n\n";
        $configContent .= '$multiconfig = ' . var_export($multiconfig, true) . ";\n";
        @file_put_contents(confroot . 'multiconfig.php', $configContent);
    }
    $mConfig = [];
    if (is_array($multiconfig)) {
        foreach ($multiconfig as $k => $v) {
            $v['key'] = $k;
            $v['is_master'] = ($k == $multimaster);
            $mConfig[] = $v;
        }
    }
    $tVars = [
        'multiConfig' => $mConfig,
        'multimaster' => $multimaster,
        'token' => genUToken('admin.multisite'),
        'php_self' => $PHP_SELF,
        'lang' => $lang,
    ];
    $xt = $twig->loadTemplate('skins/' . $config['admin_skin'] . '/tpl/multisite.tpl');
    return $xt->render($tVars);
}
//
// Toggle multisite status
//
function multisiteToggle()
{
    global $lang, $multiDomainName;
    // Check permissions
    if (!checkPermission(['plugin' => '#admin', 'item' => 'configuration'], null, 'modify')) {
        msg(['type' => 'error', 'text' => $lang['perm.denied']], 1, 1);
        return false;
    }
    // Multisite management is only available on main site
    if (!empty($multiDomainName) && $multiDomainName !== 'main') {
        msg(['type' => 'error', 'text' => 'Управление мультисайтами доступно только на основном сайте.']);
        return false;
    }
    // Check for security token
    if ((!isset($_REQUEST['token'])) || ($_REQUEST['token'] != genUToken('admin.multisite'))) {
        msg(['type' => 'error', 'text' => $lang['error.security.token']]);
        return false;
    }
    $siteId = trim($_GET['site_id'] ?? '');
    // Load current multiconfig
    $multiconfig = [];
    $multimaster = 'main';
    if (is_file(confroot . 'multiconfig.php')) {
        include confroot . 'multiconfig.php';
    }
    // Ensure main site exists in multiconfig with current domain
    global $config;
    if (!isset($multiconfig['main']) || empty($multiconfig['main']['domains'])) {
        // Extract domain from config home_url
        $mainDomain = parse_url($config['home_url'], PHP_URL_HOST);
        if (!$mainDomain) {
            $mainDomain = $_SERVER['HTTP_HOST'] ?? 'localhost';
        }
        $multiconfig['main'] = [
            'domains' => [$mainDomain],
            'active' => 1
        ];
    }
    // Check if site exists
    if (!isset($multiconfig[$siteId])) {
        msg(['type' => 'error', 'text' => $lang['multisite_not_found']]);
        return false;
    }
    // Toggle active status
    $multiconfig[$siteId]['active'] = empty($multiconfig[$siteId]['active']) ? 1 : 0;
    // Save multiconfig.php
    $configContent = "<?php\n\n";
    $configContent .= "// Multisite configuration\n";
    $configContent .= "// Generated: " . date('Y-m-d H:i:s') . "\n\n";
    $configContent .= '$multimaster = ' . var_export($multimaster, true) . ";\n\n";
    $configContent .= '$multiconfig = ' . var_export($multiconfig, true) . ";\n";
    if (!@file_put_contents(confroot . 'multiconfig.php', $configContent)) {
        msg(['type' => 'error', 'text' => $lang['multisite_save_error']]);
        return false;
    }
    msgSticker($lang['multisite_toggled']);
    return true;
}
//
//
// Check if SAVE is requested and SAVE was successfull
if (isset($_REQUEST['subaction']) && ($_REQUEST['subaction'] == 'save') && ($_SERVER['REQUEST_METHOD'] == 'POST') && systemConfigSave()) {
    @include confroot . 'config.php';
    // Clear cache
    if (isset($_REQUEST['clear_cache']) && $_REQUEST['clear_cache'] == '1') {
        $cacheDir = root . 'cache/';
        if (is_dir($cacheDir)) {
            $files = glob($cacheDir . '*');
            foreach ($files as $file) {
                if (is_file($file)) {
                    @unlink($file);
                }
            }
        }
    }
    // Redirect to refresh page with new skin
    if (isset($_REQUEST['redirect']) && $_REQUEST['redirect']) {
        header('Location: ' . $_REQUEST['redirect']);
        exit;
    }
}
// Handle multisite actions
if (isset($_REQUEST['action'])) {
    switch ($_REQUEST['action']) {
        case 'multisite_manage':
            $main_admin = multisiteManage();
            break;
        case 'multisite_add':
            if ($_SERVER['REQUEST_METHOD'] == 'POST') {
                multisiteAdd();
                header('Location: admin.php?mod=configuration&action=multisite_manage');
                exit;
            }
            break;
        case 'multisite_delete':
            multisiteDelete();
            header('Location: admin.php?mod=configuration&action=multisite_manage');
            exit;
        case 'multisite_toggle':
            multisiteToggle();
            header('Location: admin.php?mod=configuration&action=multisite_manage');
            exit;
    }
}
// Show configuration form
if (!isset($main_admin)) {
    $main_admin = systemConfigEditForm();
}
