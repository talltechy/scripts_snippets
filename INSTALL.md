# Installation Guide 📦

This guide provides comprehensive installation instructions for the Scripts & Snippets repository across different platforms and use cases.

## 🚀 Quick Installation

### One-Line Install (Linux/macOS)
```bash
git clone https://github.com/talltechy/scripts_snippets.git && cd scripts_snippets && find bash/ -name "*.sh" -exec chmod +x {} \;
```

### Windows (PowerShell)
```powershell
git clone https://github.com/talltechy/scripts_snippets.git
cd scripts_snippets
# PowerShell scripts are ready to use
```

## 📋 Prerequisites by Platform

### 🐧 Linux (All Distributions)

#### Essential Dependencies
```bash
# Core tools (usually pre-installed)
which git bash chmod find

# Security tools (required for flagship scripts)
# Alpine Linux
apk add gnupg msmtp pass

# Fedora/RHEL/CentOS
dnf install gnupg2 msmtp pass

# Ubuntu/Debian
apt update && apt install gnupg msmtp pass

# Arch Linux
pacman -S gnupg msmtp pass
```

#### Optional Dependencies
```bash
# For enhanced email functionality
# Alpine
apk add mailx s-nail

# Fedora/RHEL
dnf install mailx

# Ubuntu/Debian
apt install mailutils

# For development and testing
# Alpine
apk add curl wget jq

# Fedora/RHEL
dnf install curl wget jq

# Ubuntu/Debian
apt install curl wget jq
```

### 🪟 Windows

#### PowerShell Requirements
```powershell
# Check PowerShell version (5.1+ recommended)
$PSVersionTable.PSVersion

# Enable script execution (if needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Optional Tools
```powershell
# Install Git (if not already installed)
winget install Git.Git

# Install Windows Subsystem for Linux (for bash scripts)
wsl --install

# Install Chocolatey (for package management)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### 🍎 macOS

#### Using Homebrew (Recommended)
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install gnupg msmtp pass git
```

#### Using MacPorts
```bash
# Install dependencies
sudo port install gnupg2 msmtp pass git
```

## 🔧 Detailed Installation Steps

### Step 1: Clone Repository
```bash
# HTTPS (recommended for most users)
git clone https://github.com/talltechy/scripts_snippets.git

# SSH (for contributors with SSH keys)
git clone git@github.com:talltechy/scripts_snippets.git

# Navigate to directory
cd scripts_snippets
```

### Step 2: Set Permissions (Linux/macOS)
```bash
# Make all bash scripts executable
find bash/ -name "*.sh" -exec chmod +x {} \;

