# `cds` Developer Guide

This guide explains the internal logic and design decisions of the `cds` utility, intended for those who wish to maintain or extend its functionality.

## Core Design Principles

1.  **Zero Dependencies:** Only uses standard POSIX/Bash utilities (`awk`, `sed`, `grep`, `sort`, `uniq`).
2.  **Encapsulation:** All internal helper functions start with `_cds_` to avoid namespace collisions.
3.  **Local Scope:** Every variable inside a function is declared as `local`.
4.  **Single Source of Truth:** Bookmark data is consolidated into one file (`cds_db`).

---

## 1. Data Structures

### Bookmarks (`cds_db`)
- **Path:** `$CDS_DATAPATH/data/cds_db`
- **Format:** `index|tag|path`
- **Example:** `1|work|/mnt/d/projects`
- **Logic:** `awk` is used for field-based searching (`-F'|'`), and `sort` is used to keep the file numerically ordered by index.

### Smart Output Logic (`[[ -t 1 ]]`)
`cds` uses `[[ -t 1 ]]` to detect if it's running in an interactive terminal or a subshell/command substitution.
- **If `[[ -t 1 ]]` is true:** It performs the `cd` command and prints status messages.
- **If `[[ -t 1 ]]` is false:** It only `printf` the path to `stdout` and redirects all other messages to `stderr` (`>&2`). This allows use in commands like `cp $(cds 1)/file.txt .`.

### Backups (Multi-level Undo)
- **Directory:** `$CDS_DATAPATH/data/backups/`
- **Mechanism:** A rotating stack of 10 files (`cds_db.1` to `cds_db.10`).
- **Rotation:** Before any write operation, `_cds_backup` is called:
  - `cds_db.9` -> `cds_db.10`, ..., `cds_db.1` -> `cds_db.2`.
  - The current `cds_db` is copied to `cds_db.1`.
- **Restoration:** `_cds_undo` restores `cds_db.1` to the main database and shifts the remaining backups back up the stack.

### History (`cds_history`)
- **Path:** `$CDS_DATAPATH/data/cds_history`
- **Format:** Plain text list of absolute paths.
- **Maintenance:** The `_cds_log` function rotates the history by keeping the last 5000 lines whenever it exceeds that limit.

---

## 2. Key Internal Functions

### `_cds_migrate`
Checks for the existence of legacy data files (`cds_path`, `cds_tag`, `cds_idx`). If found, it uses `paste` to merge them into the new `cds_db` format and creates backups (`.bak`).

### `_cds_log`
Appends the current path to `cds_history`. 
- **Filter:** It ignores `$HOME` and `/` to prevent the history from being cluttered with common top-level directories.
- **Rotation:** Uses `tail` to prune old entries.

### `_cds_smart_get_path` (The Frecency Engine)
This is the "Smart Jump" logic. It processes the history file as follows:
1.  `grep -i "$query"`: Finds all paths matching the search term.
2.  `sort | uniq -c`: Groups identical paths and counts their occurrences.
3.  `sort -nr`: Sorts by count (frequency) in descending order.
4.  `awk '{print $2}'`: Extracts the top-ranked path.

---

## 3. The `cd` Wrapper

To enable automatic history tracking, `cds` overrides the shell's `cd` command:
```bash
cd() {
    builtin cd "$@" || return
    _cds_log "$(pwd)"
}
```
- It uses `builtin cd` to avoid recursive calls.
- It only logs the path if the `cd` operation was successful (`|| return`).

---

## 4. Extending `cds`

### Adding a New Command
To add a new option (e.g., `-f` for fuzzy search), follow these steps:
1.  Add the flag to the `case "$cmd"` block in the main `cds()` function.
2.  Create an internal helper function `_cds_fuzzy_search` if the logic is complex.
3.  Update the `-h` help menu.

### Modifying the Database Format
If you need to add a fourth field (e.g., "visit_count" for bookmarks):
1.  Update the `_cds_migrate` function to handle the transition.
2.  Update `awk` field indexes in `_cds_print_list` and `_cds_get_path`.

## 5. Debugging Tips
- If `cds` is behaving unexpectedly, check the database file directly: `cat $CDS_DATAPATH/data/cds_db`.
- To see how the smart jump is ranking paths: `sort $CDS_DATAPATH/data/cds_history | uniq -c | sort -nr`.
