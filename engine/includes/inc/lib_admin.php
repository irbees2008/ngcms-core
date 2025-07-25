<?php

//
// Copyright (C) 2006-2014 Next Generation CMS (http://ngcms.ru/)
// Name: lib_admin.php
// Description: General function for site administration calls
// Author: Vitaly Ponomarev
//

//
// Mass news flags modifier
// $list		- array with news identities [only 1 field should be filled]
//		'id'	- list of IDs
//		'data'	- list of records (result of SELECT query from DB)
// $setValue	- what to change in table (array with field => value)
// $permCheck	- flag if permissions should be checked (0 - don't check, 1 - check if current user have required rights)
//
// Return value: number of successfully updated news
//
function massModifyNews($list, $setValue, $permCheck = true)
{
    global $mysql, $lang, $PFILTERS, $catmap, $userROW;

    // Check if we have anything to update
    if (!is_array($list)) {
        return -1;
    }

    // Check for security token
    if ($permCheck && ((!isset($_REQUEST['token'])) || ($_REQUEST['token'] != genUToken('admin.news.edit')))) {
        msg(['type' => 'error', 'text' => $lang['error.security.token'], 'info' => $lang['error.security.token#desc']]);

        return -1;
    }

    // Load permissions
    $perm = checkPermission(['plugin' => '#admin', 'item' => 'news'], null, [
        'personal.modify',
        'personal.modify.published',
        'personal.publish',
        'personal.unpublish',
        'personal.delete',
        'personal.delete.published',
        'personal.mainpage',
        'personal.pinned',
        'personal.customdate',
        'other.view',
        'other.modify',
        'other.modify.published',
        'other.publish',
        'other.unpublish',
        'other.delete',
        'other.delete.published',
        'other.html',
        'other.mainpage',
        'other.pinned',
        'other.customdate',
    ]);

    $nList = [];
    $nData = [];

    $results = [];
    $recList = [];

    if (isset($list['data'])) {
        $recList = $list['data'];
    } elseif (isset($list['id'])) {
        $SNQ = [];
        foreach ($list['id'] as $id) {
            $SNQ[] = db_squote($id);
        }

        $recList = $mysql->select('select * from ' . prefix . '_news where id in (' . implode(', ', $SNQ) . ')');
    } else {
        return [];
    }

    // Scan RECORDS and prepare output
    foreach ($recList as $rec) {
        // SKIP records if user has not enougt permissions
        if ($permCheck) {
            $isOwn = ($rec['author_id'] == $userROW['id']) ? 1 : 0;
            $permGroupMode = $isOwn ? 'personal' : 'other';

            // Manage `PUBLISHED` field
            $ic = 0;
            if (isset($setValue['approve'])) {
                if ((($rec['approve'] == 1) && ($setValue['approve'] != 1) && (!$perm[$permGroupMode . '.unpublish'])) ||
                    (($rec['approve'] < 1) && ($setValue['approve'] == 1) && (!$perm[$permGroupMode . '.publish']))
                ) {
                    $results[] = '#' . $rec['id'] . ' (' . secure_html($rec['title']) . ') - ' . $lang['perm.denied'];
                    continue;
                }
                $ic++;
            }

            // Manage `MAINPAGE` flag
            if (isset($setValue['mainpage'])) {
                if (!$perm[$permGroupMode . '.mainpage']) {
                    $results[] = '#' . $rec['id'] . ' (' . secure_html($rec['title']) . ') - ' . $lang['perm.denied'];
                    continue;
                }
                $ic++;
            }

            // Check if we have other options except MAINPAGE/APPROVE
            if (count($setValue) > $ic) {
                if (!$perm[$permGroupMode . '.modify' . (($rec['approve'] == 1) ? '.published' : '')]) {
                    $results[] = '#' . $rec['id'] . ' (' . secure_html($rec['title']) . ') - ' . $lang['perm.denied'];
                    continue;
                }
            }

            //			if (($rec['status'] > 1) && ($rec['author_id'] != $userROW['id']))
            //				continue;
        }
        $results[] = '#' . $rec['id'] . ' (' . secure_html($rec['title']) . ') - Ok';

        $nList[] = $rec['id'];
        $nData[$rec['id']] = $rec;
    }

    if (!count($nList)) {
        return $results;
    }

    // Convert $setValue into SQL string
    $sqllSET = [];
    foreach ($setValue as $k => $v) {
        $sqllSET[] = $k . ' = ' . db_squote($v);
    }

    $sqlSET = implode(', ', $sqllSET);

    // Call plugin filters
    if (is_array($PFILTERS['news'])) {
        foreach ($PFILTERS['news'] as $k => $v) {
            $v->massModifyNews($nList, $setValue, $nData);
        }
    }

    $mysql->query('UPDATE ' . prefix . "_news SET $sqlSET WHERE id in (" . implode(', ', $nList) . ')');

    // Some activity if we change APPROVE flag for news
    if (isset($setValue['approve'])) {
        // Update user's news counters
        foreach ($nData as $nid => $ndata) {
            if (($ndata['approve'] == 1) && ($setValue['approve'] != 1)) {
                $mysql->query('update ' . uprefix . '_users set news=news-1 where id = ' . intval($ndata['author_id']));
            } elseif (($ndata['approve'] != 1) && ($setValue['approve'] == 1)) {
                $mysql->query('update ' . uprefix . '_users set news=news+1 where id = ' . intval($ndata['author_id']));
            }
        }

        // DeApprove news
        if ($setValue['approve'] < 1) {
            // Count categories & counters to decrease - we have this news currently in _news_map because this news are marked as published
            foreach ($mysql->select('select categoryID, count(newsID) as cnt from ' . prefix . '_news_map where newsID in (' . implode(', ', $nList) . ') and categoryID > 0 group by categoryID') as $crec) {
                $mysql->query('update ' . prefix . '_category set posts=posts-' . intval($crec['cnt']) . ' where id = ' . intval($crec['categoryID']));
            }

            // Delete news map
            $mysql->query('delete from ' . prefix . '_news_map where newsID in (' . implode(', ', $nList) . ')');
        } elseif ($setValue['approve'] == 1) {
            // Approve news
            $clist = [];
            foreach ($nData as $nr) {
                // Skip already published news
                if ($nr['approve'] == 1) {
                    continue;
                }

                // Calculate list
                $ncats = 0;
                foreach (explode(',', $nr['catid']) as $cid) {
                    if (!isset($catmap[$cid])) {
                        continue;
                    }
                    $clist[$cid]++;
                    $ncats++;
                    $mysql->query('insert into ' . prefix . '_news_map (newsID, categoryID, dt) values (' . intval($nr['id']) . ', ' . intval($cid) . ', from_unixtime(' . (($nr['editdate'] > $nr['postdate']) ? $nr['editdate'] : $nr['postdate']) . '))');
                }
                // Also put news without category into special category with ID = 0
                if (!$ncats) {
                    $mysql->query('insert into ' . prefix . '_news_map (newsID, categoryID, dt) values (' . intval($nr['id']) . ', 0, from_unixtime(' . (($nr['editdate'] > $nr['postdate']) ? $nr['editdate'] : $nr['postdate']) . '))');
                }
            }
            foreach ($clist as $cid => $cv) {
                $mysql->query('update ' . prefix . '_category set posts=posts+' . intval($cv) . ' where id = ' . intval($cid));
            }
        }
    }

    // Call plugin filters [ NOTIFY ABOUT MODIFICATION ]
    if (is_array($PFILTERS['news'])) {
        foreach ($PFILTERS['news'] as $k => $v) {
            $v->massModifyNewsNotify($nList, $setValue, $nData);
        }
    }

    //return count($nList);
    return $results;
}

