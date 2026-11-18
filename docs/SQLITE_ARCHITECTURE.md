# SQLite Integration Architecture Diagram

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    NGCMS Installation                            │
│                        install.php                               │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ Step 2: Database Configuration                          │   │
│  │  ○ MySQL (traditional server)                          │   │
│  │  ○ SQLite (file-based, no server required)             │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────────┬──────────────────────────────────────────────────────┘
             │
      ┌──────┴──────┐
      │             │
      ▼             ▼
  ┌────────────┐  ┌──────────────┐
  │  MySQL     │  │   SQLite     │
  │            │  │              │
  │ Params:   │  │ Params:      │
  │ - host    │  │ - dbpath     │
  │ - user    │  │              │
  │ - pass    │  │              │
  │ - db      │  │              │
  └─────┬──────┘  └────────┬─────┘
        │                  │
        └──────┬───────────┘
               │
               ▼
    ┌─────────────────────────────┐
    │    NGPDO (Enhanced)         │
    │  ┌─────────────────────────┐│
    │  │ createDSN()             ││
    │  │ initializeDatabase()    ││
    │  │ query()                 ││
    │  │ convertSQLForSQLite()   ││
    │  │ getDbType()             ││
    │  │ getLastInsertId()       ││
    │  └─────────────────────────┘│
    └────────────┬────────────────┘
                 │
         ┌───────┴───────┐
         │               │
         ▼               ▼
    ┌─────────┐    ┌──────────────────┐
    │ MySQL   │    │ NGSQLiteAdapter  │
    │ Driver  │    │ ┌────────────────┤
    │ (PDO)   │    │ │ convertSQL()   │
    │         │    │ │ tableExists()  │
    │         │    │ │ getTables()    │
    │         │    │ │ createBackup() │
    │         │    │ │ vacuum()       │
    │         │    │ │ pragma...()    │
    │         │    │ └────────────────┤
    └─────────┘    └──────────────────┘
         │                  │
         ▼                  ▼
    ┌─────────┐    ┌──────────────┐
    │MySQL DB │    │ SQLite File  │
    │         │    │              │
    │ Tables  │    │ database.    │
    │ Data    │    │ sqlite       │
    │ Indexes │    │              │
    └─────────┘    └──────────────┘
         │                  │
         └──────┬───────────┘
                │
                ▼
    ┌─────────────────────────┐
    │  NGCMS Application      │
    │  - News Management      │
    │  - User Management      │
    │  - Comments             │
    │  - Admin Panel          │
    └─────────────────────────┘
```

## Database Selection During Installation

```
Installation Flow:
═════════════════════════════════════════════════════════════════

Step 1: License Agreement ───┐
                             │
Step 2: Database Setup ──────┤─► [Choose Database Type]
   │                         │
   ├─► MySQL Server         │    Database Type Selection
   │   ├─ Host              │    ┌────────────────────┐
   │   ├─ Database Name     │    │ ○ MySQL (default) │
   │   ├─ User              │    │ ○ SQLite (new)    │
   │   ├─ Password          │    └────────────────────┘
   │   └─ Create DB?        │
   │                         │
   └─► SQLite File          │
       ├─ File Path         │
       └─ Create Dir?       │
                             │
Step 3: Access Check ────────┤
   ├─ File Permissions      │
   ├─ Directory Writable    │
   └─ Extensions Available  │
                             │
Step 4-7: Setup Completion ─┴─► Database Ready
                                ├─ Tables Created
                                ├─ Initial Data Inserted
                                └─ Configuration Saved
```

## File Organization

```
Project Structure:
═════════════════════════════════════════════════════════════════

