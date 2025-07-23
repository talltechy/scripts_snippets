#!/bin/bash
set -euo pipefail

# --- Script Information ---
SCRIPT_VERSION="2.2.0"
SCRIPT_NAME="create_admin_user.sh"
LAST_UPDATED="2025-07-23"

# --- Color Definitions ---
if [[ -t 1 ]]; then
    # Colors for terminal output
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly BLUE='\033[0;34m'
    readonly PURPLE='\033[0;35m'
    readonly CYAN='\033[0;36m'
    readonly WHITE='\033[1;37m'
    readonly BOLD='\033[1m'
    readonly DIM='\033[2m'
    readonly NC='\033[0m' # No Color
else
    # No colors for non-terminal output
    readonly RED=''
    readonly GREEN=''
    readonly YELLOW=''
    readonly BLUE=''
    readonly PURPLE=''
    readonly CYAN=''
    readonly WHITE=''
    readonly BOLD=''
    readonly DIM=''
    readonly NC=''
fi

# --- Configurable variables ---
DEFAULT_USERNAME="admin"
DEFAULT_SUDO_LEVEL="standard"
DEFAULT_CONFIG_FILE="/etc/create_admin_user.conf"
LOG_FILE="/var/log/create_admin_user.log"
REQUIRE_PASSPHRASE="true"
BACKUP_RETENTION_DAYS="30"
KEY_EXPIRY_DAYS="365"
GITHUB_REPO="talltechy/scripts_snippets"
VERSION_CHECK_CACHE="/tmp/.create_admin_user_version_check"
VERSION_CHECK_TIMEOUT="5"

# --- Global flags ---
DRY_RUN=false
NON_INTERACTIVE=false
VALIDATE_ONLY=false
TEST_SETUP=false
ALLOW_NO_PASSPHRASE=false
SKIP_VERSION_CHECK=false
ASSUME_YES=false
VERBOSE=false

# --- Sudo permission templates ---
get_sudo_template() {
    local level="$1"
    case "$level" in
        "minimal")
            echo "/usr/bin/systemctl status, /usr/bin/systemctl restart, /bin/ls, /bin/cat, /usr/bin/tail, /usr/bin/grep"
            ;;
        "standard")
            echo "/usr/bin/systemctl, /usr/bin/apt, /usr/bin/yum, /usr/bin/dnf, /usr/bin/docker, /usr/bin/git, /bin/mount, /bin/umount"
            ;;
        "admin")
            echo "/usr/bin/systemctl, /usr/bin/apt, /usr/bin/yum, /usr/bin/dnf, /usr/bin/docker, /usr/bin/git, /bin/mount, /bin/umount, /usr/bin/passwd, /usr/bin/usermod, /usr/bin/groupmod"
            ;;
        "full")
            echo "ALL"
            ;;
        *)
            return 1
            ;;
    esac
}

# --- Enhanced Display Functions ---
print_header() {
    local title="$1"
    local width=60
    echo -e "\n${CYAN}╔$(printf '═%.0s' $(seq 1 $((width-2))))╗${NC}"
    printf "${CYAN}║${BOLD}%*s%*s${NC}${CYAN}║${NC}\n" $(((width + ${#title}) / 2)) "$title" $(((width - ${#title}) / 2)) ""
    echo -e "${CYAN}╚$(printf '═%.0s' $(seq 1 $((width-2))))╝${NC}\n"
}

print_section() {
    local title="$1"
    echo -e "\n${BLUE}▶ ${BOLD}$title${NC}"
    echo -e "${BLUE}$(printf '─%.0s' $(seq 1 ${#title}))${NC}"
}

print_step() {
    local step="$1"
    local description="$2"
    echo -e "${PURPLE}[$step]${NC} $description"
}

print_success() {
    local message="$1"
    echo -e "${GREEN}✅ $message${NC}"
}

print_warning() {
    local message="$1"
    echo -e "${YELLOW}⚠️  $message${NC}"
}

print_error() {
    local message="$1"
    echo -e "${RED}❌ $message${NC}" >&2
}

print_info() {
    local message="$1"
    echo -e "${BLUE}ℹ️  $message${NC}"
}

print_tip() {
    local message="$1"
    echo -e "${CYAN}💡 ${DIM}Tip: $message${NC}"
}

print_divider() {
    echo -e "${BLUE}$(printf '━%.0s' $(seq 1 60))${NC}"
}

print_waiting() {
    local message="$1"
    echo -e "\n${YELLOW}⏳ ${BOLD}WAITING FOR INPUT${NC}"
    echo -e "${YELLOW}${message}${NC}\n"
}

confirm_proceed() {
    local message="${1:-Do you want to proceed?}"
    if [[ "$ASSUME_YES" == "true" ]]; then
        echo -e "${GREEN}✓ Auto-confirmed (--assume-yes)${NC}"
        return 0
    fi
    
    echo -e "\n${YELLOW}❓ ${BOLD}$message${NC} ${DIM}[y/N]${NC}"
    read -r response
    case "$response" in
        [yY]|[yY][eE][sS])
            return 0
            ;;
        *)
            echo -e "${RED}❌ Operation cancelled by user${NC}"
            return 1
            ;;
    esac
}

show_progress() {
    local current="$1"
    local total="$2"
    local description="$3"
    local width=40
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "\r${BLUE}Progress: [${GREEN}"
    printf "%*s" $filled | tr ' ' '█'
    printf "${BLUE}"
    printf "%*s" $empty | tr ' ' '░'
    printf "${BLUE}] ${BOLD}%d%%${NC} - %s" $percentage "$description"
    
    if [[ $current -eq $total ]]; then
        echo ""
    fi
}

spinner() {
    local pid=$1
    local message="$2"
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %10 ))
        printf "\r${BLUE}${spin:$i:1} $message${NC}"
        sleep 0.1
    done
    printf "\r"
}