# Verify permissions
ls -la bash/*.sh
ls -la bash/create_admin_user/*.sh
```

### Step 3: Verify Installation
```bash
# Test flagship tool
cd bash/create_admin_user
./create_admin_user.sh --help

# Test auto-update script
cd ../../bash
./auto-update.sh --help

# Test Python modules
cd ../python/new_project
python3 -c "from utils import setup_logging; print('Python modules working!')"
```

## 🏢 Enterprise Installation

### Centralized Deployment
```bash
# System-wide installation (requires sudo)
sudo git clone https://github.com/talltechy/scripts_snippets.git /opt/scripts_snippets
sudo chown -R root:root /opt/scripts_snippets
sudo find /opt/scripts_snippets/bash/ -name "*.sh" -exec chmod +x {} \;

# Create system-wide symlinks
sudo ln -s /opt/scripts_snippets/bash/create_admin_user/create_admin_user.sh /usr/local/bin/create-admin-user
sudo ln -s /opt/scripts_snippets/bash/auto-update.sh /usr/local/bin/auto-update
```

### Configuration Management
```bash
# Create system configuration directory
sudo mkdir -p /etc/scripts_snippets

# Copy configuration templates
sudo cp /opt/scripts_snippets/bash/create_admin_user/config.example /etc/scripts_snippets/create_admin_user.conf
sudo cp /opt/scripts_snippets/bash/auto-update.env /etc/scripts_snippets/auto-update.env

# Set secure permissions
sudo chmod 600 /etc/scripts_snippets/*.conf
sudo chmod 600 /etc/scripts_snippets/*.env
```

### Automated Deployment Script
```bash
#!/bin/bash
# enterprise-install.sh - Automated enterprise deployment

set -euo pipefail

INSTALL_DIR="/opt/scripts_snippets"
CONFIG_DIR="/etc/scripts_snippets"
BIN_DIR="/usr/local/bin"

echo "🚀 Starting enterprise installation..."

# Clone repository
if [ ! -d "$INSTALL_DIR" ]; then
    git clone https://github.com/talltechy/scripts_snippets.git "$INSTALL_DIR"
else
    cd "$INSTALL_DIR" && git pull
fi

# Set ownership and permissions
chown -R root:root "$INSTALL_DIR"
find "$INSTALL_DIR/bash/" -name "*.sh" -exec chmod +x {} \;

# Create configuration directory
mkdir -p "$CONFIG_DIR"

# Install configuration templates
cp "$INSTALL_DIR/bash/create_admin_user/config.example" "$CONFIG_DIR/create_admin_user.conf"
cp "$INSTALL_DIR/bash/auto-update.env" "$CONFIG_DIR/auto-update.env"
chmod 600 "$CONFIG_DIR"/*

# Create system symlinks
ln -sf "$INSTALL_DIR/bash/create_admin_user/create_admin_user.sh" "$BIN_DIR/create-admin-user"
ln -sf "$INSTALL_DIR/bash/auto-update.sh" "$BIN_DIR/auto-update"

echo "✅ Enterprise installation complete!"
echo "📖 Edit configuration files in $CONFIG_DIR"
echo "🔧 Tools available: create-admin-user, auto-update"
```

## 🐳 Container Installation

### Docker Setup
```dockerfile
# Dockerfile for scripts_snippets
FROM alpine:latest

# Install dependencies
RUN apk add --no-cache bash git gnupg msmtp pass python3

# Clone repository
RUN git clone https://github.com/talltechy/scripts_snippets.git /opt/scripts_snippets

# Set permissions
RUN find /opt/scripts_snippets/bash/ -name "*.sh" -exec chmod +x {} \;

# Set working directory
WORKDIR /opt/scripts_snippets

# Default command
CMD ["/bin/bash"]
```

```bash
# Build and run container
docker build -t scripts_snippets .
docker run -it scripts_snippets

# Or use docker-compose
cat > docker-compose.yml << EOF
version: '3.8'
services:
  scripts_snippets:
    build: .
    volumes:
      - ./config:/etc/scripts_snippets
      - ./logs:/var/log
    environment:
      - SCRIPTS_CONFIG_DIR=/etc/scripts_snippets
EOF

docker-compose up -d
```

## 🔒 Security Configuration

### GPG Setup (Required for Email Features)
```bash
# Generate GPG key for script automation
gpg --full-generate-key

# List keys
gpg --list-secret-keys --keyid-format LONG

# Export public key (for sharing)
gpg --armor --export YOUR_KEY_ID > public_key.asc

# Test encryption/decryption
echo "test password" | gpg --encrypt --armor -r YOUR_EMAIL > test.gpg
gpg --decrypt test.gpg
```

### Password Store Setup
```bash
# Initialize password store
pass init YOUR_GPG_KEY_ID

# Store SMTP password
pass insert smtp/password

# Test retrieval
pass show smtp/password
```

### File Permissions Audit
```bash
# Check sensitive file permissions
find . -name "*.env" -exec ls -la {} \;
find . -name "*.conf" -exec ls -la {} \;
find . -name "*.key" -exec ls -la {} \;

# Fix permissions if needed
find . -name "*.env" -exec chmod 600 {} \;
find . -name "*.conf" -exec chmod 600 {} \;
```

## 🧪 Testing Installation

### Comprehensive Test Script
```bash
#!/bin/bash
# test-installation.sh - Verify installation

echo "🧪 Testing Scripts & Snippets Installation"
echo "=========================================="

# Test 1: Repository structure
echo "📁 Checking repository structure..."
for dir in bash python powershell excel Vulnerability_Fix windows; do
    if [ -d "$dir" ]; then
        echo "✅ $dir directory found"
    else
        echo "❌ $dir directory missing"
    fi
done

# Test 2: Script permissions
echo -e "\n🔐 Checking script permissions..."
find bash/ -name "*.sh" -not -executable -print | while read script; do
    echo "❌ $script is not executable"
done

# Test 3: Dependencies
echo -e "\n📦 Checking dependencies..."
for cmd in git bash gnupg msmtp pass; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "✅ $cmd found"
    else
        echo "⚠️  $cmd not found (may be optional)"
    fi
done

# Test 4: Flagship tool
echo -e "\n🏆 Testing flagship tool..."
if [ -x "bash/create_admin_user/create_admin_user.sh" ]; then
    cd bash/create_admin_user
    if ./create_admin_user.sh --help >/dev/null 2>&1; then
        echo "✅ create_admin_user.sh working"
    else
        echo "❌ create_admin_user.sh has issues"
    fi
    cd ../..
else
    echo "❌ create_admin_user.sh not executable"
fi

# Test 5: Python modules
echo -e "\n🐍 Testing Python modules..."
if python3 -c "import sys; sys.path.append('python/new_project'); from utils import setup_logging; print('✅ Python modules working')" 2>/dev/null; then
    echo "✅ Python modules working"
else
    echo "⚠️  Python modules may have issues"
fi

echo -e "\n🎉 Installation test complete!"
```

## 🔄 Updates and Maintenance

### Automatic Updates
```bash
# Create update script
cat > update-scripts.sh << 'EOF'
#!/bin/bash
cd /opt/scripts_snippets || exit 1
git pull origin main
find bash/ -name "*.sh" -exec chmod +x {} \;
echo "✅ Scripts updated successfully"
EOF

chmod +x update-scripts.sh

# Add to crontab for weekly updates
echo "0 2 * * 0 /opt/scripts_snippets/update-scripts.sh" | crontab -
```

### Version Management
```bash
# Check current version
git describe --tags --always

# List available versions
git tag -l

# Switch to specific version
git checkout v2.1.1

# Return to latest
git checkout main
```

## 🆘 Troubleshooting

### Common Issues

#### Permission Denied
```bash
# Fix: Make scripts executable
chmod +x bash/*.sh
find bash/ -name "*.sh" -exec chmod +x {} \;
```

#### Missing Dependencies
```bash
# Fix: Install missing packages
# Alpine
apk add gnupg msmtp pass

# Ubuntu/Debian
apt install gnupg msmtp pass

# Fedora
dnf install gnupg2 msmtp pass
```

#### GPG Issues
```bash
# Fix: Check GPG configuration
gpg --list-keys
gpg --list-secret-keys

# Regenerate if needed
gpg --full-generate-key
```

#### Email Configuration
```bash
# Fix: Test SMTP settings
echo "Test message" | msmtp --debug your-email@example.com

# Check configuration
cat ~/.msmtprc
```

### Getting Help

1. **Check Documentation**: Review README.md and script-specific documentation
2. **Run with Debug**: Use `bash -x script.sh` for detailed execution trace
3. **Check Logs**: Review log files in `/var/log/` or script-specific locations
4. **Community Support**: Open an issue on GitHub with detailed error information

## 📞 Support

- **Documentation**: [README.md](README.md)
- **Issues**: [GitHub Issues](https://github.com/talltechy/scripts_snippets/issues)
- **Security**: Report security issues privately to maintainers
- **Community**: Join discussions for support and feature requests

---

*Installation guide last updated: January 2025*
