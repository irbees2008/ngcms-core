<?php

//
// Copyright (C) 2006-2015 Next Generation CMS (http://ngcms.ru/)
// Name: cmodules.php
// Description: Common CORE modules
// Author: Vitaly Ponomarev
//

// Protect against hack attempts
if (!defined('NGCMS')) {
    exit('HAL');
}

function coreActivateUser()
{
    global $lang, $config, $SYSTEM_FLAGS, $mysql, $CurrentHandler;

    $lang = LoadLang('activation', 'site');
    $SYSTEM_FLAGS['info']['title']['group'] = $lang['loc_activation'];

    $userid = $_REQUEST['userid'] ?? ($CurrentHandler['params']['userid'] ?? null);
    $code = $_REQUEST['code'] ?? ($CurrentHandler['params']['code'] ?? null);

    // Check if user exists with ID = $userid
    $uRow = $mysql->record('select * from '.prefix.'_users where id='.db_squote($userid));
    if (!empty($uRow)) {
        // User found. Check activation.
        if ($uRow['activation']) {
            if ($uRow['activation'] == $code) {
                // Yeah, activate user!
                $mysql->query('update `'.uprefix."_users` set activation = '' where id = ".db_squote($userid));

                msg(['text' => $lang['msgo_activated'], 'info' => sprintf($lang['msgi_activated'], admin_url)]);
                $SYSTEM_FLAGS['module.usermenu']['redirect'] = $config['home_url'].'/';
            } else {
                // Incorrect activation code
                msg(['text' => $lang['msge_activate'], 'info' => sprintf($lang['msgi_activate'], admin_url)]);
            }
        } else {
            // Already activated
            echo 'ALREADY';
            msg(['text' => $lang['msge_activation'], 'info' => sprintf($lang['msgi_activation'], admin_url)]);
        }
    } else {
        // User not found
        error404();
    }
}


function coreRegisterUser()
{
    global $ip, $lang, $config, $AUTH_METHOD, $SYSTEM_FLAGS, $userROW, $PFILTERS, $mysql;

    $lang = LoadLang('registration', 'site');
    $SYSTEM_FLAGS['info']['title']['group'] = $lang['loc_registration'];

    // If logged in user comes to us - REDIRECT him to main page
    if (is_array($userROW)) {
        @header('Location: '.$config['home_url']);
        return;
    }

    // Check for ban
    if ($ban_mode = checkBanned($ip, 'users', 'register', $userROW, $userROW['name'])) {
        msg(['type' => 'error', 'text' => ($ban_mode == 1) ? $lang['register.banned'] : $lang['msge_regforbid']]);
        return;
    }

    if (!$_REQUEST['type'] && $config['users_selfregister']) {
        // Receiving parameter list during registration
        $auth = $AUTH_METHOD[$config['auth_module']];
        $params = $auth->get_reg_params();
        generate_reg_page($params);
    } elseif ($_REQUEST['type'] == 'doregister' && $config['users_selfregister']) {
        // Receiving parameter list during registration
        $auth = $AUTH_METHOD[$config['auth_module']];
        $params = $auth->get_reg_params();
        $values = [];

        foreach ($params as $param) {
            $values[$param['name']] = $_POST[$param['name']] ?? null;
        }

        $msg = '';

        // Check captcha
        if ($config['use_captcha']) {
            $captcha = $_REQUEST['vcode'];
            if (!$captcha || ($_SESSION['captcha'] != $captcha)) {
                // Fail
                $msg = $lang['msge_vcode'];
            }
        }

        // Execute filters - check if user is allowed to register
        if (!$msg && is_array($PFILTERS['core.registerUser'])) {
            foreach ($PFILTERS['core.registerUser'] as $k => $v) {
                if (!$v->registerUser($params, $msg)) {
                    break;
                }
            }
        }

        // Trying register
        if (!$msg && ($uid = $auth->register($params, $values, $msg))) {
            // OK, fetch user record
            if ($uid > 1) {
                // ** COMPAT: exec action only if $uid > 1
                $urec = $mysql->record('select * from '.uprefix.'_users where id = '.intval($uid));

                // LOG: Successfully registered
                ngSYSLOG(['plugin' => 'core', 'item' => 'register'], ['action' => 'register'], $urec, [1, '']);

                // Execute filters - add additional variables
                if (is_array($urec) && is_array($PFILTERS['core.registerUser'])) {
                    foreach ($PFILTERS['core.registerUser'] as $k => $v) {
                        $v->registerUserNotify($uid, $urec);
                    }
                }
            }
        } else {
            // LOG: Registration failed
            ngSYSLOG(['plugin' => 'core', 'item' => 'register'], ['action' => 'register'], 0, [0, 'Registration failed']);

            // Fail
            generate_reg_page($params, $values, $msg);
        }
    } else {
        msg(['type' => 'error', 'text' => $lang['msge_regforbid']]);
    }
}


