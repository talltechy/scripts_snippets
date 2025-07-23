# Usage Examples & Patterns 💡

This guide provides comprehensive examples demonstrating the advanced capabilities and real-world usage patterns of the Scripts & Snippets repository tools.

## 🏆 Flagship Tool Examples

### 🔐 Admin User Creation Suite

#### Basic Interactive Usage
```bash
cd bash/create_admin_user
./create_admin_user.sh
```
**Output Preview:**
```
╔══════════════════════════════════════════════════════════╗
║             Admin User Creation Script v2.1.1             ║
╚══════════════════════════════════════════════════════════╝

[1/6] 🔍 System Validation
✅ Running as root
✅ System compatibility confirmed
✅ Required tools available

[2/6] 👤 User Configuration
Enter username: jdoe
Enter full name: John Doe
Enter email: john.doe@company.com
```

#### Enterprise Automation with Configuration
```bash
# Create production configuration
cat > production.conf << EOF
USERNAME="deploy"
FULLNAME="Deployment User"
EMAIL="deploy@company.com"
SUDO_LEVEL="standard"
SSH_KEY_TYPE="ed25519"
SSH_KEY_BITS="4096"
BACKUP_ENABLED="true"
NOTIFICATION_EMAIL="admin@company.com"
EOF

# Deploy with configuration
./create_admin_user.sh --config production.conf --non-interactive
```

#### Security Validation and Testing
```bash
# Dry-run mode - validate without changes
./create_admin_user.sh --config production.conf --dry-run

# Validation-only mode - check system readiness
./create_admin_user.sh --validate-only

# Setup verification - confirm existing user setup
./create_admin_user.sh --verify-setup jdoe
```

#### Advanced Security Scenarios
```bash
# Minimal sudo permissions (most secure)
./create_admin_user.sh --sudo-level minimal --config secure.conf

# Full admin access (use with caution)
./create_admin_user.sh --sudo-level full --backup-existing

# Custom SSH key with expiry
./create_admin_user.sh --ssh-key-type rsa --ssh-key-bits 4096 --key-expiry 90
```

### 🔄 System Update Automation

#### Basic Update with Email Notifications
```bash
# Setup email configuration
./auto-update.sh --setup
# Follow prompts to configure SMTP settings

# Run updates with notifications
./auto-update.sh --email admin@company.com
```

#### Advanced Update Scenarios
```bash
# Scheduled updates with comprehensive logging
./auto-update.sh --schedule weekly --log-level verbose --email-on-error

# Emergency security updates only
./auto-update.sh --security-only --force --notify-all

# Test mode - check for updates without applying
./auto-update.sh --check-only --report-email admin@company.com
```

## 🐍 Python Utilities Examples

### Secure Logging Implementation
```python
#!/usr/bin/env python3
"""
Example: Secure application logging with the utils module
"""
import sys
import os

# Add the utils module to path
sys.path.append('python/new_project')

from utils import setup_logging, secure_random_string
from validators import validate_email

def main():
    # Setup secure logging
    logger = setup_logging(
        app_name="myapp",
        log_file="/var/log/myapp.log",
        log_level="INFO"
    )
    
    logger.info("Application started")
    
    # Generate secure session token
    session_token = secure_random_string(32)
    logger.info(f"Generated session token: {session_token[:8]}...")
    
    # Validate user input
    user_email = input("Enter email: ")
    if validate_email(user_email):
        logger.info(f"Valid email provided: {user_email}")
        print("✅ Email validation successful")
    else:
        logger.warning(f"Invalid email attempted: {user_email}")
        print("❌ Invalid email format")
    
    logger.info("Application completed")

if __name__ == "__main__":
    main()
```

