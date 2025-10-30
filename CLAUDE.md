# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is an Ubuntu development environment setup automation tool. It installs system utilities, development tools, and configures dotfiles from a separate repository.

## Architecture

The codebase follows a modular bash scripting architecture:

- **run.sh**: Main entry point that orchestrates the setup process
- **packages.conf**: Configuration file defining package arrays (SYSTEM_UTILS, DEV_TOOLS, EXTENDED_DEV_TOOLS)
- **utils.sh**: Utility functions library containing installation helpers
- **dotfiles.sh**: Manages dotfiles installation via stow from the emoriarty/dotfiles repository
- **fonts.sh**: Installs MesloLGS Nerd Font
- **ruby.sh**: Sets up rbenv and ruby-build

### Package Installation Strategy

The system uses two distinct installation approaches:

1. **Standard packages** (via `install_package`): Uses dpkg to check if packages are installed, then installs via apt
2. **Extended packages** (via `install_extended_package`): Supports custom installation functions and path-based verification using the `::` separator syntax (e.g., `tpm::~/.tmux/plugins/tpm`)

For extended packages, the system looks for a corresponding `install_<package_name>` function (e.g., `install_lazygit`, `install_mise`). If the package uses path verification (contains `::`), it checks file/directory existence instead of command availability.

## Running the Setup

```bash
./run.sh
```

This will:
1. Update and upgrade apt packages
2. Install system utilities from SYSTEM_UTILS array
3. Install development tools from DEV_TOOLS array
4. Install extended development tools from EXTENDED_DEV_TOOLS array
5. Clean up apt cache

## Testing Changes

There's no formal test suite. To test changes:

1. Test individual utility functions in isolation:
   ```bash
   source utils.sh
   # Test specific functions
   is_installed "curl"
   is_extended_package_installed "lazygit"
   ```

2. Test package installation without running full setup:
   ```bash
   source utils.sh
   source packages.conf
   install_package "neofetch"
   ```

3. For dotfiles changes, run:
   ```bash
   ./dotfiles.sh
   ```

## Adding New Packages

### Standard APT packages
Add to appropriate array in `packages.conf`:
- `SYSTEM_UTILS`: System-level utilities
- `DEV_TOOLS`: Development tools available in apt

### Extended packages
1. Add to `EXTENDED_DEV_TOOLS` array in `packages.conf`
2. If custom installation needed, create `install_<package_name>` function in `utils.sh`
3. Use `package::path` syntax if verification should check file/directory existence

Example:
```bash
# In packages.conf
EXTENDED_DEV_TOOLS=(
  mypackage::~/.config/mypackage
)

# In utils.sh
function install_mypackage() {
  # Custom installation logic
}
```

## Dotfiles Integration

The dotfiles.sh script uses GNU Stow to symlink configurations from https://github.com/emoriarty/dotfiles. When modifying this script:
- Maintain the stow commands for each tool (nvim, tmux, editorconfig, starship, alacritty, bash_ubuntu)
- The script also handles Alacritty theme installation and .gitignore setup

## Important Notes

- All scripts use `set -e` or `set -euo pipefail` for error handling
- Path expansion: The `is_extended_package_installed` function manually expands `~` to `$HOME`
- The ruby.sh script has a syntax error (`local` used outside function) but is included in the repository