//
// Mass news delete function
// $list		- array with news identities
// $permCheck	- flag if permissions should be checked (0 - don't check, 1 - check if current user have required rights)
//
// Return value: number of successfully updated news
//
function massDeleteNews($list, $permCheck = true)
{
    global $mysql, $lang, $PFILTERS, $userROW;

    $selected_news = $_REQUEST['selected_news'];

    // Check for security token
    if ($permCheck && (!isset($_REQUEST['token'])) || ($_REQUEST['token'] != genUToken('admin.news.edit'))) {
        msg(['type' => 'error', 'text' => $lang['error.security.token'], 'info' => $lang['error.security.token#desc']]);

        return;
    }

    if ((!is_array($list)) || (!count($list))) {
        msg(['type' => 'error', 'text' => $lang['msge_selectnews'], 'info' => $lang['msgi_selectnews']]);

        return;
    }

    // Load permissions
    $perm = checkPermission(['plugin' => '#admin', 'item' => 'news'], null, [
        'personal.delete',
        'personal.delete.published',
        'other.delete',
        'other.delete.published',
    ]);

    $results = [];

    // Scan list of news to be deleted
    foreach ($list as $id) {
        // Fetch news
        if (!is_array($nrow = $mysql->record('select * from ' . prefix . '_news where id = ' . db_squote($id)))) {
            // Skip ID's of non-existent news
            continue;
        }

        // Check for permissions
        $isOwn = ($nrow['author_id'] == $userROW['id']) ? 1 : 0;
        $permGroupMode = $isOwn ? 'personal' : 'other';

        if ((!$perm[$permGroupMode . '.delete' . (($nrow['approve'] == 1) ? '.published' : '')]) && $permCheck) {
            $results[] = '#' . $nrow['id'] . ' (' . secure_html($nrow['title']) . ') - ' . $lang['perm.denied'];
            continue;
        }

        if (is_array($PFILTERS['news'])) {
            foreach ($PFILTERS['news'] as $k => $v) {
                $v->deleteNews($nrow['id'], $nrow);
            }
        }

        // Update counters only if news is published
        if ($nrow['approve'] == 1) {
            if ($nrow['catid']) {
                $oldcatsql = [];
                foreach (explode(',', $nrow['catid']) as $key) {
                    $oldcatsql[] = 'id = ' . db_squote($key);
                }
                $mysql->query('update ' . prefix . '_category set posts=posts-1 where ' . implode(' or ', $oldcatsql));
            }

            // Update user's posts counter
            if ($nrow['author_id']) {
                $mysql->query('update ' . uprefix . '_users set news=news-1 where id=' . $nrow['author_id']);
            }
        }

        // Delete comments (with updating user's comment counter) [ if plugin comments is installed ]
        if (getPluginStatusInstalled('comments')) {
            foreach ($mysql->select('select * from ' . prefix . '_comments where post=' . $nrow['id']) as $crow) {
                if ($nrow['author_id']) {
                    $mysql->query('update ' . uprefix . '_users set com=com-1 where id=' . $crow['author_id']);
                }
            }
            $mysql->query('delete from ' . prefix . '_comments WHERE post=' . db_squote($nrow['id']));
        }

        $mysql->query('delete from ' . prefix . '_news where id=' . db_squote($nrow['id']));
        $mysql->query('delete from ' . prefix . '_news_map where newsID = ' . db_squote($nrow['id']));

        // Notify plugins about news deletion
        if (is_array($PFILTERS['news'])) {
            foreach ($PFILTERS['news'] as $k => $v) {
                $v->deleteNewsNotify($nrow['id'], $nrow);
            }
        }

        // Delete attached news/files if any
        $fmanager = new file_managment();
        // ** Files
        foreach ($mysql->select('select * from ' . prefix . '_files where (storage=1) and (linked_ds=1) and (linked_id=' . db_squote($nrow['id']) . ')') as $frec) {
            $fmanager->file_delete(['type' => 'file', 'id' => $frec['id']]);
        }

        // ** Images
        foreach ($mysql->select('select * from ' . prefix . '_images where (storage=1) and (linked_ds=1) and (linked_id=' . db_squote($nrow['id']) . ')') as $frec) {
            $fmanager->file_delete(['type' => 'image', 'id' => $frec['id']]);
        }

        $results[] = '#' . $nrow['id'] . ' (' . secure_html($nrow['title']) . ') - Ok';
    }
    msg(['text' => $lang['editnews']['msgo_deleted'], 'info' => implode("<br/>\n", $results)]);
}