C:\OSPanell\home\it\
│
├── engine/
│   ├── classes/
│   │   └── NGPDO.class.php
│   │       └── [Modified for SQLite support]
│   │
│   ├── conf/
│   │   └── config.php
│   │       ├── dbtype: 'pdo'
│   │       ├── db_driver: 'mysql' | 'sqlite'
│   │       ├── For MySQL:
│   │       │   ├── dbhost
│   │       │   ├── dbname
│   │       │   ├── dbuser
│   │       │   └── dbpasswd
│   │       └── For SQLite:
│   │           └── dbpath: /path/to/database.sqlite
│   │
│   ├── includes/
│   │   ├── sqlite_support.php
│   │   │   └── NGSQLiteAdapter class
│   │   └── core.php
│   │       └── [Initialize SQLite support]
│   │
│   ├── lang/
│   │   ├── russian/
│   │   │   └── install.ini
│   │   │       └── [SQLite translations]
│   │   └── english/
│   │       └── install.ini
│   │           └── [SQLite translations]
│   │
│   └── admin/
│       └── templates/
│           └── config_db.tpl
│               └── [Database selection form]
│
├── data/
│   ├── .htaccess
│   │   └── [Protect .sqlite files]
│   ├── database.sqlite (SQLite option)
│   ├── database.sqlite-wal
│   ├── database.sqlite-shm
│   └── backups/
│       ├── database.sqlite.2025-01-15
│       └── database.sqlite.2025-01-16
│
├── install.php
│   └── [Modified for database selection]
│
└── docs/
    └── SQLite Documentation
        ├── SQLITE_INDEX.md (navigation)
        ├── SQLITE_QUICKSTART.md (getting started)
        ├── sqlite-integration.md (architecture)
        ├── sqlite-implementation-plan.md (implementation)
        ├── sqlite-config-examples.md (code examples)
        └── SQLITE_SUMMARY.md (this package)
```

## Query Flow

```
User Request
    │
    ▼
┌─────────────────────┐
│ NGCMS Application   │
│ (e.g., List Posts)  │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ NGPDO::query()      │
│                     │
│ 1. Check dbType     │
│ 2. If SQLite:       │
│    - Convert SQL    │
│    - Adapt syntax   │
│ 3. Execute query    │
│ 4. Return results   │
└────────┬────────────┘
         │
    ┌────┴─────┐
    │           │
    ▼           ▼
┌────────┐  ┌──────────────┐
│ MySQL  │  │ SQLite       │
│ Server │  │ (file-based) │
└────────┘  └──────────────┘
    │           │
    └────┬──────┘
         │
         ▼
┌──────────────────┐
│ Result Set       │
│ (standardized)   │
└────────┬─────────┘
         │
         ▼
    Application
    processes
    results
```

## Compatibility Layer

```
MySQL SQL                SQLite SQL
═════════════════════════════════════════════════════════════════

`table_name`         →   "table_name"
AUTO_INCREMENT       →   AUTOINCREMENT
INT UNSIGNED         →   INT
SHOW TABLES          →   SELECT name FROM sqlite_master
LAST_INSERT_ID()     →   last_insert_rowid()
CHARACTER SET utf8   →   (default UTF-8)
COLLATE utf8mb4      →   (removed)
ENGINE=InnoDB        →   (removed)


Conversion Process:
═════════════════════════════════════════════════════════════════

Original MySQL SQL
        │
        ▼
NGSQLiteAdapter::convertSQL()
        │
        ├─ Replace backticks with quotes
        ├─ Remove MySQL-specific clauses
        ├─ Convert AUTO_INCREMENT
        ├─ Remove UNSIGNED
        └─ Normalize syntax
        │
        ▼
SQLite-Compatible SQL
        │
        ▼
Execute on SQLite
```

## Backup & Restore Process

```
Backup Flow:
═════════════════════════════════════════════════════════════════

SQLite Database File
    (database.sqlite)
            │
            ▼
[Copy file]
            │
            ▼
Backup Directory
    (backups/)
            │
            ├─ database.sqlite.2025-01-15.10-30-45
            ├─ database.sqlite.2025-01-16.14-20-15
            └─ ... (keep last 10 backups)


Restore Flow:
═════════════════════════════════════════════════════════════════

Current Database        Backup File
(database.sqlite)       (database.sqlite.YYYYMMDD)
        │                       │
        ├─► [Safety Copy]       │
        │   (database.sqlite    │
        │    .before-restore)   │
        │                       │
        └──────────┬────────────┘
                   │
                   ▼
            [Copy file]
                   │
                   ▼
        Restored Database
        (ready to use)