# --- Functions ---
log() {
    local msg="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${DIM}[DRY-RUN] $timestamp - $msg${NC}"
    else
        echo "$timestamp - $msg" | tee -a "$LOG_FILE" > /dev/null
    fi
}

require_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root." >&2
        exit 1
    fi
}

load_config() {
    local config_file="${1:-$DEFAULT_CONFIG_FILE}"
    if [[ -f "$config_file" ]]; then
        log "Loading configuration from $config_file"
        # Source config file safely
        while IFS='=' read -r key value; do
            # Skip comments and empty lines
            [[ $key =~ ^[[:space:]]*# ]] && continue
            [[ -z $key ]] && continue
            
            # Remove quotes and export
            value=$(echo "$value" | sed 's/^["'\'']\|["'\'']$//g')
            case $key in
                DEFAULT_USERNAME) DEFAULT_USERNAME="$value" ;;
                DEFAULT_SUDO_LEVEL) DEFAULT_SUDO_LEVEL="$value" ;;
                REQUIRE_PASSPHRASE) REQUIRE_PASSPHRASE="$value" ;;
                BACKUP_RETENTION_DAYS) BACKUP_RETENTION_DAYS="$value" ;;
                KEY_EXPIRY_DAYS) KEY_EXPIRY_DAYS="$value" ;;
            esac
        done < "$config_file"
    fi
}

create_config_template() {
    local config_file="${1:-$DEFAULT_CONFIG_FILE}"
    if [[ "$DRY_RUN" == "true" ]]; then
        log "Would create configuration template at $config_file"
        return 0
    fi
    
    cat <<EOF > "$config_file"
# Admin User Creation Script Configuration
# Created: $(date '+%Y-%m-%d %H:%M:%S')

# Default username for user creation
DEFAULT_USERNAME="admin"

# Default sudo permission level (minimal|standard|admin|full)
DEFAULT_SUDO_LEVEL="standard"

# Require SSH key passphrase (true|false)
REQUIRE_PASSPHRASE="true"

# Backup retention in days
BACKUP_RETENTION_DAYS="30"

# SSH key expiry warning in days
KEY_EXPIRY_DAYS="365"

# Custom sudo commands (comma-separated, overrides sudo level)
# CUSTOM_SUDO_COMMANDS="/usr/bin/systemctl,/usr/bin/docker"
EOF
    chmod 600 "$config_file"
    log "Configuration template created at $config_file"
}