### Input Validation Patterns
```python
#!/usr/bin/env python3
"""
Example: Comprehensive input validation
"""
import sys
sys.path.append('python/new_project')

from validators import validate_email

def validate_user_registration(username, email, password):
    """Validate user registration data"""
    errors = []
    
    # Username validation
    if not username or len(username) < 3:
        errors.append("Username must be at least 3 characters")
    
    if not username.isalnum():
        errors.append("Username must contain only letters and numbers")
    
    # Email validation
    if not validate_email(email):
        errors.append("Invalid email format")
    
    # Password validation (basic example)
    if len(password) < 8:
        errors.append("Password must be at least 8 characters")
    
    return errors

# Example usage
def main():
    print("🔐 User Registration Validator")
    print("=" * 40)
    
    username = input("Username: ")
    email = input("Email: ")
    password = input("Password: ")
    
    errors = validate_user_registration(username, email, password)
    
    if errors:
        print("\n❌ Validation Errors:")
        for error in errors:
            print(f"  • {error}")
    else:
        print("\n✅ All validation checks passed!")

if __name__ == "__main__":
    main()
```

## 💻 PowerShell Examples

### Automated Software Installation
```powershell
# Example: Automated Datadog agent deployment
param(
    [string]$ApiKey,
    [string]$Site = "datadoghq.com",
    [switch]$Silent
)

# Load the installation script
. .\powershell\old\datadog-download-install.ps1

# Configure installation parameters
$InstallParams = @{
    ApiKey = $ApiKey
    Site = $Site
    Silent = $Silent
    LogPath = "C:\Logs\datadog-install.log"
}

# Execute installation
try {
    Install-DatadogAgent @InstallParams
    Write-Host "✅ Datadog agent installed successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Installation failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
```

### File Download Utility
```powershell
# Example: Secure file download with validation
. .\powershell\old\powershell_function_download_file.ps1

# Download with integrity checking
$DownloadParams = @{
    Url = "https://example.com/software.msi"
    OutputPath = "C:\Temp\software.msi"
    CheckSum = "SHA256:abc123..."
    MaxRetries = 3
    TimeoutSeconds = 300
}

try {
    Download-FileSecure @DownloadParams
    Write-Host "✅ File downloaded and verified" -ForegroundColor Green
} catch {
    Write-Host "❌ Download failed: $($_.Exception.Message)" -ForegroundColor Red
}
```

## 📊 Excel/VBA Examples

### Hyperlink Extraction and Management
```vba
' Example: Extract and organize hyperlinks from worksheets
Sub ExtractAndOrganizeHyperlinks()
    Dim ws As Worksheet
    Dim hlnk As Hyperlink
    Dim outputWs As Worksheet
    Dim row As Long
    
    ' Create output worksheet
    Set outputWs = Worksheets.Add
    outputWs.Name = "Extracted_Links"
    
    ' Headers
    outputWs.Cells(1, 1) = "Source Sheet"
    outputWs.Cells(1, 2) = "Cell Address"
    outputWs.Cells(1, 3) = "Display Text"
    outputWs.Cells(1, 4) = "URL"
    outputWs.Cells(1, 5) = "Link Type"
    
    row = 2
    
    ' Process all worksheets
    For Each ws In Worksheets
        If ws.Name <> "Extracted_Links" Then
            For Each hlnk In ws.Hyperlinks
                outputWs.Cells(row, 1) = ws.Name
                outputWs.Cells(row, 2) = hlnk.Range.Address
                outputWs.Cells(row, 3) = hlnk.TextToDisplay
                outputWs.Cells(row, 4) = hlnk.Address
                outputWs.Cells(row, 5) = DetermineUrlType(hlnk.Address)
                row = row + 1
            Next hlnk
        End If
    Next ws
    
    ' Format output
    outputWs.Range("A1:E1").Font.Bold = True
    outputWs.Columns.AutoFit
    
    MsgBox "✅ Hyperlinks extracted successfully! Found " & (row - 2) & " links."
End Sub

Function DetermineUrlType(url As String) As String
    If InStr(url, "mailto:") > 0 Then
        DetermineUrlType = "Email"
    ElseIf InStr(url, "http") > 0 Then
        DetermineUrlType = "Web"
    ElseIf InStr(url, "file:") > 0 Then
        DetermineUrlType = "File"
    Else
        DetermineUrlType = "Other"
    End If
End Function
```