```

## Configuration Priority

```
Database Type Determination:
═════════════════════════════════════════════════════════════════

1. Check engine/conf/config.php
   ├─ dbtype: 'pdo' (always for both MySQL and SQLite)
   └─ db_driver: 'mysql' | 'sqlite' (NEW)

2. If db_driver = 'mysql':
   ├─ dbhost
   ├─ dbname
   ├─ dbuser
   └─ dbpasswd

3. If db_driver = 'sqlite':
   └─ dbpath (absolute path to .sqlite file)

4. Fallback (if not specified):
   └─ Assume 'mysql' for backward compatibility
```

## Performance Characteristics

```
Operation          MySQL          SQLite
═════════════════════════════════════════════════════════════════
Connection Setup   Medium         Very Fast
Query Execution    Very Fast      Fast
Concurrent Writes  Excellent      Limited
Large Datasets     Excellent      Good
Small Datasets     Good           Excellent
Memory Usage       Medium         Low
File Size          Database       Single .sqlite file
Backup Time        Medium         Very Fast (copy)
Restore Time       Medium         Very Fast (copy)
```

## Security Architecture

```
Web Server
    │
    ├─► index.php ──► Access Allowed
    ├─► admin.php ──► Access Allowed
    └─► data/
         │
         └─► database.sqlite ──X► Access Denied
              │
              ├─ .htaccess blocks
              │  <FilesMatch ".sqlite$">
              │      Deny from all
              │  </FilesMatch>
              │
              └─ Permissions: 640
                  (owner: rw-, group: r--, other: ---)

Access Flow:
┌──────────────┐
│  Web Client  │
└──────┬───────┘
       │
       ▼
┌──────────────────────┐
│  Web Server/PHP      │
│  (trusted)           │
└──────┬───────────────┘
       │
       ├─► [Can read/write]
       │
       ▼
┌──────────────────────┐
│  Database (SQLite)   │
│  database.sqlite     │
└──────────────────────┘
```

## Implementation Timeline

```
Timeline: 28-38 Hours
═════════════════════════════════════════════════════════════════

Week 1: Foundation (6-8 hours)
├─ Day 1-2: Read Documentation (2-3h)
├─ Day 2-3: Understand Current Code (2-3h)
├─ Day 3: Prepare Environment (2h)

Week 2: NGPDO Modification (8-10 hours)
├─ Day 1-2: Extend NGPDO Class (4-5h)
├─ Day 2-3: SQL Conversion Functions (2-3h)
├─ Day 3: Unit Testing (2h)

Week 3: Installation & UI (6-8 hours)
├─ Day 1-2: Modify install.php (3-4h)
├─ Day 2: Update Templates (1-2h)
├─ Day 3: Form Validation (2h)

Week 4: Utilities & Security (6-8 hours)
├─ Day 1: Backup/Restore Functions (2h)
├─ Day 2: Database Maintenance (1-2h)
├─ Day 3: Security Hardening (2-3h)
└─ Day 4: Protection Rules (1h)

Week 4-5: Testing & Release (4-6 hours)
├─ Days 1-2: Functional Testing (2-3h)
├─ Day 3: Performance Testing (1-2h)
├─ Day 4: Release Documentation (1h)

TOTAL: 28-38 hours
```

## Decision Tree

```
SQLite Integration for NGCMS - Should You Use It?
═════════════════════════════════════════════════════════════════

                    [Start]
                      │
            Does your site need
          MySQL advanced features?
                   /    \
                 Yes      No
                  │        │
                  ▼        ▼
              Use      [Continue]
             MySQL         │
                    Is this for
                 production with
                 high traffic?
                    /    \
                  Yes      No
                   │        │
                   ▼        ▼
                Use      [Continue]
               MySQL         │
                      Do you need
                    easy hosting
                      (shared)?
                      /    \
                    Yes      No
                     │        │
                     ▼        ▼
                  [Continue]  Use MySQL
                     │
                  Is this for:
                - Development
                - Small site
                - Standalone
                      │
                      ▼
                  USE SQLITE ✓
```

---

**Visual diagrams help understand the architecture and flow. Reference these when implementing!**