// Generate backup for table list. If no list is given - backup ALL tables with system prefix
function dbBackup($fname, $gzmode, $tlist = '')
{
    $db = NGEngine::getInstance()->getDB();

    if ($gzmode && (!function_exists('gzopen'))) {
        $gzmode = 0;
    }

    if ($gzmode) {
        $fh = gzopen($fname, 'w');
    } else {
        $fh = fopen($fname, 'w');
    }

    if ($fh === false) {
        return 0;
    }

    // Generate a list of tables for backup
    if (!is_array($tlist)) {
        $tlist = [];

        foreach ($db->query('show tables like :profile', ['profile' => prefix . '_%']) as $tn) {
            $tlist[] = array_pop(array_values($tn));
        }
    }

    // Now make a header
    $out = '# ' . str_repeat('=', 60) . "\n# Backup file for `Next Generation CMS`\n# " . str_repeat('=', 60) . "\n# DATE: " . gmdate('d-m-Y H:i:s', time()) . " GMT\n# VERSION: " . engineVersion . "\n#\n";
    $out .= '# List of tables for backup: ' . implode(', ', $tlist) . "\n#\n";

    // Write a header
    if ($gzmode) {
        gzwrite($fh, $out);
    } else {
        fwrite($fh, $out);
    }

    // Now, let's scan tables
    foreach ($tlist as $tname) {
        // Fetch create syntax for table and after - write table's content
        if (is_array($csql = $db->record('show create table `' . $tname . '`'))) {
            $out = "\n#\n# Table `" . $tname . "`\n#\n";
            $out .= 'DROP TABLE IF EXISTS `' . $tname . "`;\n";
            $out .= array_pop(array_values($csql)) . ";\n";

            if ($gzmode) {
                gzwrite($fh, $out);
            } else {
                fwrite($fh, $out);
            }

            $start = 0;
            $rowNo = 0;
            do {
                $cursor = $db->createCursor('select * from `' . $tname . '` limit ' . $start . ', 10000');
                $qRowCount = 0;
                $start += 10000;

                while ($row = $db->fetchCursor($cursor)) {
                    $qRowCount++;
                    $out = 'insert into `' . $tname . '` values (';
                    $rowNo++;
                    $colNo = 0;
                    foreach ($row as $v) {
                        $out .= (($colNo++) ? ', ' : '') . db_squote($v);
                    }
                    $out .= ");\n";

                    if ($gzmode) {
                        gzwrite($fh, $out);
                    } else {
                        fwrite($fh, $out);
                    }
                }
            } while ($qRowCount > 0);

            $out = "# Total records: $rowNo\n";

            if ($gzmode) {
                gzwrite($fh, $out);
            } else {
                fwrite($fh, $out);
            }
        } else {
            $out = "#% Error fetching information for table `$tname`\n";

            if ($gzmode) {
                gzwrite($fh, $out);
            } else {
                fwrite($fh, $out);
            }
        }
    }
    if ($gzmode) {
        gzclose($fh);
    } else {
        fclose($fh);
    }

    return 1;
}

