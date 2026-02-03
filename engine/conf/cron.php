<?php
return array (
  0 => 
  array (
    'min' => '0',
    'hour' => '2',
    'day' => '*',
    'month' => '*',
    'dow' => '*',
    'plugin' => 'core',
    'handler' => 'db_backup',
  ),
  1 => 
  array (
    'min' => '0,15,30,45',
    'hour' => '*',
    'day' => '*',
    'month' => '*',
    'dow' => '*',
    'plugin' => 'core',
    'handler' => 'news_views',
  ),
  2 => 
  array (
    'min' => '20',
    'hour' => '2',
    'day' => '*',
    'month' => '*',
    'dow' => '*',
    'plugin' => 'core',
    'handler' => 'load_truncate',
  ),
  3 => 
  array (
    'min' => '0,15,30,45',
    'hour' => '*',
    'day' => '*',
    'month' => '*',
    'dow' => '*',
    'plugin' => 'telegram_import',
    'handler' => 'poll',
  ),
  4 => 
  array (
    'min' => '0,5,10,15,20,25,30,35,40,45,50,55',
    'hour' => '*',
    'day' => '*',
    'month' => '*',
    'dow' => '*',
    'plugin' => 'subscribe_comments',
    'handler' => 'run',
  ),
  5 => 
  array (
    'min' => '0,5,10,15,20,25,30,35,40,45,50,55',
    'hour' => '*',
    'day' => '*',
    'month' => '*',
    'dow' => '*',
    'plugin' => 'nsched',
    'handler' => 'run',
  ),
);