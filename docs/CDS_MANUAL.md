# `cds` User Manual

The `cds` command is a powerful, dependency-free directory shortcut and smart-jump utility.

## Concepts

`cds` operates using two main concepts:
1.  **Bookmarks (Manual):** Fixed shortcuts you assign an index or tag.
2.  **Smart Jump (Automated):** A "frecency" based system that learns where you go and lets you jump back easily.

---

## 1. Manual Bookmarks

### Adding a Shortcut
```bash
# Add current directory (automatically fills the smallest missing index)
cds -a

# Add a specific path at a specific index
cds -a /mnt/d/projects 10

# Add current directory (.) at index 5
cds -a . 5
```

### Navigation
```bash
# Jump to index 5
cds 5

# Jump to a tag (if assigned)
cds work
```

### Management
```bash
# List all bookmarks (auto-sorted by index)
cds -l

# Assign/Change a tag for index 5
cds -an 5 work

# Switch indexes 5 and 10 (or change if 10 is empty)
cds -ci 5 10

# Swap content (tag and path) between indexes 1 and 2
cds -s 1 2

# Remove a bookmark by index or tag
cds -r 5
cds -r work

# Undo the last change (up to 10 previous states)
cds -undo

# Print the path of a bookmark without moving
cds -p work
```

### Using `cds` in Commands (Smart Output)
`cds` automatically detects if it's being used in a command substitution (`$(...)`).
- **Directly:** `cds 1` will change your directory to index 1.
- **In a command:** `cp $(cds 1)/file.txt .` will treat `$(cds 1)` as the path string without changing your current directory.

---

## 2. Operation Modes (Direct vs. Memory)

You can choose how `cds` saves its data by setting the `CDS_MODE` environment variable.

### Direct Mode (Default)
- **Setting:** `export CDS_MODE=direct` (or leave unset)
- **Behavior:** All changes are saved immediately to the main database.
- **Advantage:** Instant synchronization across multiple terminal windows.

### Memory Mode (Session Sandbox)
- **Setting:** `export CDS_MODE=memory`
- **Behavior:** Changes are stored in a temporary session buffer (`/tmp/cds_db_...`).
- **Advantage:** Fast, isolated experimentation. Changes won't affect other terminals until saved.
- **Commands:**
    - `cds -save`: Persist current session changes to the main database.
    - `cds -load`: Discard current session changes and reload from the main database.

---

## 3. Smart Jump (Frecency)

### Automatic Tracking
`cds` automatically wraps the standard `cd` command. Every time you change directories, it's recorded in your history.

### Using Smart Jump
```bash
# Jump to the most visited directory matching "proj"
cds -z proj

# Fallback (Auto-search)
# If "proj" is not in your bookmarks, it will automatically search history
cds proj
```

### History Status
```bash
# See your top 10 most visited directories
cds -z
```

---

## 4. Data Storage

- **Bookmarks:** Stored in `$CDS_DATAPATH/data/cds_db` (`idx|tag|path`).
- **History:** Stored in `$CDS_DATAPATH/data/cds_history` (plain list of paths).
    - History is capped at 5000 lines for performance.
- **Backups:** Stored in `$CDS_DATAPATH/data/backups/`.

## 5. Why Use `cds`?

- **Offline Support:** No internet or external packages (like Python or Rust) are required. 100% Bash.
- **Portability:** Sync the `cds` folder and your data files across any system.
- **Precision:** Bookmarks give you exact control, while Smart Jump offers speed for frequent tasks.
