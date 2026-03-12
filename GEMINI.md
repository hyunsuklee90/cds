# CDS (Custom Directory Shortcut) & Shell Environment

`cds` is a modular shell configuration system and directory shortcut utility designed for Linux environments. It provides a portable and consistent terminal experience across different systems (laptop, desktop, research environments) while offering a powerful tool for jumping between frequently used directories.

## Project Overview

- **Core Utility:** The `cds` command allows users to save, list, and switch between directory shortcuts using indexes or tags.
- **Modular Design:** Shell configurations are split into logical components (aliases, functions, prompt, colors) located in `bashrc.d/`.
- **Environment Profiles:** Supports multiple environments (e.g., `desktop`, `laptop`, `kaeri_ext`) with platform-specific configurations managed in the `config/` directory.
- **Scientific Computing Support:** Includes configurations and environment module support (Lmod/Tcl) for tools like `OpenMC`, `Anaconda`, and other simulation software.

## Initialization & Usage

### Initialization

To load the environment, source the `bashrc.sh` file in your `~/.bashrc` or directly in your shell session:

```bash
# Optional: Specify your environment profile (defaults to 'default')
export CDS_ENV=desktop 

# Source the main entry point
source path/to/cds/bashrc.sh
```

### Key Commands

#### `cds` (Directory Shortcuts)
- `cds -a [path]` : Add current (or specified) directory to the shortcut list.
- `cds -l`        : List all saved shortcuts with their indexes and tags.
- `cds -r [idx]`  : Remove a shortcut by its index.
- `cds [idx|tag]` : Change directory to the shortcut associated with the index or tag.
- `cds -an [idx] [tag]` : Assign a tag (name) to a shortcut.
- `cds -save`     : Manually persist the current shortcut list to disk.

#### Standard Aliases
- `ll` : `ls -lF` (List with details and file type indicators).
- `rm`, `cp`, `mv` : Aliased with `-i` for interactive safety.
- `dir`, `ls` : Configured for colorized output.

## Directory Structure

- `bashrc.sh`       : The main entry point for environment initialization.
- `bashrc.d/`       : Modular configuration scripts loaded during startup.
    - `aliases.sh`  : Custom shell aliases.
    - `functions.sh`: Dynamic loader for functions in the `functions/` directory.
    - `lmod.sh`     : Environment module support (Lmod).
    - `prompt.sh`   : Custom shell prompt configuration.
- `functions/`      : Shell function implementations.
    - `cds/cds.sh`  : Core logic for the `cds` utility.
- `config/`         : Environment-specific configurations and data.
    - `common/`     : Shared configuration (e.g., common `MODULEPATH`, library paths).
    - `default/`, `desktop/`, `laptop/`, etc. : Profiles containing platform-specific overrides and `cds` data.
- `modulefunctions/`: Support scripts for Lmod and Tcl environment modules.

## Development Conventions

- **Platform Independence:** Keep the core logic in `bashrc.d/` and `functions/` generic. Use `config/$CDS_ENV/bashrc.sh` for platform-specific variables (like drive paths or specific software locations).
- **Persistent Data:** The `cds` utility stores its state in `$CDS_DATAPATH/data/` (specifically `cds_path`, `cds_tag`, and `cds_idx`).
- **Function Loading:** Any `.sh` file added to `functions/` or its subdirectories will be automatically sourced by `bashrc.d/functions.sh`.
- **Environment Variables:**
    - `CDS_HOME`: Root directory of the repository.
    - `CDS_ENV`: The active configuration profile.
    - `CDS_DATAPATH`: Path to the active profile's configuration and data storage.