function generate_reg_page($params, $values = [], $msg = '')
{
    global $template, $PHP_SELF, $config, $PFILTERS, $twig, $twigLoader, $lang;

    $tVars = [
        'entries' => [],
        'flags'   => [],
    ];

    if ($msg) {
        msg(['text' => $msg]);
    }

    // Prepare variable list
    foreach ($params as $param) {
        $tRow = [
            'name'       => $param['name'],
            'title'      => $param['title'],
            'descr'      => $param['descr'],
            'error'      => '',
            'input'      => '',
            'flags'      => [],
            'type'       => $param['type'],
            'html_flags' => $param['html_flags'],
            'value'      => $param['value'],
            'values'     => $param['values'],
            'manual'     => $param['manual'],
        ];

        if (!empty($param['id'])) {
            $tRow['id'] = $param['id'];
        }

        if ($param['error']) {
            $tRow['flags']['isError'] = true;
            $tRow['error'] = str_replace('%error%', $param['error'], $lang['param_error']);
        }

        if (!empty($values[$param['name']])) {
            $tRow['value'] = $values[$param['name']];
            $param['value'] = $values[$param['name']];
        }

        $tVars['entries'][] = $tRow;
    }

    // Execute filters - add additional variables
    if (!empty($PFILTERS['core.registerUser'])) {
        foreach ($PFILTERS['core.registerUser'] as $k => $v) {
            $v->registerUserForm($tVars);
        }
    }

    // Generate inputs
foreach ($tVars['entries'] as &$param) {
    $tInput = '';

    if ($param['type'] == 'text') {
        $tInput = '<textarea ' . (isset($param['id']) && $param['id'] ? 'id="' . $param['id'] . '" ' : '') . 'name="' . $param['name'] . '" title="' . $param['title'] . '" ' . $param['html_flags'] . '>' . secure_html($param['value']) . '</textarea>';
    } elseif ($param['type'] == 'input') {
        $tInput = '<input ' . (isset($param['id']) && $param['id'] ? 'id="' . $param['id'] . '" ' : '') . 'name="' . $param['name'] . '" type="text" title="' . $param['title'] . '" ' . $param['html_flags'] . ' value="' . secure_html($param['value']) . '"/>';
    } elseif ($param['type'] == 'password' || $param['type'] == 'hidden') {
        $tInput = '<input ' . (isset($param['id']) && $param['id'] ? 'id="' . $param['id'] . '" ' : '') . 'name="' . $param['name'] . '" type="' . $param['type'] . '" title="' . $param['title'] . '" ' . $param['html_flags'] . ' value="' . secure_html($param['value']) . '"/>';
    } elseif ($param['type'] == 'select') {
        $tInput = '<select ' . (isset($param['id']) && $param['id'] ? 'id="' . $param['id'] . '" ' : '') . 'name="' . $param['name'] . '" title="' . $param['title'] . '" ' . $param['html_flags'] . '>';

        foreach ($param['values'] as $oid => $oval) {
            $tInput .= '<option value="' . $oid . '"' . ($param['value'] == $oid ? ' selected' : '') . '>' . $oval . '</option>';
        }

        $tInput .= '</select>';
    } elseif ($param['type'] == 'manual') {
        $tInput = $param['manual'];
    }

    $param['input'] = $tInput;
}

$tVars['flags']['hasCaptcha'] = $config['use_captcha'];
$tVars['form_action'] = checkLinkAvailable('core', 'registration') ?
    generateLink('core', 'registration', []) :
    generateLink('core', 'plugin', ['plugin' => 'core', 'handler' => 'registration']);

// Prepare REGEX conversion table
$conversionConfigRegex = [
    "#\[captcha\](.*?)\[/captcha\]#si" => '{% if (flags.hasCaptcha) %}$1{% endif %}',
    '#{entries}#si' => '{% for entry in entries %}{% include "registration.entries.tpl" %}{% endfor %}',
];

$conversionConfig = [
    '{form_action}' => '{{ form_action }}',
];

$conversionConfigEntries = [
    '{name}' => '{{ entry.name }}',
    '{title}' => '{{ entry.title }}',
    '{descr}' => '{{ entry.descr }}',
    '{error}' => '{{ entry.error }}',
    '{input}' => '{{ entry.input }}',
];


$twigLoader->setConversion('registration.tpl', $conversionConfig, $conversionConfigRegex);
$twigLoader->setConversion('registration.entries.tpl', $conversionConfigEntries);
$template['vars']['mainblock'] .= $twig->render('registration.tpl', $tVars);
}