### Dynamic Dropdown Management
```vba
' Example: Create cascading dropdown lists
Sub CreateCascadingDropdowns()
    Dim ws As Worksheet
    Set ws = ActiveSheet
    
    ' Create main category dropdown
    With ws.Range("B2").Validation
        .Delete
        .Add Type:=xlValidateList, _
             AlertStyle:=xlValidAlertStop, _
             Formula1:="Hardware,Software,Services"
        .IgnoreBlank = True
        .InCellDropdown = True
    End With
    
    ' Create dependent dropdown
    With ws.Range("C2").Validation
        .Delete
        .Add Type:=xlValidateList, _
             AlertStyle:=xlValidAlertStop, _
             Formula1:="=INDIRECT(B2)"
        .IgnoreBlank = True
        .InCellDropdown = True
    End With
    
    ' Create named ranges for categories
    CreateNamedRanges
    
    MsgBox "✅ Cascading dropdowns created successfully!"
End Sub

Sub CreateNamedRanges()
    ' Hardware options
    Range("F2:F5").Name = "Hardware"
    Range("F2:F5") = Application.Transpose(Array("Servers", "Laptops", "Monitors", "Printers"))
    
    ' Software options
    Range("G2:G4").Name = "Software"
    Range("G2:G4") = Application.Transpose(Array("Windows", "Office", "Antivirus"))
    
    ' Services options
    Range("H2:H3").Name = "Services"
    Range("H2:H3") = Application.Transpose(Array("Support", "Training"))
End Sub
```

## 🛡️ Security & Vulnerability Fix Examples

### Adobe Flash Removal
```powershell
# Example: Automated Adobe Flash removal across enterprise
param(
    [string[]]$ComputerNames,
    [string]$LogPath = "C:\Logs\flash-removal.log"
)

# Load the removal script
. .\Vulnerability_Fix\adobe_flash\uninstall_flash.ps1

foreach ($Computer in $ComputerNames) {
    try {
        Write-Host "🔍 Processing $Computer..." -ForegroundColor Yellow
        
        # Execute removal on remote computer
        Invoke-Command -ComputerName $Computer -ScriptBlock {
            # Run the flash removal script
            & "\\server\scripts\uninstall_flash.ps1" -Silent
        }
        
        Write-Host "✅ Flash removed from $Computer" -ForegroundColor Green
        Add-Content -Path $LogPath -Value "$(Get-Date): SUCCESS - $Computer"
        
    } catch {
        Write-Host "❌ Failed to process $Computer`: $($_.Exception.Message)" -ForegroundColor Red
        Add-Content -Path $LogPath -Value "$(Get-Date): ERROR - $Computer - $($_.Exception.Message)"
    }
}
```

### Registry Security Hardening
```batch
@echo off
REM Example: Automated security hardening deployment

echo 🔒 Applying Security Hardening...
echo ================================

REM Disable DDE Auto-execution
echo [1/3] Disabling DDE Auto-execution...
regedit /s "windows\registry\old\disable_ddeauto.reg"
if %errorlevel% equ 0 (
    echo ✅ DDE Auto-execution disabled
) else (
    echo ❌ Failed to disable DDE Auto-execution
)

REM Configure Windows Defender
echo [2/3] Configuring Windows Defender...
regedit /s "windows\registry\old\Enable_Windows_Defender_Security_Center.reg"
if %errorlevel% equ 0 (
    echo ✅ Windows Defender configured
) else (
    echo ❌ Failed to configure Windows Defender
)

