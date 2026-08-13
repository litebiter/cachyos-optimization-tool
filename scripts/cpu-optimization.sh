#!/bin/bash

# Universal CPU Optimization Script
# Created by litebiter & auxmeet

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

echo -e "${CYAN}=== CPU Optimization ===${NC}"

# Load hardware configuration
if [ -f /tmp/hardware-config.conf ]; then
    source /tmp/hardware-config.conf
else
    echo -e "${CYAN}Detecting hardware...${NC}"
    bash "$(dirname "$0")/detect-hardware.sh"
    source /tmp/hardware-config.conf
fi

# Check available governors
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors ]; then
    echo -e "${BLUE}Available CPU governors:${NC}"
    cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
else
    echo -e "${GREEN}CPU frequency scaling not available${NC}"
    exit 0
fi

# Set performance governor
echo -e "${BLUE}Setting CPU governor to performance...${NC}"
cpupower frequency-set -g performance
echo -e "${GREEN}CPU governor set to performance${NC}"

# AMD P-State EPP optimization
if [ "$CPU_TYPE" == "AMD" ]; then
    if [ -d /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_available_preferences ]; then
        echo -e "${BLUE}Setting AMD P-State EPP to performance...${NC}"
        echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference > /dev/null 2>&1
        echo -e "${GREEN}AMD P-State EPP set to performance${NC}"
    fi
    
    if [ -f /sys/devices/system/cpu/amd_pstate/status ]; then
        echo -e "${BLUE}Current AMD P-State status:${NC}"
        cat /sys/devices/system/cpu/amd_pstate/status
    fi
fi

# Intel P-State optimization
if [ "$CPU_TYPE" == "Intel" ]; then
    if [ -f /sys/devices/system/cpu/intel_pstate/no_turbo ]; then
        echo -e "${BLUE}Enabling Turbo Boost...${NC}"
        echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
        echo -e "${GREEN}Turbo Boost enabled${NC}"
    fi
fi

# Current CPU frequency
echo -e "${BLUE}Current CPU frequency:${NC}"
cpupower frequency-info | grep 'frequency' | head -n1

echo -e "${GREEN}=== CPU Optimization Complete ===${NC}"