validate_username() {
    local name="$1"
    # Enhanced validation with better error messages
    if [[ ! "$name" =~ ^[a-zA-Z_][a-zA-Z0-9_-]*$ ]]; then
        echo "Invalid username: $name (must start with letter/underscore, contain only alphanumeric/underscore/hyphen)" >&2
        exit 1
    fi
    if [[ ${#name} -gt 32 ]]; then
        echo "Invalid username: $name (maximum 32 characters)" >&2
        exit 1
    fi
    if [[ ${#name} -lt 2 ]]; then
        echo "Invalid username: $name (minimum 2 characters)" >&2
        exit 1
    fi
}

validate_sudo_level() {
    local level="$1"
    if ! get_sudo_template "$level" >/dev/null 2>&1; then
        echo "Invalid sudo level: $level (must be: minimal, standard, admin, or full)" >&2
        echo "Available levels:" >&2
        echo "  minimal: $(get_sudo_template "minimal")" >&2
        echo "  standard: $(get_sudo_template "standard")" >&2
        echo "  admin: $(get_sudo_template "admin")" >&2
        echo "  full: $(get_sudo_template "full")" >&2
        exit 1
    fi
}

backup_file() {
    local file="$1"
    if [[ "$DRY_RUN" == "true" ]]; then
        if [[ -f "$file" ]]; then
            log "Would backup $file to $BACKUP_DIR/"
        fi
        return 0
    fi
    
    if [[ -f "$file" ]]; then
        local backup="$BACKUP_DIR/$(basename "$file").bak.$(date +%s)"
        cp -p "$file" "$backup"
        log "Backed up $file to $backup"
    fi
}

cleanup_old_backups() {
    local backup_base="/root/user_backups"
    if [[ "$DRY_RUN" == "true" ]]; then
        log "Would clean up backups older than $BACKUP_RETENTION_DAYS days in $backup_base"
        return 0
    fi
    
    if [[ -d "$backup_base" ]]; then
        find "$backup_base" -type d -mtime +$BACKUP_RETENTION_DAYS -exec rm -rf {} + 2>/dev/null || true
        log "Cleaned up backups older than $BACKUP_RETENTION_DAYS days"
    fi
}

check_key_expiry() {
    local key_file="$1"
    local user="$2"
    
    if [[ ! -f "$key_file" ]]; then
        return 0
    fi
    
    local key_age_days=$(( ($(date +%s) - $(stat -c %Y "$key_file")) / 86400 ))
    if [[ $key_age_days -gt $KEY_EXPIRY_DAYS ]]; then
        echo "⚠️  WARNING: SSH key for $user is $key_age_days days old (expires at $KEY_EXPIRY_DAYS days)"
        echo "   Consider regenerating the key for better security"
        log "WARNING: SSH key for $user is $key_age_days days old"
    fi
}

usage() {
    cat <<EOF
$SCRIPT_NAME v$SCRIPT_VERSION (Updated: $LAST_UPDATED)
Creates a new admin user with SSH key and configurable sudo access.

USAGE:
    $0 [OPTIONS] [username]

OPTIONS:
    -h, --help                    Show this help message
    -v, --version                 Show version information
    
    Security Options:
    --sudo-level LEVEL            Set sudo permission level (minimal|standard|admin|full)
    --sudo-commands "cmd1,cmd2"   Custom sudo commands (overrides --sudo-level)
    --require-passphrase          Require SSH key passphrase (default)
    --allow-no-passphrase         Allow SSH key without passphrase
    --key-expiry-days DAYS        Set key expiry warning days (default: $KEY_EXPIRY_DAYS)
    
    Automation Options:
    --non-interactive             Run without user prompts
    --config-file FILE            Load configuration from file
    --password-hash HASH          Use pre-hashed password (requires --non-interactive)
    --ssh-pubkey "KEY"            Import existing SSH public key
    
    Testing Options:
    --dry-run                     Show what would be done without making changes
    --validate-only               Check prerequisites and validate configuration
    --test-setup                  Test existing user configuration
    --create-config               Create configuration template and exit
    
    Script Options:
    --skip-version-check          Skip checking for script updates
    --assume-yes                  Automatically answer yes to prompts
    --verbose                     Show detailed output and debug information

SUDO LEVELS:
    minimal     Basic system commands (systemctl status, ls, cat, etc.)
    standard    Service management, package installation, docker (default)
    admin       User management, system configuration
    full        Complete sudo access (use with caution)

EXAMPLES:
    $0                                          # Create user '$DEFAULT_USERNAME' with standard sudo
    $0 myuser                                   # Create user 'myuser' with standard sudo
    $0 --sudo-level minimal myuser              # Create user with minimal sudo access
    $0 --sudo-commands "systemctl,docker" user  # Create user with custom sudo commands
    $0 --dry-run --sudo-level admin myuser      # Preview admin user creation
    $0 --non-interactive --config-file /etc/admin.conf  # Automated deployment
    $0 --test-setup myuser                      # Test existing user configuration
    $0 --create-config                          # Create configuration template

CONFIGURATION:
    Default config file: $DEFAULT_CONFIG_FILE
    Log file: $LOG_FILE
    Backup location: /root/user_backups/USERNAME/TIMESTAMP/

EOF
}

show_version() {
    echo "$SCRIPT_NAME v$SCRIPT_VERSION"
    echo "Last Updated: $LAST_UPDATED"
    echo "Description: Creates admin users with SSH keys and configurable sudo access"
    echo "Repository: Scripts & Snippets Collection"
    exit 0
}

verify_setup() {
    local user="$1"
    local success=true
    
    echo "Verifying setup for $user..."
    
    # Check user exists and is in sudo group
    if groups "$user" 2>/dev/null | grep -q sudo; then
        echo "✓ User is in sudo group"
    else
        echo "✗ User not in sudo group"
        success=false
    fi
    
    # Check SSH key exists
    if sudo -u "$user" test -f "/home/$user/.ssh/id_ed25519" 2>/dev/null; then
        echo "✓ SSH private key exists"
        check_key_expiry "/home/$user/.ssh/id_ed25519" "$user"
    else
        echo "✗ SSH private key missing"
        success=false
    fi
    
    # Check sudoers file
    if visudo -cf "/etc/sudoers.d/$user" 2>/dev/null; then
        echo "✓ Sudoers configuration valid"
    else
        echo "✗ Sudoers configuration invalid"
        success=false
    fi
    
    # Check file permissions
    local ssh_dir="/home/$user/.ssh"
    if [[ -d "$ssh_dir" ]]; then
        local perms=$(stat -c %a "$ssh_dir" 2>/dev/null || echo "000")
        if [[ "$perms" == "700" ]]; then
            echo "✓ SSH directory permissions correct (700)"
        else
            echo "⚠️  SSH directory permissions: $perms (should be 700)"
        fi
    fi
    
    if [[ "$success" == "true" ]]; then
        echo "✅ Setup verification complete!"
        return 0
    else
        echo "❌ Setup verification failed!"
        return 1
    fi
}

test_user_setup() {
    local user="$1"
    
    if ! id "$user" &>/dev/null; then
        echo "❌ User $user does not exist"
        exit 1
    fi
    
    echo "🔍 Testing configuration for user: $user"
    echo ""
    
    # Test sudo access
    echo "Testing sudo access..."
    if sudo -u "$user" sudo -n true 2>/dev/null; then
        echo "✓ Passwordless sudo access working"
    else
        echo "✗ Passwordless sudo access failed"
    fi
    
    # Test SSH key
    echo "Testing SSH key..."
    local ssh_key="/home/$user/.ssh/id_ed25519"
    if [[ -f "$ssh_key" ]]; then
        if sudo -u "$user" ssh-keygen -l -f "$ssh_key" &>/dev/null; then
            echo "✓ SSH private key is valid"
            local fingerprint=$(sudo -u "$user" ssh-keygen -l -f "$ssh_key" 2>/dev/null | awk '{print $2}')
            echo "  Fingerprint: $fingerprint"
        else
            echo "✗ SSH private key is invalid or corrupted"
        fi
    else
        echo "✗ SSH private key not found"
    fi
    
    # Run full verification
    echo ""
    verify_setup "$user"
}

validate_prerequisites() {
    local errors=0
    
    echo "🔍 Validating prerequisites..."
    
    # Check if running as root
    if [[ $EUID -ne 0 ]]; then
        echo "✗ Must run as root"
        ((errors++))
    else
        echo "✓ Running as root"
    fi
    
    # Check required commands
    local required_commands=("adduser" "usermod" "ssh-keygen" "visudo")
    for cmd in "${required_commands[@]}"; do
        if command -v "$cmd" >/dev/null 2>&1; then
            echo "✓ Command available: $cmd"
        else
            echo "✗ Command missing: $cmd"
            ((errors++))
        fi
    done
    
    # Check disk space
    local available_space=$(df /home | awk 'NR==2 {print $4}')
    if [[ $available_space -gt 100000 ]]; then  # 100MB in KB
        echo "✓ Sufficient disk space available"
    else
        echo "⚠️  Low disk space in /home ($(($available_space/1024))MB available)"
    fi
    
    # Check log directory
    if [[ -w "$(dirname "$LOG_FILE")" ]]; then
        echo "✓ Log directory writable"
    else
        echo "✗ Log directory not writable: $(dirname "$LOG_FILE")"
        ((errors++))
    fi
    
    if [[ $errors -eq 0 ]]; then
        echo "✅ All prerequisites satisfied"
        return 0
    else
        echo "❌ $errors prerequisite(s) failed"
        return 1
    fi
}

cleanup_on_failure() {
    local user="$1"
    local stage="$2"
    
    log "Setup failed at stage: $stage. Performing cleanup for user: $user"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log "Would perform cleanup for failed setup"
        return 0
    fi
    
    # Remove sudoers file if it was created
    if [[ -f "/etc/sudoers.d/$user" ]]; then
        rm -f "/etc/sudoers.d/$user"
        log "Removed sudoers file for $user"
    fi
    
    # Remove SSH directory if we created it
    if [[ -d "/home/$user/.ssh" ]] && [[ "$stage" != "user_creation" ]]; then
        rm -rf "/home/$user/.ssh"
        log "Removed SSH directory for $user"
    fi
    
    log "Cleanup completed. User account $user was left intact for manual review."
    echo "Setup failed. Partial cleanup completed. Please review user account $user manually."
}

generate_sudo_config() {
    local user="$1"
    local sudo_level="$2"
    local custom_commands="$3"
    
    if [[ -n "$custom_commands" ]]; then
        # Use custom commands
        echo "$user ALL=(ALL) NOPASSWD: $custom_commands"
    elif [[ "$sudo_level" == "full" ]]; then
        # Full access with warning
        echo "$user ALL=(ALL) NOPASSWD:ALL"
    else
        # Use template
        local commands=$(get_sudo_template "$sudo_level")
        echo "$user ALL=(ALL) NOPASSWD: $commands"
    fi
}

# --- Version Management Functions ---
check_latest_version() {
    if [[ "$SKIP_VERSION_CHECK" == "true" ]]; then
        return 0
    fi
    
    # Check cache first
    if [[ -f "$VERSION_CHECK_CACHE" ]]; then
        local cache_age=$(( $(date +%s) - $(stat -c %Y "$VERSION_CHECK_CACHE" 2>/dev/null || echo 0) ))
        if [[ $cache_age -lt 3600 ]]; then  # Cache for 1 hour
            if [[ "$VERBOSE" == "true" ]]; then
                print_info "Using cached version information"
            fi
            return 0
        fi
    fi
    
    print_info "Checking for updates..."
    
    # Query GitHub API with timeout
    local api_url="https://api.github.com/repos/$GITHUB_REPO/releases/latest"
    local latest_version=""
    
    if command -v curl >/dev/null 2>&1; then
        latest_version=$(curl -s --connect-timeout "$VERSION_CHECK_TIMEOUT" --max-time "$VERSION_CHECK_TIMEOUT" "$api_url" 2>/dev/null | grep '"tag_name"' | cut -d'"' -f4 | sed 's/^v//')
    elif command -v wget >/dev/null 2>&1; then
        latest_version=$(wget -qO- --timeout="$VERSION_CHECK_TIMEOUT" "$api_url" 2>/dev/null | grep '"tag_name"' | cut -d'"' -f4 | sed 's/^v//')
    else
        if [[ "$VERBOSE" == "true" ]]; then
            print_warning "Neither curl nor wget available - skipping version check"
        fi
        return 0
    fi
    
    if [[ -z "$latest_version" ]]; then
        if [[ "$VERBOSE" == "true" ]]; then
            print_warning "Could not check for updates (network/API issue)"
        fi
        return 0
    fi
    
    # Cache the result
    echo "$latest_version" > "$VERSION_CHECK_CACHE" 2>/dev/null || true
    
    # Compare versions
    if [[ "$latest_version" != "$SCRIPT_VERSION" ]]; then
        print_warning "A newer version is available: v$latest_version (current: v$SCRIPT_VERSION)"
        echo -e "${CYAN}📥 To update, run:${NC}"
        echo -e "${DIM}   curl -fsSL https://raw.githubusercontent.com/$GITHUB_REPO/main/bash/create_admin_user/create_admin_user.sh -o create_admin_user.sh && chmod +x create_admin_user.sh${NC}"
        echo ""
        
        if [[ "$NON_INTERACTIVE" == "false" ]]; then
            if ! confirm_proceed "Continue with current version?"; then
                exit 0
            fi
        fi
    else
        print_success "You have the latest version (v$SCRIPT_VERSION)"
    fi
}

show_what_will_be_done() {
    print_divider
    echo -e "${BOLD}📋 WHAT THIS SCRIPT WILL DO:${NC}"
    echo -e "${BLUE}•${NC} Create user account: ${BOLD}$USERNAME${NC}"
    echo -e "${BLUE}•${NC} Configure sudo permissions: ${BOLD}$SUDO_LEVEL${NC} level"
    if [[ -n "$CUSTOM_SUDO_COMMANDS" ]]; then
        echo -e "${BLUE}•${NC} Custom sudo commands: ${BOLD}$CUSTOM_SUDO_COMMANDS${NC}"
    fi
    echo -e "${BLUE}•${NC} Generate SSH keys with Ed25519 encryption"
    echo -e "${BLUE}•${NC} Set up secure file permissions"
    echo -e "${BLUE}•${NC} Create backups in: ${DIM}$BACKUP_DIR${NC}"
    
    if [[ "$SUDO_LEVEL" == "full" ]]; then
        echo ""
        print_warning "This will grant FULL system access to the user!"
    fi
    
    print_divider
}

# --- Argument parsing ---
SUDO_LEVEL="$DEFAULT_SUDO_LEVEL"
CUSTOM_SUDO_COMMANDS=""
CONFIG_FILE=""
PASSWORD_HASH=""
SSH_PUBKEY=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--version)
            show_version
            ;;
        --sudo-level)
            SUDO_LEVEL="$2"
            shift 2
            ;;
        --sudo-commands)
            CUSTOM_SUDO_COMMANDS="$2"
            shift 2
            ;;
        --require-passphrase)
            REQUIRE_PASSPHRASE="true"
            shift
            ;;
        --allow-no-passphrase)
            ALLOW_NO_PASSPHRASE="true"
            REQUIRE_PASSPHRASE="false"
            shift
            ;;
        --key-expiry-days)
            KEY_EXPIRY_DAYS="$2"
            shift 2
            ;;
        --non-interactive)
            NON_INTERACTIVE="true"
            shift
            ;;
        --config-file)
            CONFIG_FILE="$2"
            shift 2
            ;;
        --password-hash)
            PASSWORD_HASH="$2"
            shift 2
            ;;
        --ssh-pubkey)
            SSH_PUBKEY="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN="true"
            shift
            ;;
        --validate-only)
            VALIDATE_ONLY="true"
            shift
            ;;
        --test-setup)
            TEST_SETUP="true"
            shift
            ;;
        --create-config)
            require_root
            create_config_template "$DEFAULT_CONFIG_FILE"
            echo "Configuration template created at $DEFAULT_CONFIG_FILE"
            echo "Edit the file and run the script again."
            exit 0
            ;;
        --skip-version-check)
            SKIP_VERSION_CHECK="true"
            shift
            ;;
        --assume-yes)
            ASSUME_YES="true"
            shift
            ;;
        --verbose)
            VERBOSE="true"
            shift
            ;;
        -*)
            echo "Unknown option: $1" >&2
            echo "Use --help for usage information." >&2
            exit 1
            ;;
        *)
            USERNAME="$1"
            shift
            ;;
    esac
