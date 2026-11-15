<?php
/**
 * INSTALL.PHP MODIFICATIONS FOR SQLite SUPPORT
 * 
 * This file shows the modifications needed in install.php
 * to support SQLite selection during installation
 */

// ============================================================================
// STEP 1: Add database type selection to the form
// ============================================================================

/**
 * Modified doConfig_db function with SQLite support
 */
function doConfig_db_MODIFIED($check)
{
    global $lang, $tpl, $tvars, $sx;

    $myparams = [
        'action', 'stage', 'reg_dbtype', 
        'reg_dbhost', 'reg_dbname', 'reg_dbuser', 'reg_dbpass', 'reg_dbprefix',
        'reg_dbpath',  // NEW: SQLite database file path
        'reg_autocreate', 'reg_dbadminuser', 'reg_dbadminpass'
    ];

    $DEFAULT = [
        'reg_dbhost' => 'localhost',
        'reg_dbprefix' => 'ng',
        'reg_dbtype' => 'mysql',  // Default to MySQL
        'reg_dbpath' => 'data/database.sqlite'  // Default SQLite path
    ];

    // Process form submission
    if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['action']) && $_POST['action'] == 'install') {
        foreach ($myparams as $k) {
            $_POST[$k] = isset($_POST[$k]) ? trim($_POST[$k]) : $DEFAULT[$k] ?? '';
        }

        if (!$check) {
            // Display form
            return doConfig_db_form($DEFAULT, $_POST);
        }

        // Validate database type selection
        $dbType = $_POST['reg_dbtype'];
        
        if (!in_array($dbType, ['mysql', 'sqlite'])) {
            $tvars['vars']['error_message'] = 
                '<div class="errorDiv">Неизвестный тип базы данных</div>';
            return false;
        }

        // Validate based on database type
        if ($dbType === 'mysql') {
            return doConfig_db_mysql_validation($_POST);
        } else {
            return doConfig_db_sqlite_validation($_POST);
        }
    }

    return doConfig_db_form($DEFAULT, $_POST);
}

/**
 * Validate MySQL configuration
 */
function doConfig_db_mysql_validation($post)
{
    global $lang, $tpl, $tvars, $sx;

    $tvars['vars']['err:reg_dbtype'] = '';
    $tvars['vars']['err:reg_dbhost'] = '';
    $tvars['vars']['err:reg_dbname'] = '';
    $tvars['vars']['err:reg_dbuser'] = '';

    foreach (['reg_dbtype', 'reg_dbhost', 'reg_dbname', 'reg_dbuser'] as $k) {
        if (!strlen($post[$k])) {
            $tvars['vars']['err:' . $k] = 
                '<span style="color: red;">' . $lang['err.' . $k] . '</span>';
        }
    }

    if (strlen($tvars['vars']['err:reg_dbhost'])) {
        return false;
    }

    // Try to connect to MySQL
    try {
        $sx->set('db', new NGPDO([
            'dbtype' => 'mysql',
            'host' => $post['reg_dbhost'],
            'db' => '',  // Connect without selecting database
            'user' => $post['reg_dbadminuser'] ?: $post['reg_dbuser'],
            'pass' => $post['reg_dbadminpass'] ?: $post['reg_dbpass']
        ]));
        $mysql = $sx->getLegacyDB();
        $sqlr = $mysql->mysql_version();
        
        // Create database if needed
        if ($post['reg_autocreate']) {
            $createDbSQL = "CREATE DATABASE IF NOT EXISTS `" . 
                addslashes($post['reg_dbname']) . 
                "` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci";
            
            $sx->getDB()->query($createDbSQL);
        }

        // Reconnect to the database
        $sx->set('db', new NGPDO([
            'dbtype' => 'mysql',
            'host' => $post['reg_dbhost'],
            'db' => $post['reg_dbname'],
            'user' => $post['reg_dbuser'],
            'pass' => $post['reg_dbpass']
        ]));

        $mysql = $sx->getLegacyDB();
        $sqlr = $mysql->mysql_version();

    } catch (Exception $e) {
        $tvars['vars']['error_message'] = 
            '<div class="errorDiv">' . 
            $lang['error.dbconnect'] . ' "' . htmlspecialchars($post['reg_dbhost']) . '":<br/> (' . 
            $e->getCode() . ') ' . $e->getMessage() . 
            '</div>';
        return false;
    }

    // Save configuration
    save_mysql_config($post);
    return true;
}

