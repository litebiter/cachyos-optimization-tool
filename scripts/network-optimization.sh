#!/bin/bash

# Universal Network Optimization Script
# Created by litebiter & auxmeet

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}=== Network Optimization ===${NC}"

# Load hardware configuration
if [ -f /tmp/hardware-config.conf ]; then
    source /tmp/hardware-config.conf
else
    echo -e "${CYAN}Detecting hardware...${NC}"
    bash "$(dirname "$0")/detect-hardware.sh"
    source /tmp/hardware-config.conf
fi

# Current network driver
echo -e "${BLUE}Current network driver: $NET_DRIVER${NC}"

# Realtek network card optimization
if lspci | grep -qi realtek; then
    echo -e "${BLUE}Realtek network card detected${NC}"
    
    # Try to switch to r8168 if using r8169
    if lsmod | grep -q r8169; then
        echo -e "${BLUE}Switching from r8169 to r8168 driver...${NC}"
        
        # Check if r8168 is available
        if modinfo r8168 &> /dev/null; then
            modprobe -r r8169 > /dev/null 2>&1
            modprobe r8168 > /dev/null 2>&1
            
            # Blacklist r8169
            echo "blacklist r8169" > /etc/modprobe.d/blacklist-r8169.conf 2>/dev/null
            echo "r8168" > /etc/modules-load.d/r8168.conf 2>/dev/null
            
            echo -e "${GREEN}Switched to r8168 driver${NC}"
        else
            echo -e "${GREEN}r8168 driver not available, keeping r8169${NC}"
        fi
    fi
fi

# Intel network card optimization
if lspci | grep -qi "intel.*ethernet"; then
    echo -e "${BLUE}Intel network card detected${NC}"
    echo -e "${GREEN}Intel network cards use optimized drivers by default${NC}"
fi

# General network optimizations
echo -e "${BLUE}Applying general network optimizations...${NC}"

# Increase network buffers
echo 16777216 > /proc/sys/net/core/rmem_max > /dev/null 2>&1
echo 16777216 > /proc/sys/net/core/wmem_max > /dev/null 2>&1
echo 5000 > /proc/sys/net/core/netdev_max_backlog > /dev/null 2>&1
echo 65535 > /proc/sys/net/core/somaxconn > /dev/null 2>&1

# TCP optimizations
echo "4096 87380 16777216" > /proc/sys/net/ipv4/tcp_rmem > /dev/null 2>&1
echo "4096 65536 16777216" > /proc/sys/net/ipv4/tcp_wmem > /dev/null 2>&1
echo 1 > /proc/sys/net/ipv4/tcp_window_scaling > /dev/null 2>&1
echo 1 > /proc/sys/net/ipv4/tcp_timestamps > /dev/null 2>&1
echo 1 > /proc/sys/net/ipv4/tcp_sack > /dev/null 2>&1
echo 1 > /proc/sys/net/ipv4/tcp_fack > /dev/null 2>&1
echo 3 > /proc/sys/net/ipv4/tcp_fastopen > /dev/null 2>&1
echo 0 > /proc/sys/net/ipv4/tcp_slow_start_after_idle > /dev/null 2>&1

# UDP optimizations
echo 8192 > /proc/sys/net/ipv4/udp_rmem_min > /dev/null 2>&1
echo 8192 > /proc/sys/net/ipv4/udp_wmem_min > /dev/null 2>&1

echo -e "${GREEN}Network optimizations applied${NC}"

# Network status
echo -e "${BLUE}Network status:${NC}"
ip addr show 2>/dev/null | grep -E "^[0-9]+:|inet " | head -n4

echo -e "${GREEN}=== Network Optimization Complete ===${NC}"