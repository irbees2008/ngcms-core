<?php
//
// Multilingual News Support Helper Functions
// Created: 2026-04-01
//

// Protect against hack attempts
if (!defined('NGCMS')) {
    exit('HAL');
}

/**
 * Get current site language code based on multiDomainName
 * @return string Language code (e.g., 'ru', 'en', 'uk')
 */
function getCurrentSiteLanguage()
{
    global $multiDomainName, $multiconfig;

    // Default language
    $defaultLang = 'ru';

    // If multisite is not active, return default
    if (empty($multiDomainName) || $multiDomainName === 'main') {
        return $defaultLang;
    }

    // Load multiconfig if not loaded
    if (empty($multiconfig) && is_file(confroot . 'multiconfig.php')) {
        include confroot . 'multiconfig.php';
    }

    // Check if site has language configured
    if (isset($multiconfig[$multiDomainName]['lang'])) {
        return $multiconfig[$multiDomainName]['lang'];
    }

    // Try to detect from domain name (e.g., ru.example.com -> 'ru')
    if (isset($multiconfig[$multiDomainName]['domains']) && !empty($multiconfig[$multiDomainName]['domains'])) {
        $firstDomain = $multiconfig[$multiDomainName]['domains'][0];
        $parts = explode('.', $firstDomain);

        // Check if first part is language code (2-3 chars)
        if (strlen($parts[0]) <= 3 && preg_match('/^[a-z]{2,3}$/i', $parts[0])) {
            return strtolower($parts[0]);
        }
    }

    return $defaultLang;
}

/**
 * Get list of all active language sites
 * @return array Array of ['site_id' => site_id, 'lang' => lang_code, 'domain' => domain]
 */
function getActiveLanguageSites()
{
    global $multiconfig;

    // Load multiconfig if not loaded
    if (empty($multiconfig) && is_file(confroot . 'multiconfig.php')) {
        include confroot . 'multiconfig.php';
    }

    $sites = [];

    if (is_array($multiconfig)) {
        foreach ($multiconfig as $siteId => $siteConfig) {
            // Skip inactive sites
            if (empty($siteConfig['active'])) {
                continue;
            }

            // Skip sites with multilang disabled (default: enabled for backward compatibility)
            if (isset($siteConfig['multilang_enabled']) && !$siteConfig['multilang_enabled']) {
                continue;
            }

            // Determine language
            $lang = isset($siteConfig['lang']) ? $siteConfig['lang'] : null;

            // Try to detect from domain if not set
            if (!$lang && isset($siteConfig['domains']) && !empty($siteConfig['domains'])) {
                $firstDomain = $siteConfig['domains'][0];
                $parts = explode('.', $firstDomain);

                if (strlen($parts[0]) <= 3 && preg_match('/^[a-z]{2,3}$/i', $parts[0])) {
                    $lang = strtolower($parts[0]);
                }
            }

            // Default to site_id if can't detect language
            if (!$lang) {
                $lang = $siteId;
            }

            $sites[] = [
                'site_id' => $siteId,
                'lang' => $lang,
                'domain' => isset($siteConfig['domains'][0]) ? $siteConfig['domains'][0] : '',
                'label' => strtoupper($lang) . ' (' . $siteId . ')'
            ];
        }
    }

    return $sites;
}

/**
 * Get translations for a news article
 * @param string $translationGroupId Translation group ID
 * @param int $excludeNewsId News ID to exclude from results
 * @return array Array of translated news records
 */
function getNewsTranslations($translationGroupId, $excludeNewsId = 0)
{
    global $mysql;

    if (empty($translationGroupId)) {
        return [];
    }

    $sql = "SELECT n.*,
            (SELECT COUNT(*) FROM " . prefix . "_comments c WHERE c.post = n.id) as comments_count
            FROM " . prefix . "_news n
            WHERE n.translation_group_id = " . db_squote($translationGroupId);

    if ($excludeNewsId > 0) {
        $sql .= " AND n.id != " . intval($excludeNewsId);
    }

    $sql .= " ORDER BY n.lang_code";

    return $mysql->select($sql);
}

/**
 * Generate UUID v4
 * @return string UUID
 */
function generateUUID()
{
    // Try to use random_bytes if available (PHP 7+)
    if (function_exists('random_bytes')) {
        $data = random_bytes(16);
        $data[6] = chr(ord($data[6]) & 0x0f | 0x40); // Set version to 0100
        $data[8] = chr(ord($data[8]) & 0x3f | 0x80); // Set bits 6-7 to 10

        return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($data), 4));
    }

    // Fallback to mt_rand
    return sprintf(
        '%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
        mt_rand(0, 0xffff),
        mt_rand(0, 0xffff),
        mt_rand(0, 0xffff),
        mt_rand(0, 0x0fff) | 0x4000,
        mt_rand(0, 0x3fff) | 0x8000,
        mt_rand(0, 0xffff),
        mt_rand(0, 0xffff),
        mt_rand(0, 0xffff)
    );
}

/**
 * Create translation link for a news article
 * @param int $sourceNewsId Source news ID
 * @param string $targetLang Target language code
 * @param string $targetSiteId Target site ID
 * @param array $newsData News data (title, content, etc.)
 * @return int|false New news ID or false on error
 */
function createNewsTranslation($sourceNewsId, $targetLang, $targetSiteId, $newsData)
{
    global $mysql;

    // Get source news to copy translation_group_id
    $sourceNews = $mysql->record("SELECT * FROM " . prefix . "_news WHERE id = " . intval($sourceNewsId));

    if (!$sourceNews) {
        return false;
    }

    // Use existing translation_group_id or create new one
    $translationGroupId = !empty($sourceNews['translation_group_id'])
        ? $sourceNews['translation_group_id']
        : generateUUID();

    // Update source news with translation_group_id if not set
    if (empty($sourceNews['translation_group_id'])) {
        $mysql->query("UPDATE " . prefix . "_news
                      SET translation_group_id = " . db_squote($translationGroupId) . "
                      WHERE id = " . intval($sourceNewsId));
    }

    // Prepare news data for insertion
    $newsData['translation_group_id'] = $translationGroupId;
    $newsData['lang_code'] = $targetLang;

    // Insert new translation
    // Note: This should be called from addNews() or similar function
    // that handles all the complexity of creating news

    return $translationGroupId;
}

/**
 * Get language name by code
 * @param string $langCode Language code
 * @return string Language name
 */
function getLanguageName($langCode)
{
    $languages = [
        'ru' => 'Русский',
        'en' => 'English',
        'uk' => 'Українська',
        'de' => 'Deutsch',
        'fr' => 'Français',
        'es' => 'Español',
        'it' => 'Italiano',
        'pl' => 'Polski',
        'pt' => 'Português',
        'zh' => '中文',
        'ja' => '日本語',
    ];

    return isset($languages[$langCode]) ? $languages[$langCode] : strtoupper($langCode);
}