/**
 * Validate SQLite configuration
 */
function doConfig_db_sqlite_validation($post)
{
    global $lang, $tpl, $tvars, $sx;

    $tvars['vars']['err:reg_dbpath'] = '';

    if (!strlen($post['reg_dbpath'])) {
        $tvars['vars']['err:reg_dbpath'] = 
            '<span style="color: red;">Путь к файлу БД не указан</span>';
        return false;
    }

    // Convert to absolute path if relative
    $dbPath = $post['reg_dbpath'];
    if (!str_starts_with($dbPath, '/') && !preg_match('/^[a-z]:/i', $dbPath)) {
        // Relative path - convert to absolute
        $dbPath = dirname(dirname(dirname(__FILE__))) . '/' . $dbPath;
    }

    // Check if directory exists and is writable
    $dbDir = dirname($dbPath);
    if (!is_dir($dbDir)) {
        if (!@mkdir($dbDir, 0755, true)) {
            $tvars['vars']['err:reg_dbpath'] = 
                '<span style="color: red;">Невозможно создать директорию для БД</span>';
            return false;
        }
    }

    if (!is_writable($dbDir)) {
        $tvars['vars']['err:reg_dbpath'] = 
            '<span style="color: red;">Директория не доступна для записи</span>';
        return false;
    }

    // Try to connect to SQLite
    try {
        $sx->set('db', new NGPDO([
            'dbtype' => 'sqlite',
            'dbpath' => $dbPath
        ]));

        // Test connection
        $result = $sx->getDB()->query('SELECT 1');
        
    } catch (Exception $e) {
        $tvars['vars']['error_message'] = 
            '<div class="errorDiv">' . 
            $lang['error.dbconnect'] . ' "' . htmlspecialchars($dbPath) . '":<br/> (' . 
            $e->getCode() . ') ' . $e->getMessage() . 
            '</div>';
        return false;
    }

    // Save configuration
    save_sqlite_config($post, $dbPath);
    return true;
}

/**
 * Save MySQL configuration
 */
function save_mysql_config($post)
{
    global $conf_data;

    $conf_data['dbtype'] = 'pdo';
    $conf_data['dbhost'] = $post['reg_dbhost'];
    $conf_data['dbname'] = $post['reg_dbname'];
    $conf_data['dbuser'] = $post['reg_dbuser'];
    $conf_data['dbpasswd'] = $post['reg_dbpass'];
    $conf_data['prefix'] = $post['reg_dbprefix'];
}

/**
 * Save SQLite configuration
 */
function save_sqlite_config($post, $dbPath)
{
    global $conf_data;

    $conf_data['dbtype'] = 'pdo';
    $conf_data['db_driver'] = 'sqlite';
    $conf_data['dbpath'] = $dbPath;
    $conf_data['prefix'] = $post['reg_dbprefix'];
}

/**
 * Display database configuration form
 */
function doConfig_db_form($default, $values)
{
    global $lang, $tpl, $tvars;

    $tvars['vars']['menu_db'] = ' class="hover"';

    // Get current database type
    $currentDbType = $values['reg_dbtype'] ?? $default['reg_dbtype'];

    // Set template variables
    $tvars['vars']['reg_dbtype_mysql_checked'] = 
        ($currentDbType === 'mysql') ? 'checked' : '';
    $tvars['vars']['reg_dbtype_sqlite_checked'] = 
        ($currentDbType === 'sqlite') ? 'checked' : '';

    $tvars['vars']['reg_dbhost'] = htmlspecialchars($values['reg_dbhost'] ?? $default['reg_dbhost']);
    $tvars['vars']['reg_dbname'] = htmlspecialchars($values['reg_dbname'] ?? '');
    $tvars['vars']['reg_dbuser'] = htmlspecialchars($values['reg_dbuser'] ?? '');
    $tvars['vars']['reg_dbpath'] = htmlspecialchars($values['reg_dbpath'] ?? $default['reg_dbpath']);
    $tvars['vars']['reg_dbprefix'] = htmlspecialchars($values['reg_dbprefix'] ?? $default['reg_dbprefix']);

    // Show/hide sections based on database type
    $tvars['vars']['mysql_section_display'] = ($currentDbType === 'mysql') ? 'block' : 'none';
    $tvars['vars']['sqlite_section_display'] = ($currentDbType === 'sqlite') ? 'block' : 'none';

    $tpl->template('config_db', $templateDir);
    $tpl->vars('config_db', $tvars);
}