// ======================================================================================================
// Add news
// ======================================================================================================
// $mode - calling mode
//	*	'no.meta'	- disable metatags
//	*	'no.files'	- disable files
//	*	'no.token'	- do not check for security token
//	*	'no.editurl'	- do now show URL (in admin panel) for edit news
function addNews($mode = [])
{
    global $mysql, $lang, $userROW, $parse, $PFILTERS, $config, $catz, $catmap;

    // Load required library
    @include_once root . 'includes/classes/upload.class.php';

    // Check for security token
    if ((!isset($mode['no.token']) || (!$mode['no.token'])) && ((!isset($_REQUEST['token'])) || ($_REQUEST['token'] != genUToken('admin.news.add')))) {
        msg(['type' => 'error', 'text' => $lang['error.security.token'], 'info' => $lang['error.security.token#desc']]);

        return;
    }

    // Load permissions
    $perm = checkPermission(['plugin' => '#admin', 'item' => 'news'], null, [
        'add',
        'add.approve',
        'add.mainpage',
        'add.pinned',
        'add.favorite',
        'add.html',
        'personal.view',
        'personal.modify',
        'personal.modify.published',
        'personal.publish',
        'personal.unpublish',
        'personal.delete',
        'personal.delete.published',
        'personal.html',
        'personal.mainpage',
        'personal.pinned',
        'personal.catpinned',
        'personal.favorite',
        'personal.setviews',
        'personal.multicat',
        'personal.nocat',
        'personal.customdate',
        'personal.altname',
    ]);

    // Check permissions
    if (!$perm['add']) {
        msg(['type' => 'error', 'text' => $lang['perm.denied']]);

        return 0;
    }

    $title = $_REQUEST['title'];

    // Fill content
    $content = '';

    // Check if EDITOR SPLIT feature is activated
    if ($config['news.edit.split']) {
        // Prepare delimiter
        $ed = '<!--more-->';
        if ($config['extended_more'] && ($_REQUEST['content_delimiter'] != '')) {
            // Disable `new line` + protect from XSS
            $ed = '<!--more="' . str_replace(["\r", "\n", '"'], '', $_REQUEST['content_delimiter']) . '"-->';
        }
        $content = $_REQUEST['ng_news_content_short'] . (($_REQUEST['ng_news_content_full'] != '') ? $ed . $_REQUEST['ng_news_content_full'] : '');
    } else {
        $content = $_REQUEST['ng_news_content'];
    }

    // Rewrite `\r\n` to `\n`
    $content = str_replace("\r\n", "\n", $content);

    // Check title
    if ((!mb_strlen(trim($title))) || ((!mb_strlen(trim($content))) && (!$config['news_without_content']))) {
        msg(['type' => 'error', 'text' => $lang['addnews']['msge_fields'], 'info' => $lang['addnews']['msgi_fields']]);

        return 0;
    }

    $SQL['title'] = $title;

    // Check for dup if alt_name is specified
    $alt_name = ($perm['personal.altname'] && isset($_REQUEST['alt_name'])) ? $parse->translit(trim($_REQUEST['alt_name']), 1) : '';

    if ($alt_name) {
        if (is_array($mysql->record('select id from ' . prefix . '_news where alt_name = ' . db_squote($alt_name) . ' limit 1'))) {
            msg(['type' => 'error', 'text' => $lang['addnews']['msge_alt_name'], 'info' => $lang['addnews']['msgi_alt_name']]);

            return 0;
        }
        $SQL['alt_name'] = $alt_name;
    } else {
        // Generate uniq alt_name if no alt_name specified
        $alt_name = mb_strtolower($parse->translit(trim($title), 1));
        // Make a conversion:
        // * '.'  to '_'
        // * '__' to '_' (several to one)
        // * Delete leading/finishing '_'
        $alt_name = preg_replace(['/\./', '/(_{2,20})/', '/^(_+)/', '/(_+)$/'], ['_', '_'], $alt_name);

        // Make alt_name equal to '_' if it appear to be blank after conversion
        if ($alt_name == '') {
            $alt_name = '_';
        }

        $i = '';
        while (is_array($mysql->record('select id from ' . prefix . '_news where alt_name = ' . db_squote($alt_name . $i) . ' limit 1'))) {
            $i++;
        }
        $SQL['alt_name'] = $alt_name . $i;
    }

    // Custom date[ only while adding via admin panel ]
    if (isset($_REQUEST['customdate']) && $_REQUEST['customdate'] && $perm['personal.customdate']) {
        if (preg_match('#^(\d+)\.(\d+)\.(\d+) +(\d+)\:(\d+)$#', $_REQUEST['cdate'], $m)) {
            $SQL['postdate'] = mktime($m[4], $m[5], 0, $m[2], $m[1], $m[3]) + ($config['date_adjust'] * 60);
        }

        //$SQL['postdate'] = mktime(intval($_REQUEST['c_hour']), intval($_REQUEST['c_minute']), 0, intval($_REQUEST['c_month']), intval($_REQUEST['c_day']), intval($_REQUEST['c_year'])) + ($config['date_adjust'] * 60);
    } else {
        $SQL['postdate'] = time() + ($config['date_adjust'] * 60);
    }

    $SQL['editdate'] = $SQL['postdate'];

    // Fetch MASTER provided categories
    $catids = [];
    if (intval($_POST['category']) && isset($catmap[intval($_POST['category'])])) {
        $catids[intval($_POST['category'])] = 1;
    }

    // Fetch ADDITIONAL provided categories [if allowed]
    if ($perm['personal.multicat']) {
        foreach ($_POST as $k => $v) {
            if (preg_match('#^category_(\d+)$#', $k, $match) && $v && isset($catmap[intval($match[1])])) {
                $catids[$match[1]] = 1;
            }
        }
    }

    // Check if no categories specified and user can post news without categories
    if ((!count($catids)) && (!$perm['personal.nocat'])) {
        msg(['type' => 'error', 'text' => $lang['addnews']['error.nocat'], 'info' => $lang['addnews']['error.nocat#desc']]);

        return 0;
    }

    // Metatags (only for adding via admin panel)
    if ($config['meta'] && (!isset($mode['no.meta']) || !$mode['no.meta'])) {
        $SQL['description'] = isset($_REQUEST['description']) ? $_REQUEST['description'] : '';
        $SQL['keywords'] = isset($_REQUEST['keywords']) ? $_REQUEST['keywords'] : ''; 
    } else {
        $SQL['description'] = '';
        $SQL['keywords'] = ''; 
    }
    $SQL['author'] = $userROW['name'];
    $SQL['author_id'] = $userROW['id'];
    $SQL['catid'] = implode(',', array_keys($catids));

    // Variable FLAGS is a bit-variable:
    // 0 = RAW mode		[if set, no conversion "\n" => "<br />" will be done]
    // 1 = HTML enable	[if set, HTML codes may be used in news]

    if ($perm['personal.html']) {
        $SQL['flags'] = ($_REQUEST['flag_RAW'] ? 1 : 0) + ($_REQUEST['flag_HTML'] ? 2 : 0);
    } else {
        $SQL['flags'] = 0;
    }

    $SQL['mainpage'] = intval(intval($_REQUEST['mainpage']) && $perm['personal.mainpage']);
    $SQL['favorite'] = intval(intval($_REQUEST['favorite']) && $perm['personal.favorite']);
    $SQL['pinned'] = intval(intval($_REQUEST['pinned']) && $perm['personal.pinned']);
    $SQL['catpinned'] = intval(intval($_REQUEST['catpinned']) && $perm['personal.catpinned']);

    switch (intval($_REQUEST['approve'])) {
        case -1:
            $SQL['approve'] = -1;
            break;
        case 0:
            $SQL['approve'] = 0;
            break;
        case 1:
            $SQL['approve'] = $perm['personal.publish'] ? 1 : 0;
            break;
        default:
            $SQL['approve'] = 0;
    }

    $SQL['content'] = $content;

    if (intval($mysql->result('SELECT LAST_INSERT_ID() as id')) == 0) {
        $row = $mysql->record('SELECT id,approve,alt_name,catid  FROM ' . prefix . '_news WHERE title=' . db_squote($title) . ' AND content=' . db_squote($content) . '');
        if ($row['id']) {
            msg(['type' => 'error', 'text' => $lang['addnews']['msgi_news_error']]);
            return 0;
        }
    }

    // Dummy parameter for API call
    $tvars = [];

    exec_acts('addnews');

    $pluginNoError = 1;
    if (is_array($PFILTERS['news'])) {
        foreach ($PFILTERS['news'] as $k => $v) {
            if (!($pluginNoError = $v->addNews($tvars, $SQL))) {
                msg(['type' => 'error', 'text' => str_replace('{plugin}', $k, $lang['addnews']['msge_pluginlock'])]);
                break;
            }
        }
    }

    if (!$pluginNoError) {
        return 0;
    }

    $vnames = [];
    $vparams = [];
    foreach ($SQL as $k => $v) {
        $vnames[] = $k;
        $vparams[] = db_squote($v);
    }

    $mysql->query('insert into ' . prefix . '_news (' . implode(',', $vnames) . ') values (' . implode(',', $vparams) . ')');
    $id = $mysql->result('SELECT LAST_INSERT_ID() as id');

    // Update category / user posts counter [ ONLY if news is approved ]
    if ($SQL['approve'] == 1) {
        if (count($catids)) {
            $mysql->query('update ' . prefix . '_category set posts=posts+1 where id in (' . implode(', ', array_keys($catids)) . ')');
            foreach (array_keys($catids) as $catid) {
                $mysql->query('insert into ' . prefix . '_news_map (newsID, categoryID, dt) values (' . db_squote($id) . ', ' . db_squote($catid) . ', now())');
            }
        } else {
            $mysql->query('insert into ' . prefix . '_news_map (newsID, categoryID, dt) values (' . db_squote($id) . ', 0, now())');
        }

        $mysql->query('update ' . uprefix . '_users set news=news+1 where id=' . $SQL['author_id']);
    }

    // Attaches are available only for admin panel
    if (!$mode['no.files']) {

        // Now let's manage attached files
        $fmanager = new file_managment();

        $flagUpdateAttachCount = false;

        // Delete files (if needed)
        foreach ($_POST as $k => $v) {
            if (preg_match('#^delfile_(\d+)$#', $k, $match)) {
                $fmanager->file_delete(['type' => 'file', 'id' => $match[1]]);
                $flagUpdateAttachCount = true;
            }
        }

        //print "<pre>".var_export($_FILES, true)."</pre>";
        // PREPARE a list for upload
        if (is_array($_FILES['userfile']['name'])) {
            foreach ($_FILES['userfile']['name'] as $i => $v) {
                if ($v == '') {
                    continue;
                }

                $flagUpdateAttachCount = true;
                //
                $up = $fmanager->file_upload(['dsn' => true, 'linked_ds' => 1, 'linked_id' => $id, 'type' => 'file', 'http_var' => 'userfile', 'http_varnum' => $i]);
                //print "OUT: <pre>".var_export($up, true)."</pre>";
                if (!is_array($up)) {
                    // Error uploading file
                    // ... show error message ...
                }
            }
        }
    }

    // Notify plugins about adding new news
    if (is_array($PFILTERS['news'])) {
        foreach ($PFILTERS['news'] as $k => $v) {
            $v->addNewsNotify($tvars, $SQL, $id);
        }
    }

    // Update attach count if we need this
    $numFiles = $mysql->result('select count(*) as cnt from ' . prefix . '_files where (storage=1) and (linked_ds=1) and (linked_id=' . db_squote($id) . ')');
    if ($numFiles) {
        $mysql->query('update ' . prefix . '_news set num_files = ' . intval($numFiles) . ' where id = ' . db_squote($id));
    }

    $numImages = $mysql->result('select count(*) as cnt from ' . prefix . '_images where (storage=1) and (linked_ds=1) and (linked_id=' . db_squote($id) . ')');
    if ($numImages) {
        $mysql->query('update ' . prefix . '_news set num_images = ' . intval($numImages) . ' where id = ' . db_squote($id));
    }

    exec_acts('addnews_', $id);

    $msgInfo = ['text' => $lang['addnews']['msgo_added']];
    if (!$mode['no.editurl']) {
        $msgInfo['info'] = sprintf($lang['addnews']['msgi_added'], admin_url . '/admin.php?mod=news&action=edit&id=' . $id, admin_url . '/admin.php?mod=news');
    }
    msg($msgInfo);

    return 1;
}

