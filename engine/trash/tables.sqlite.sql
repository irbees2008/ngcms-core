CREATE TABLE `XPREFIX_config` (
  `name` TEXT NOT NULL PRIMARY KEY,
  `value` TEXT
);

CREATE TABLE `XPREFIX_category` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `position` INTEGER DEFAULT NULL,
  `name` TEXT NOT NULL DEFAULT '',
  `alt` TEXT NOT NULL DEFAULT '',
  `flags` TEXT DEFAULT '',
  `tpl` TEXT DEFAULT '',
  `number` INTEGER DEFAULT 0,
  `parent` INTEGER DEFAULT '0',
  `description` TEXT,
  `keywords` TEXT,
  `info` TEXT,
  `icon` TEXT NOT NULL,
  `image_id` INTEGER DEFAULT '0',
  `alt_url` TEXT,
  `orderby` TEXT DEFAULT 'id desc',
  `posts` INTEGER DEFAULT 0,
  `posorder` INTEGER DEFAULT 999,
  `poslevel` INTEGER DEFAULT 0,
  `cat_show` INTEGER DEFAULT '0'
);

CREATE TABLE `XPREFIX_files` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL DEFAULT '',
  `orig_name` TEXT NOT NULL DEFAULT '',
  `description` TEXT NOT NULL DEFAULT '',
  `folder` TEXT NOT NULL DEFAULT '',
  `date` INTEGER NOT NULL DEFAULT '0',
  `user` TEXT NOT NULL DEFAULT '',
  `owner_id` INTEGER DEFAULT '0',
  `category` INTEGER DEFAULT '0',
  `linked_ds` INTEGER DEFAULT 0,
  `linked_id` INTEGER DEFAULT 0,
  `plugin` TEXT DEFAULT '',
  `pidentity` TEXT DEFAULT '',
  `storage` INTEGER DEFAULT 0
);

CREATE INDEX `XPREFIX_files__link` ON `XPREFIX_files` (`linked_ds`, `linked_id`);

CREATE TABLE `XPREFIX_flood` (
  `ip` TEXT NOT NULL DEFAULT '' PRIMARY KEY,
  `id` INTEGER DEFAULT NULL
);

CREATE TABLE `XPREFIX_images` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL DEFAULT '',
  `orig_name` TEXT NOT NULL DEFAULT '',
  `description` TEXT NOT NULL DEFAULT '',
  `folder` TEXT NOT NULL DEFAULT '',
  `date` INTEGER NOT NULL DEFAULT '0',
  `user` TEXT NOT NULL DEFAULT '',
  `width` INTEGER DEFAULT 0,
  `height` INTEGER DEFAULT 0,
  `preview` INTEGER DEFAULT '0',
  `p_width` INTEGER DEFAULT 0,
  `p_height` INTEGER DEFAULT 0,
  `owner_id` INTEGER DEFAULT '0',
  `stamp` INTEGER DEFAULT '0',
  `category` INTEGER DEFAULT '0',
  `linked_ds` INTEGER DEFAULT 0,
  `linked_id` INTEGER DEFAULT 0,
  `plugin` TEXT DEFAULT '',
  `pidentity` TEXT DEFAULT '',
  `storage` INTEGER DEFAULT 0
);

CREATE INDEX `XPREFIX_images__link` ON `XPREFIX_images` (`linked_ds`, `linked_id`);

CREATE TABLE `XPREFIX_ipban` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `addr` TEXT,
  `atype` INTEGER DEFAULT 0,
  `addr_start` INTEGER DEFAULT 0,
  `addr_stop` INTEGER DEFAULT 0,
  `netlen` INTEGER DEFAULT 0,
  `flags` TEXT DEFAULT '',
  `createdate` TEXT,
  `reason` TEXT,
  `hitcount` INTEGER DEFAULT 0
);

CREATE INDEX `XPREFIX_ipban__ban_start` ON `XPREFIX_ipban` (`addr_start`);

