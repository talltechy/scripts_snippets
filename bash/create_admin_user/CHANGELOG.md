# Changelog

All notable changes to the `create_admin_user.sh` script will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.2.0] - 2025-07-23

### Added

- **GitHub Release Version Checking**: Automatic update detection and notification system
  - Queries GitHub API to check for latest releases
  - Compares current version with latest available version
  - Provides download commands for updates
  - Caches version information to reduce API calls (1-hour cache)
  - `--skip-version-check` option to bypass version checking
  - Graceful fallback when network/API is unavailable

- **Enhanced User Interaction Flow**: Dramatically improved user experience and clarity
  - **Pre-execution Confirmation**: Clear "WHAT THIS SCRIPT WILL DO" summary before any changes
  - **System Changes Warning**: Explicit warning about system modifications with confirmation prompt
  - **Waiting for Input Indicators**: Clear visual cues when user input is required
  - **Auto-confirmation Support**: `--assume-yes` flag for automated environments
  - **Interactive Prompts**: Improved confirmation dialogs with clear yes/no options

- **Professional User Interface Enhancements**:
  - **Visual Dividers**: Clean separation between sections using Unicode characters
  - **Progress Tracking**: Step-by-step progress indicators with percentage completion
  - **Enhanced Status Messages**: Improved success, warning, and error messaging
  - **Configuration Preview**: Visual summary box showing all settings before execution
  - **Verbose Mode**: `--verbose` flag for detailed debugging and troubleshooting output

- **Generic Configuration**: Removed vendor-specific references
  - Changed default username from "talltechy" to "admin" for universal applicability
  - Removed all hardcoded vendor-specific references
  - Made script completely vendor-neutral and professional

### Changed

- **Startup Experience**: Complete overhaul of script initialization
  - Version check runs automatically at startup (unless skipped)
  - Clear header with version information
  - Professional appearance suitable for enterprise environments
  - Better error handling during initialization

- **User Confirmation Flow**: Enhanced decision-making process
  - Shows exactly what will be modified before making changes
  - Clear warnings about system impact
  - Option to cancel at any point before execution
  - Better integration with non-interactive mode

- **Output Clarity**: Improved messaging throughout execution
  - Clearer progress indicators
  - Better error messages with context
  - Enhanced success confirmations
  - More informative dry-run output

### Security

- **Vendor Neutrality**: Removed potential security concerns from hardcoded values
  - Generic default username reduces attack surface
  - No vendor-specific assumptions in security configurations
  - Professional appearance reduces social engineering risks

- **Update Security**: Secure version checking implementation
  - Uses HTTPS for all API communications
  - Timeout protection against hanging requests
  - Safe parsing of version information
  - No automatic downloads - user must manually update

### Fixed

- **User Experience Issues**: Addressed confusion about script behavior
  - Clear indication when waiting for user input
  - Better communication about what's happening at each step
  - Resolved ambiguity about when system changes occur
  - Improved error recovery and cleanup messaging

- **Professional Presentation**: Enhanced script professionalism
  - Consistent formatting and messaging
  - Appropriate for enterprise and production environments
  - Clear documentation and help system

## [2.1.1] - 2025-07-23

### Added

- **Enhanced Visual Experience**: Complete beautification and user-friendly interface overhaul
  - Color-coded output with ANSI color support for different message types
  - Beautiful Unicode box drawing characters for headers and sections
  - Progress bars with visual indicators (█ and ░ characters)
  - Enhanced status symbols: ✅ ✗ ⚠️ 🔍 ❌ ℹ️ 💡
  - Step-by-step progress tracking with numbered indicators
  - Animated spinner support for long-running operations

- **Improved User Guidance**: Enhanced feedback and tooltips throughout execution
  - Configuration summary box with clear visual formatting
  - Contextual tips and warnings with appropriate visual cues
  - Enhanced error messages with actionable guidance
  - Post-setup instructions with clear next steps
  - Security reminders with visual emphasis

- **Better Information Architecture**: Organized output with clear visual hierarchy
  - Sectioned output with headers and dividers
  - Progress tracking showing current step and total steps
  - Enhanced dry-run output with clear "would do" messaging
  - Improved validation feedback with detailed status reporting

### Changed

