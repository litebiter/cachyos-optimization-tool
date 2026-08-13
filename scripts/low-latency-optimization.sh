#!/bin/bash

# Low Latency Gaming Optimization Script
# Based on Reddit, CachyOS Forum, and Arch Wiki recommendations
# Created by litebiter & auxmeet

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}=== Low Latency Gaming Optimization ===${NC}"

# Load hardware configuration
if [ -f /tmp/hardware-config.conf ]; then
    source /tmp/hardware-config.conf
    CPU_TYPE="${CPU_TYPE//\"/}"
    GPU_TYPE="${GPU_TYPE//\"/}"
else
    echo -e "${CYAN}Detecting hardware...${NC}"
    bash "$(dirname "$0")/detect-hardware.sh"
    source /tmp/hardware-config.conf
    CPU_TYPE="${CPU_TYPE//\"/}"
    GPU_TYPE="${GPU_TYPE//\"/}"
fi

echo -e "${BLUE}Applying low latency optimizations...${NC}"

# Apply low latency sysctl settings
echo -e "${BLUE}Applying low latency sysctl settings...${NC}"
if [ -f "$(dirname "$0")/../config/sysctl/99-low-latency.conf" ]; then
    sudo cp "$(dirname "$0")/../config/sysctl/99-low-latency.conf" /etc/sysctl.d/
    sudo sysctl -p /etc/sysctl.d/99-low-latency.conf
    echo -e "${GREEN}Low latency sysctl settings applied${NC}"
else
    echo -e "${RED}Low latency sysctl config not found${NC}"
fi

# Disable ananicy-cpp during gaming (if installed)
echo -e "${BLUE}Checking for ananicy-cpp...${NC}"
if systemctl is-active --quiet ananicy-cpp 2>/dev/null; then
    echo -e "${YELLOW}ananicy-cpp is running. Consider disabling it during gaming:${NC}"
    echo -e "${WHITE}sudo systemctl stop ananicy-cpp${NC}"
else
    echo -e "${GREEN}ananicy-cpp not running${NC}"
fi

# CPU isolation for gaming (optional)
echo -e "${BLUE}CPU isolation information:${NC}"
echo -e "${WHITE}For lowest latency, consider isolating CPU cores:${NC}"
echo -e "${WHITE}Add to kernel cmdline: isolcpus=2-5 (adjust based on your CPU)${NC}"
echo -e "${WHITE}Then use taskset to pin games to isolated cores${NC}"

# Disable split-lock detection
echo -e "${BLUE}Disabling split-lock detection...${NC}"
if [ -f /sys/kernel/debug/x86/split_lock_mitigate ]; then
    echo 0 | sudo tee /sys/kernel/debug/x86/split_lock_mitigate > /dev/null 2>&1
    echo -e "${GREEN}Split-lock detection disabled${NC}"
else
    echo -e "${WHITE}Split-lock detection not available or already disabled${NC}"
fi

