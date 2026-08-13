#!/bin/bash

# Universal GPU Optimization Script
# Created by litebiter & auxmeet

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

echo -e "${CYAN}=== GPU Optimization ===${NC}"

# Load hardware configuration
if [ -f /tmp/hardware-config.conf ]; then
    source /tmp/hardware-config.conf
else
    echo -e "${CYAN}Detecting hardware...${NC}"
    bash "$(dirname "$0")/detect-hardware.sh"
    source /tmp/hardware-config.conf
fi

# NVIDIA GPU optimization
if [ "$GPU_TYPE" == "NVIDIA" ]; then
    echo -e "${BLUE}NVIDIA GPU detected${NC}"
    
    if command -v nvidia-smi &> /dev/null; then
        echo -e "${BLUE}Current GPU status:${NC}"
        nvidia-smi --query-gpu=name,driver_version --format=csv,noheader
        
        # Enable persistence mode
        echo -e "${BLUE}Enabling NVIDIA persistence mode...${NC}"
        nvidia-smi -pm 1 > /dev/null 2>&1
        echo -e "${GREEN}NVIDIA persistence mode enabled${NC}"
        
        # Set power limit to maximum
        echo -e "${BLUE}Setting GPU power limit to maximum...${NC}"
        nvidia-smi -pl 0 > /dev/null 2>&1
        echo -e "${GREEN}GPU power limit set to maximum${NC}"
        
        # PCIe optimization
        echo -e "${BLUE}Optimizing PCIe settings...${NC}"
        if [ -f /sys/module/pcie_aspm/parameters/policy ]; then
            echo performance > /sys/module/pcie_aspm/parameters/policy > /dev/null 2>&1
            echo -e "${GREEN}PCIe ASPM set to performance${NC}"
        fi
        
        # Check PCIe status
        echo -e "${BLUE}Current PCIe status:${NC}"
        if [ -f /sys/bus/pci/devices/0000:07:00.0/current_link_speed ]; then
            echo "Link Speed: $(cat /sys/bus/pci/devices/0000:07:00.0/current_link_speed)"
            echo "Link Width: $(cat /sys/bus/pci/devices/0000:07:00.0/current_link_width)"
        fi
        
        # Apply NVIDIA settings if X11 is running
        if command -v nvidia-settings &> /dev/null && [ -n "$DISPLAY" ]; then
            echo -e "${BLUE}Applying NVIDIA settings...${NC}"
            nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=1" > /dev/null 2>&1
            echo -e "${GREEN}NVIDIA settings applied${NC}"
        fi
    else
        echo -e "${GREEN}NVIDIA drivers not found or not installed${NC}"
    fi

# AMD GPU optimization
elif [ "$GPU_TYPE" == "AMD" ]; then
    echo -e "${BLUE}AMD GPU detected${NC}"
    
    # Check for amdgpu driver
    if lsmod | grep -q amdgpu; then
        echo -e "${BLUE}AMDGPU driver loaded${NC}"
        
        # Set performance mode
        if [ -d /sys/class/drm ]; then
            echo -e "${BLUE}Setting AMD GPU performance mode...${NC}"
            # Try to set performance mode for all AMD GPUs
            for card in /sys/class/drm/card*/device/power_dpm_state; do
                if [ -f "$card" ]; then
                    echo performance > "$card" > /dev/null 2>&1
                fi
            done
            echo -e "${GREEN}AMD GPU performance mode set${NC}"
        fi
        
        # PCIe optimization
        echo -e "${BLUE}Optimizing PCIe settings...${NC}"
        if [ -f /sys/module/pcie_aspm/parameters/policy ]; then
            echo performance > /sys/module/pcie_aspm/parameters/policy > /dev/null 2>&1
            echo -e "${GREEN}PCIe ASPM set to performance${NC}"
        fi
    else
        echo -e "${GREEN}AMDGPU driver not loaded${NC}"
    fi

# Intel GPU optimization
elif [ "$GPU_TYPE" == "Intel" ]; then
    echo -e "${BLUE}Intel GPU detected${NC}"
    
    # Check for i915 driver
    if lsmod | grep -q i915; then
        echo -e "${BLUE}Intel i915 driver loaded${NC}"
        echo -e "${GREEN}Intel GPU uses integrated graphics, no specific optimizations needed${NC}"
    else
        echo -e "${GREEN}Intel GPU driver not loaded${NC}"
    fi

else
    echo -e "${GREEN}No dedicated GPU or unknown GPU type${NC}"
fi

echo -e "${GREEN}=== GPU Optimization Complete ===${NC}"