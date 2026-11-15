<?php

class NGSQLiteSchemaInstaller
{
    public static function install(PDO $pdo, string $schemaFile, string $prefix, array $admin): array
    {
        if (!preg_match('/^[A-Za-z0-9_]+$/', $prefix)) {
            throw new InvalidArgumentException('SQLite table prefix contains unsupported characters');
        }
        foreach (['name', 'pass', 'mail'] as $requiredField) {
            if (!isset($admin[$requiredField])) {
                throw new InvalidArgumentException('Missing SQLite administrator field: ' . $requiredField);
            }
        }

        $schema = file_get_contents($schemaFile);
        if ($schema === false) {
            throw new RuntimeException('Cannot read SQLite schema: ' . $schemaFile);
        }
        $schema = preg_replace('/^\s*--.*$/m', '', $schema);
        $statements = array_filter(array_map('trim', explode(';', $schema)), static function ($statement) {
            return $statement !== '';
        });
        $prefix .= '_';
        $tableNames = [];

        foreach ($statements as $statement) {
            if (!preg_match('/^CREATE\s+TABLE\s+`([^`]+)`/i', $statement, $match)) {
                continue;
            }
            $tableName = str_replace('XPREFIX_', $prefix, $match[1]);
            $existing = $pdo->prepare("SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = :name");
            $existing->execute(['name' => $tableName]);
            if ($existing->fetchColumn() !== false) {
                throw new RuntimeException('SQLite table already exists: ' . $tableName);
            }
            $tableNames[] = $tableName;
        }

        try {
            $pdo->beginTransaction();
            foreach ($statements as $statement) {
                $pdo->exec(str_replace('XPREFIX_', $prefix, $statement));
            }
            $userInsert = $pdo->prepare('INSERT INTO `' . $prefix . 'users` (`name`, `pass`, `mail`, `status`, `reg`) VALUES (:name, :pass, :mail, 1, :reg)');
            $userInsert->execute([
                'name' => $admin['name'],
                'pass' => $admin['pass'],
                'mail' => $admin['mail'],
                'reg' => $admin['reg'] ?? time(),
            ]);
            $configInsert = $pdo->prepare('INSERT INTO `' . $prefix . 'config` (`name`, `value`) VALUES (:name, :value)');
            $configInsert->execute(['name' => 'database.engine.version', 'value' => '0.9.8 Release']);
            $configInsert->execute(['name' => 'database.engine.revision', 'value' => '13']);
            $pdo->commit();
        } catch (Throwable $e) {
            if ($pdo->inTransaction()) {
                $pdo->rollBack();
            }
            throw new RuntimeException('Failed to install SQLite schema: ' . $e->getMessage(), 0, $e);
        }

        return $tableNames;
    }
}
