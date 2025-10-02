<?php
// Dev-only stubs for IDE/static analysis. NOT loaded in runtime.
// phpcs:ignoreFile
// Constants that are resolved via core/bootstrap in runtime
if (!defined('NGCMS')) define('NGCMS', true);
if (!defined('tpl_actions')) define('tpl_actions', '');
if (!defined('home')) define('home', '/');
if (!defined('skins_url')) define('skins_url', '/engine/skins/default');
if (!defined('prefix')) define('prefix', 'ng');
if (!defined('tpl_site')) define('tpl_site', '/templates/');
// Core globals
/** @var array $config */
if (!isset($config)) {
    $config = [];
}
// Function stubs
function checkPermission($a = null, $b = null, $c = null)
{
    return true;
}
function ngSYSLOG($a = null, $b = null, $c = null, $d = null) {}
function dbCheckUpgradeRequired()
{
    return false;
}
function load_extras($a = null) {}
function exec_acts($a = null) {}
function msg($a = [])
{
    return '';
}
function LoadLang($a = '', $b = '')
{
    return [];
}
function LoadPluginLibrary($a = '', $b = '') {}
function userGetAvatar($user)
{
    return [null, '/engine/skins/default/images/default-avatar.jpg'];
}
function new_pm()
{
    return '';
}
function Padeg($n, $forms)
{
    return $forms;
}
function genUToken($k)
{
    return '';
}
function pluginGetVariable($p, $k)
{
    return null;
}
function secure_html($s)
{
    return htmlspecialchars((string)$s, ENT_QUOTES, 'UTF-8');
}
function makeCategoryList($opts = [])
{
    return '<select name="' . ($opts['name'] ?? 'parent') . '"><option value="0">--</option></select>';
}
function OrderList($selected = '', $edit = false)
{
    return '<select name="orderby"><option value="0">0</option></select>';
}
function db_squote($v)
{
    return "'" . addslashes((string)$v) . "'";
}
function cacheStoreFile($name, $value)
{
    return true;
}
function category_remove()
{
    return true;
}
function admCategoryReorder()
{
    return true;
}
function admCategoryList()
{
    return '';
}
// Classes
if (!class_exists('mysql_class')) {
    class mysql_class
    {
        public function result($q)
        {
            return 0;
        }
        public function query($q)
        {
            return false;
        }
        public function num_rows($r)
        {
            return 0;
        }
        public function record($q)
        {
            return ['id' => 1];
        }
        public $query_list = [];
    }
}
if (!isset($mysql) || !($mysql instanceof mysql_class)) {
    $mysql = new mysql_class();
}
// Minimal file/image managers
if (!class_exists('file_managment')) {
    class file_managment
    {
        public function file_upload($opts)
        {
            return [1, 'file.jpg', 'path'];
        }
        public function file_delete($opts)
        {
            return true;
        }
    }
}
if (!class_exists('image_managment')) {
    class image_managment
    {
        public function get_size($path)
        {
            return [0, 200, 200];
        }
        public function create_thumb($dir, $name, $w, $h, $q)
        {
            return [100, 100];
        }
    }
}
// Parser stub
if (!isset($parse)) {
    class parse_class
    {
        public function nameCheck($s)
        {
            return true;
        }
        public function translit($s)
        {
            return strtolower(preg_replace('~[^a-z0-9]+~i', '-', (string)$s));
        }
    }
    $parse = new parse_class();
}
