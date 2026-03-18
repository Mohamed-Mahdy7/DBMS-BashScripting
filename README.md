# Bash DBMS

A lightweight **file-based database management system** implemented in **Bash**.

This repo contains a simple DBMS prototype that stores databases as directories and tables as pairs of metadata and data files. It is built with clear layering and a strict shared contract between contributors.

---

## Overview

- **Database** = directory under `databases/`.
- **Table** = two files inside a database directory:
    - `<table>.meta` — schema (column names, types, primary key)
    - `<table>.db` — data rows (pipe-separated values)
- Scripts are organized into three layers:
    - `db_layer/` — create/drop/list/connect databases
    - `table_layer/` — create/drop/list tables + menu navigation
    - `record_layer/` — insert/select/update/delete rows

This project is designed with a strong shared contract: layers interact only through well-defined file formats and global variables.

---

## Repository structure

```
Bash-DBMS/
├── main.sh                  # entry point — sources all layers, sets globals
├── contract.md              # shared contract and conventions
├── db_layer/
│   ├── create_db.sh         # Mohamed Mahdy
│   ├── list_dbs.sh          # Mohamed Mahdy
│   ├── connect_db.sh        # Mohamed Mahdy
│   ├── drop_db.sh           # Mohamed Mahdy
│   ├── rename_db.sh         # Mohamed Mahdy
│   └── db_menu.sh           # Mohamed Mahdy
├── table_layer/
│   ├── create_table.sh      # Mohamed Mahdy
│   ├── list_tables.sh       # Mohamed Mahdy
│   ├── drop_table.sh        # Mohamed Mahdy
│   ├── table_utils.sh       # Yamen Aly
│   └── table_menu.sh        # Yamen Aly
└── record_layer/
    ├── validate.sh          # Yamen Aly
    ├── insert.sh            # Yamen Aly
    ├── select.sh            # Yamen Aly
    ├── delete.sh            # Yamen Aly
    └── update.sh            # Yamen Aly
```

> Note: `main.sh` must source scripts in the order shown in the above structure.

---

## Work split (Mahdy vs Yamen)

This project is intentionally structured so each contributor owns a clear slice of functionality:

- **Mohamed Mahdy**
    - Database lifecycle: creation, listing, connection, dropping, renaming
    - Table lifecycle: creation, listing, dropping
    - Shared contract and entrypoint wiring

- **Yamen Aly**
    - Table utilities and menu navigation
    - Record operations: validation, insert, select, update, delete

All cross-layer interactions happen via the agreed file formats (`.meta` / `.db`) and global variables (`BASE_DIR`, `CURRENT_DB`).

---

## Global variables

All globals are set in `main.sh`; no script redefines them.

- `BASE_DIR` — set to `$(dirname "$0")/databases`
- `CURRENT_DB` — set by `connect_db.sh` to the currently connected database directory

`CURRENT_DB` is set on connect and unset on disconnect.

---

## On-disk formats

### Database layout

- A database is a directory: `databases/<db_name>/`
- A table is present only when both files exist:
    - `<table>.meta` — schema
    - `<table>.db` — data

A missing file in a table pair is considered corruption; operations must abort with exit code `1`.

### Schema file (`.meta`)

- One column per line: `<colname>:<type>` or `<colname>:<type>:pk`
- Exactly one column must be marked `:pk`
- Supported types: `int`, `str`
- Column ordering in `.meta` defines the field order in `.db`

Example:

```
id:int:pk
name:str
age:int
email:str
```

### Data file (`.db`)

- One row per line
- Fields separated by pipe `|`
- No header row (schema lives in `.meta`)
- No trailing delimiter
- No blank lines

Example:

```
1|Ahmed|24|ahmed@mail.com
2|Sara|28|sara@mail.com
```

---

## Conventions

### Exit codes

| Code | Meaning                                                                |
| ---- | ---------------------------------------------------------------------- |
| 0    | Success                                                                |
| 1    | Logical error (not found, already exists, type mismatch, duplicate PK) |
| 2    | Wrong number of arguments                                              |

### Output

- `stdout` — success results (lists, rows, confirmations)
- `stderr` — errors only (formatted as `Error: <reason>`)
- Menu scripts (`db_menu.sh`, `table_menu.sh`) handle UI. Core functions must not print menus, prompts, or banners.

### Identifier validation

Database and table names must match:

```
^[a-zA-Z_][a-zA-Z0-9_]*$
```

No spaces, hyphens, dots, or special characters.

### Type validation

Implemented in `record_layer/validate.sh` and used by `insert.sh` and `update.sh`.

- `int` — optionally negative integer (`^-?[0-9]+$`)
- `str` — non-empty string (`-n "$v"`)

Invalid values abort with exit code `1` before modifying any files.

### Primary key rules

- Only enforced on insert (PK updates are not supported in v1)
- Duplicate keys abort the insert with exit code `1`

### Safe writes

Modifying `.db` uses a temp-file + `mv` pattern to avoid corrupting data on failures:

```bash
local tmp
tmp=$(mktemp)
# ... write new content to "$tmp" ...
mv "$tmp" "$target_file"
```

---

## Getting started

1. Make sure the repo is executable:

    ```bash
    chmod +x main.sh
    ```

2. Run the entry point:

    ```bash
    ./main.sh
    ```

3. Use the interactive menu to create/connect databases and manage tables/records.

---