done

# --- Main script execution ---

# Show header
print_header "Admin User Creation Script v$SCRIPT_VERSION"

# Check for updates (unless skipped)
check_latest_version

# Load configuration if specified
if [[ -n "$CONFIG_FILE" ]]; then
    print_info "Loading configuration from: $CONFIG_FILE"
    load_config "$CONFIG_FILE"
elif [[ -f "$DEFAULT_CONFIG_FILE" ]]; then
    print_info "Loading default configuration from: $DEFAULT_CONFIG_FILE"
    load_config "$DEFAULT_CONFIG_FILE"
fi

# Set username default
USERNAME="${USERNAME:-$DEFAULT_USERNAME}"

# Validate inputs
print_section "Input Validation"
print_step "1/2" "Validating username: $USERNAME"
validate_username "$USERNAME"
print_success "Username validation passed"

print_step "2/2" "Validating sudo level: $SUDO_LEVEL"
validate_sudo_level "$SUDO_LEVEL"
print_success "Sudo level validation passed"

# Handle special modes
if [[ "$VALIDATE_ONLY" == "true" ]]; then
    print_section "Prerequisites Validation"
    validate_prerequisites
    exit $?
fi

if [[ "$TEST_SETUP" == "true" ]]; then
    print_section "Testing User Setup"
    test_user_setup "$USERNAME"
    exit $?
