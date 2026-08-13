#!/bin/bash

# CachyOS Optimization Project - Universal Setup Script
# Created by litebiter & auxmeet

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

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
    echo -e "${GREEN}"
    cat << "EOF"
   ██████╗ ██████╗ ███████╗ █████╗ ███╗   ███╗███████╗
  ██╔════╝██╔═══██╗██╔════╝██╔══██╗████╗ ████║██╔════╝
  ██║     ██║   ██║███████╗███████║██╔████╔██║███████╗
  ██║     ██║   ██║╚════██║██╔══██║██║╚██╔╝██║╚════██║
  ╚██████╗╚██████╔╝███████║██║  ██║██║ ╚═╝ ██║███████║
   ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
EOF
    echo -e "${WHITE}    Universal System Optimization Tool${NC}"
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
echo -e "${GREEN}=== Starting Installation Process ===${NC}"
echo ""

# Detect hardware
show_loading "Detecting system hardware..."
bash "$SCRIPTS_DIR/detect-hardware.sh"
if [ -f /tmp/hardware-config.conf ]; then
    source /tmp/hardware-config.conf
    # Remove quotes from variables
    CPU_TYPE="${CPU_TYPE//\"/}"
    CPU_MODEL="${CPU_MODEL//\"/}"
    GPU_TYPE="${GPU_TYPE//\"/}"
    GPU_MODEL="${GPU_MODEL//\"/}"
    RAM_TOTAL="${RAM_TOTAL//\"/}"
    RAM_GB_RAW="${RAM_GB_RAW//\"/}"
    show_success "Hardware detected: $CPU_TYPE CPU, $GPU_TYPE GPU"
else
    show_error "Hardware detection failed"
    exit 1
fi

# Install required packages
show_loading "Installing required packages..."
pacman -S --needed --noconfirm cpupower thermald > /dev/null 2>&1 || true
show_success "Required packages installed"

# Clone source repositories
show_loading "Cloning source repositories..."
cd "$SCRIPT_DIR/sources"

if [ ! -d "CachyOS-Settings" ]; then
    git clone https://github.com/CachyOS/CachyOS-Settings.git > /dev/null 2>&1
    show_success "CachyOS Settings cloned"
else
    show_success "CachyOS Settings already exists"
fi

if [ ! -d "linux-cachyos" ]; then
    git clone https://github.com/CachyOS/linux-cachyos.git > /dev/null 2>&1
    show_success "CachyOS Kernel cloned"
else
    show_success "CachyOS Kernel already exists"
fi

# Apply sysctl configurations
show_loading "Applying sysctl configurations..."
cp "$CONFIG_DIR/sysctl/99-performance.conf" /etc/sysctl.d/ 2>/dev/null || true
cp "$CONFIG_DIR/sysctl/99-cachyos-tweaks.conf" /etc/sysctl.d/ 2>/dev/null || true
sysctl --system > /dev/null 2>&1
show_success "Sysctl configurations applied"

# Setup systemd services
show_loading "Setting up systemd services..."
cp "$CONFIG_DIR/systemd/cpupower-performance.service" /etc/systemd/system/ 2>/dev/null || true
systemctl daemon-reload > /dev/null 2>&1
systemctl enable cpupower-performance.service > /dev/null 2>&1
systemctl start cpupower-performance.service > /dev/null 2>&1
show_success "Systemd services configured"

# Setup Xorg configurations
show_loading "Setting up Xorg configurations..."
mkdir -p /etc/X11/xorg.conf.d
if [ "$GPU_TYPE" == "NVIDIA" ]; then
    cp "$CONFIG_DIR/xorg/10-nvidia-performance.conf" /etc/X11/xorg.conf.d/ 2>/dev/null || true
    show_success "NVIDIA Xorg configuration applied"
elif [ "$GPU_TYPE" == "AMD" ]; then
    cp "$CONFIG_DIR/xorg/10-amd-performance.conf" /etc/X11/xorg.conf.d/ 2>/dev/null || true
    show_success "AMD Xorg configuration applied"
else
    show_success "No GPU-specific Xorg configuration needed"
fi

# Setup kernel parameters
show_loading "Setting up kernel parameters..."
if [ -f /etc/default/grub ]; then
    GRUB_PARAMS="amd_pstate=active pcie_aspm=off"
    
    # Add CPU-specific parameters
    if [ "$CPU_TYPE" == "AMD" ]; then
        GRUB_PARAMS="$GRUB_PARAMS amd_iommu=on"
    elif [ "$CPU_TYPE" == "Intel" ]; then
        GRUB_PARAMS="$GRUB_PARAMS intel_iommu=on"
    fi
    
    # Add GPU-specific parameters
    if [ "$GPU_TYPE" == "NVIDIA" ]; then
        GRUB_PARAMS="$GRUB_PARAMS nvidia-drm.modeset=1"
    fi
    
    if ! grep -q "amd_pstate=active" /etc/default/grub; then
        sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 $GRUB_PARAMS\"/" /etc/default/grub
        grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1
        show_success "Kernel parameters configured"
    else
        show_success "Kernel parameters already configured"
    fi
else
    show_success "GRUB not found, skipping kernel parameters"
fi

# Run optimization scripts
show_loading "Running CPU optimization..."
bash "$SCRIPTS_DIR/cpu-optimization.sh" > /dev/null 2>&1
show_success "CPU optimization completed"

show_loading "Running GPU optimization..."
bash "$SCRIPTS_DIR/gpu-optimization.sh" > /dev/null 2>&1
show_success "GPU optimization completed"

show_loading "Running memory optimization..."
bash "$SCRIPTS_DIR/memory-optimization.sh" > /dev/null 2>&1
show_success "Memory optimization completed"

show_loading "Running network optimization..."
bash "$SCRIPTS_DIR/network-optimization.sh" > /dev/null 2>&1
show_success "Network optimization completed"

show_loading "Running storage optimization..."
bash "$SCRIPTS_DIR/storage-optimization.sh" > /dev/null 2>&1
show_success "Storage optimization completed"

show_loading "Running low latency optimization..."
bash "$SCRIPTS_DIR/low-latency-optimization.sh" > /dev/null 2>&1
show_success "Low latency optimization completed"

# Enable fstrim for SSDs
if [ $NVME_COUNT -gt 0 ] || [ $SSD_COUNT -gt 0 ]; then
    show_loading "Enabling periodic TRIM for SSDs..."
    systemctl enable fstrim.timer > /dev/null 2>&1
    systemctl start fstrim.timer > /dev/null 2>&1
    show_success "TRIM enabled for SSDs"
fi

echo ""
echo -e "${GREEN}=== Installation Complete ===${NC}"
echo ""
echo -e "${WHITE}Summary of changes:${NC}"
echo -e "${WHITE}• CPU governor set to performance${NC}"
echo -e "${WHITE}• GPU performance mode enabled${NC}"
echo -e "${WHITE}• Memory and swap optimized${NC}"
echo -e "${WHITE}• Network drivers optimized${NC}"
echo -e "${WHITE}• Storage I/O optimized${NC}"
echo -e "${WHITE}• Kernel parameters tuned${NC}"
echo ""
echo -e "${YELLOW}⚠ Please reboot your system to apply all changes${NC}"
echo -e "${YELLOW}After reboot, run 'bash check-status.sh' to verify optimizations${NC}"
echo ""
echo -e "${CYAN}Created by litebiter & auxmeet${NC}"