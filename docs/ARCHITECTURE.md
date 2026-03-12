# Shell Environment Architecture

This project provides a portable, modular shell configuration system designed to sync across various Linux-based systems (WSL, standalone PCs, offline servers).

## Directory Structure

```text
cds/
├── bashrc.sh           # Main entry point (source this in ~/.bashrc)
├── bashrc.d/           # Modular shell scripts (aliases, prompt, etc.)
├── functions/          # Reusable shell functions (e.g., cds)
├── config/             # Environment-specific configuration and data
│   ├── common/         # Shared settings (OpenMC, module paths)
│   └── [profile]/      # System profiles (desktop, laptop, etc.)
└── modulefunctions/    # Support for Lmod and Tcl environment modules
```

## How It Works

### 1. Initialization (`bashrc.sh`)
- Determines the active profile via the `$CDS_ENV` variable (defaults to `default`).
- Sets `$CDS_HOME` and `$CDS_DATAPATH`.
- Sources all scripts in `bashrc.d/*.sh`.
- Sources any profile-specific `.sh` files in `config/$CDS_ENV/`.

### 2. Environment Profiles
Profiles are used to handle system-specific differences like paths and hardware settings.
- **Desktop/Laptop**: Typically point to local paths on different machines.
- **Common**: Holds shared scientific software paths (e.g., `OPENMC_CROSS_SECTIONS`).

### 3. Function Loading
- `bashrc.d/functions.sh` automatically scans the `functions/` directory for any `.sh` files and sources them into your current shell session.

## Scientific Computing Support
The environment is built with support for:
- **Lmod / Tcl Modules**: Integration for scientific packages.
- **Anaconda**: Shared utilities for managing conda environments across systems.
