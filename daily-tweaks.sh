#!/bin/bash

# Daily Maintenance Script
# Universal system maintenance
# Created by litebiter & auxmeet

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

echo -e "${CYAN}=== Daily Maintenance ===${NC}"

# Clean package cache
echo -e "${BLUE}Cleaning package cache...${NC}"
sudo pacman -Sc --noconfirm > /dev/null 2>&1
echo -e "${GREEN}Package cache cleaned${NC}"

# Clean systemd journal
echo -e "${BLUE}Cleaning systemd journal...${NC}"
sudo journalctl --vacuum-time=7d > /dev/null 2>&1
echo -e "${GREEN}Systemd journal cleaned${NC}"

# Check system status
echo -e "${BLUE}Checking system status...${NC}"
if [ -f "$(dirname "$0")/check-status.sh" ]; then
    bash "$(dirname "$0")/check-status.sh"
else
    echo -e "${GREEN}Status check script not found${NC}"
fi

# Check for updates
echo -e "${BLUE}Checking for system updates...${NC}"
sudo pacman -Sy > /dev/null 2>&1
echo -e "${GREEN}Update check completed${NC}"

# GPU status
if command -v nvidia-smi &> /dev/null; then
    echo -e "${BLUE}Checking GPU status...${NC}"
    nvidia-smi --query-gpu=name,temperature,power.draw --format=csv,noheader
fi

# CPU temperature
if command -v sensors &> /dev/null; then
    echo -e "${BLUE}CPU Temperature:${NC}"
    sensors | grep -E "Core|Package" | head -n4
fi

# Memory usage
echo -e "${BLUE}Memory Usage:${NC}"
free -h | grep Mem

# Disk usage
echo -e "${BLUE}Disk Usage:${NC}"
df -h | grep -E "Filesystem|/dev/"

echo -e "${GREEN}=== Daily Maintenance Complete ===${NC}"