function coreRestorePassword()
{
    global $lang, $userROW, $config, $AUTH_METHOD, $SYSTEM_FLAGS, $mysql, $CurrentHandler;

    $lang = LoadLang('lostpassword', 'site');
    $SYSTEM_FLAGS['info']['title']['group'] = $lang['loc_lostpass'];

    if (is_array($userROW)) {
        header('Location: '.$config['home_url']);
        return;
    }

    $userid = ($CurrentHandler['pluginName'] == 'core' && $CurrentHandler['handlerName'] == 'lostpassword') ? 
        ($CurrentHandler['params']['userid'] ?? $_REQUEST['userid']) : $_REQUEST['userid'];
    $code = ($CurrentHandler['pluginName'] == 'core' && $CurrentHandler['handlerName'] == 'lostpassword') ? 
        ($CurrentHandler['params']['code'] ?? $_REQUEST['code']) : $_REQUEST['code'];

    // Confirmation
    if ($userid && $code) {
        $auth = $AUTH_METHOD[$config['auth_module']];
        $msg = '';

        if ($auth->confirm_restorepw($msg, $userid, $code)) {
            msg(['text' => $msg]); // OK
        } else {
            msg(['type' => 'error', 'text' => $msg]); // Fail
        }
    } elseif ($_REQUEST['type'] == 'send') {
        // PROCESSING REQUEST

        // Receiving parameter list during password recovery
        $auth = $AUTH_METHOD[$config['auth_module']];
        $params = $auth->get_restorepw_params();
        $values = [];

        foreach ($params as $param) {
            $values[$param['name']] = $_POST[$param['name']];
        }

        $msg = '';

        // Check captcha
if ($config['use_captcha']) {
    $captcha = $_REQUEST['vcode'];
    if (!$captcha || ($_SESSION['captcha'] != $captcha)) {
        $msg = $lang['msge_vcode']; // Fail
    }
}

// Trying password recovery
if ($msg === '' && $auth->restorepw($params, $values, $msg)) {
    // OK
    // ...
} else {
    generate_restorepw_page($params, $values, $msg); // Fail and reloading page
}
} else {
    // DEFAULT: SHOW RESTORE PW SCREEN

    $auth = $AUTH_METHOD[$config['auth_module']];
    $params = $auth->get_restorepw_params();

    if (!is_array($params)) {
        msg(['type' => 'error', 'text' => $lang['msge_lpforbid']]);
        return;
    }

    generate_restorepw_page($params);
}

}

function generate_restorepw_page(array $params, array $values = [], string $msg = ''): void {
    global $twig, $template, $config, $lang;

    if (!empty($msg)) {
        msg(['text' => $msg]);
    }

    $entries = '';

    foreach ($params as $param) {
        $tvars = [
            'name' => $param['name'],
            'title' => $param['title'],
            'descr' => $param['descr'],
            'error' => '',
            'input' => '',
            'text' => $param['text'],
        ];

        if ($param['error']) {
            $tvars['error'] = str_replace('%error%', $param['error'], $lang['param_error']);
        }

        if ($values[$param['name']]) {
            $param['value'] = $values[$param['name']];
        }

        if ($param['type'] == 'text') {
            $tvars['input'] = '<textarea name="' . $param['name'] . '" title="' . secure_html($param['title']) . '" ' . $param['html_flags'] . '>' . secure_html($param['value']) . '</textarea>';
        } elseif (in_array($param['type'], ['input', 'password', 'hidden'], true)) {
            $tvars['input'] = '<input name="' . $param['name'] . '" type="' . (($param['type'] == 'input') ? 'text' : $param['type']) . '" title="' . secure_html($param['title']) . '" ' . $param['html_flags'] . ' value="' . secure_html($param['value']) . '" />';
        } elseif ($param['type'] == 'select') {
            $tvars['input'] = '<select name="' . $param['name'] . '" title="' . secure_html($param['title']) . '" ' . $param['html_flags'] . '>';
            foreach ($param['values'] as $oid => $oval) {
                $tvars['input'] .= '<option value="' . secure_html($oid) . '"' . ($param['value'] == $oid ? ' selected' : '') . '>' . secure_html($oval) . '</option>';
            }
            $tvars['input'] .= '</select>';
        } elseif ($param['type'] == 'manual') {
            $tvars['input'] = $param['manual'];
        }

        $entryTemplate = $param['text'] ? 'lostpassword.entry-full.tpl' : 'lostpassword.entries.tpl';
        $entries .= $twig->render($entryTemplate, $tvars);
    }

    $tvars = [
        'entries' => $entries,
        'captcha_source_url' => admin_url . '/captcha.php',
        'flags' => [
            'hasCaptcha' => false,
        ],
    ];

    if ($config['use_captcha']) {
        $_SESSION['captcha'] = rand(00000, 99999);
        $tvars['flags']['hasCaptcha'] = true;
    }

    $formActionParams = checkLinkAvailable('core', 'lostpassword') ?
        ['core', 'lostpassword', []] :
        ['core', 'plugin', ['plugin' => 'core', 'handler' => 'lostpassword']];
    $tvars['form_action'] = generateLink(...$formActionParams);

    $template['vars']['mainblock'] .= $twig->render('lostpassword.tpl', $tvars);
}