- **Enhanced Output Formatting**: All script output now uses consistent visual formatting
  - Replaced plain text messages with color-coded, symbol-enhanced output
  - Added visual progress indicators for multi-step operations
  - Improved error and warning display with appropriate colors and symbols
  - Enhanced success messages with clear visual confirmation

- **User Experience Improvements**: More intuitive and professional appearance
  - Better visual separation between different phases of execution
  - Clear indication of current operation and progress
  - Enhanced readability with proper spacing and formatting
  - Professional appearance suitable for enterprise environments

## [2.1.0] - 2025-07-23

### Added

- **Granular Sudo Permission System**: Revolutionary security enhancement with four permission levels
  - `minimal`: Basic system commands (systemctl status, ls, cat, grep, tail)
  - `standard`: Service management, package installation, docker, git (default)
  - `admin`: User management, system configuration, password changes
  - `full`: Complete sudo access (with security warnings)
  - Custom sudo commands support with `--sudo-commands` option

- **Enhanced SSH Key Security**:
  - Mandatory passphrase enforcement with `--require-passphrase` (default: true)
  - `--allow-no-passphrase` bypass flag with security warnings
  - SSH key expiry tracking and warnings (`--key-expiry-days`)
  - Automatic detection of passphrase-protected keys
  - Enhanced key validation and fingerprint display

- **Comprehensive Automation Support**:
  - `--non-interactive` mode for CI/CD and automated deployments
  - `--password-hash` support for pre-hashed passwords
  - `--ssh-pubkey` option to import existing SSH public keys
  - Configuration file support (`--config-file` and `/etc/create_admin_user.conf`)
  - Environment variable integration

- **Advanced Testing and Validation**:
  - `--dry-run` mode showing planned actions without making changes
  - `--validate-only` for prerequisite checking and configuration validation
  - `--test-setup` for comprehensive existing user configuration testing
  - Enhanced prerequisite validation with detailed error reporting
  - Disk space and permission checking

- **Configuration Management System**:
  - Configuration file support with safe parsing
  - `--create-config` option to generate configuration templates
  - Example configuration file with deployment scenarios
  - Hierarchical configuration (file → environment → command-line)

- **Enhanced Backup and Maintenance**:
  - Automatic cleanup of old backups based on retention policy
  - Configurable backup retention days
  - Organized backup structure with timestamps
  - Enhanced backup logging and verification

- **Improved User Experience**:
  - Comprehensive help system with examples and sudo level descriptions
  - Enhanced error messages with actionable guidance
  - Progress indicators and status symbols (✓, ✗, ⚠️, 🔍)
  - Detailed post-setup instructions and next steps
  - Security warnings for high-privilege configurations

### Changed

- **Enhanced Argument Parsing**: Complete rewrite with comprehensive option support
  - Support for 15+ command-line options
  - Improved error handling for invalid arguments
  - Better help system with categorized options

- **Security-First Design**: All operations now follow security-first principles
  - Default to secure configurations (passphrase required, standard sudo level)
  - Explicit warnings for insecure configurations
  - Enhanced validation for all security-sensitive operations

- **Improved Error Handling**: Comprehensive error handling with structured cleanup
  - Better error propagation and logging
  - Enhanced cleanup on failure with stage tracking
  - Graceful handling of edge cases and partial configurations

- **Enhanced Logging**: Structured logging with security focus
  - ISO timestamp format following repository standards
  - Dry-run logging support
  - Enhanced log messages with context and actionable information
  - Security event logging for audit trails

### Security

- **Granular Permission Control**: Addresses the critical security issue of overly broad sudo permissions
  - Default `standard` level instead of `full` access
  - Explicit warnings for `full` sudo access
  - Custom command validation and sanitization

- **SSH Key Security Enhancements**:
  - Mandatory passphrase enforcement by default
  - Key age tracking and expiration warnings
  - Enhanced key validation and corruption detection
  - Secure key import functionality

- **Configuration Security**:
  - Configuration files created with restrictive permissions (600)
  - Safe configuration parsing to prevent injection attacks
  - Input validation for all configuration parameters

- **Backup Security**: Enhanced backup protection and organization
  - Secure backup directory permissions
  - Automatic cleanup to prevent information disclosure
  - Organized backup structure for better access control

### Fixed

- **Cross-Platform Compatibility**: Improved compatibility across Linux distributions and bash versions
  - Better handling of different user creation commands
  - Enhanced OS detection and command availability checking
  - Improved error handling for missing system commands
  - **Bash 3.x Compatibility**: Replaced associative arrays with functions for older bash versions