// ============================================================================
// STEP 2: Add JavaScript for dynamic form switching
// ============================================================================

?>

<!-- INSTALL.TPL MODIFICATIONS -->

<script>
function switchDatabaseType() {
    var type = document.querySelector('input[name="reg_dbtype"]:checked').value;
    
    var mysqlSection = document.getElementById('mysql-config');
    var sqliteSection = document.getElementById('sqlite-config');
    
    if (type === 'mysql') {
        mysqlSection.style.display = 'block';
        sqliteSection.style.display = 'none';
        // Make MySQL fields required
        document.querySelectorAll('#mysql-config input[required]').forEach(el => {
            el.setAttribute('required', 'required');
        });
        document.querySelectorAll('#sqlite-config input[required]').forEach(el => {
            el.removeAttribute('required');
        });
    } else if (type === 'sqlite') {
        mysqlSection.style.display = 'none';
        sqliteSection.style.display = 'block';
        // Make SQLite fields required
        document.querySelectorAll('#sqlite-config input[required]').forEach(el => {
            el.setAttribute('required', 'required');
        });
        document.querySelectorAll('#mysql-config input[required]').forEach(el => {
            el.removeAttribute('required');
        });
    }
}

// Call on page load
document.addEventListener('DOMContentLoaded', switchDatabaseType);
</script>

<!-- HTML FORM -->

<form method="POST" action="?step=install">
    <input type="hidden" name="action" value="install">
    <input type="hidden" name="stage" value="db">

    <h3>Выбор типа базы данных</h3>
    
    <div class="db-type-selection">
        <label>
            <input type="radio" name="reg_dbtype" value="mysql" 
                   onchange="switchDatabaseType()" 
                   [reg_dbtype_mysql_checked]>
            MySQL (требует отдельного сервера)
        </label>
        
        <label>
            <input type="radio" name="reg_dbtype" value="sqlite" 
                   onchange="switchDatabaseType()" 
                   [reg_dbtype_sqlite_checked]>
            SQLite (автономная БД, рекомендуется для малых сайтов)
        </label>
    </div>

    <!-- MySQL Configuration -->
    <div id="mysql-config" style="display: [mysql_section_display]">
        <h4>Параметры подключения к MySQL</h4>
        
        <label>Хост: 
            <input type="text" name="reg_dbhost" value="[reg_dbhost]" required>
        </label>
        
        <label>База данных: 
            <input type="text" name="reg_dbname" value="[reg_dbname]" required>
        </label>
        
        <label>Пользователь: 
            <input type="text" name="reg_dbuser" value="[reg_dbuser]" required>
        </label>
        
        <label>Пароль: 
            <input type="password" name="reg_dbpass" value="">
        </label>
        
        <label>
            <input type="checkbox" name="reg_autocreate" value="1">
            Автоматически создать БД если её нет
        </label>
    </div>

    <!-- SQLite Configuration -->
    <div id="sqlite-config" style="display: [sqlite_section_display]">
        <h4>Параметры подключения к SQLite</h4>
        
        <label>Путь к файлу БД: 
            <input type="text" name="reg_dbpath" value="[reg_dbpath]" required>
            <small>Относительный путь от корня сайта, например: data/database.sqlite</small>
        </label>
    </div>

    <!-- Common Settings -->
    <div>
        <label>Префикс таблиц: 
            <input type="text" name="reg_dbprefix" value="[reg_dbprefix]" required>
        </label>
    </div>

    [error_message]
    
    <button type="submit">Далее</button>
</form>

<!-- LANGUAGE FILE ADDITIONS (install.ini) -->

[ru]
err.reg_dbpath = "Путь к файлу БД не указан"
info.sqlite = "SQLite - это автономная база данных, сохраняемая в виде файла. Идеальна для разработки и маленьких сайтов."
info.mysql = "MySQL - полнофункциональный сервер баз данных. Требует отдельной установки и конфигурации."

[en]
err.reg_dbpath = "Database file path is not specified"
info.sqlite = "SQLite is a standalone database saved as a file. Perfect for development and small websites."
info.mysql = "MySQL is a full-featured database server. Requires separate installation and configuration."