// ======================================================================================================
// Edit news
// ======================================================================================================
// $mode - calling mode [ we can disable processing of some features/functions ]
//	*	'no.meta'	- disable changing metatags
//	*	'no.files'	- disable updating files
//	*	'no.token'	- do not check for security token
function editNews($mode = [])
{
    global $lang, $parse, $mysql, $config, $PFILTERS, $userROW, $catmap;

    // Load permissions
    $perm = checkPermission(['plugin' => '#admin', 'item' => 'news'], null, [
        'personal.view',
        'personal.modify',
        'personal.modify.published',
        'personal.publish',
        'personal.unpublish',
        'personal.delete',
        'personal.delete.published',
        'personal.html',
        'personal.mainpage',
        'personal.pinned',
        'personal.catpinned',
        'personal.favorite',
        'personal.setviews',
        'personal.multicat',
        'personal.nocat',
        'personal.customdate',
        'personal.altname',
        'other.view',
        'other.modify',
        'other.modify.published',
        'other.publish',
        'other.unpublish',
        'other.delete',
        'other.delete.published',
        'other.html',
        'other.mainpage',
        'other.pinned',
        'other.catpinned',
        'other.favorite',
        'other.setviews',
        'other.multicat',
        'other.nocat',
        'other.customdate',
        'other.altname',
    ]);

    $id = $_REQUEST['id'];

    // Check for security token
    if ((!isset($mode['no.token']) || (!$mode['no.token'])) && ((!isset($_REQUEST['token'])) || ($_REQUEST['token'] != genUToken('admin.news.edit')))) {
        msg(['type' => 'error', 'text' => $lang['error.security.token'], 'info' => $lang['error.security.token#desc']]);

        return;
    }

    // Try to find news that we're trying to edit
    if (!is_array($row = $mysql->record('select * from ' . prefix . '_news where id=' . db_squote($id)))) {
        msg(['type' => 'error', 'text' => $lang['editnews']['msge_not_found']]);

        return;
    }

    $isOwn = ($row['author_id'] == $userROW['id']) ? 1 : 0;
    $permGroupMode = $isOwn ? 'personal' : 'other';

    // Check permissions
    if (!$perm[$permGroupMode . '.modify' . (($row['approve'] == 1) ? '.published' : '')]) {
        msg(['type' => 'error', 'text' => $lang['perm.denied']]);

        return;
    }

    // Variable FLAGS is a bit-variable:
    // 0 = RAW mode		[if set, no conversion "\n" => "<br />" will be done]
    // 1 = HTML enable	[if set, HTML codes may be used in news]
    $SQL = [];

    $SQL['flags'] = ($perm[$permGroupMode . '.html']) ? (($_REQUEST['flag_RAW'] ? 1 : 0) + ($_REQUEST['flag_HTML'] ? 2 : 0)) : 0;

    $title = $_REQUEST['title'];

    // Fill content
    $content = '';

    // Check if EDITOR SPLIT feature is activated
    if ($config['news.edit.split']) {
        // Prepare delimiter
        $ed = '<!--more-->';
        if ($_REQUEST['content_delimiter'] != '') {
            // Disable `new line` + protect from XSS
            $ed = '<!--more="' . str_replace(["\r", "\n", '"'], '', $_REQUEST['content_delimiter']) . '"-->';
        }
        $content = $_REQUEST['ng_news_content_short'] . (($_REQUEST['ng_news_content_full'] != '') ? $ed . $_REQUEST['ng_news_content_full'] : '');
    } else {
        $content = $_REQUEST['ng_news_content'];
    }

    // Rewrite `\r\n` to `\n`
    $content = str_replace("\r\n", "\n", $content);

    // Check if we have content
    if ((!mb_strlen(trim($title))) || ((!mb_strlen(trim($content))) && (!$config['news_without_content']))) {
        msg(['type' => 'error', 'text' => $lang['msge_fields'], 'info' => $lang['msgi_fields']]);

        return;
    }

    // Manage alt name
    if ($perm[$permGroupMode . '.altname'] && isset($_REQUEST['alt_name'])) {
        $alt_name = $_REQUEST['alt_name'];
        // Check if alt name should be generated again
        if (trim($alt_name) == '') {
            $alt_name = mb_strtolower($parse->translit(trim($title), 1));
            // Make a conversion:
            // * '.'  to '_'
            // * '__' to '_' (several to one)
            // * Delete leading/finishing '_'
            $alt_name = preg_replace(['/\./', '/(_{2,20})/', '/^(_+)/', '/(_+)$/'], ['_', '_'], $alt_name);

            // Make alt_name equal to '_' if it appear to be blank after conversion
            if ($alt_name == '') {
                $alt_name = '_';
            }

            $i = '';
            while (is_array($mysql->record('select id from ' . prefix . '_news where alt_name = ' . db_squote($alt_name . $i) . ' limit 1'))) {
                $i++;
            }
            $alt_name = $alt_name . $i;
        }

        // Check if alt name was changed
        if ($alt_name != $row['alt_name']) {
            // Check for allowed chars in alt name
            if (!$parse->nameCheck($alt_name)) {
                msg(['type' => 'error', 'text' => $lang['editnews']['err.altname.wrong']]);

                return;
            }
        }

        // Check if we try to use duplicate alt_name
        if (is_array($mysql->record('select * from ' . prefix . '_news where alt_name=' . db_squote($alt_name) . ' and id <> ' . db_squote($row['id']) . ' limit 1'))) {
            msg(['type' => 'error', 'text' => $lang['editnews']['err.altname.dup']]);

            return;
        }
    } else {
        // Alt name was not modified or modification is not allowed
        $alt_name = $row['alt_name'];
    }

    // Generate SQL old cats list
    $oldcatids = [];
    foreach (explode(',', $row['catid']) as $cat) {
        if (preg_match('#^(\d+)$#', trim($cat), $cmatch)) {
            $oldcatids[$cmatch[1]] = 1;
        }
    }

    // Fetch MASTER provided categories
    $catids = [];
    if (intval($_POST['category']) && isset($catmap[intval($_POST['category'])])) {
        $catids[intval($_POST['category'])] = 1;
    }

    // Fetch ADDITIONAL provided categories [if allowed]
    if ($perm[$permGroupMode . '.multicat']) {
        foreach ($_POST as $k => $v) {
            if (preg_match('#^category_(\d+)$#', $k, $match) && $v && isset($catmap[intval($match[1])])) {
                $catids[$match[1]] = 1;
            }
        }
    }

    // Check if no categories specified and user can post news without categories
    if ((!count($catids)) && (!$perm[$permGroupMode . '.nocat'])) {
        msg(['type' => 'error', 'text' => $lang['editnews']['error.nocat'], 'info' => $lang['addnews']['error.nocat#desc']]);

        return 0;
    }

    if ($config['meta'] && (!isset($mode['no.meta']) || !$mode['no.meta'])) {
        $SQL['description'] = $_REQUEST['description'];
        $SQL['keywords'] = $_REQUEST['keywords'];
    } else {
        $SQL['description'] = $row['description'];
        $SQL['keywords'] = $row['keywords'];
    }

    if ($perm[$permGroupMode . '.customdate']) {
        if ($_REQUEST['setdate_custom']) {
            if (preg_match('#^(\d+)\.(\d+)\.(\d+) +(\d+)\:(\d+)$#', $_REQUEST['cdate'], $m)) {
                $SQL['postdate'] = mktime($m[4], $m[5], 0, $m[2], $m[1], $m[3]);
            }

            //$SQL['postdate'] = mktime(intval($_REQUEST['c_hour']), intval($_REQUEST['c_minute']), 0, intval($_REQUEST['c_month']), intval($_REQUEST['c_day']), intval($_REQUEST['c_year'])) + ($config['date_adjust'] * 60);
        } elseif ($_REQUEST['setdate_current']) {
            $SQL['postdate'] = time() + ($config['date_adjust'] * 60);
        }
    }

    $SQL['title'] = $title;
    $SQL['content'] = $content;

    // Check if user can modify altname
    if ($perm[$permGroupMode . '.altname']) {
        $SQL['alt_name'] = $alt_name;
    } else {
        $SQL['alt_name'] = $row['alt_name'];
    }
    $SQL['editdate'] = time() + ($config['date_adjust'] * 60);
    $SQL['catid'] = implode(',', array_keys($catids));

    // Change this parameters if user have enough access level
    $SQL['mainpage'] = ($perm[$permGroupMode . '.mainpage'] && intval($_REQUEST['mainpage'])) ? 1 : 0;
    $SQL['pinned'] = ($perm[$permGroupMode . '.pinned'] && intval($_REQUEST['pinned'])) ? 1 : 0;
    $SQL['catpinned'] = ($perm[$permGroupMode . '.catpinned'] && intval($_REQUEST['catpinned'])) ? 1 : 0;
    $SQL['favorite'] = ($perm[$permGroupMode . '.favorite'] && intval($_REQUEST['favorite'])) ? 1 : 0;

    switch (intval($_REQUEST['approve'])) {
        case -1:
            $SQL['approve'] = -1;
            break;
        case 0:
            $SQL['approve'] = 0;
            break;
        case 1:
            $SQL['approve'] = (($row['approve'] == 1) || (($row['approve'] < 1) && ($perm[$permGroupMode . '.publish']))) ? 1 : 0;
            break;
        default:
            $SQL['approve'] = 0;
    }

    if ($perm[$permGroupMode . '.setviews'] && $_REQUEST['setViews']) {
        $SQL['views'] = intval($_REQUEST['views']);
    }

    // Load list of attached images/files
    $row['#files'] = $mysql->select("select *, date_format(from_unixtime(date), '%d.%m.%Y') as date from " . prefix . '_files where (linked_ds = 1) and (linked_id = ' . db_squote($row['id']) . ')');
    $row['#images'] = $mysql->select("select *, date_format(from_unixtime(date), '%d.%m.%Y') as date from " . prefix . '_images where (linked_ds = 1) and (linked_id = ' . db_squote($row['id']) . ')');

    // Dummy parameter for API call
    $tvars = [];

    exec_acts('editnews', $id);

    $pluginNoError = 1;
    if (is_array($PFILTERS['news'])) {
        foreach ($PFILTERS['news'] as $k => $v) {
            if (!($pluginNoError = $v->editNews($id, $row, $SQL, $tvars))) {
                msg(['type' => 'error', 'text' => str_replace('{plugin}', $k, $lang['editnews']['msge_pluginlock'])]);
                break;
            }
        }
    }

    if (!$pluginNoError) {
        return;
    }

    $SQLparams = [];
    foreach ($SQL as $k => $v) {
        $SQLparams[] = $k . ' = ' . db_squote($v);
    }

    $mysql->query('update ' . prefix . '_news set ' . implode(', ', $SQLparams) . ' where id = ' . db_squote($id));

    // Update category posts counters
    if (($row['approve'] == 1) && count($oldcatids)) {
        $mysql->query('update ' . prefix . '_category set posts=posts-1 where id in (' . implode(',', array_keys($oldcatids)) . ')');
    }

    $mysql->query('delete from ' . prefix . '_news_map where newsID = ' . db_squote($id));

    // Check if we need to update user's counters [ only if news was or will be published ]
    if (($row['approve'] != $SQL['approve']) && (($row['approve'] == 1) || ($SQL['approve'] == 1))) {
        $mysql->query('update ' . uprefix . '_users set news=news' . (($row['approve'] == 1) ? '-' : '+') . '1 where id=' . $row['author_id']);
    }

    if ($SQL['approve'] == 1) {
        if (count($catids)) {
            $mysql->query('update ' . prefix . '_category set posts=posts+1 where id in (' . implode(',', array_keys($catids)) . ')');
            foreach (array_keys($catids) as $catid) {
                $mysql->query('insert into ' . prefix . '_news_map (newsID, categoryID, dt) values (' . db_squote($id) . ', ' . db_squote($catid) . ', from_unixtime(' . intval($SQL['editdate']) . '))');
            }
        } else {
            $mysql->query('insert into ' . prefix . '_news_map (newsID, categoryID, dt) values (' . db_squote($id) . ', 0, from_unixtime(' . intval($SQL['editdate']) . '))');
        }
    }

    // Skip file processing (if requested)
    if (!(isset($params['no.files']) && $params['no.files'])) {

        // Now let's manage attached files
        $fmanager = new file_managment();

        $flagUpdateAttachCount = false;

        // Delete files (if needed)
        foreach ($_POST as $k => $v) {
            if (preg_match('#^delfile_(\d+)$#', $k, $match)) {
                $fmanager->file_delete(['type' => 'file', 'id' => $match[1]]);
                $flagUpdateAttachCount = true;
            }
        }

        // PREPARE a list for upload
        if (is_array($_FILES['userfile']['name'])) {
            foreach ($_FILES['userfile']['name'] as $i => $v) {
                if ($v == '') {
                    continue;
                }

                $flagUpdateAttachCount = true;
                //
                $up = $fmanager->file_upload(['dsn' => true, 'linked_ds' => 1, 'linked_id' => $id, 'type' => 'file', 'http_var' => 'userfile', 'http_varnum' => $i]);
                //print "OUT: <pre>".var_export($up, true)."</pre>";
                if (!is_array($up)) {
                    // Error uploading file
                    // ... show error message ...
                }
            }
        }
    }

    // Notify plugins about news edit completion
    if (is_array($PFILTERS['news'])) {
        foreach ($PFILTERS['news'] as $k => $v) {
            $v->editNewsNotify($id, $row, $SQL, $tvars);
        }
    }

    // Update attach count if we need this
    $numFiles = $mysql->result('select count(*) as cnt from ' . prefix . '_files where (storage=1) and (linked_ds=1) and (linked_id=' . db_squote($id) . ')');
    if ($numFiles != $row['num_files']) {
        $mysql->query('update ' . prefix . '_news set num_files = ' . intval($numFiles) . ' where id = ' . db_squote($id));
    }

    $numImages = $mysql->result('select count(*) as cnt from ' . prefix . '_images where (storage=1) and (linked_ds=1) and (linked_id=' . db_squote($id) . ')');
    if ($numImages != $row['num_images']) {
        $mysql->query('update ' . prefix . '_news set num_images = ' . intval($numImages) . ' where id = ' . db_squote($id));
    }

    // Fetch again news record and show it's link if news is published now
    if (is_array($row = $mysql->record('select * from ' . prefix . '_news where id=' . db_squote($id))) && ($row['approve'] > 0)) {
        $nlink = newsGenerateLink($row, false, 0, true);
        msg(['text' => $lang['editnews']['msgo_edited'], 'info' => str_replace('{link}', $nlink, $lang['msgo_edited#link'])]);
    } else {
        msg(['text' => $lang['editnews']['msgo_edited']]);
    }
}

