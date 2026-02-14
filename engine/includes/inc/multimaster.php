<?php
//
// Copyright (C) 2006-2011 Next Generation CMS (http://ngcms.org/)
// Name: multimaster.php
// Description: multidomain mastering
// Author: Vitaly A Ponomarev, vp7@mail.ru
//
function multi_multisites()
{
    global $config, $siteDomainName, $multiDomainName, $multiconfig, $multimaster;
    $siteDomainName = '';
    $multiDomainName = '';

    // Проверяем, включен ли мультисайт в настройках
    // ВАЖНО: на первом вызове (до загрузки config.php) пропускаем эту проверку
    if (isset($config['use_multisite']) && empty($config['use_multisite'])) {
        return;
    }

    // Определяем путь к конфигу (используем engine/conf вместо root/conf)
    $multiconfigPath = defined('confroot') ? confroot . 'multiconfig.php' : root . 'conf/multiconfig.php';

    // Анализируем мультидоменную конфигурацию
    if (!is_file($multiconfigPath)) {
        return;
    }
    @include $multiconfigPath;
    if (!is_array($multiconfig)) {
        return;
    }
    // Если не выбран МультиМастер - не обрабатываем мультиконфиг
    if (
        !$multimaster || (!is_array($multiconfig[$multimaster])) ||
        (!$multiconfig[$multimaster]['active']) || (!is_array($multiconfig[$multimaster]['domains']))
    ) {
        return;
    }
    // Обёртка для реализации break'ов
    do {
        // Проверка мастера
        foreach ($multiconfig[$multimaster]['domains'] as $mdom) {
            if (($_SERVER['SERVER_NAME'] == $mdom) || ($_SERVER['HTTP_HOST'] == $mdom)) {
                // Найден сайт
                $siteDomainName = $mdom;
                $multiDomainName = $multimaster;
                break;
            }
        }
        // Проверка остальных учётных записей
        foreach ($multiconfig as $mname => $mrec) {
            if (!is_array($mrec['domains'])) {
                continue;
            }
            foreach ($mrec['domains'] as $mdom) {
                if (($_SERVER['SERVER_NAME'] == $mdom) || ($_SERVER['HTTP_HOST'] == $mdom)) {
                    // Найден сайт
                    $siteDomainName = $mdom;
                    $multiDomainName = $mname;
                    break;
                }
            }
            if ($siteDomainName) {
                break;
            }
        }
    } while (0);
    // Если нет ни одного совпадения, то выбираем первый домен у мастера
    if (!$siteDomainName) {
        $siteDomainName = $multiconfig[$multimaster]['domains'][0];
    }
    // Если мультидомен выбран - меняем пути
    if ($multiDomainName && ($multiDomainName != $multimaster)) {
    }
    $siteDomainName = trim($siteDomainName);
}
function multi_multidomains()
{
    global $config, $siteDomainName, $multiDomainName, $multimaster, $multiconfig, $multimaster, $SYSTEM_FLAGS;
    $newdomain = '';
    $SYSTEM_FLAGS['mydomains'] = [];

    // Базовая мультидоменность работает всегда (для переменной {domain})
    // Полный мультисайт требует включения через use_multisite

    // Анализируем параметр конфига mydomains
    $domlist = null;
    if (isset($config['mydomains'])) {
        $domlist = explode("\n", $config['mydomains']);
        if (!is_array($domlist)) {
            return 0;
        }
        $SYSTEM_FLAGS['mydomains'] = $domlist;
        foreach ($domlist as $domain) {
            $domain = trim($domain);
            if (($_SERVER['SERVER_NAME'] == $domain) || ($_SERVER['HTTP_HOST'] == $domain)) {
                // We found it. First - get default domain
                $newdomain = $domain;
                break;
            }
        }
    }
    // Если не найдено ни одного совпадения, то прописываем самый первый хост
    if (!$newdomain) {
        // Если заданы хосты в mydomains, то выбираем первый. Иначе - выбираем хост выбранный в мультисайте
        if (is_array($domlist)) {
            $newdomain = $domlist[0];
        } else {
            if ($siteDomainName) {
                $newdomain = $siteDomainName;
                $SYSTEM_FLAGS['mydomains'] = [$newdomain];
            } else {
                // Если имя хоста так и не нашли, то берём данные с сервера
                $newdomain = $_SERVER['HTTP_HOST'];
                $SYSTEM_FLAGS['mydomains'] = [$newdomain];
            }
        }
    }
    //
    // Отрабатываем замену масок {domain}, {domainID} в конфиг-файле
    //
    $newdomain = trim($newdomain);
    $newdomainid = trim($multiDomainName);
    if ($newdomain) {
        foreach (['home_url', 'admin_url', 'avatars_url',  'images_url', 'files_url', 'avatars_dir',  'images_dir', 'files_dir', 'attach_url', 'attach_dir'] as $vn) {
            $config[$vn] = str_replace('{domain}', $newdomain, $config[$vn]);
            $config[$vn] = str_replace('{domainid}', $newdomainid, $config[$vn]);
        }
    }
}