- **Edge Case Handling**: Comprehensive handling of edge cases and error conditions
  - Better handling of existing users and partial configurations
  - Improved cleanup on failure scenarios
  - Enhanced validation for unusual username formats

## [2.0.0] - 2025-07-23

### Added

- **Version Information**: Added script version tracking and display
  - Script version constant (`SCRIPT_VERSION="2.0.0"`)
  - Version display option (`--version` or `-v`)
  - Version information in logs and help output
  - Script name and last updated date tracking

- **Setup Verification Function**: Added `verify_setup()` to validate complete configuration
  - Verifies user is in sudo group
  - Confirms SSH keys exist and are accessible
  - Validates sudoers file syntax
  - Provides clear ✓/✗ status indicators

- **Cleanup on Failure**: Added `cleanup_on_failure()` function
  - Automatically removes partial configurations when setup fails
  - Cleans up sudoers files and SSH directories
  - Prevents system inconsistencies from failed runs

- **Enhanced Backup System**:
  - Centralized backup directory: `/root/user_backups/USERNAME/TIMESTAMP/`
  - Better organization of backup files with timestamps
  - Improved backup logging and traceability

- **SSH Key Passphrase Detection**:
  - Warns users if SSH key was generated without a passphrase
  - Logs passphrase status for security auditing

- **Improved User Experience**:
  - Enhanced help system with better formatting and examples
  - Post-setup instructions with clear next steps
  - Display of SSH public key for easy copying
  - Emoji indicators for better visual feedback
  - Backup location information
  - Version information display (`--version` option)

### Changed

- **Username Validation**: Enhanced regex to accept uppercase letters
  - Old: `^[a-z_][a-z0-9_-]*[$]?$`
  - New: `^[a-zA-Z_][a-zA-Z0-9_-]*$` with 32-character limit
  - More descriptive error messages

- **Error Handling**: Replaced simple error exits with comprehensive cleanup
  - All critical operations now include cleanup on failure
  - Better error propagation and logging

- **Security Improvements**:
  - Log file permissions set to 600 (owner read/write only)
  - Backup files stored in secure, organized directories

- **SSH Key Generation**: Enhanced error handling and validation
  - Proper error checking for ssh-keygen command
  - Cleanup on SSH key generation failure

### Security

- **Log File Protection**: Restricted log file permissions to prevent unauthorized access
- **Backup Security**: Organized backups in secure root-only accessible directories
- **Passphrase Awareness**: Added detection and warning for unprotected SSH keys

### Fixed

- Improved error handling prevents partial system configurations
- Better validation prevents script continuation with invalid states
- Cleanup function prevents orphaned configuration files

## [1.0.0] - Initial Version

### Features

- Basic admin user creation functionality
- SSH key generation with ed25519 encryption
- Passwordless sudo configuration
- Basic error handling with `set -euo pipefail`
- File permission management
- Basic logging functionality
- Username validation
- Sudoers file syntax validation with `visudo -cf`

### Security Features

- Root privilege requirement
- Proper file permissions (700 for .ssh, 600 for private keys, 644 for public keys)
- Sudoers syntax validation before applying changes
- Basic file backup before modifications

---

## Version Guidelines

### Version Numbers

- **Major** (X.0.0): Breaking changes, significant architecture changes
- **Minor** (0.X.0): New features, enhancements, non-breaking changes
- **Patch** (0.0.X): Bug fixes, security patches, minor improvements

### Change Categories

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security-related changes

## Future Planned Features

### Roadmap for v2.3.0

- [ ] SSH configuration hardening options
- [ ] Log rotation configuration
- [ ] Multiple SSH key format support
- [x] Interactive confirmation for destructive operations (✅ Completed in v2.2.0)
- [x] Configuration file support for default settings (✅ Completed in v2.1.0)

### Roadmap for v2.4.0

- [ ] User group management beyond sudo
- [ ] SSH key distribution to remote servers
- [ ] Integration with configuration management tools
- [ ] Advanced dry-run mode for testing

### Security Enhancements Under Consideration

- [ ] Two-factor authentication setup
- [ ] SSH key rotation scheduling
- [ ] Audit logging integration
- [ ] SELinux/AppArmor profile creation
