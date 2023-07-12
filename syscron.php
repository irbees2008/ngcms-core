<?php

//
// Copyright (C) 2006-2012 Next Generation CMS (http://ngcms.ru)
// Name: syscron.php
// Description: Entry point for maintanance (cron) external calls
// Author: NGCMS project team
//

// Load CORE
require_once 'engine/core.php';


// Run CRON tasks
if (isset($cron) && is_object($cron)) {
    $cron->run(true);
}

// Terminate execution of script
coreNormalTerminate();