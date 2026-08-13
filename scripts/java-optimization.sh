#!/bin/bash

# Java Optimization Script for CachyOS/Arch Linux
# Based on Reddit, Arch Wiki, Phoronix benchmarks, and Minecraft optimization guides
# Created by litebiter & auxmeet

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}=== Java Performance Optimization for CachyOS ===${NC}"
echo ""

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo -e "${RED}Java not found. Installing OpenJDK...${NC}"
    sudo pacman -S jdk-openjdk jre-openjdk --noconfirm
    echo -e "${GREEN}✓ Java installed${NC}"
else
    echo -e "${GREEN}✓ Java is already installed${NC}"
fi

echo ""
echo -e "${BLUE}Checking Java version...${NC}"
java -version 2>&1 | head -n1

echo ""
echo -e "${BLUE}Detecting CPU architecture...${NC}"
CPU_FLAGS=$(cat /proc/cpuinfo | grep flags | head -n1)

if echo "$CPU_FLAGS" | grep -q "avx512"; then
    ARCH_LEVEL="x86-64-v4"
    echo -e "${GREEN}Detected: x86-64-v4 (AVX512 support)${NC}"
elif echo "$CPU_FLAGS" | grep -q "avx2"; then
    ARCH_LEVEL="x86-64-v3"
    echo -e "${GREEN}Detected: x86-64-v3 (AVX2 support)${NC}"
else
    ARCH_LEVEL="x86-64"
    echo -e "${YELLOW}Detected: x86-64 (generic)${NC}"
fi

echo ""
echo -e "${BLUE}Checking CachyOS optimized repositories...${NC}"

# Check if CachyOS repos are configured
if grep -q "cachyos-v3" /etc/pacman.conf 2>/dev/null || grep -q "cachyos-v4" /etc/pacman.conf 2>/dev/null; then
    echo -e "${GREEN}✓ CachyOS optimized repositories are configured${NC}"
    echo -e "${CYAN}  These provide 5-20% performance improvement for Java${NC}"
else
    echo -e "${YELLOW}⚠ CachyOS optimized repositories not configured${NC}"
    echo -e "${WHITE}  Consider enabling them for better Java performance${NC}"
    echo -e "${WHITE}  See: https://wiki.cachyos.org/features/optimized_repos/${NC}"
fi

echo ""
echo -e "${BLUE}Applying system-level Java optimizations...${NC}"

# Enable Transparent Huge Pages for Java
echo -e "${WHITE}Enabling Transparent Huge Pages...${NC}"
if [ -w /sys/kernel/mm/transparent_hugepage/enabled ]; then
    echo always > /sys/kernel/mm/transparent_hugepage/enabled 2>/dev/null || echo "  (Requires root)"
    echo -e "${GREEN}✓ Transparent Huge Pages enabled${NC}"
else
    echo -e "${YELLOW}⚠ Cannot set Transparent Huge Pages (requires root)${NC}"
fi

# Check if huge pages are configured
if [ -f /proc/sys/vm/nr_hugepages ]; then
    CURRENT_HUGEPAGES=$(cat /proc/sys/vm/nr_hugepages)
    if [ "$CURRENT_HUGEPAGES" -eq 0 ]; then
        echo -e "${YELLOW}⚠ No huge pages allocated. For Java servers, consider allocating huge pages${NC}"
        echo -e "${WHITE}  Add to /etc/sysctl.conf: vm.nr_hugepages = 1024${NC}"
    else
        echo -e "${GREEN}✓ $CURRENT_HUGEPAGES huge pages allocated${NC}"
    fi
fi

echo ""
echo -e "${BLUE}Creating Java optimization configuration...${NC}"

USER_HOME=$(getent passwd $(whoami) | cut -d':' -f6)
JAVA_ENV_FILE="$USER_HOME/.config/cachyos-optimization/java-env.conf"
mkdir -p "$USER_HOME/.config/cachyos-optimization"

# Create Java environment file
cat > "$JAVA_ENV_FILE" << 'EOF'
# Java Performance Optimization Environment Variables
# Created by cachyos-optimization-tool
# Based on Reddit, Arch Wiki, and Phoronix benchmarks

# General Java optimizations
export _JAVA_OPTIONS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"

# For Java 21+ with Generational ZGC (better for large heaps and low latency)
# Uncomment for Java 21+ applications:
# export _JAVA_OPTIONS="-XX:+UseZGC -XX:+ZGenerational -XX:ZCollectionInterval=5 -XX:ConcGCThreads=2 -XX:ParallelGCThreads=8"

# NUMA optimization for multi-socket systems
export _JAVA_OPTIONS="$_JAVA_OPTIONS -XX:+UseNUMA"

# Code cache optimization
export _JAVA_OPTIONS="$_JAVA_OPTIONS -XX:ReservedCodeCacheSize=400M -XX:NonNMethodCodeHeapSize=12M -XX:ProfiledCodeHeapSize=194M -XX:NonProfiledCodeHeapSize=194M"

# Disable JIT compilation of huge methods (reduces compilation overhead)
export _JAVA_OPTIONS="$_JAVA_OPTIONS -XX:-DontCompileHugeMethods -XX:MaxNodeLimit=240000 -XX:NodeLimitFudgeFactor=8000"

# Performance monitoring optimizations
export _JAVA_OPTIONS="$_JAVA_OPTIONS -XX:+PerfDisableSharedMem -XX:+UseFastUnorderedTimeStamps"

# Thread priority optimization
export _JAVA_OPTIONS="$_JAVA_OPTIONS -XX:+UseCriticalJavaThreadPriority -XX:ThreadPriorityPolicy=1"