fi

# Require root for actual operations
require_root

# Show configuration summary
print_section "Configuration Summary"
echo -e "${BLUE}┌─ User Configuration ─────────────────────────────────┐${NC}"
echo -e "${BLUE}│${NC} Username:           ${BOLD}$USERNAME${NC}"
echo -e "${BLUE}│${NC} Sudo Level:         ${BOLD}$SUDO_LEVEL${NC}"
if [[ -n "$CUSTOM_SUDO_COMMANDS" ]]; then
    echo -e "${BLUE}│${NC} Custom Commands:    ${BOLD}$CUSTOM_SUDO_COMMANDS${NC}"
fi
echo -e "${BLUE}│${NC} Require Passphrase: ${BOLD}$REQUIRE_PASSPHRASE${NC}"
echo -e "${BLUE}│${NC} Dry Run:            ${BOLD}$DRY_RUN${NC}"
echo -e "${BLUE}│${NC} Non-Interactive:    ${BOLD}$NON_INTERACTIVE${NC}"
echo -e "${BLUE}└──────────────────────────────────────────────────────┘${NC}"

if [[ "$SUDO_LEVEL" == "full" ]]; then
    print_warning "Full sudo access grants complete system control!"
    print_tip "Consider using 'admin' level for most administrative tasks"
