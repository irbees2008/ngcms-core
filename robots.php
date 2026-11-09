<?php
//
// Dynamic robots.txt generator for NGCMS multisite
// This file serves different robots.txt based on domain
//
// Prevent direct access without proper headers
if (php_sapi_name() === 'cli') {
    die('This script can only be run through web server');
}
// Set correct content type
header('Content-Type: text/plain; charset=utf-8');
// Load NGCMS core to get config
define('NGCMS', 1);
// Get document root
$documentRoot = __DIR__;
// Include multimaster first (before core) to set domain
require_once $documentRoot . '/engine/includes/inc/multimaster.php';
// Now load core
require_once $documentRoot . '/engine/core.php';
// Function to generate default robots.txt
function generateDefaultRobots($siteUrl)
{
    $content = "User-agent: *\n";
    $content .= "Disallow: /engine/\n";
    $content .= "Disallow: /templates/\n";
    $content .= "Allow: /uploads/\n";
    $content .= "\n";
    $content .= "# Sitemap\n";
    $content .= "Sitemap: {$siteUrl}/sitemap.xml\n";
    $content .= "Sitemap: {$siteUrl}/gsmg.xml\n";
    $content .= "\n";
    $content .= "Host: {$siteUrl}\n";
    return $content;
}
// Try to get multisite config
$robotsContent = '';
$siteUrl = !empty($config['home_url']) ? $config['home_url'] : 'http://' . $_SERVER['HTTP_HOST'];
$currentDomain = $_SERVER['HTTP_HOST'];
// Determine which robots.txt file to use
$robotsFile = null;
// Get multisite variables (already set by multimaster.php -> core.php)
// confroot is already set to correct path:
// - Main site: engine/conf/
// - Multisite: engine/conf/multi/{site_id}/
$robotsFile = confroot . 'robots.txt';
// Load robots.txt file
if (file_exists($robotsFile)) {
    $robotsContent = file_get_contents($robotsFile);
    // Replace placeholders
    $robotsContent = str_replace('{SITE_URL}', $siteUrl, $robotsContent);
    $robotsContent = str_replace('{DOMAIN}', $currentDomain, $robotsContent);
}
// If no custom robots.txt found, try static file
if (empty($robotsContent)) {
    $staticRobots = $documentRoot . '/robots.txt';
    if (file_exists($staticRobots . '.static')) {
        $robotsContent = file_get_contents($staticRobots . '.static');
        $robotsContent = str_replace('{SITE_URL}', $siteUrl, $robotsContent);
        $robotsContent = str_replace('{DOMAIN}', $_SERVER['HTTP_HOST'], $robotsContent);
    }
}
// If still no content, generate default
if (empty($robotsContent)) {
    $robotsContent = generateDefaultRobots($siteUrl);
}
// Check if robots_editor plugin is active
if (function_exists('robots_editor_generate_content_twig')) {
    // Use plugin-generated content if available
    $pluginContent = robots_editor_generate_content_twig();
    if (!empty($pluginContent)) {
        $robotsContent = $pluginContent;
    }
}
// Output robots.txt
echo $robotsContent;
exit;