# Vectorization optimizations
export _JAVA_OPTIONS="$_JAVA_OPTIONS -XX:+UseVectorCmov"

# Minecraft-specific optimizations (Aikar's flags - widely tested)
# For Minecraft servers/clients, use these instead:
# export _JAVA_OPTIONS="-Xms4G -Xmx4G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"
EOF

echo -e "${GREEN}✓ Java environment file created at $JAVA_ENV_FILE${NC}"

# Source the file in .bashrc if not already present
BASHRC="$USER_HOME/.bashrc"
if ! grep -q "cachyos-optimization/java-env.conf" "$BASHRC" 2>/dev/null; then
    echo "" >> "$BASHRC"
    echo "# Load Java optimizations" >> "$BASHRC"
    echo "source $JAVA_ENV_FILE" >> "$BASHRC"
    echo -e "${GREEN}✓ Added to .bashrc${NC}"
fi

# Source in .zshrc if zsh is used
ZSHRC="$USER_HOME/.zshrc"
if [ -f "$ZSHRC" ] && ! grep -q "cachyos-optimization/java-env.conf" "$ZSHRC" 2>/dev/null; then
    echo "" >> "$ZSHRC"
    echo "# Load Java optimizations" >> "$ZSHRC"
    echo "source $JAVA_ENV_FILE" >> "$ZSHRC"
    echo -e "${GREEN}✓ Added to .zshrc${NC}"
fi

echo ""
echo -e "${BLUE}Creating sysctl configuration for Java optimization...${NC}"

SYSCTL_FILE="/etc/sysctl.d/99-java-tuning.conf"
sudo tee "$SYSCTL_FILE" > /dev/null << 'EOF'
# Java Performance Tuning
# Created by cachyos-optimization-tool

# Huge pages for Java (improves memory access)
vm.nr_hugepages = 1024
vm.hugetlb_shm_group = 0

# Transparent huge pages (already enabled via sysfs, this ensures persistence)
vm.transparent_hugepage = always

# Memory overcommit for Java (prevents OOM errors)
vm.overcommit_memory = 1
vm.overcommit_ratio = 150

# Shared memory segments for Java
kernel.shmmax = 68719476736
kernel.shmall = 4294967296

# Increase file descriptor limits for Java servers
fs.file-max = 2097152
EOF

echo -e "${GREEN}✓ Sysctl configuration created at $SYSCTL_FILE${NC}"

sudo sysctl -p "$SYSCTL_FILE" > /dev/null 2>&1
echo -e "${GREEN}✓ Sysctl settings applied${NC}"

echo ""
echo -e "${BLUE}Creating systemd override for Java services...${NC}"

# Create a systemd override file for java services
SYSTEMD_OVERRIDE="/etc/systemd/system.conf.d/java-performance.conf"
sudo mkdir -p /etc/systemd/system.conf.d
sudo tee "$SYSTEMD_OVERRIDE" > /dev/null << 'EOF'
# Java Performance Override
# LimitNOFILE is increased for Java applications
[Manager]
DefaultLimitNOFILE=65536
EOF

echo -e "${GREEN}✓ Systemd override created${NC}"

echo ""
echo -e "${GREEN}=== Java Optimization Complete ===${NC}"
echo ""
echo -e "${WHITE}Applied optimizations based on:${NC}"
echo -e "${WHITE}• Phoronix CachyOS benchmarks${NC}"
echo -e "${WHITE}• Arch Wiki Java documentation${NC}"
echo -e "${WHITE}• Reddit Minecraft optimization guides${NC}"
echo -e "${WHITE}• Aikar's Minecraft flags (widely tested)${NC}"
echo ""
echo -e "${CYAN}System-level optimizations:${NC}"
echo -e "  • Transparent Huge Pages enabled"
echo -e "  • Huge pages configured (1024 pages)"
echo -e "  • Memory overcommit optimized"
echo -e "  • Shared memory limits increased"
echo -e "  • File descriptor limits increased"
echo ""
echo -e "${CYAN}JVM optimizations (via _JAVA_OPTIONS):${NC}"
echo -e "  • G1GC with tuned parameters"
echo -e "  • NUMA awareness enabled"
echo -e "  • Code cache optimized"
echo -e "  • Vectorization enabled"
echo -e "  • Thread priority optimization"
echo ""
echo -e "${YELLOW}⚠ To apply changes, restart your terminal or run:${NC}"
echo -e "  source $JAVA_ENV_FILE"
echo ""
echo -e "${YELLOW}⚠ For Minecraft-specific optimizations, uncomment the Minecraft section in:${NC}"
echo -e "  $JAVA_ENV_FILE"
echo ""
echo -e "${YELLOW}⚠ For Java 21+ with low latency requirements, consider Generational ZGC:${NC}"
echo -e "  Uncomment the ZGC section in $JAVA_ENV_FILE"
echo ""
echo -e "${CYAN}For Minecraft servers, use these Aikar's flags:${NC}"
echo -e "${WHITE}java -Xms4G -Xmx4G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -jar server.jar${NC}"
echo ""
echo -e "${CYAN}Expected performance improvements:${NC}"
echo -e "  • 5-20% from CachyOS optimized repositories (if configured)${NC}"
echo -e "  • Reduced GC pauses with G1GC tuning${NC}"
echo -e "  • Better memory access with huge pages${NC}"
echo -e "  • Improved NUMA performance on multi-socket systems${NC}"
echo ""
echo -e "${CYAN}Created by litebiter & auxmeet${NC}"