REM Apply LAN Manager hash fix
echo [3/3] Applying LAN Manager hash fix...
powershell -ExecutionPolicy Bypass -File "Vulnerability_Fix\VULN Fix\Weak_LAN_Manager_hashing_permitted.ps1"
if %errorlevel% equ 0 (
    echo ✅ LAN Manager hash fix applied
) else (
    echo ❌ Failed to apply LAN Manager hash fix
)

echo.
echo 🎉 Security hardening complete!
echo Please reboot the system to ensure all changes take effect.
pause
```

## 🏢 Enterprise Integration Examples

### CI/CD Pipeline Integration
```yaml
# Example: GitHub Actions workflow using the scripts
name: Infrastructure Automation

on:
  push:
    branches: [main]
  schedule:
    - cron: '0 2 * * 1'  # Weekly on Monday at 2 AM

jobs:
  deploy-users:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Scripts
        run: |
          chmod +x bash/create_admin_user/create_admin_user.sh
          chmod +x bash/auto-update.sh
      
      - name: Deploy Admin Users
        run: |
          # Create configuration from secrets
          cat > deploy.conf << EOF
          USERNAME="${{ secrets.DEPLOY_USERNAME }}"
          FULLNAME="CI/CD Deploy User"
          EMAIL="${{ secrets.DEPLOY_EMAIL }}"
          SUDO_LEVEL="standard"
          SSH_KEY_TYPE="ed25519"
          BACKUP_ENABLED="true"
          EOF
          
          # Deploy with dry-run first
          ./bash/create_admin_user/create_admin_user.sh --config deploy.conf --dry-run
          
          # Deploy for real if dry-run succeeds
          ./bash/create_admin_user/create_admin_user.sh --config deploy.conf --non-interactive
      
      - name: System Updates
        run: |
          ./bash/auto-update.sh --security-only --email ${{ secrets.ADMIN_EMAIL }}
```

### Ansible Playbook Integration
```yaml
# Example: Ansible playbook using the scripts
---
- name: Deploy Scripts & Snippets Tools
  hosts: linux_servers
  become: yes
  vars:
    scripts_repo: "https://github.com/talltechy/scripts_snippets.git"
    install_dir: "/opt/scripts_snippets"
    
  tasks:
    - name: Clone scripts repository
      git:
        repo: "{{ scripts_repo }}"
        dest: "{{ install_dir }}"
        version: main
        
    - name: Set script permissions
      file:
        path: "{{ install_dir }}/bash"
        mode: '0755'
        recurse: yes
        
    - name: Create admin users from inventory
      command: >
        {{ install_dir }}/bash/create_admin_user/create_admin_user.sh
        --username {{ item.username }}
        --fullname "{{ item.fullname }}"
        --email {{ item.email }}
        --sudo-level {{ item.sudo_level | default('standard') }}
        --non-interactive
      loop: "{{ admin_users }}"
      register: user_creation
      
    - name: Setup automated updates
      command: >
        {{ install_dir }}/bash/auto-update.sh
        --setup
        --email {{ admin_email }}
        --schedule weekly
```

### Docker Container Usage
```dockerfile
# Example: Multi-stage Docker build with scripts
FROM alpine:latest AS scripts-base

# Install dependencies
RUN apk add --no-cache bash git gnupg msmtp pass python3

# Clone and setup scripts
RUN git clone https://github.com/talltechy/scripts_snippets.git /opt/scripts
RUN find /opt/scripts/bash/ -name "*.sh" -exec chmod +x {} \;

# Production stage
FROM alpine:latest AS production

# Copy scripts from base stage
COPY --from=scripts-base /opt/scripts /opt/scripts

# Install runtime dependencies
RUN apk add --no-cache bash gnupg msmtp pass

# Create entrypoint script
RUN cat > /entrypoint.sh << 'EOF'
#!/bin/bash
set -e

# Initialize GPG if needed
if [ ! -d ~/.gnupg ]; then
    gpg --batch --generate-key << GPGEOF
