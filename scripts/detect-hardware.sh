#!/bin/bash

# Hardware Detection Script
# Universal detection for all CPU/GPU combinations

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

echo -e "${CYAN}=== Hardware Detection ===${NC}"

# CPU Detection
echo -e "${BLUE}Detecting CPU...${NC}"
CPU_VENDOR=$(grep 'vendor_id' /proc/cpuinfo | head -n1 | awk '{print $3}')
CPU_MODEL_RAW=$(grep 'model name' /proc/cpuinfo | head -n1 | cut -d':' -f2)
CPU_MODEL=$(echo "$CPU_MODEL_RAW" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
CPU_CORES=$(nproc)
CPU_THREADS=$(lscpu | grep 'Thread' | awk '{print $4}')

if [[ "$CPU_VENDOR" == "AuthenticAMD" ]]; then
    CPU_TYPE="AMD"
    CPU_FAMILY=$(lscpu | grep 'CPU family' | awk '{print $3}')
elif [[ "$CPU_VENDOR" == "GenuineIntel" ]]; then
    CPU_TYPE="Intel"
    CPU_FAMILY=$(lscpu | grep 'CPU family' | awk '{print $3}')
else
    CPU_TYPE="Unknown"
    CPU_FAMILY="Unknown"
fi

echo -e "${GREEN}CPU: $CPU_TYPE $CPU_MODEL ($CPU_CORES cores, $CPU_THREADS threads)${NC}"

# GPU Detection
echo -e "${BLUE}Detecting GPU...${NC}"
GPU_INFO=$(lspci | grep -i vga)
GPU_COUNT=$(echo "$GPU_INFO" | wc -l)

if [ $GPU_COUNT -gt 0 ]; then
    INDEX=1
    FIRST_LINE=$(echo "$GPU_INFO" | head -n1)
    
    if echo "$FIRST_LINE" | grep -qi nvidia; then
        GPU_TYPE="NVIDIA"
        # Extract the part between brackets which usually contains the model
        GPU_MODEL_RAW=$(echo "$FIRST_LINE" | grep -o '\[.*\]' | sed 's/\[//' | sed 's/\]//')
        if [ -z "$GPU_MODEL_RAW" ]; then
            GPU_MODEL_RAW=$(echo "$FIRST_LINE" | sed 's/.*NVIDIA //' | sed 's/Corporation//' | xargs)
        fi
        GPU_MODEL=$(echo "$GPU_MODEL_RAW" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    elif echo "$FIRST_LINE" | grep -qi "advanced micro devices"; then
        GPU_TYPE="AMD"
        GPU_MODEL_RAW=$(echo "$FIRST_LINE" | grep -o '\[.*\]' | sed 's/\[//' | sed 's/\]//')
        if [ -z "$GPU_MODEL_RAW" ]; then
            GPU_MODEL_RAW=$(echo "$FIRST_LINE" | sed 's/.*AMD //' | sed 's/Corporation//' | xargs)
        fi
        GPU_MODEL=$(echo "$GPU_MODEL_RAW" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    elif echo "$FIRST_LINE" | grep -qi intel; then
        GPU_TYPE="Intel"
        GPU_MODEL_RAW=$(echo "$FIRST_LINE" | grep -o '\[.*\]' | sed 's/\[//' | sed 's/\]//')
        if [ -z "$GPU_MODEL_RAW" ]; then
            GPU_MODEL_RAW=$(echo "$FIRST_LINE" | sed 's/.*Intel //' | sed 's/Corporation//' | xargs)
        fi
        GPU_MODEL=$(echo "$GPU_MODEL_RAW" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    else
        GPU_TYPE="Unknown"
        GPU_MODEL_RAW=$(echo "$FIRST_LINE" | cut -d':' -f3)
        GPU_MODEL=$(echo "$GPU_MODEL_RAW" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    fi
    
    echo -e "${GREEN}GPU 1: $GPU_TYPE - $GPU_MODEL${NC}"
    
    # Display additional GPUs if present
    if [ $GPU_COUNT -gt 1 ]; then
        echo "$GPU_INFO" | tail -n +2 | while read -r line; do
            ((INDEX++))
            echo -e "${GREEN}GPU $INDEX: Additional GPU detected${NC}"
        done
    fi
else
    GPU_TYPE="None"
    GPU_MODEL="None"
    echo -e "${GREEN}No dedicated GPU detected${NC}"
fi

# Ensure GPU_TYPE is set
if [ -z "$GPU_TYPE" ]; then
    GPU_TYPE="None"
    GPU_MODEL="None"
fi

# Memory Detection
echo -e "${BLUE}Detecting Memory...${NC}"
RAM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
RAM_AVAILABLE=$(free -h | grep Mem | awk '{print $7}')
RAM_GB_RAW=$(free -g | grep Mem | awk '{print $2}')
echo -e "${GREEN}Memory: $RAM_AVAILABLE / $RAM_TOTAL available${NC}"

# Storage Detection
echo -e "${BLUE}Detecting Storage...${NC}"
SSD_COUNT=0
HDD_COUNT=0
NVME_COUNT=0

while IFS= read -r line; do
    DEVICE=$(echo "$line" | awk '{print $1}')
    ROTATIONAL=$(echo "$line" | awk '{print $2}')
    
    if [[ "$DEVICE" == nvme* ]]; then
        ((NVME_COUNT++))
    elif [ "$ROTATIONAL" == "0" ]; then
        ((SSD_COUNT++))
    elif [ "$ROTATIONAL" == "1" ]; then
        ((HDD_COUNT++))
    fi
done < <(lsblk -d -o name,rota -n)

echo -e "${GREEN}Storage: $NVME_COUNT NVMe, $SSD_COUNT SSD, $HDD_COUNT HDD${NC}"

# Network Detection
echo -e "${BLUE}Detecting Network...${NC}"
NET_DRIVER=$(lspci -nnk -d ::0200 2>/dev/null | grep -A 3 "Ethernet" | grep "driver" | awk '{print $5}')
if [ -z "$NET_DRIVER" ]; then
    NET_DRIVER="Unknown"
fi
echo -e "${GREEN}Network Driver: $NET_DRIVER${NC}"

# Kernel Detection
echo -e "${BLUE}Detecting Kernel...${NC}"
KERNEL_VERSION=$(uname -r)
KERNEL_NAME=$(uname -s)
echo -e "${GREEN}Kernel: $KERNEL_NAME $KERNEL_VERSION${NC}"

# Governor Detection
echo -e "${BLUE}Detecting CPU Governor...${NC}"
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
    CURRENT_GOVERNOR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
    AVAILABLE_GOVERNORS=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)
    echo -e "${GREEN}Current Governor: $CURRENT_GOVERNOR${NC}"
    echo -e "${GREEN}Available Governors: $AVAILABLE_GOVERNORS${NC}"
else
    echo -e "${GREEN}CPU frequency scaling not available${NC}"
fi

# Output hardware configuration file
cat > /tmp/hardware-config.conf << EOF
CPU_TYPE="$CPU_TYPE"
CPU_MODEL="$CPU_MODEL"
CPU_CORES=$CPU_CORES
CPU_THREADS=$CPU_THREADS
CPU_FAMILY="$CPU_FAMILY"
GPU_COUNT=$GPU_COUNT
GPU_TYPE="$GPU_TYPE"
GPU_MODEL="$GPU_MODEL"
RAM_TOTAL="$RAM_TOTAL"
RAM_GB_RAW=$RAM_GB_RAW
NVME_COUNT=$NVME_COUNT
SSD_COUNT=$SSD_COUNT
HDD_COUNT=$HDD_COUNT
NET_DRIVER="$NET_DRIVER"
KERNEL_VERSION="$KERNEL_VERSION"
CURRENT_GOVERNOR="$CURRENT_GOVERNOR"
EOF

echo -e "${CYAN}Hardware configuration saved to /tmp/hardware-config.conf${NC}"
echo -e "${GREEN}=== Detection Complete ===${NC}"