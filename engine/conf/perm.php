<?php
// NGCMS User defined permissions ()
$confPermUser = array (
  1 => 
  array (
    '#admin' => 
    array (
      'categories' => 
      array (
        'list.admin' => '1',
      ),
      'news' => 
      array (
        'unapproved' => false,
      ),
    ),
  ),
  2 => 
  array (
    '#admin' => 
    array (
      'system' => 
      array (
        'admpanel.view' => false,
        'lockedsite.view' => false,
        'debug.view' => false,
        '*' => false,
      ),
      'configuration' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'users' => 
      array (
        'view' => false,
        'details' => false,
        'modify' => false,
      ),
      'cron' => 
      array (
        'details' => false,
        'modify' => false,
      ),
      'rewrite' => 
      array (
        'details' => false,
        'modify' => false,
      ),
      'categories' => 
      array (
        'list.admin' => '1',
      ),
      'news' => 
      array (
        'unapproved' => false,
      ),
      'templates' => 
      array (
        'details' => false,
        'modify' => false,
      ),
      'perm' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'ugroup' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'dbo' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'extras' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'extra-config' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'statistics' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'editcomments' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'options' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'files' => 
      array (
        'details' => false,
        '*' => false,
      ),
      'images' => 
      array (
        'details' => false,
        '*' => false,
      ),
      'pm' => 
      array (
        'details' => false,
        '*' => false,
      ),
      'preview' => 
      array (
        'details' => false,
        '*' => false,
      ),
    ),
    'nsm' => 
    array (
      '' => 
      array (
        'add' => false,
        'list' => false,
        'view' => false,
        'view.draft' => false,
        'view.unpublished' => false,
        'view.published' => false,
        'modify.draft' => false,
        'modify.unpublished' => false,
        'modify.published' => false,
        'delete.draft' => false,
        'delete.unpublished' => false,
        'delete.published' => false,
      ),
    ),
  ),
  3 => 
  array (
    '#admin' => 
    array (
      'system' => 
      array (
        'admpanel.view' => false,
        'lockedsite.view' => false,
        'debug.view' => false,
        '*' => false,
      ),
      'configuration' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'static' => 
      array (
        'view' => false,
        'details' => false,
        'modify' => false,
      ),
      'users' => 
      array (
        'view' => false,
        'details' => false,
        'modify' => false,
      ),
      'cron' => 
      array (
        'details' => false,
        'modify' => false,
      ),
      'rewrite' => 
      array (
        'details' => false,
        'modify' => false,
      ),
      'categories' => 
      array (
        'list.admin' => '1',
      ),
      'news' => 
      array (
        'unapproved' => false,
        'other.list' => false,
        'other.view' => false,
        'other.modify' => false,
        'other.modify.published' => false,
        'other.publish' => false,
        'other.unpublish' => false,
        'other.delete' => false,
        'other.delete.published' => false,
        'other.html' => false,
        'other.mainpage' => false,
        'other.pinned' => false,
        'other.catpinned' => false,
        'other.favorite' => false,
        'other.setviews' => false,
        'other.multicat' => false,
        'other.nocat' => false,
        'other.customdate' => false,
        'other.altname' => false,
      ),
      'templates' => 
      array (
        'details' => false,
        'modify' => false,
      ),
      'perm' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'ugroup' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'dbo' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'extras' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'extra-config' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'statistics' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'editcomments' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'options' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'files' => 
      array (
        'details' => false,
        '*' => false,
      ),
      'images' => 
      array (
        'details' => false,
        '*' => false,
      ),
      'pm' => 
      array (
        'details' => false,
        '*' => false,
      ),
      'preview' => 
      array (
        'details' => false,
        '*' => false,
      ),
    ),
    'nsm' => 
    array (
      '' => 
      array (
        'add' => false,
        'list' => false,
        'view' => false,
        'view.draft' => false,
        'view.unpublished' => false,
        'view.published' => false,
        'modify.draft' => false,
        'modify.unpublished' => false,
        'modify.published' => false,
        'delete.draft' => false,
        'delete.unpublished' => false,
        'delete.published' => false,
      ),
    ),
  ),
  4 => 
  array (
    '#admin' => 
    array (
      'system' => 
      array (
        'admpanel.view' => false,
        'lockedsite.view' => false,
        'debug.view' => false,
        '*' => false,
      ),
      'configuration' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'static' => 
      array (
        'view' => false,
        'details' => false,
        'modify' => false,
      ),
      'users' => 
      array (
        'view' => false,
        'details' => false,
        'modify' => false,
      ),
      'cron' => 
      array (
        'details' => false,
        'modify' => false,
      ),
      'rewrite' => 
      array (
        'details' => false,
        'modify' => false,
      ),
      'ipban' => 
      array (
        'view' => false,
        'modify' => false,
      ),
      'categories' => 
      array (
        'view' => false,
        'details' => false,
        'modify' => false,
        'list.admin' => '1',
      ),
      'news' => 
      array (
        'view' => false,
        'add' => false,
        'add.mainpage' => false,
        'add.pinned' => false,
        'add.catpinned' => false,
        'add.favorite' => false,
        'add.html' => false,
        'add.raw' => false,
        'unapproved' => false,
        'personal.list' => false,
        'personal.view' => false,
        'personal.modify' => false,
        'personal.modify.published' => false,
        'personal.publish' => false,
        'personal.unpublish' => false,
        'personal.delete' => false,
        'personal.delete.published' => false,
        'personal.html' => false,
        'personal.mainpage' => false,
        'personal.pinned' => false,
        'personal.catpinned' => false,
        'personal.favorite' => false,
        'personal.setviews' => false,
        'personal.multicat' => false,
        'personal.nocat' => false,
        'personal.customdate' => false,
        'personal.altname' => false,
        'other.list' => false,
        'other.view' => false,
        'other.modify' => false,
        'other.modify.published' => false,
        'other.publish' => false,
        'other.unpublish' => false,
        'other.delete' => false,
        'other.delete.published' => false,
        'other.html' => false,
        'other.mainpage' => false,
        'other.pinned' => false,
        'other.catpinned' => false,
        'other.favorite' => false,
        'other.setviews' => false,
        'other.multicat' => false,
        'other.nocat' => false,
        'other.customdate' => false,
        'other.altname' => false,
      ),
      'templates' => 
      array (
        'details' => false,
        'modify' => false,
      ),
      'perm' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'ugroup' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'dbo' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'extras' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'extra-config' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'statistics' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'editcomments' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'options' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'files' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'images' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'pm' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'preview' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
      'docs' => 
      array (
        'details' => false,
        'modify' => false,
        '*' => false,
      ),
    ),
    'nsm' => 
    array (
      '' => 
      array (
        'add' => false,
        'list' => false,
        'view' => false,
        'view.draft' => false,
        'view.unpublished' => false,
        'view.published' => false,
        'modify.draft' => false,
        'modify.unpublished' => false,
        'modify.published' => false,
        'delete.draft' => false,
        'delete.unpublished' => false,
        'delete.published' => false,
      ),
    ),
  ),
)
;
?>