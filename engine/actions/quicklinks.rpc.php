<?php
if (!defined('NGCMS')) {
    exit('HAL');
}

function quickLinksCheckAccess($params)
{
    global $userROW;
    if (!is_array($userROW) || empty($userROW['id'])) {
        return ['status' => 0, 'errorCode' => 1, 'errorText' => 'Authentication required'];
    }
    if (!is_array($params) || empty($params['token']) || $params['token'] !== genUToken('admin.quicklinks')) {
        return ['status' => 0, 'errorCode' => 2, 'errorText' => 'Invalid security token'];
    }
    return null;
}

function quickLinksStorageFile()
{
    global $userROW;
    $host = strtolower($_SERVER['HTTP_HOST'] ?? 'default');
    return root . 'conf/user_quick_links_' . (int)$userROW['id'] . '_' . md5($host) . '.php';
}

function quickLinksNormalizeUrl($value)
{
    global $config;
    if (!is_string($value) || $value === '' || $value[0] !== '/' || substr($value, 0, 2) === '//' || preg_match('/[\x00-\x1F\\\\]/', $value)) {
        return '';
    }
    $path = parse_url($value, PHP_URL_PATH);
    $adminPath = parse_url($config['admin_url'] ?? '/engine', PHP_URL_PATH) ?: '/engine';
    $adminPath = rtrim($adminPath, '/') ?: '/';
    if (!is_string($path) || !($path === $adminPath || strpos($path, rtrim($adminPath, '/') . '/') === 0) || preg_match('#/rpc\.php$#i', $path)) {
        return '';
    }
    return substr($value, 0, 2048);
}

function quickLinksReadStored()
{
    $file = quickLinksStorageFile();
    if (!is_file($file)) {
        return ['items' => [], 'pending' => []];
    }
    $contents = @file_get_contents($file);
    $marker = "__halt_compiler();\n";
    $markerPosition = is_string($contents) ? strpos($contents, $marker) : false;
    $json = ($markerPosition === false) ? false : substr($contents, $markerPosition + strlen($marker));
    $data = is_string($json) ? json_decode($json, true) : null;
    return is_array($data) ? [
        'items' => is_array($data['items'] ?? null) ? $data['items'] : [],
        'pending' => is_array($data['pending'] ?? null) ? $data['pending'] : [],
    ] : ['items' => [], 'pending' => []];
}

function quickLinksNormalizeState($params)
{
    $items = [];
    $sourceItems = is_array($params['items'] ?? null) ? $params['items'] : [];
    foreach ($sourceItems as $item) {
        if (!is_array($item) || count($items) >= 20) {
            continue;
        }
        $url = quickLinksNormalizeUrl($item['url'] ?? '');
        $title = trim(strip_tags((string)($item['title'] ?? '')));
        if ($url === '' || $title === '') {
            continue;
        }
        $items[] = [
            'url' => $url,
            'title' => mb_substr($title, 0, 80),
            'visits' => max(0, min(1000000000, (int)($item['visits'] ?? 0))),
            'updated' => max(0, (int)($item['updated'] ?? 0)),
            'manual' => !empty($item['manual']),
        ];
    }

    $pending = [];
    $sourcePending = is_array($params['pending'] ?? null) ? $params['pending'] : [];
    foreach ($sourcePending as $url => $entry) {
        if (!is_array($entry) || count($pending) >= 100) {
            continue;
        }
        $url = quickLinksNormalizeUrl((string)$url);
        $title = trim(strip_tags((string)($entry['title'] ?? '')));
        if ($url === '' || $title === '') {
            continue;
        }
        $pending[$url] = [
            'title' => mb_substr($title, 0, 80),
            'visits' => max(0, min(1000000000, (int)($entry['visits'] ?? 0))),
            'updated' => max(0, (int)($entry['updated'] ?? 0)),
        ];
    }
    return ['items' => $items, 'pending' => $pending];
}

function admQuickLinksGet($params)
{
    if ($error = quickLinksCheckAccess($params)) {
        return $error;
    }
    $stored = quickLinksReadStored();
    $state = quickLinksNormalizeState($stored);
    return ['status' => 1, 'errorCode' => 0, 'errorText' => 'OK', 'items' => $state['items'], 'pending' => $state['pending']];
}

function admQuickLinksSave($params)
{
    if ($error = quickLinksCheckAccess($params)) {
        return $error;
    }
    $state = quickLinksNormalizeState($params);
    $json = json_encode($state, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    $fileContents = "<?php\nif (!defined('NGCMS')) { exit('HAL'); }\n__halt_compiler();\n" . $json;
    if (!is_string($json) || @file_put_contents(quickLinksStorageFile(), $fileContents, LOCK_EX) === false) {
        return ['status' => 0, 'errorCode' => 3, 'errorText' => 'Could not save quick links'];
    }
    return ['status' => 1, 'errorCode' => 0, 'errorText' => 'OK'];
}

if (function_exists('rpcRegisterAdminFunction')) {
    rpcRegisterAdminFunction('admin.quicklinks.get', 'admQuickLinksGet');
    rpcRegisterAdminFunction('admin.quicklinks.save', 'admQuickLinksSave');
}
