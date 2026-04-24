-- Upgrade SQL: Add multilingual support for news
-- Date: 2026-04-01
-- Description: Adds fields for linking translated versions of news articles

-- Add translation_group_id field (UUID for grouping translations)
ALTER TABLE `XPREFIX_news`
ADD COLUMN `translation_group_id` VARCHAR(36) NULL DEFAULT NULL AFTER `id`,
ADD COLUMN `lang_code` VARCHAR(5) NULL DEFAULT NULL AFTER `translation_group_id`,
ADD INDEX `idx_translation_group` (`translation_group_id`),
ADD INDEX `idx_lang_code` (`lang_code`);

-- Generate translation_group_id for existing news (each existing article is its own group)
UPDATE `XPREFIX_news`
SET `translation_group_id` = UUID(),
    `lang_code` = 'ru'
WHERE `translation_group_id` IS NULL;
