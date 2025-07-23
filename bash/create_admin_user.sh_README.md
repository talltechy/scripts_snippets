# Admin User Creation Script

[![Version](https://img.shields.io/badge/version-2.1.0-blue.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-CC0--1.0-green.svg)](#-license)
[![Bash](https://img.shields.io/badge/bash-4.0%2B-orange.svg)](https://www.gnu.org/software/bash/)
[![Security](https://img.shields.io/badge/security-enhanced-brightgreen.svg)](#-security-features)

A comprehensive, security-focused bash script for creating administrative users with granular sudo permissions, SSH key authentication, and enterprise-grade automation support on Linux systems.

## 🚀 Features

### 🔒 **Security-First Design**
- ✅ **Granular Sudo Permissions** with four security levels (minimal|standard|admin|full)
- 🔐 **Enhanced SSH Key Security** with mandatory passphrase enforcement
- 🛡️ **Custom Sudo Commands** for precise permission control
- 📊 **SSH Key Expiry Tracking** with automated warnings
- 🔍 **Comprehensive Security Validation** and testing

### 🤖 **Enterprise Automation**
- ⚡ **Non-Interactive Mode** for CI/CD and automated deployments
- 📋 **Configuration File Support** with hierarchical settings
- 🧪 **Dry-Run Mode** for testing and validation
- 🔧 **Pre-Hashed Password Support** for secure automation
- 📥 **SSH Key Import** functionality

### 🛠️ **Advanced Management**
- 📁 **Intelligent Backup System** with automatic cleanup
- 🔍 **Setup Verification** and health checking
- 📝 **Structured Logging** with security audit trails
- 🎯 **Enhanced User Experience** with detailed guidance
- 🧹 **Automatic Cleanup** on failure with stage tracking

## 📋 Requirements

- **Operating System**: Linux (Ubuntu, Debian, CentOS, RHEL, etc.)
- **Shell**: Bash 4.0 or higher
- **Privileges**: Must be run as root
- **Dependencies**: `adduser`, `usermod`, `ssh-keygen`, `visudo`

## 🔧 Installation

### Quick Install

```bash
# Download the script
curl -O https://raw.githubusercontent.com/yourusername/your-repo/main/create_admin_user.sh

# Make it executable
chmod +x create_admin_user.sh

# Run as root
sudo ./create_admin_user.sh
```

### Manual Install

```bash
# Clone the repository
git clone https://github.com/yourusername/your-repo.git
cd your-repo

# Make the script executable
chmod +x create_admin_user.sh
```

## 📖 Usage

### Basic Usage

```bash
# Create user with default username and standard sudo level
sudo ./create_admin_user.sh

# Create user with custom username
sudo ./create_admin_user.sh myuser

# Create user with minimal sudo permissions
sudo ./create_admin_user.sh --sudo-level minimal myuser

# Show comprehensive help
./create_admin_user.sh --help

# Show version information
./create_admin_user.sh --version
```

### Security Options

```bash
# Create user with specific sudo level
sudo ./create_admin_user.sh --sudo-level admin myuser

# Create user with custom sudo commands
sudo ./create_admin_user.sh --sudo-commands "systemctl,docker,git" myuser

# Require SSH key passphrase (default behavior)
sudo ./create_admin_user.sh --require-passphrase myuser

# Allow SSH key without passphrase (with warning)
sudo ./create_admin_user.sh --allow-no-passphrase myuser

# Set custom key expiry warning period
sudo ./create_admin_user.sh --key-expiry-days 180 myuser
```

### Automation Options

```bash
# Non-interactive mode for automation
sudo ./create_admin_user.sh --non-interactive --allow-no-passphrase myuser

# Use configuration file
sudo ./create_admin_user.sh --config-file /etc/myconfig.conf

# Use pre-hashed password
sudo ./create_admin_user.sh --non-interactive --password-hash '$6$salt$hash' myuser

# Import existing SSH public key
sudo ./create_admin_user.sh --ssh-pubkey "ssh-ed25519 AAAA..." myuser
```

### Testing and Validation

```bash
# Dry run - show what would be done
sudo ./create_admin_user.sh --dry-run --sudo-level admin myuser

# Validate prerequisites only
./create_admin_user.sh --validate-only

# Test existing user setup
sudo ./create_admin_user.sh --test-setup myuser

# Create configuration template
sudo ./create_admin_user.sh --create-config
```

### Sudo Permission Levels

| Level | Description | Commands Included |
|-------|-------------|-------------------|
| **minimal** | Basic system commands | `systemctl status`, `ls`, `cat`, `grep`, `tail` |
| **standard** | Service management (default) | Service control, package management, docker, git |
| **admin** | User management | Standard + user/group management, password changes |
| **full** | Complete access (⚠️ use with caution) | All commands (`NOPASSWD:ALL`) |

### Configuration File Support

```bash
# Create configuration template
sudo ./create_admin_user.sh --create-config

# Use custom configuration file
sudo ./create_admin_user.sh --config-file /path/to/config.conf
```

Example configuration file (`/etc/create_admin_user.conf`):
```bash
DEFAULT_USERNAME="admin"
DEFAULT_SUDO_LEVEL="standard"
REQUIRE_PASSPHRASE="true"
BACKUP_RETENTION_DAYS="30"
KEY_EXPIRY_DAYS="365"
```

## 🛠️ What the Script Does

1. **User Validation**: Validates username format and checks for existing users
2. **User Creation**: Creates new user account with home directory
3. **Sudo Access**: Adds user to sudo group and configures passwordless sudo
4. **SSH Setup**:
   - Creates `.ssh` directory with proper permissions
   - Generates Ed25519 SSH key pair
   - Configures `authorized_keys` file
5. **Security**: Sets appropriate file permissions and validates configurations
6. **Backup**: Creates timestamped backups of existing files
7. **Verification**: Confirms all setup steps completed successfully
8. **Cleanup**: Automatically cleans up on failure to prevent partial configurations

## 📂 File Structure

```text
/
├── home/
│   └── [username]/
│       └── .ssh/
│           ├── id_ed25519          # Private key (600)
│           ├── id_ed25519.pub      # Public key (644)
│           └── authorized_keys     # SSH access (600)
├── etc/
│   └── sudoers.d/
│       └── [username]              # Sudo configuration (440)
├── var/log/
│   └── create_admin_user.log       # Script logs (600)
└── root/user_backups/
    └── [username]/
        └── [timestamp]/            # Backup directory
```

## 🔒 Security Features

### 🛡️ **Permission Control**
- **Granular Sudo Levels**: Four security levels from minimal to full access
- **Custom Command Support**: Define exact commands users can execute
- **Default Security**: Secure defaults with explicit warnings for high-privilege access
- **Permission Validation**: Comprehensive validation of all sudo configurations

### 🔐 **SSH Key Security**
- **Modern Encryption**: Ed25519 keys with superior security
- **Mandatory Passphrases**: Enforced by default with bypass options
- **Key Expiry Tracking**: Automated warnings for aging keys
- **Key Import Support**: Secure import of existing SSH public keys
- **Fingerprint Validation**: Automatic key integrity checking

### 🔍 **System Security**
- **Root Privilege Validation**: Ensures script runs with proper permissions
- **Username Sanitization**: Validates usernames against secure patterns
- **File Permission Management**: Sets restrictive permissions on sensitive files
- **Sudoers Validation**: Uses `visudo -cf` to validate syntax before applying
- **Backup Protection**: Stores backups in root-only accessible directories
- **Log Security**: Restricts log file access to root only
- **Configuration Security**: Safe parsing with injection attack prevention

### 🧪 **Testing and Validation**
- **Prerequisite Checking**: Validates system requirements before execution
- **Dry-Run Mode**: Test configurations without making changes
- **Setup Verification**: Comprehensive post-installation testing
- **Health Monitoring**: Ongoing configuration health checks

## 📊 Success Verification

The script automatically verifies:

- ✅ User exists and is in sudo group
- ✅ SSH private key is accessible and valid
- ✅ Sudoers configuration is syntactically correct
- ✅ File permissions are properly set (700, 600, 644)
- ✅ SSH key fingerprint is valid
- ✅ Backup system is functioning
- ✅ Configuration files are secure

## 🔍 Troubleshooting

### Common Issues

#### Permission Denied

```bash
# Ensure you're running as root
sudo ./create_admin_user.sh
```

#### Username Validation Failed

```bash
# Valid username format: letters, numbers, underscore, hyphen
# Must start with letter or underscore, max 32 characters
./create_admin_user.sh valid_user123
```

#### SSH Key Generation Failed

```bash
# Check available disk space and permissions
df -h /home
ls -la /home/[username]/.ssh/
```

### Log Files

Check the detailed logs for troubleshooting:

```bash
sudo tail -f /var/log/create_admin_user.log
```

### Backup Recovery

If something goes wrong, backups are stored in:

```bash
/root/user_backups/[username]/[timestamp]/
```

## 🔄 Version History

See [CHANGELOG.md](CHANGELOG.md) for detailed version history and feature additions.

### Latest Version: 2.1.0

- **Revolutionary Security Enhancement**: Granular sudo permission system with four levels
- **Enterprise Automation**: Non-interactive mode, configuration files, dry-run testing
- **Enhanced SSH Security**: Mandatory passphrases, key expiry tracking, import support
- **Advanced Management**: Intelligent backups, comprehensive validation, health checking
- **Improved User Experience**: Enhanced help, detailed guidance, security warnings

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow existing code style and error handling patterns
- Add comprehensive logging for new features
- Update the changelog for all changes
- Include appropriate tests and validation
- Update documentation as needed

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This script modifies system user accounts and sudo configurations. Always:

- Test in a development environment first
- Review the script before running in production
- Ensure you have proper backups
- Understand the security implications

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/your-repo/issues)
- **Documentation**: [Wiki](https://github.com/yourusername/your-repo/wiki)
- **Security**: Report security issues privately via email

## 🔗 Related Projects

- [SSH Hardening Guide](https://github.com/yourusername/ssh-hardening)
- [Linux Security Toolkit](https://github.com/yourusername/linux-security)
- [Server Setup Scripts](https://github.com/yourusername/server-setup)

---

**Made with ❤️ for system administrators and DevOps engineers**