fi

if [[ "$DRY_RUN" == "true" ]]; then
    print_info "Running in DRY-RUN mode - no changes will be made"
fi

# Set up paths
SSH_DIR="/home/$USERNAME/.ssh"
KEY_PATH="$SSH_DIR/id_ed25519"
SUDOERS_FILE="/etc/sudoers.d/$USERNAME"
BACKUP_DIR="/root/user_backups/$USERNAME/$(date +%Y%m%d_%H%M%S)"

log "Starting $SCRIPT_NAME v$SCRIPT_VERSION for user: $USERNAME"
log "Sudo level: $SUDO_LEVEL, Dry run: $DRY_RUN, Non-interactive: $NON_INTERACTIVE"

# Validate prerequisites
if ! validate_prerequisites; then
    exit 1
fi

# Show what will be done and get confirmation (unless in non-interactive mode)
if [[ "$NON_INTERACTIVE" == "false" && "$DRY_RUN" == "false" ]]; then
    show_what_will_be_done
    
    print_warning "⚠️  SYSTEM CHANGES REQUIRED"
    echo -e "${YELLOW}This script will modify your system by creating users, configuring sudo access, and generating SSH keys.${NC}"
    
    if ! confirm_proceed "Ready to proceed with user creation?"; then
        echo -e "${BLUE}ℹ️  Operation cancelled. No changes were made.${NC}"
        exit 0
    fi
    
    echo -e "${GREEN}✓ Proceeding with user setup...${NC}"
fi

# Create backup directory
if [[ "$DRY_RUN" == "false" ]]; then
    mkdir -p "$BACKUP_DIR"
    log "Created backup directory: $BACKUP_DIR"
    
    # Set restrictive permissions on log file
    touch "$LOG_FILE"
    chmod 600 "$LOG_FILE"
fi

# Clean up old backups
print_section "System Preparation"
print_step "1/2" "Cleaning up old backups (older than $BACKUP_RETENTION_DAYS days)"
cleanup_old_backups
print_success "Backup cleanup completed"

print_step "2/2" "Initializing backup directory: $BACKUP_DIR"
if [[ "$DRY_RUN" == "false" ]]; then
    mkdir -p "$BACKUP_DIR"
    log "Created backup directory: $BACKUP_DIR"
    
    # Set restrictive permissions on log file
    touch "$LOG_FILE"
    chmod 600 "$LOG_FILE"
fi
print_success "Backup directory ready"

# Main setup process with progress tracking
print_section "User Setup Process"
TOTAL_STEPS=6
CURRENT_STEP=0

# Step 1: Add user and handle password
((CURRENT_STEP++))
show_progress $CURRENT_STEP $TOTAL_STEPS "Creating user account"
if id "$USERNAME" &>/dev/null; then
    print_info "User $USERNAME already exists - skipping creation"
    log "User $USERNAME already exists. Skipping user creation."
else
    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "Would create user $USERNAME"
        log "Would create user $USERNAME"
    elif [[ "$NON_INTERACTIVE" == "true" ]]; then
        if [[ -n "$PASSWORD_HASH" ]]; then
            if ! useradd -m -p "$PASSWORD_HASH" "$USERNAME"; then
                print_error "Failed to create user with password hash"
                cleanup_on_failure "$USERNAME" "user_creation"
                exit 1
            fi
        else
            # Create user with disabled password for non-interactive mode
            if ! useradd -m "$USERNAME"; then
                print_error "Failed to create user account"
                cleanup_on_failure "$USERNAME" "user_creation"
                exit 1
            fi
            passwd -l "$USERNAME"  # Lock password
        fi
        print_success "User $USERNAME created (non-interactive mode)"
        log "User $USERNAME created (non-interactive mode)."
    else
        print_info "Creating user $USERNAME (interactive mode - follow prompts)"
        if ! adduser "$USERNAME"; then
            print_error "Failed to create user account"
            log "Failed to add user."
            cleanup_on_failure "$USERNAME" "user_creation"
            exit 1
        fi
        print_success "User $USERNAME created successfully"
        log "User $USERNAME created."
    fi