Key-Type: RSA
Key-Length: 2048
Name-Real: Container User
Name-Email: container@example.com
Expire-Date: 1y
%no-protection
%commit
GPGEOF
fi

# Execute the requested script
exec "$@"
EOF

RUN chmod +x /entrypoint.sh

WORKDIR /opt/scripts
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
```

## 🔄 Automation Patterns

### Cron Job Integration
```bash
#!/bin/bash
# Example: Comprehensive cron job setup

# Create cron jobs for automated maintenance
cat > /etc/cron.d/scripts-snippets << 'EOF'
# Scripts & Snippets Automation
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# Weekly system updates (Sundays at 2 AM)
0 2 * * 0 root /opt/scripts_snippets/bash/auto-update.sh --email admin@company.com

# Monthly user audit (First day of month at 3 AM)
0 3 1 * * root /opt/scripts_snippets/bash/create_admin_user/create_admin_user.sh --audit-users --report-email security@company.com

# Daily backup verification (Every day at 1 AM)
0 1 * * * root /opt/scripts_snippets/bash/create_admin_user/create_admin_user.sh --verify-backups --log-only
EOF

# Set proper permissions
chmod 644 /etc/cron.d/scripts-snippets

echo "✅ Cron jobs configured successfully"
```

### Systemd Service Integration
```ini
# Example: Systemd service for automated updates
# File: /etc/systemd/system/auto-update.service
[Unit]
Description=Automated System Updates
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
User=root
ExecStart=/opt/scripts_snippets/bash/auto-update.sh --email admin@company.com
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

```ini
# Example: Systemd timer for weekly execution
# File: /etc/systemd/system/auto-update.timer
[Unit]
Description=Run auto-update weekly
Requires=auto-update.service

[Timer]
OnCalendar=Sun 02:00
Persistent=true

[Install]
WantedBy=timers.target
```

```bash
# Enable and start the service
systemctl enable auto-update.service
systemctl enable auto-update.timer
systemctl start auto-update.timer

# Check status
systemctl status auto-update.timer
```

## 🧪 Testing and Validation Examples

### Comprehensive Testing Script
```bash
#!/bin/bash
# Example: Comprehensive testing and validation

set -euo pipefail

SCRIPT_DIR="/opt/scripts_snippets"
LOG_FILE="/var/log/scripts-test.log"
EMAIL="admin@company.com"

echo "🧪 Starting comprehensive testing..." | tee -a "$LOG_FILE"

# Test 1: Repository integrity
echo "[1/5] Testing repository integrity..." | tee -a "$LOG_FILE"
cd "$SCRIPT_DIR"
if git fsck --full; then
    echo "✅ Repository integrity check passed" | tee -a "$LOG_FILE"
else
    echo "❌ Repository integrity check failed" | tee -a "$LOG_FILE"
    exit 1
fi

# Test 2: Script permissions and syntax
echo "[2/5] Testing script permissions and syntax..." | tee -a "$LOG_FILE"
find bash/ -name "*.sh" | while read script; do
    if [ -x "$script" ]; then
        if bash -n "$script"; then
            echo "✅ $script: syntax OK" | tee -a "$LOG_FILE"
        else
            echo "❌ $script: syntax error" | tee -a "$LOG_FILE"
        fi
    else
        echo "⚠️  $script: not executable" | tee -a "$LOG_FILE"
    fi
done

# Test 3: Flagship tool dry-run
echo "[3/5] Testing flagship tool..." | tee -a "$LOG_FILE"
cd bash/create_admin_user
if ./create_admin_user.sh --validate-only; then
    echo "✅ Flagship tool validation passed" | tee -a "$LOG_FILE"
else
    echo "❌ Flagship tool validation failed" | tee -a "$LOG_FILE"
fi

# Test 4: Python modules
echo "[4/5] Testing Python modules..." | tee -a "$LOG_FILE"
cd ../../python/new_project
if python3 -c "from utils import setup_logging; from validators import validate_email; print('Modules OK')"; then
    echo "✅ Python modules test passed" | tee -a "$LOG_FILE"
else
    echo "❌ Python modules test failed" | tee -a "$LOG_FILE"
fi

# Test 5: Security configuration
echo "[5/5] Testing security configuration..." | tee -a "$LOG_FILE"
cd ../../
if gpg --list-keys >/dev/null 2>&1; then
    echo "✅ GPG configuration OK" | tee -a "$LOG_FILE"
else
    echo "⚠️  GPG not configured" | tee -a "$LOG_FILE"
fi

echo "🎉 Testing complete! Check $LOG_FILE for details." | tee -a "$LOG_FILE"

# Email results
if command -v msmtp >/dev/null 2>&1; then
    {
        echo "Subject: Scripts & Snippets Test Results"
        echo "To: $EMAIL"
        echo ""
        echo "Testing completed at $(date)"
        echo ""
        tail -20 "$LOG_FILE"
    } | msmtp "$EMAIL"
fi
```