# USB autosuspend disable for input devices
echo -e "${BLUE}Disabling USB autosuspend for input devices...${NC}"
for device in /sys/bus/usb/devices/*/power/autosuspend; do
    if [ -f "$device" ]; then
        echo -1 | sudo tee "$device" > /dev/null 2>&1
    fi
done
echo -e "${GREEN}USB autosuspend disabled${NC}"

# CPU frequency governor already set to performance by main script
echo -e "${BLUE}CPU governor check:${NC}"
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
    CURRENT_GOVERNOR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
    if [ "$CURRENT_GOVERNOR" == "performance" ]; then
        echo -e "${GREEN}CPU governor is set to performance${NC}"
    else
        echo -e "${YELLOW}CPU governor is $CURRENT_GOVERNOR (should be performance for low latency)${NC}"
    fi
fi

# GPU-specific low latency settings
echo -e "${BLUE}GPU low latency optimizations:${NC}"

if [ "$GPU_TYPE" == "NVIDIA" ]; then
    echo -e "${WHITE}NVIDIA GPU detected${NC}"
    if command -v nvidia-settings &> /dev/null; then
        echo -e "${WHITE}Set maximum performance in NVIDIA X Server Settings${NC}"
        echo -e "${WHITE}Enable Low Latency Mode in NVIDIA Control Panel${NC}"
        echo -e "${WHITE}Use '__GL_SYNC_TO_VBLANK=0' for lowest latency${NC}"
    fi
elif [ "$GPU_TYPE" == "AMD" ]; then
    echo -e "${WHITE}AMD GPU detected${NC}"
    echo -e "${WHITE}Consider using RADV_PERFTEST='amd' for testing${NC}"
    echo -e "${WHITE}Use 'RADV_THREAD=1' for multithreaded compilation${NC}"
fi

# Gaming tools recommendations
echo -e "${BLUE}Recommended gaming tools:${NC}"
echo -e "${WHITE}• GameMode: sudo pacman -S gamemode${NC}"
echo -e "${WHITE}• MangoHud: sudo pacman -S mangohud${NC}"
echo -e "${WHITE}• Gamescope: sudo pacman -S gamescope${NC}"
echo -e "${WHITE}• Low Latency Layer: Available in AUR (low_latency_layer)${NC}"

# Environment variables for gaming
echo -e "${BLUE}Recommended environment variables:${NC}"
echo -e "${WHITE}Steam launch options:${NC}"
echo -e "${CYAN}__GL_SYNC_TO_VBLANK=0 __GLX_VSYNC_MODE=0 vblank_mode=0%command%${NC}"
echo -e "${CYAN}__GL_THREADED_OPTIMIZATIONS=1%command%${NC}"
echo -e "${CYAN}PROTON_NO_ESYNC=1 PROTON_NO_FSYNC=1%command%${NC}"

# Gamescope recommendation
echo -e "${WHITE}For lowest latency with Gamescope:${NC}"
echo -e "${CYAN}gamescope -W 1920 -H 1080 -r 144 -b -- %command%${NC}"
echo -e "${WHITE}Set niceness: sudo setcap 'CAP_SYS_NICE=eip' \"\$(which gamescope)\"${NC}"

# Low Latency Layer recommendation
echo -e "${WHITE}Low Latency Layer (from AUR):${NC}"
echo -e "${CYAN}LOW_LATENCY_LAYER=1 %command%${NC}"
echo -e "${CYAN}LOW_LATENCY_LAYER_REFLEX=1 %command%${NC}"

# Kernel recommendation
echo -e "${BLUE}Kernel recommendations for low latency:${NC}"
echo -e "${WHITE}• BORE scheduler: CachyOS default (already enabled)${NC}"
echo -e "${WHITE}• sched-ext scx_lavd: Experimental gaming scheduler${NC}"
echo -e "${WHITE}• High refresh rate: Use 1000Hz tick rate for lowest latency${NC}"

# X11 vs Wayland
echo -e "${BLUE}Display server recommendation:${NC}"
echo -e "${WHITE}• X11: Generally lower input latency for gaming${NC}"
echo -e "${WHITE}• Wayland: Better for desktop, slightly higher latency${NC}"
echo -e "${WHITE}• For competitive gaming: X11 recommended${NC}"

echo -e "${GREEN}=== Low Latency Optimization Complete ===${NC}"
echo ""
echo -e "${YELLOW}⚠ Note: Some optimizations may trade performance for lower latency${NC}"
echo -e "${YELLOW}⚠ Test with your specific games to find the best balance${NC}"
echo ""
echo -e "${CYAN}For extreme low latency, add these kernel parameters:${NC}"
echo -e "${WHITE}processor.max_cstate=0 intel_idle.max_cstate=0 nowatchdog nosoftlockup audit=0 usbcore.autosuspend=-1${NC}"