fi

# Step 2: Add user to sudo group
((CURRENT_STEP++))
show_progress $CURRENT_STEP $TOTAL_STEPS "Adding user to sudo group"
if [[ "$DRY_RUN" == "true" ]]; then
    print_info "Would add user $USERNAME to sudo group"
    log "Would add user $USERNAME to sudo group"
else
    if ! usermod -aG sudo "$USERNAME"; then
        print_error "Failed to add user to sudo group"
        log "Failed to add user to sudo group."
        cleanup_on_failure "$USERNAME" "sudo_group"
        exit 1
    fi
    print_success "User $USERNAME added to sudo group"
    log "User $USERNAME added to sudo group."
fi

# Step 3: Configure sudo permissions
((CURRENT_STEP++))
show_progress $CURRENT_STEP $TOTAL_STEPS "Configuring sudo permissions"
backup_file "$SUDOERS_FILE"
SUDOERS_LINE=$(generate_sudo_config "$USERNAME" "$SUDO_LEVEL" "$CUSTOM_SUDO_COMMANDS")

if [[ "$DRY_RUN" == "true" ]]; then
    print_info "Would configure sudo with: $SUDOERS_LINE"
    log "Would configure sudo with: $SUDOERS_LINE"
else
    echo "$SUDOERS_LINE" > "$SUDOERS_FILE"
    chmod 0440 "$SUDOERS_FILE"
    if ! visudo -cf "$SUDOERS_FILE"; then
        print_error "Sudoers file syntax validation failed"
        log "Sudoers file syntax error. Removing $SUDOERS_FILE for safety."
        rm -f "$SUDOERS_FILE"
        cleanup_on_failure "$USERNAME" "sudoers_config"
        exit 1
    fi
    print_success "Sudo permissions configured ($SUDO_LEVEL level)"
    log "Sudo configured for $USERNAME with level: $SUDO_LEVEL"
    
    # Warn about full access
    if [[ "$SUDO_LEVEL" == "full" ]]; then
        print_warning "User $USERNAME has FULL sudo access (NOPASSWD:ALL)"
        print_tip "This grants complete system control - consider using a more restrictive level"
        log "WARNING: Full sudo access granted to $USERNAME"
    fi
fi

# Step 4: Create SSH directory and backup existing keys
((CURRENT_STEP++))
show_progress $CURRENT_STEP $TOTAL_STEPS "Setting up SSH directory"
if [[ "$DRY_RUN" == "true" ]]; then
    print_info "Would create SSH directory $SSH_DIR with permissions 700"
    log "Would create SSH directory $SSH_DIR with permissions 700"
else
    mkdir -p "$SSH_DIR"
    chown "$USERNAME:$USERNAME" "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    print_success "SSH directory created with secure permissions"
fi

# Backup existing SSH keys if present
print_info "Backing up existing SSH keys (if any)"
backup_file "$KEY_PATH"
backup_file "${KEY_PATH}.pub"

# Step 5: Handle SSH key generation or import
((CURRENT_STEP++))
show_progress $CURRENT_STEP $TOTAL_STEPS "Generating/importing SSH keys"

if [[ -n "$SSH_PUBKEY" ]]; then
    # Import existing public key
    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "Would import provided SSH public key"
        log "Would import provided SSH public key"
    else
        echo "$SSH_PUBKEY" > "${KEY_PATH}.pub"
        chmod 644 "${KEY_PATH}.pub"
        chown "$USERNAME:$USERNAME" "${KEY_PATH}.pub"
        print_success "SSH public key imported successfully"
        log "Imported SSH public key for $USERNAME"
    fi
elif sudo -u "$USERNAME" test -f "$KEY_PATH" 2>/dev/null; then
    print_info "SSH key already exists - skipping generation"
    log "SSH key already exists at $KEY_PATH. Skipping key generation."
    check_key_expiry "$KEY_PATH" "$USERNAME"