function admcookie_get()
{
    if (isset($_COOKIE['ng_adm']) && is_array($x = unserialize($_COOKIE['ng_adm']))) {
        return $x;
    }

    return [];
}

function admcookie_set($x = [])
{
    return setcookie('ng_adm', serialize($x), time() + 365 * 86400);
}

function showPreview()
{
    global $userROW, $EXTRA_CSS, $EXTRA_HTML_VARS, $PFILTERS, $tpl, $parse, $mysql, $config, $catmap;

    // Инициализация плагинов
    pluginsLoadConfig();

    // Загрузка плагина archive
    if (!function_exists('plugin_archive_showTwig')) {
        include_once root . 'plugins/archive/archive.php';
    }

    // Загрузка плагина top_active_users
    if (!function_exists('plugin_top_active_users_showTwig')) {
        include_once root . 'plugins/top_active_users/top_active_users.php';
    }

    // Load permissions
    $perm = checkPermission(['plugin' => '#admin', 'item' => 'news'], null, [
        'personal.html',
    ]);

    $SQL = ['id' => -1];
    // Эмулируем работу всех штатных средств отвечающих за отображение новости.
    // Заполняем соответствующие поля
    if ($_REQUEST['customdate']) {
        $SQL['postdate'] = mktime(intval($_REQUEST['c_hour']), intval($_REQUEST['c_minute']), 0, intval($_REQUEST['c_month']), intval($_REQUEST['c_day']), intval($_REQUEST['c_year'])) + ($config['date_adjust'] * 60);
    } else {
        $SQL['postdate'] = time() + ($config['date_adjust'] * 60);
    }
    $SQL['title'] = $_REQUEST['title'];
    $SQL['alt_name'] = $parse->translit(trim($_REQUEST['alt_name'] ? $_REQUEST['alt_name'] : $_REQUEST['title']));

    // Fetch MASTER provided categories
    $catids = [];
    if (intval($_POST['category']) && isset($catmap[intval($_POST['category'])])) {
        $catids[intval($_POST['category'])] = 1;
    }

    // Fetch ADDITIONAL provided categories
    foreach ($_POST as $k => $v) {
        if (preg_match('#^category_(\d+)$#', $k, $match) && $v && isset($catmap[intval($_POST['category'])])) {
            $catids[$match[1]] = 1;
        }
    }

    $SQL['author'] = $userROW['name'];
    $SQL['author_id'] = $userROW['id'];
    $SQL['catid'] = implode(',', array_keys($catids));
    $SQL['allow_com'] = $_REQUEST['allow_com'];

    // Variable FLAGS is a bit-variable:
    // 0 = RAW mode		[if set, no conversion "\n" => "<br />" will be done]
    // 1 = HTML enable	[if set, HTML codes may be used in news]
    $SQL['flags'] = ($perm['personal.html']) ? (($_REQUEST['flag_RAW'] ? 1 : 0) + ($_REQUEST['flag_HTML'] ? 2 : 0)) : 0;

    // This actions are allowed only for admins & Edtiors
    if (($userROW['status'] == 1) || ($userROW['status'] == 2)) {
        $SQL['mainpage'] = $_REQUEST['mainpage'];
        $SQL['approve'] = $_REQUEST['approve'];
        $SQL['favorite'] = $_REQUEST['favorite'];
        $SQL['pinned'] = $_REQUEST['pinned'];
    }

    // Fill content
    $content = '';

    // Check if EDITOR SPLIT feature is activated
    if ($config['news.edit.split']) {
        // Prepare delimiter
        $ed = '<!--more-->';
        if ($_REQUEST['content_delimiter'] != '') {
            // Disable `new line` + protect from XSS
            $ed = '<!--more="' . str_replace(["\r", "\n", '"'], '', $_REQUEST['content_delimiter']) . '"-->';
        }
        $content = $_REQUEST['ng_news_content_short'] . (($_REQUEST['ng_news_content_full'] != '') ? $ed . $_REQUEST['ng_news_content_full'] : '');
    } else {
        $content = $_REQUEST['ng_news_content'];
    }

    // Rewrite `\r\n` to `\n`
    $content = str_replace("\r\n", "\n", $content);

    $SQL['content'] = $content;

    // Process plugin variables to make proper SQL filling
    $tvx = [];
    if (is_array($PFILTERS['news'])) {
        foreach ($PFILTERS['news'] as $k => $v) {
            $v->editNews(-1, $SQL, $SQL, $tvx);
        }
    }

    $tvx = [];

    // Добавляем поясняющие заголовки с оформлением
    $tvx['vars']['short'] = '<div style="margin: 15px 0 5px; padding: 8px 12px; background: #f5f5f5; border-left: 4px solid #3498db; font-weight: bold; color: #333;">
                               Короткая новость:
                            </div>' .
        news_showone(-1, '', ['emulate' => $SQL, 'style' => 'short']);

    $tvx['vars']['full'] = '<div style="margin: 20px 0 5px; padding: 8px 12px; background: #f5f5f5; border-left: 4px solid #2ecc71; font-weight: bold; color: #333;">
                              Полная новость:
                            </div>' .
        news_showone(-1, '', ['emulate' => $SQL, 'style' => 'full']);

    // Fill extra CSS links
    foreach ($EXTRA_CSS as $css => $null) {
        $EXTRA_HTML_VARS[] = ['type' => 'css', 'data' => $css];
    }

    // Generate metatags
    $EXTRA_HTML_VARS[] = ['type' => 'plain', 'data' => GetMetatags()];

    $txv['vars']['htmlvars'] = '';
    // Fill additional HTML vars
    $htmlrow = [];
    $dupCheck = [];
    foreach ($EXTRA_HTML_VARS as $htmlvar) {
        if (in_array($htmlvar['data'], $dupCheck)) {
            continue;
        }
        $dupCheck[] = $htmlvar['data'];
        switch ($htmlvar['type']) {
            case 'css':
                $htmlrow[] = '<link href="' . $htmlvar['data'] . '" rel="stylesheet" type="text/css" />';
                break;
            case 'js':
                $htmlrow[] = '<script type="text/javascript" src="' . $htmlvar['data'] . '"></script>';
                break;
            case 'rss':
                $htmlrow[] = '<link href="' . $htmlvar['data'] . '" rel="alternate" type="application/rss+xml" title="RSS" />';
                break;
            case 'plain':
                $htmlrow[] = $htmlvar['data'];
                break;
        }
    }

    if (count($htmlrow)) {
        $tvx['vars']['htmlvars'] = implode("\n", $htmlrow);
    }

    $tvx['vars']['extracss'] = '';

    $tpl->template('preview', tpl_actions);
    $tpl->vars('preview', $tvx);
    echo $tpl->show('preview');
}

// Check if DB needs to be upgraded
function dbCheckUpgradeRequired(): bool
{
    global $twig;

    $db = NGEngine::getInstance()->getDB();
    $dbv = $db->record('select * from ' . prefix . "_config where name = 'database.engine.revision'");

    if (!is_array($dbv)) {
        // DB was created before starting version-tracking
        return true;
    }
    if ($dbv['value'] < minDBVersion) {
        // DB version is old, we need an upgrade
        return true;
    }

    return false;
}