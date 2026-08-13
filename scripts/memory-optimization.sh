#!/bin/bash

# Universal Memory Optimization Script
# Created by litebiter & auxmeet

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}=== Memory Optimization ===${NC}"

# Load hardware configuration
if [ -f /tmp/hardware-config.conf ]; then
    source /tmp/hardware-config.conf
    # Remove quotes from variables
    CPU_TYPE="${CPU_TYPE//\"/}"
    CPU_MODEL="${CPU_MODEL//\"/}"
    RAM_TOTAL="${RAM_TOTAL//\"/}"
    RAM_GB_RAW="${RAM_GB_RAW//\"/}"
else
    echo -e "${CYAN}Detecting hardware...${NC}"
    bash "$(dirname "$0")/detect-hardware.sh"
    source /tmp/hardware-config.conf
    CPU_TYPE="${CPU_TYPE//\"/}"
    CPU_MODEL="${CPU_MODEL//\"/}"
    RAM_TOTAL="${RAM_TOTAL//\"/}"
    RAM_GB_RAW="${RAM_GB_RAW//\"/}"
fi

# Current memory settings
echo -e "${BLUE}Current memory settings:${NC}"
echo "Swappiness: $(cat /proc/sys/vm/swappiness)"
echo "VFS Cache Pressure: $(cat /proc/sys/vm/vfs_cache_pressure)"

# Optimize swappiness based on RAM size
echo -e "${BLUE}Optimizing swappiness...${NC}"
if [ -n "$RAM_GB_RAW" ]; then
    if [ "$RAM_GB_RAW" -ge 16 ]; then
        echo 10 > /proc/sys/vm/swappiness
        echo -e "${GREEN}Swappiness set to 10 (high RAM system)${NC}"
    elif [ "$RAM_GB_RAW" -ge 8 ]; then
        echo 20 > /proc/sys/vm/swappiness
        echo -e "${GREEN}Swappiness set to 20 (medium RAM system)${NC}"
    else
        echo 30 > /proc/sys/vm/swappiness
        echo -e "${GREEN}Swappiness set to 30 (low RAM system)${NC}"
    fi
else
    echo 20 > /proc/sys/vm/swappiness
    echo -e "${GREEN}Swappiness set to 20 (default)${NC}"
fi

# Optimize VFS cache pressure
echo -e "${BLUE}Optimizing VFS cache pressure...${NC}"
echo 50 > /proc/sys/vm/vfs_cache_pressure
echo -e "${GREEN}VFS cache pressure set to 50${NC}"

# Enable transparent hugepages
if [ -f /proc/sys/vm/transparent_hugepage ]; then
    echo -e "${BLUE}Enabling transparent hugepages...${NC}"
    echo always > /proc/sys/vm/transparent_hugepage
    echo -e "${GREEN}Transparent hugepages enabled${NC}"
fi

# Optimize dirty ratios
echo -e "${BLUE}Optimizing dirty ratios...${NC}"
echo 15 > /proc/sys/vm/dirty_ratio
echo 5 > /proc/sys/vm/dirty_background_ratio
echo -e "${GREEN}Dirty ratios optimized${NC}"

# Optimize dirty bytes for SSD systems
if [ $NVME_COUNT -gt 0 ] || [ $SSD_COUNT -gt 0 ]; then
    echo -e "${BLUE}Optimizing dirty bytes for SSD systems...${NC}"
    echo 67108864 > /proc/sys/vm/dirty_background_bytes
    echo 536870912 > /proc/sys/vm/dirty_bytes
    echo -e "${GREEN}Dirty bytes optimized for SSD${NC}"
fi

# Disable page-cluster
echo -e "${BLUE}Disabling page-cluster...${NC}"
echo 0 > /proc/sys/vm/page-cluster
echo -e "${GREEN}Page-cluster disabled${NC}"

# Set min_free_kbytes
echo -e "${BLUE}Setting min_free_kbytes...${NC}"
echo 65536 > /proc/sys/vm/min_free_kbytes
echo -e "${GREEN}Min_free_kbytes set${NC}"

# Updated memory settings
echo -e "${BLUE}Updated memory settings:${NC}"
echo "Swappiness: $(cat /proc/sys/vm/swappiness)"
echo "VFS Cache Pressure: $(cat /proc/sys/vm/vfs_cache_pressure)"

echo -e "${GREEN}=== Memory Optimization Complete ===${NC}"