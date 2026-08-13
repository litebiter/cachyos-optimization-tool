#!/bin/bash

# CachyOS Optimization Status Check
# Universal system status checker
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
    echo -e "${WHITE}    System Status Check${NC}"
    echo -e "${CYAN}    Created by litebiter & auxmeet${NC}"
    echo ""
}

print_banner

echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${WHITE}                SYSTEM STATUS${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Load hardware configuration
if [ -f /tmp/hardware-config.conf ]; then
    source /tmp/hardware-config.conf
    # Remove quotes from variables
    CPU_TYPE="${CPU_TYPE//\"/}"
    CPU_MODEL="${CPU_MODEL//\"/}"
    RAM_TOTAL="${RAM_TOTAL//\"/}"
    GPU_TYPE="${GPU_TYPE//\"/}"
    GPU_MODEL="${GPU_MODEL//\"/}"
else
    echo -e "${CYAN}Detecting hardware...${NC}"
    bash "$(dirname "$0")/scripts/detect-hardware.sh"
    source /tmp/hardware-config.conf
    CPU_TYPE="${CPU_TYPE//\"/}"
    CPU_MODEL="${CPU_MODEL//\"/}"
    RAM_TOTAL="${RAM_TOTAL//\"/}"
    GPU_TYPE="${GPU_TYPE//\"/}"
    GPU_MODEL="${GPU_MODEL//\"/}"
fi

# System Information
echo -e "${BLUE}System Information:${NC}"
echo -e "${WHITE}Kernel: $KERNEL_VERSION${NC}"
echo -e "${WHITE}CPU: $CPU_TYPE $CPU_MODEL ($CPU_CORES cores)${NC}"
echo -e "${WHITE}RAM: $RAM_TOTAL${NC}"
echo ""

# CPU Status
echo -e "${BLUE}CPU Status:${NC}"
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
    CURRENT_GOVERNOR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
    echo -e "${WHITE}Governor: $CURRENT_GOVERNOR${NC}"
    
    if [ "$CURRENT_GOVERNOR" == "performance" ]; then
        echo -e "${GREEN}✓ CPU Governor: OPTIMIZED${NC}"
    else
        echo -e "${RED}✗ CPU Governor: NOT OPTIMIZED${NC}"
    fi
else
    echo -e "${WHITE}CPU frequency scaling not available${NC}"
fi
echo ""

# GPU Status
echo -e "${BLUE}GPU Status:${NC}"
# Direct GPU detection as fallback
if lspci | grep -qi nvidia; then
    GPU_TYPE="NVIDIA"
    GPU_MODEL=$(lspci | grep -i nvidia | head -n1 | sed 's/.*NVIDIA //' | sed 's/ (.*//' | xargs)
    echo -e "${WHITE}GPU: $GPU_MODEL${NC}"
    if command -v nvidia-smi &> /dev/null; then
        PERSISTENCE=$(nvidia-smi --query-gpu=persistence_mode --format=csv,noheader 2>/dev/null)
        if echo "$PERSISTENCE" | grep -q "Enabled"; then
            echo -e "${GREEN}✓ GPU Persistence: OPTIMIZED${NC}"
        else
            echo -e "${RED}✗ GPU Persistence: NOT OPTIMIZED${NC}"
        fi
    else
        echo -e "${WHITE}NVIDIA GPU detected but drivers not loaded${NC}"
    fi
elif lspci | grep -qi "advanced micro devices"; then
    GPU_TYPE="AMD"
    GPU_MODEL=$(lspci | grep -i "advanced micro devices" | head -n1 | sed 's/.*AMD //' | sed 's/ (.*//' | xargs)
    echo -e "${WHITE}GPU: $GPU_MODEL${NC}"
    if lsmod | grep -q amdgpu; then
        echo -e "${GREEN}✓ AMDGPU driver loaded${NC}"
    else
        echo -e "${RED}✗ AMDGPU driver not loaded${NC}"
    fi
elif lspci | grep -qi intel; then
    GPU_TYPE="Intel"
    GPU_MODEL=$(lspci | grep -i intel | head -n1 | sed 's/.*Intel //' | sed 's/ (.*//' | xargs)
    echo -e "${WHITE}GPU: $GPU_MODEL${NC}"
    if lsmod | grep -q i915; then
        echo -e "${GREEN}✓ Intel GPU driver loaded${NC}"
    else
        echo -e "${RED}✗ Intel GPU driver not loaded${NC}"
    fi
else
    echo -e "${WHITE}No dedicated GPU detected${NC}"
fi
echo ""

# Memory Status
echo -e "${BLUE}Memory Status:${NC}"
SWAPPINESS=$(cat /proc/sys/vm/swappiness)
VFS_CACHE=$(cat /proc/sys/vm/vfs_cache_pressure)
echo -e "${WHITE}Swappiness: $SWAPPINESS${NC}"
echo -e "${WHITE}VFS Cache Pressure: $VFS_CACHE${NC}"

if [ "$SWAPPINESS" -le 20 ]; then
    echo -e "${GREEN}✓ Memory Swappiness: OPTIMIZED${NC}"
else
    echo -e "${RED}✗ Memory Swappiness: NOT OPTIMIZED${NC}"
fi
echo ""

# PCIe Status
echo -e "${BLUE}PCIe Status:${NC}"
if [ -f /sys/bus/pci/devices/0000:07:00.0/current_link_speed ]; then
    PCIE_SPEED=$(cat /sys/bus/pci/devices/0000:07:00.0/current_link_speed)
    PCIE_WIDTH=$(cat /sys/bus/pci/devices/0000:07:00.0/current_link_width)
    echo -e "${WHITE}Link Speed: $PCIE_SPEED${NC}"
    echo -e "${WHITE}Link Width: $PCIE_WIDTH${NC}"
    
    if echo "$PCIE_SPEED" | grep -q "16.0 GT/s"; then
        echo -e "${GREEN}✓ PCIe Speed: OPTIMIZED${NC}"
    else
        echo -e "${RED}✗ PCIe Speed: NOT OPTIMIZED (requires BIOS check)${NC}"
    fi
else
    echo -e "${WHITE}PCIe device information not available${NC}"
fi
echo ""

# System Services
echo -e "${BLUE}System Services:${NC}"
if systemctl is-active --quiet cpupower-performance.service 2>/dev/null; then
    echo -e "${GREEN}✓ CPU Power Service: RUNNING${NC}"
else
    echo -e "${RED}✗ CPU Power Service: NOT RUNNING${NC}"
fi

if systemctl is-active --quiet thermald 2>/dev/null; then
    echo -e "${GREEN}✓ Thermal Daemon: RUNNING${NC}"
else
    echo -e "${WHITE}Thermal Daemon: NOT INSTALLED OR DISABLED${NC}"
fi

if systemctl is-active --quiet fstrim.timer 2>/dev/null; then
    echo -e "${GREEN}✓ TRIM Service: RUNNING${NC}"
else
    echo -e "${WHITE}TRIM Service: NOT RUNNING${NC}"
fi
echo ""

# Performance Score
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${WHITE}            PERFORMANCE SCORE${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""

score=0
max_score=5

# CPU Governor check
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
    if [ "$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)" = "performance" ]; then
        echo -e "${GREEN}✓ CPU Governor: OPTIMIZED${NC}"
        ((score++))
    else
        echo -e "${RED}✗ CPU Governor: NOT OPTIMIZED${NC}"
    fi
else
    echo -e "${WHITE}○ CPU Governor: NOT APPLICABLE${NC}"
    ((max_score--))
fi

# GPU Persistence check
if [ "$GPU_TYPE" == "NVIDIA" ] && command -v nvidia-smi &> /dev/null; then
    if nvidia-smi --query-gpu=persistence_mode --format=csv,noheader | grep -q "Enabled"; then
        echo -e "${GREEN}✓ GPU Persistence: OPTIMIZED${NC}"
        ((score++))
    else
        echo -e "${RED}✗ GPU Persistence: NOT OPTIMIZED${NC}"
    fi
elif [ "$GPU_TYPE" == "AMD" ] && lsmod | grep -q amdgpu; then
    echo -e "${GREEN}✓ AMDGPU Driver: LOADED${NC}"
    ((score++))
elif [ "$GPU_TYPE" == "Intel" ] && lsmod | grep -q i915; then
    echo -e "${GREEN}✓ Intel GPU Driver: LOADED${NC}"
    ((score++))
elif [ "$GPU_TYPE" == "None" ] || [ "$GPU_TYPE" == "" ]; then
    echo -e "${WHITE}○ GPU Driver: NOT APPLICABLE${NC}"
    ((max_score--))
else
    echo -e "${WHITE}○ GPU Driver: NOT APPLICABLE${NC}"
    ((max_score--))
fi

# Memory Swappiness check
if [ "$(cat /proc/sys/vm/swappiness)" -le 20 ]; then
    echo -e "${GREEN}✓ Memory Swappiness: OPTIMIZED${NC}"
    ((score++))
else
    echo -e "${RED}✗ Memory Swappiness: NOT OPTIMIZED${NC}"
fi

# PCIe Speed check
if [ -f /sys/bus/pci/devices/0000:07:00.0/current_link_speed ]; then
    if [ "$(cat /sys/bus/pci/devices/0000:07:00.0/current_link_speed)" = "16.0 GT/s PCIe" ]; then
        echo -e "${GREEN}✓ PCIe Speed: OPTIMIZED${NC}"
        ((score++))
    else
        echo -e "${RED}✗ PCIe Speed: NOT OPTIMIZED (requires BIOS check)${NC}"
    fi
else
    echo -e "${WHITE}○ PCIe Speed: NOT APPLICABLE${NC}"
    ((max_score--))
fi

# System Services check
if systemctl is-active --quiet cpupower-performance.service 2>/dev/null; then
    echo -e "${GREEN}✓ System Services: OPTIMIZED${NC}"
    ((score++))
else
    echo -e "${RED}✗ System Services: NOT OPTIMIZED${NC}"
fi

echo ""
echo -e "${WHITE}Overall Performance Score: $score/$max_score${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${CYAN}Created by litebiter & auxmeet${NC}"