#!/bin/bash

# Universal Storage Optimization Script
# Created by litebiter & auxmeet

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}=== Storage Optimization ===${NC}"

# Load hardware configuration
if [ -f /tmp/hardware-config.conf ]; then
    source /tmp/hardware-config.conf
else
    echo -e "${CYAN}Detecting hardware...${NC}"
    bash "$(dirname "$0")/detect-hardware.sh"
    source /tmp/hardware-config.conf
fi

# Optimize I/O schedulers for each device
echo -e "${BLUE}Optimizing I/O schedulers...${NC}"
for device in /sys/block/*; do
    dev_name=$(basename "$device")
    
    # Skip loop devices and non-block devices
    [[ "$dev_name" == loop* ]] && continue
    [[ ! -f "$device/queue/rotational" ]] && continue
    
    rotational=$(cat "$device/queue/rotational")
    
    if [ "$rotational" -eq 0 ]; then
        # SSD/NVMe device
        if [[ "$dev_name" == nvme* ]]; then
            echo "none" > "$device/queue/scheduler" > /dev/null 2>&1
            echo -e "${GREEN}Set scheduler to 'none' for NVMe $dev_name${NC}"
        else
            echo "mq-deadline" > "$device/queue/scheduler" > /dev/null 2>&1
            echo -e "${GREEN}Set scheduler to 'mq-deadline' for SSD $dev_name${NC}"
        fi
        
        # Optimize queue depth
        if [ -f "$device/queue/nr_requests" ]; then
            echo 128 > "$device/queue/nr_requests" > /dev/null 2>&1
        fi
        
        # Optimize read-ahead
        if [ -f "$device/queue/read_ahead_kb" ]; then
            echo 128 > "$device/queue/read_ahead_kb" > /dev/null 2>&1
        fi
    else
        # HDD device
        echo "bfq" > "$device/queue/scheduler" > /dev/null 2>&1
        echo -e "${GREEN}Set scheduler to 'bfq' for HDD $dev_name${NC}"
        
        # Apply hdparm settings for HDD
        if command -v hdparm &> /dev/null; then
            hdparm -B 254 -S 0 "/dev/$dev_name" > /dev/null 2>&1
        fi
    fi
done

# Optimize SATA link power management
echo -e "${BLUE}Optimizing SATA link power management...${NC}"
if [ -d /sys/class/scsi_host ]; then
    for host in /sys/class/scsi_host/host*; do
        if [ -f "$host/link_power_management_policy" ]; then
            echo "max_performance" > "$host/link_power_management_policy" > /dev/null 2>&1
        fi
    done
    echo -e "${GREEN}SATA link power management set to max_performance${NC}"
fi

# Enable periodic TRIM for SSDs
if [ $NVME_COUNT -gt 0 ] || [ $SSD_COUNT -gt 0 ]; then
    echo -e "${BLUE}Enabling periodic TRIM for SSDs...${NC}"
    systemctl enable fstrim.timer > /dev/null 2>&1
    systemctl start fstrim.timer > /dev/null 2>&1
    echo -e "${GREEN}Periodic TRIM enabled${NC}"
fi

# Current I/O schedulers
echo -e "${BLUE}Current I/O schedulers:${NC}"
for device in /sys/block/*; do
    if [ -f "$device/queue/scheduler" ]; then
        scheduler=$(cat "$device/queue/scheduler")
        current=$(echo "$scheduler" | grep -o '\[.*\]' | tr -d '[]')
        [[ -n "$current" ]] && echo "$(basename $device): $current"
    fi
done

echo -e "${GREEN}=== Storage Optimization Complete ===${NC}"