CREATE TABLE `XPREFIX_news` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `translation_group_id` TEXT DEFAULT NULL,
  `lang_code` TEXT DEFAULT NULL,
  `postdate` INTEGER NOT NULL DEFAULT '0',
  `author` TEXT NOT NULL DEFAULT '',
  `author_id` INTEGER NOT NULL DEFAULT '0',
  `title` TEXT NOT NULL DEFAULT '',
  `content` TEXT NOT NULL,
  `alt_name` TEXT DEFAULT NULL,
  `mainpage` INTEGER DEFAULT '1',
  `approve` INTEGER DEFAULT '0',
  `views` INTEGER DEFAULT '0',
  `favorite` INTEGER DEFAULT '0',
  `pinned` INTEGER DEFAULT '0',
  `catpinned` INTEGER DEFAULT '0',
  `flags` INTEGER DEFAULT '0',
  `num_files` INTEGER DEFAULT '0',
  `num_images` INTEGER DEFAULT '0',
  `editdate` INTEGER NOT NULL DEFAULT '0',
  `catid` TEXT NOT NULL DEFAULT '0',
  `description` TEXT NOT NULL,
  `keywords` TEXT NOT NULL,
  `rating` INTEGER NOT NULL DEFAULT '0',
  `votes` INTEGER NOT NULL DEFAULT '0'
);

CREATE INDEX `XPREFIX_news__news_id_pagination` ON `XPREFIX_news` (`id`);

CREATE INDEX `XPREFIX_news__alt_name` ON `XPREFIX_news` (`alt_name`);

CREATE INDEX `XPREFIX_news__news_title` ON `XPREFIX_news` (`title`);

CREATE INDEX `XPREFIX_news__news_postdate` ON `XPREFIX_news` (`postdate`);

CREATE INDEX `XPREFIX_news__news_editdate` ON `XPREFIX_news` (`editdate`);

CREATE INDEX `XPREFIX_news__news_view` ON `XPREFIX_news` (`views`);

CREATE INDEX `XPREFIX_news__news_archive` ON `XPREFIX_news` (`favorite`, `approve`);

CREATE INDEX `XPREFIX_news__news_main` ON `XPREFIX_news` (`pinned`, `postdate`, `approve`, `mainpage`);

CREATE INDEX `XPREFIX_news__news_mainid` ON `XPREFIX_news` (`approve`, `mainpage`, `pinned`, `id`);

CREATE INDEX `XPREFIX_news__news_catid` ON `XPREFIX_news` (`approve`, `catpinned`, `id`);

CREATE INDEX `XPREFIX_news__idx_news_approved_order` ON `XPREFIX_news` (`approve`, `catpinned`, `postdate`, `id`);

CREATE INDEX `XPREFIX_news__idx_news_approved_pinned_order` ON `XPREFIX_news` (`approve`, `pinned`, `postdate`, `id`);

CREATE INDEX `XPREFIX_news__news_altname` ON `XPREFIX_news` (`alt_name`);

CREATE INDEX `XPREFIX_news__news_mainpage` ON `XPREFIX_news` (`approve`, `pinned`, `id`);

CREATE INDEX `XPREFIX_news__news_mcount` ON `XPREFIX_news` (`mainpage`, `approve`);

CREATE INDEX `XPREFIX_news__idx_translation_group` ON `XPREFIX_news` (`translation_group_id`);

CREATE INDEX `XPREFIX_news__idx_lang_code` ON `XPREFIX_news` (`lang_code`);

CREATE TABLE `XPREFIX_news_map` (
  `newsID` INTEGER DEFAULT NULL,
  `categoryID` INTEGER DEFAULT NULL,
  `dt` TEXT DEFAULT NULL
);

CREATE INDEX `XPREFIX_news_map__newsID` ON `XPREFIX_news_map` (`newsID`);

