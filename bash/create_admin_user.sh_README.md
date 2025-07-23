# Admin User Creation Script

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](#-license)
[![Bash](https://img.shields.io/badge/bash-4.0%2B-orange.svg)](https://www.gnu.org/software/bash/)

A robust, production-ready bash script for creating administrative users with SSH key authentication and passwordless sudo access on Linux systems.

## 🚀 Features

- ✅ **Secure Admin User Creation** with comprehensive validation
- 🔐 **SSH Key Generation** using modern Ed25519 encryption
- 🛡️ **Passwordless Sudo Configuration** with syntax validation
- 📁 **Organized Backup System** with timestamped directories
- 🔍 **Setup Verification** to ensure everything works correctly
- 🧹 **Automatic Cleanup** on failure to prevent partial configurations
- 📝 **Comprehensive Logging** with security-focused permissions
- 🎯 **User-Friendly Output** with clear status indicators

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
# Create user with default username 'talltechy'
sudo ./create_admin_user.sh

# Create user with custom username
sudo ./create_admin_user.sh myusername

# Show help
./create_admin_user.sh --help

# Show version
./create_admin_user.sh --version
```

### Command Line Options

```text
Usage: create_admin_user.sh [username]

Options:
  -h, --help     Show help message
  -v, --version  Show version information

Examples:
  ./create_admin_user.sh              # Creates user 'talltechy'
  ./create_admin_user.sh myuser       # Creates user 'myuser'
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

- **Root Privilege Validation**: Ensures script runs with proper permissions
- **Username Sanitization**: Validates usernames against secure patterns
- **File Permission Management**: Sets restrictive permissions on sensitive files
- **Sudoers Validation**: Uses `visudo -cf` to validate syntax before applying
- **SSH Key Security**: Generates modern Ed25519 keys with passphrase support
- **Backup Protection**: Stores backups in root-only accessible directories
- **Log Security**: Restricts log file access to root only

## 📊 Success Verification

The script automatically verifies:

- ✅ User exists and is in sudo group
- ✅ SSH private key is accessible
- ✅ Sudoers configuration is valid
- ✅ File permissions are correct

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

### Latest Version: 2.0.0

- Added setup verification and cleanup on failure
- Enhanced backup system with organized directories
- Improved error handling and user experience
- Added version tracking and better documentation

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