## 📊 Monitoring and Reporting Examples

### Advanced Logging and Monitoring
```bash
#!/bin/bash
# Example: Advanced monitoring and alerting

SCRIPT_NAME="monitoring-example"
LOG_DIR="/var/log/scripts_snippets"
ALERT_EMAIL="alerts@company.com"

# Setup logging
mkdir -p "$LOG_DIR"
exec 1> >(tee -a "$LOG_DIR/$SCRIPT_NAME.log")
exec 2> >(tee -a "$LOG_DIR/$SCRIPT_NAME.error.log" >&2)

# Function to send alerts
send_alert() {
    local severity=$1
    local message=$2
    
    {
        echo "Subject: [$severity] Scripts & Snippets Alert"
        echo "To: $ALERT_EMAIL"
        echo ""
        echo "Alert Time: $(date)"
        echo "Severity: $severity"
        echo "Message: $message"
        echo ""
        echo "System Information:"
        echo "Hostname: $(hostname)"
        echo "Uptime: $(uptime)"
        echo "Disk Usage: $(df -h / | tail -1)"
        echo "Memory Usage: $(free -h | grep Mem)"
    } | msmtp "$ALERT_EMAIL"
}

# Monitor script execution
monitor_script() {
    local script_path=$1
    local max_runtime=${2:-300}  # 5 minutes default
    
    echo "🔍 Monitoring: $script_path"
    
    # Start script in background
    timeout "$max_runtime" "$script_path" &
    local pid=$!
    
    # Wait for completion
    if wait $pid; then
        echo "✅ Script completed successfully"
        return 0
    else
        local exit_code=$?
        echo "❌ Script failed with exit code: $exit_code"
        send_alert "ERROR" "Script $script_path failed with exit code $exit_code"
        return $exit_code
    fi
}

# Example usage
monitor_script "/opt/scripts_snippets/bash/auto-update.sh" 600
monitor_script "/opt/scripts_snippets/bash/create_admin_user/create_admin_user.sh --validate-only" 60
```

---

## 🎯 Best Practices Summary

### Security Best Practices
- Always use dry-run mode before production deployment
- Validate configurations before applying changes
- Use minimal required permissions (principle of least privilege)
- Enable comprehensive logging for audit trails
- Encrypt sensitive data with GPG
- Regular security validation and testing

### Automation Best Practices
- Use configuration files for consistent deployments
- Implement proper error handling and rollback mechanisms
- Test in non-production environments first
- Use version control for configuration management
- Monitor and alert on script execution
- Document all automation workflows

### Integration Best Practices
- Use standardized interfaces (CLI arguments, exit codes)
- Implement proper logging for troubleshooting
- Design for idempotency (safe to run multiple times)
- Use configuration management tools for scale
- Implement health checks and validation
- Plan for disaster recovery scenarios

---

*Examples guide last updated: January 2025*