CREATE INDEX `XPREFIX_news_map__idx_news_category` ON `XPREFIX_news_map` (`newsID`, `categoryID`);

CREATE INDEX `XPREFIX_news_map__categoryID` ON `XPREFIX_news_map` (`categoryID`);

CREATE TABLE `XPREFIX_static` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `postdate` INTEGER NOT NULL DEFAULT '0',
  `title` TEXT DEFAULT NULL,
  `content` TEXT,
  `alt_name` TEXT DEFAULT '',
  `template` TEXT DEFAULT '',
  `description` TEXT,
  `keywords` TEXT,
  `approve` INTEGER DEFAULT 0,
  `flags` INTEGER DEFAULT '0'
);

CREATE INDEX `XPREFIX_static__static_title` ON `XPREFIX_static` (`title`);

CREATE INDEX `XPREFIX_static__static_altname` ON `XPREFIX_static` (`alt_name`);

CREATE TABLE `XPREFIX_users` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL DEFAULT '',
  `mail` TEXT DEFAULT NULL,
  `pass` TEXT DEFAULT NULL,
  `news` INTEGER DEFAULT '0',
  `status` INTEGER DEFAULT '4',
  `last` INTEGER NOT NULL DEFAULT '0',
  `reg` INTEGER NOT NULL DEFAULT '0',
  `where_from` TEXT DEFAULT NULL,
  `info` TEXT,
  `avatar` TEXT NOT NULL DEFAULT '',
  `activation` TEXT NOT NULL DEFAULT '',
  `ip` TEXT NOT NULL DEFAULT '0',
  `newpw` TEXT DEFAULT NULL,
  `authcookie` TEXT DEFAULT NULL
);

CREATE INDEX `XPREFIX_users__users_name` ON `XPREFIX_users` (`name`);

CREATE INDEX `XPREFIX_users__users_auth` ON `XPREFIX_users` (`authcookie`);

CREATE TABLE `XPREFIX_load` (
  `dt` TEXT NOT NULL PRIMARY KEY,
  `hit_core` INTEGER,
  `hit_plugin` INTEGER,
  `hit_ppage` INTEGER,
  `exectime` REAL,
  `exec_core` REAL,
  `exec_plugin` REAL,
  `exec_ppage` REAL
);

CREATE TABLE `XPREFIX_syslog` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `dt` TEXT,
  `ip` TEXT,
  `plugin` TEXT,
  `item` TEXT,
  `ds` INTEGER,
  `ds_id` INTEGER,
  `action` TEXT,
  `alist` TEXT,
  `userid` INTEGER,
  `username` TEXT,
  `status` INTEGER,
  `stext` TEXT
);

CREATE TABLE `XPREFIX_profiler` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `dt` TEXT DEFAULT NULL,
  `userid` INTEGER DEFAULT NULL,
  `exectime` REAL DEFAULT NULL,
  `memusage` REAL DEFAULT NULL,
  `url` TEXT DEFAULT NULL,
  `tracedata` TEXT
);

CREATE INDEX `XPREFIX_profiler__ondt` ON `XPREFIX_profiler` (`dt`);

CREATE TABLE `XPREFIX_news_view` (
  `id` INTEGER NOT NULL PRIMARY KEY,
  `cnt` INTEGER DEFAULT '0'
);

CREATE TABLE `XPREFIX_users_sessions` (
  `userID` INTEGER NOT NULL,
  `ip` TEXT NOT NULL DEFAULT '0',
  `last` INTEGER NOT NULL DEFAULT '0',
  `authcookie` TEXT DEFAULT NULL
);

CREATE INDEX `XPREFIX_users_sessions__userUpdate` ON `XPREFIX_users_sessions` (`userID`, `authcookie`);

CREATE INDEX `XPREFIX_users_sessions__users_auth` ON `XPREFIX_users_sessions` (`authcookie`);

-- sqlite_sequence is an internal SQLite table created by AUTOINCREMENT; intentionally not declared.