//
// Execute an action for coreLogin() function
// This is a workaround for 2-stage AUTH functions (like openID)
// Parameter: user's record [row]
function coreLoginAction($row = null, $redirect = null)
{
    global $auth, $auth_db, $username, $userROW, $is_logged, $is_logged_cookie, $SYSTEM_FLAGS, $HTTP_REFERER;
    global $twig, $template, $config, $lang, $ip;

    $lang = LoadLang('login', 'site');
    $SYSTEM_FLAGS['info']['title']['group'] = $lang['loc_login'];

    // Try to auth && check for bans
    if (is_array($row) && !checkBanned($ip, 'users', 'auth', $row, $row['name'])) {
        $auth_db->save_auth($row);
        $username = $row['name'];
        $userROW = $row;
        $is_logged_cookie = true;
        $is_logged = true;

        // LOG: Successfully logged in
        ngSYSLOG(['plugin' => 'core', 'item' => 'login'], ['action' => 'login', 'list' => ['login' => $username]], null, [1, '']);

        // Redirect back
        @header('Location: '.($redirect ? $redirect : home));
    } else {
        // LOG: Login error
        ngSYSLOG(['plugin' => 'core', 'item' => 'login'], ['action' => 'login', 'list' => ['errorInfo' => $row]], null, [0, 'Login failed.']);

        $SYSTEM_FLAGS['auth_fail'] = 1;
        $result = true;
        $is_logged_cookie = false;

        // Show login template
        $tvars = [
            'form_action' => generateLink('core', 'login'),
            'redirect' => isset($_POST['redirect']) ? $_POST['redirect'] : $HTTP_REFERER,
        ];

        if (preg_match('#^ERR:NEED.ACTIVATE#', $row, $null)) {
            $tvars['flags'] = [
                'need_activate' => true,
                'error' => false,
                'banned' => false,
            ];
        } elseif ($row == 'ERR:NOT_ENTERED') {
            $tvars['flags'] = [
                'need_activate' => false,
                'error' => false,
                'banned' => false,
            ];
        } else {
            $tvars['flags'] = [
                'need_activate' => false,
                'error' => ($ban_mode != 1),
                'banned' => ($ban_mode == 1),
            ];
        }

        $template['vars']['mainblock'] = $twig->render('login.tpl', $tvars);
    }
}


function coreLogin()
{
    global $auth, $auth_db, $username, $userROW, $is_logged, $is_logged_cookie, $SYSTEM_FLAGS, $HTTP_REFERER;
    global $template, $config, $lang, $ip;

    // If user ALREADY logged in - redirect to main page
    if (is_array($userROW)) {
        @header('Location: '.$config['home_url']);
        return;
    }

    // Determine redirect point
    $redirect = '';
    if (isset($_POST['redirect']) && $_POST['redirect']) {
        $redirect = $_POST['redirect'];
    } elseif (isset($_REQUEST['redirect_home']) && $_REQUEST['redirect_home']) {
        $redirect = $config['home_url'];
    } elseif (preg_match('#^http\:\/\/#', $HTTP_REFERER, $tmp)) {
        $redirect = $HTTP_REFERER;
    } else {
        $redirect = $config['home_url'];
    }

    // Auth can work ONLY via POST method
    if ($_SERVER['REQUEST_METHOD'] != 'POST') {
        coreLoginAction('ERR:NOT_ENTERED');
        return;
    }

    // Try to auth
    $row = $auth->login();
    coreLoginAction($row, $redirect);
}

function coreLogout()
{
    global $auth_db, $userROW, $username, $is_logged, $HTTP_REFERER, $config;

    $auth_db->drop_auth();
    @header('Location: '.(preg_match('#^http\:\/\/#', $HTTP_REFERER, $tmp) ? $HTTP_REFERER : $config['home_url']));

    unset($userROW);
    unset($username);
    $is_logged = false;
}