else
    # Generate new SSH key
    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "Would generate Ed25519 SSH key for $USERNAME"
        log "Would generate SSH key for $USERNAME"
    else
        if [[ "$NON_INTERACTIVE" == "true" ]]; then
            # Non-interactive key generation
            if [[ "$REQUIRE_PASSPHRASE" == "true" && "$ALLOW_NO_PASSPHRASE" == "false" ]]; then
                print_error "Non-interactive mode requires --allow-no-passphrase when passphrase is required"
                cleanup_on_failure "$USERNAME" "ssh_key_generation"
                exit 1
            fi
            if ! sudo -u "$USERNAME" ssh-keygen -t ed25519 -C "$USERNAME@$(hostname)" -f "$KEY_PATH" -N ""; then
                print_error "SSH key generation failed"
                log "SSH key generation failed."
                cleanup_on_failure "$USERNAME" "ssh_key_generation"
                exit 1
            fi
            print_success "SSH key generated (non-interactive mode, no passphrase)"
            log "SSH key generated for $USERNAME (no passphrase - non-interactive mode)"
        else
            # Interactive key generation
            if [[ "$REQUIRE_PASSPHRASE" == "true" && "$ALLOW_NO_PASSPHRASE" == "false" ]]; then
                print_info "Generating SSH key for $USERNAME - passphrase REQUIRED for security"
                echo "Please enter a strong passphrase when prompted."
            else
                print_info "Generating SSH key for $USERNAME - passphrase recommended"
                echo "You will be prompted for a passphrase (recommended for security)."
            fi
            
            if ! sudo -u "$USERNAME" ssh-keygen -t ed25519 -C "$USERNAME@$(hostname)" -f "$KEY_PATH"; then
                print_error "SSH key generation failed"
                log "SSH key generation failed."
                cleanup_on_failure "$USERNAME" "ssh_key_generation"
                exit 1
            fi
            
            # Check if passphrase was set
            if sudo -u "$USERNAME" ssh-keygen -y -P "" -f "$KEY_PATH" &>/dev/null; then
                if [[ "$REQUIRE_PASSPHRASE" == "true" && "$ALLOW_NO_PASSPHRASE" == "false" ]]; then
                    print_error "SSH key generated without passphrase, but passphrase is required"
                    echo "Please regenerate the key with a passphrase or use --allow-no-passphrase flag." >&2
                    cleanup_on_failure "$USERNAME" "ssh_key_generation"
                    exit 1
                else
                    print_warning "SSH key generated without passphrase"
                    print_tip "Consider regenerating with a passphrase for better security"
                    log "WARNING: SSH key generated without passphrase for $USERNAME"
                fi
            else
                print_success "SSH key generated with passphrase protection"
                log "SSH key generated with passphrase for $USERNAME"
            fi
        fi
    fi
fi

# Step 6: Configure SSH key permissions and authorized_keys
((CURRENT_STEP++))
show_progress $CURRENT_STEP $TOTAL_STEPS "Finalizing SSH configuration"

# Set permissions for SSH keys
if [[ "$DRY_RUN" == "true" ]]; then
    print_info "Would set secure permissions on SSH keys"
else
    if [[ -f "$KEY_PATH" ]]; then
        chmod 600 "$KEY_PATH"
        chown "$USERNAME:$USERNAME" "$KEY_PATH"
    fi
    if [[ -f "${KEY_PATH}.pub" ]]; then
        chmod 644 "${KEY_PATH}.pub"
        chown "$USERNAME:$USERNAME" "${KEY_PATH}.pub"
    fi
    print_success "SSH key permissions configured securely"
fi

# Add public key to authorized_keys if not already present
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"
if [[ "$DRY_RUN" == "true" ]]; then
    print_info "Would configure authorized_keys file"
    log "Would configure authorized_keys file"
elif [[ -f "${KEY_PATH}.pub" ]]; then
    if [[ -f "$AUTHORIZED_KEYS" ]] && grep -q -F "$(cat ${KEY_PATH}.pub)" "$AUTHORIZED_KEYS" 2>/dev/null; then
        print_info "Public key already in authorized_keys"
        log "Public key already in authorized_keys."
    else
        touch "$AUTHORIZED_KEYS"
        cat "${KEY_PATH}.pub" >> "$AUTHORIZED_KEYS"
        chmod 600 "$AUTHORIZED_KEYS"
        chown "$USERNAME:$USERNAME" "$AUTHORIZED_KEYS"
        print_success "Public key added to authorized_keys"
        log "Public key added to authorized_keys."
    fi
fi

# Verify the complete setup
echo ""
if [[ "$DRY_RUN" == "true" ]]; then
    echo "🔍 Dry run completed! No changes were made."
    echo "The script would have:"
    echo "  • Created user: $USERNAME"
    echo "  • Configured sudo level: $SUDO_LEVEL"
    echo "  • Generated SSH keys with Ed25519 encryption"
    echo "  • Set up proper file permissions"
    echo "  • Created backups in: $BACKUP_DIR"
    log "Dry run completed successfully for user $USERNAME"
else
    echo "Setup completed! Verifying configuration..."
    if verify_setup "$USERNAME"; then
        log "User $USERNAME setup completed successfully with verification."
        echo ""
        echo "✅ User $USERNAME created successfully!"
        echo "📁 Backups stored in: $BACKUP_DIR"
        echo "🔐 Sudo level: $SUDO_LEVEL"
        if [[ -f "${KEY_PATH}.pub" ]]; then
            echo "📋 SSH public key:"
            cat "${KEY_PATH}.pub"
        fi
        echo ""
        echo "🔐 Next steps:"
        echo "   1. Copy the SSH public key to remote servers"
        echo "   2. Test sudo access: sudo -u $USERNAME sudo whoami"
        if [[ -f "$KEY_PATH" ]]; then
            echo "   3. Test SSH key: ssh -i $KEY_PATH user@remote-server"
        fi
        echo "   4. Review sudo permissions in /etc/sudoers.d/$USERNAME"
        if [[ "$SUDO_LEVEL" == "full" ]]; then
            echo ""
            echo "⚠️  SECURITY REMINDER: User has full sudo access!"
            echo "   Consider restricting permissions after initial setup."
        fi
    else
        log "Setup verification failed for $USERNAME"
        echo "❌ Setup completed but verification failed. Please check the logs."
        exit 1
    fi
fi
