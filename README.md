# Scripts & Snippets 🚀

[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows%20%7C%20macOS-blue.svg)]()
[![Security](https://img.shields.io/badge/Security-First-green.svg)]()
[![Enterprise](https://img.shields.io/badge/Enterprise-Ready-orange.svg)]()

A curated collection of **enterprise-grade automation scripts** and utilities designed to streamline system administration, enhance security, and automate repetitive tasks across multiple platforms. Built with a **security-first approach** and professional-quality user interfaces.

## ⚡ Quick Download & Install

```bash
# One-line download and setup
curl -fsSL https://raw.githubusercontent.com/talltechy/scripts_snippets/main/bash/create_admin_user/create_admin_user.sh | bash

# Or clone the full repository
git clone https://github.com/talltechy/scripts_snippets.git && cd scripts_snippets && find bash/ -name "*.sh" -exec chmod +x {} \;

# Quick test with flagship tool
cd bash/create_admin_user && ./create_admin_user.sh --help
```

## 🏆 Featured Tools

### 🔐 Admin User Creation Suite
**Location**: [`bash/create_admin_user/`](bash/create_admin_user/)  
**Version**: v2.1.1 (Enterprise Edition)

Our **flagship tool** for secure Linux user management with enterprise-grade features:

- **🎨 Beautiful Interface**: Color-coded output with Unicode graphics and progress bars
- **🔒 Granular Security**: 4-level sudo permission system (minimal|standard|admin|full)
- **🔑 SSH Security**: Mandatory passphrases, key expiry tracking, secure generation
- **🤖 Enterprise Automation**: Non-interactive mode, configuration files, dry-run testing
- **📊 Comprehensive Logging**: Audit trails and detailed security event logging
- **✅ Production Ready**: Backup systems, validation, and rollback capabilities

```bash
# Quick start - Interactive mode
cd bash/create_admin_user && ./create_admin_user.sh

# Enterprise automation
./create_admin_user.sh --config production.conf --non-interactive --dry-run
```

### 🔄 System Update Automation
**Location**: [`bash/auto-update.sh`](bash/auto-update.sh)

Automated system updates with email notifications and comprehensive logging:
- Multi-distribution support (Alpine, Fedora, Debian-based)
- SMTP integration with GPG-encrypted credentials
- Detailed logging and error reporting
- Configurable update policies

## 📂 Complete Tool Inventory

### 🐧 Bash Scripts
| Tool | Purpose | Status | Features |
|------|---------|--------|----------|
| **[create_admin_user.sh](bash/create_admin_user/)** | User management suite | 🏆 Flagship | Enterprise UI, granular security, automation |
| **[auto-update.sh](bash/auto-update.sh)** | System updates | ✅ Production | Multi-distro, email notifications |
| **[first_boot_fedora.sh](bash/first_boot_fedora.sh)** | Fedora initialization | ✅ Stable | First-boot configuration |
| **[init_fedora.sh](bash/init_fedora.sh)** | Fedora setup | ✅ Stable | Package installation, settings |
| **[qemu_guest_agent.sh](bash/qemu_guest_agent.sh)** | VM management | ✅ Stable | QEMU guest agent setup |
| **[ssh_key.sh](bash/ssh_key.sh)** | SSH key generation | ✅ Stable | Secure key creation |

### 🐍 Python Utilities
| Module | Purpose | Features |
|--------|---------|----------|
| **[utils.py](python/new_project/utils.py)** | Core utilities | Secure logging, random generation |
| **[validators.py](python/new_project/validators.py)** | Input validation | Email validation, security checks |

### 💻 PowerShell Scripts
| Script | Purpose | Platform |
|--------|---------|----------|
| **[datadog-download-install.ps1](powershell/old/datadog-download-install.ps1)** | Monitoring setup | Windows |
| **[powershell_function_download_file.ps1](powershell/old/powershell_function_download_file.ps1)** | File utilities | Windows |

### 📊 Excel/VBA Automation
| Tool | Purpose | Capability |
|------|---------|------------|
| **Hyperlink Extraction** | Link management | Extract and organize hyperlinks |
| **Dynamic Dropdowns** | Data validation | Multi-selection, conditional lists |
| **Chart Protection** | Worksheet security | Protected editing capabilities |

### 🛡️ Security & Vulnerability Fixes
| Fix | CVE/Issue | Platform |
|-----|-----------|----------|
| **Adobe Flash Removal** | Security cleanup | Windows |
| **CVE-2013-3900** | Authenticode bypass | Windows |
| **LAN Manager Hash** | Weak authentication | Windows |
| **Registry Security** | DDE, Defender controls | Windows |

## 🚀 Quick Start Guide

### Prerequisites
```bash
# Linux (Alpine)
apk add gnupg msmtp pass git

# Linux (Fedora)
dnf install gnupg2 msmtp pass git

# Linux (Ubuntu/Debian)
apt install gnupg msmtp pass git
```

### Installation
```bash
# Clone repository
git clone https://github.com/talltechy/scripts_snippets.git
cd scripts_snippets

# Make scripts executable
find bash/ -name "*.sh" -exec chmod +x {} \;

# Quick test with flagship tool
cd bash/create_admin_user
./create_admin_user.sh --help
```

## 💼 Enterprise Features

### 🔒 Security-First Design
- **Input Validation**: All user inputs validated before processing
- **Secure Defaults**: Security-first configuration with explicit opt-outs
- **Audit Logging**: Comprehensive logging for security-sensitive operations
- **Credential Protection**: GPG encryption for sensitive data
- **Permission Management**: Restrictive file permissions (600) for sensitive files

### 🤖 Automation Ready
- **Non-Interactive Mode**: Full automation support for CI/CD pipelines
- **Configuration Management**: File-based configuration with templates
- **Dry-Run Testing**: Validate operations before execution
- **Backup Systems**: Intelligent backup with automatic cleanup
- **Error Handling**: Graceful failure with clear, actionable messages

### 📊 Professional Interface
- **Beautiful CLI**: Color-coded output with Unicode graphics
- **Progress Tracking**: Visual progress bars and step indicators
- **Status Symbols**: Consistent emoji/symbol usage (✅ ✗ ⚠️ 🔍 ❌ ℹ️ 💡)
- **Structured Output**: Clear visual hierarchy with headers and dividers
- **Accessibility**: Color + symbol combinations for better accessibility

## 🔒 Security Approach

### Threat Model
- **Privilege Escalation**: Granular sudo permissions prevent over-privileging
- **Credential Exposure**: GPG encryption for all sensitive data
- **Input Attacks**: Comprehensive validation prevents injection attacks
- **Audit Requirements**: Detailed logging for compliance and forensics

### Security Standards
- **OWASP Compliance**: Following secure coding practices
- **Principle of Least Privilege**: Minimal required permissions
- **Defense in Depth**: Multiple security layers
- **Secure by Default**: Security-first configuration

## 📋 Platform Compatibility Matrix

| Platform | Bash | Python | PowerShell | VBA | Registry |
|----------|------|--------|------------|-----|----------|
| **Alpine Linux** | ✅ Full | ✅ Full | ❌ N/A | ❌ N/A | ❌ N/A |
| **Fedora** | ✅ Full | ✅ Full | ❌ N/A | ❌ N/A | ❌ N/A |
| **Ubuntu/Debian** | ✅ Full | ✅ Full | ❌ N/A | ❌ N/A | ❌ N/A |
| **Windows 10/11** | ⚠️ WSL | ✅ Full | ✅ Full | ✅ Full | ✅ Full |
| **Windows Server** | ⚠️ WSL | ✅ Full | ✅ Full | ✅ Full | ✅ Full |
| **macOS** | ✅ Limited | ✅ Full | ❌ N/A | ❌ N/A | ❌ N/A |

## 📖 Documentation & Examples

### 📚 Comprehensive Documentation
- **[Installation Guide](INSTALL.md)**: Platform-specific setup instructions
- **[Security Documentation](SECURITY.md)**: Security practices and considerations
- **[Contributing Guidelines](CONTRIBUTING.md)**: Development and contribution process
- **[Code of Conduct](CODE_OF_CONDUCT.md)**: Community standards

### 💡 Usage Examples

#### Enterprise User Management
```bash
# Interactive setup with beautiful interface
./create_admin_user.sh

# Automated deployment with configuration
./create_admin_user.sh --config production.conf --non-interactive

# Security validation and testing
./create_admin_user.sh --dry-run --validate-only
```

#### System Automation
```bash
# Configure automated updates
./auto-update.sh --setup

# Run updates with email notifications
./auto-update.sh --email admin@company.com
```

#### Python Utilities
```python
from python.new_project.utils import setup_logging, secure_random_string
from python.new_project.validators import validate_email

# Setup secure logging
logger = setup_logging("myapp", "/var/log/myapp.log")

# Generate secure passwords
password = secure_random_string(16)

# Validate user input
if validate_email(user_email):
    logger.info(f"Valid email provided: {user_email}")
```

## 🤝 Contributing & Community

### Contributing
We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) for:
- Code standards and quality requirements
- Security review process
- Documentation requirements
- Testing procedures

### Quality Standards
- **Security First**: All contributions undergo security review
- **Documentation**: Comprehensive documentation required
- **Testing**: Manual testing across target platforms
- **Code Review**: All changes reviewed before merge

### Community
- **Issues**: Report bugs and request features via GitHub Issues
- **Discussions**: Join community discussions for support and ideas
- **Security**: Report security issues privately to maintainers

## 🏗️ Architecture & Design

### Design Principles
- **Security by Design**: Security considerations built into every tool
- **User Experience**: Professional, accessible interfaces
- **Cross-Platform**: Support for diverse environments
- **Maintainability**: Clear organization and comprehensive documentation

### Technical Patterns
- **Error Handling**: Graceful failure with clear error messages
- **Logging**: Structured, timestamped log entries
- **Configuration**: File-based configuration with secure defaults
- **Validation**: Comprehensive input validation and testing

## 📊 Project Statistics

- **🔧 Total Scripts**: 25+ automation tools
- **🌐 Platforms**: Linux, Windows, macOS support
- **🔒 Security Tools**: 8+ vulnerability fixes and hardening scripts
- **📚 Documentation**: Comprehensive guides and examples
- **🏆 Flagship Tools**: Enterprise-grade user management suite

## 📄 License & Acknowledgments

### License
This project is licensed under the [CC0 1.0 Universal](LICENSE.md) Creative Commons License - dedicated to the public domain for maximum utility and adoption.

### Authors
- **Matt Wyen** - *Project Creator & Maintainer* - [talltechy](https://github.com/talltechy)

### Acknowledgments
- **Billie Thompson** - *README Template* - [PurpleBooth](https://github.com/PurpleBooth)
- **Security Community** - Vulnerability research and responsible disclosure
- **Open Source Contributors** - Community feedback and improvements
- **Enterprise Users** - Real-world testing and feature requirements

---

## 🎯 Getting Started

Ready to automate your infrastructure? Start with our flagship **Admin User Creation Suite**:

```bash
git clone https://github.com/talltechy/scripts_snippets.git
cd scripts_snippets/bash/create_admin_user
./create_admin_user.sh
```

Experience enterprise-grade automation with beautiful interfaces, comprehensive security, and professional documentation. 🚀

---

*Built with ❤️ for system administrators, DevOps engineers, and automation enthusiasts worldwide.*
