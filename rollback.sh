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
rm -f /etc/sysctl.d/99-low-latency.conf
rm -f /etc/sysctl.d/99-advanced-kernel-tweaks.conf
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
    sed -i 's/ processor.max_cstate=0//g' /etc/default/grub
    sed -i 's/ intel_idle.max_cstate=0//g' /etc/default/grub
    sed -i 's/ nowatchdog//g' /etc/default/grub
    sed -i 's/ nosoftlockup//g' /etc/default/grub
    sed -i 's/ audit=0//g' /etc/default/grub
    sed -i 's/ usbcore.autosuspend=-1//g' /etc/default/grub
    sed -i 's/ idle=poll//g' /etc/default/grub
    sed -i 's/ mitigations=off//g' /etc/default/grub
    sed -i 's/ slab_nomerge//g' /etc/default/grub
    sed -i 's/ slub_nomerge//g' /etc/default/grub
    sed -i 's/ mce=off//g' /etc/default/grub
    sed -i 's/ noibrs//g' /etc/default/grub
    sed -i 's/ nopat//g' /etc/default/grub
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

# Remove user-level graphics optimizations
show_loading "Removing user-level graphics optimizations..."
if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d':' -f6)
    
    # Remove graphics environment file
    rm -f "$USER_HOME/.config/cachyos-optimization/graphics-env.conf"
    
    # Remove Java environment file
    rm -f "$USER_HOME/.config/cachyos-optimization/java-env.conf"
    
    # Remove from .bashrc
    if [ -f "$USER_HOME/.bashrc" ]; then
        sed -i '/cachyos-optimization\/graphics-env.conf/d' "$USER_HOME/.bashrc"
        sed -i '/cachyos-optimization\/java-env.conf/d' "$USER_HOME/.bashrc"
    fi
    
    # Remove from .zshrc
    if [ -f "$USER_HOME/.zshrc" ]; then
        sed -i '/cachyos-optimization\/graphics-env.conf/d' "$USER_HOME/.zshrc"
        sed -i '/cachyos-optimization\/java-env.conf/d' "$USER_HOME/.zshrc"
    fi
    
    # Remove vkBasalt config
    rm -rf "$USER_HOME/.config/vkBasalt"
    
    # Remove screenlayout script
    rm -f "$USER_HOME/.screenlayout/high-refresh-rate.sh"
    
    # Remove from .xinitrc
    if [ -f "$USER_HOME/.xinitrc" ]; then
        sed -i '/screenlayout\/high-refresh-rate.sh/d' "$USER_HOME/.xinitrc"
        sed -i '/Load high refresh rate settings/d' "$USER_HOME/.xinitrc"
    fi
    
    # Remove systemd user service
    rm -f "$USER_HOME/.config/systemd/user/set-high-refresh-rate.service"
    
    # Remove autostart entries
    rm -f "$USER_HOME/.config/autostart/set-high-refresh-rate.desktop"
    rm -f "$USER_HOME/.config/autostart/nvidia-settings.desktop"
    
    show_success "User-level graphics and Java optimizations removed"
else
    show_success "No user detected, skipping user-level cleanup"
fi

# Remove Java sysctl configuration
show_loading "Removing Java sysctl configuration..."
rm -f /etc/sysctl.d/99-java-tuning.conf
show_success "Java sysctl configuration removed"

# Remove Java systemd override
show_loading "Removing Java systemd override..."
rm -f /etc/systemd/system.conf.d/java-performance.conf
show_success "Java systemd override removed"

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