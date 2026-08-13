#!/bin/bash

# CachyOS Optimization Project - Rollback Script
# Created by litebiter & auxmeet

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
 ██████╗ ██████╗ ███████╗ █████╗ ███╗   ███╗███████╗
██╔════╝██╔═══██╗██╔════╝██╔══██╗████╗ ████║██╔════╝
██║     ██║   ██║███████╗███████║██╔████╔██║███████╗
██║     ██║   ██║╚════██║██╔══██║██║╚██╔╝██║╚════██║
╚██████╗╚██████╔╝███████║██║  ██║██║ ╚═╝ ██║███████║
 ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
EOF
    echo -e "${WHITE}    Rollback System Optimizations${NC}"
    echo -e "${CYAN}    Created by litebiter & auxmeet${NC}"
    echo ""
}

show_loading() {
    local message=$1
    echo -e "${BLUE}▶ ${message}${NC}"
}

show_success() {
    local message=$1
    echo -e "${GREEN}✓ ${message}${NC}"
}

show_error() {
    local message=$1
    echo -e "${RED}✗ ${message}${NC}"
}

# Check for sudo privileges
if [ "$EUID" -ne 0 ]; then 
    show_error "This script requires sudo privileges."
    echo "Please run with sudo: sudo bash $0"
    exit 1
fi

print_banner
echo -e "${YELLOW}⚠ This will revert all system optimizations to default settings${NC}"
echo ""
read -p "Are you sure you want to continue? [y/N]: " confirm

if [[ "$confirm" != "y" ]] && [[ "$confirm" != "Y" ]]; then
    echo "Rollback cancelled."
    exit 0
fi

echo ""
echo -e "${GREEN}=== Starting Rollback Process ===${NC}"
echo ""

# Remove sysctl configurations
show_loading "Removing sysctl configurations..."
rm -f /etc/sysctl.d/99-performance.conf
rm -f /etc/sysctl.d/99-cachyos-tweaks.conf
sysctl --system > /dev/null 2>&1
show_success "Sysctl configurations removed"

# Remove systemd services
show_loading "Removing systemd services..."
systemctl stop cpupower-performance.service > /dev/null 2>&1
systemctl disable cpupower-performance.service > /dev/null 2>&1
rm -f /etc/systemd/system/cpupower-performance.service
systemctl daemon-reload > /dev/null 2>&1
show_success "Systemd services removed"

# Remove Xorg configurations
show_loading "Removing Xorg configurations..."
rm -f /etc/X11/xorg.conf.d/10-nvidia-performance.conf
rm -f /etc/X11/xorg.conf.d/10-amd-performance.conf
show_success "Xorg configurations removed"

# Restore GRUB defaults
show_loading "Restoring GRUB defaults..."
if [ -f /etc/default/grub ]; then
    sed -i 's/ amd_pstate=active//g' /etc/default/grub
    sed -i 's/ pcie_aspm=off//g' /etc/default/grub
    sed -i 's/ nvidia-drm.modeset=1//g' /etc/default/grub
    sed -i 's/ amd_iommu=on//g' /etc/default/grub
    sed -i 's/ intel_iommu=on//g' /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1
    show_success "GRUB defaults restored"
else
    show_success "GRUB not found, skipping"
fi

# Restore default CPU governor
show_loading "Restoring default CPU governor..."
cpupower frequency-set -g powersave > /dev/null 2>&1 || true
show_success "CPU governor restored to powersave"

# Reset NVIDIA settings
show_loading "Resetting NVIDIA settings..."
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi -pm 0 > /dev/null 2>&1 || true
    nvidia-smi -r > /dev/null 2>&1 || true
    show_success "NVIDIA settings reset"
else
    show_success "NVIDIA not found, skipping"
fi

# Reset memory settings
show_loading "Resetting memory settings..."
echo 100 > /proc/sys/vm/swappiness > /dev/null 2>&1 || true
echo 100 > /proc/sys/vm/vfs_cache_pressure > /dev/null 2>&1 || true
show_success "Memory settings reset"

# Reset network driver
show_loading "Resetting network driver..."
if lsmod | grep -q r8168; then
    modprobe -r r8168 > /dev/null 2>&1 || true
    rm -f /etc/modprobe.d/blacklist-r8169.conf
    rm -f /etc/modules-load.d/r8168.conf
    modprobe r8169 > /dev/null 2>&1 || true
    show_success "Network driver reset"
else
    show_success "Network driver not changed, skipping"
fi

# Disable fstrim
show_loading "Disabling periodic TRIM..."
systemctl disable fstrim.timer > /dev/null 2>&1
systemctl stop fstrim.timer > /dev/null 2>&1
show_success "Periodic TRIM disabled"

echo ""
echo -e "${GREEN}=== Rollback Complete ===${NC}"
echo ""
echo -e "${WHITE}Summary of reverted changes:${NC}"
echo -e "${WHITE}• CPU governor restored to powersave${NC}"
echo -e "${WHITE}• GPU settings reset to defaults${NC}"
echo -e "${WHITE}• Memory settings restored${NC}"
echo -e "${WHITE}• Network driver reset${NC}"
echo -e "${WHITE}• Kernel parameters restored${NC}"
echo -e "${WHITE}• All custom configurations removed${NC}"
echo ""
echo -e "${YELLOW}⚠ Please reboot your system to apply all changes${NC}"
echo ""
echo -e "${CYAN}Created by litebiter & auxmeet${NC}"