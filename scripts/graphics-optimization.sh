#!/bin/bash

# Graphics Optimization Script (OpenGL/Vulkan)
# Based on Reddit, CachyOS Forum, and Arch Wiki recommendations
# Created by litebiter & auxmeet

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}=== Graphics Optimization (OpenGL/Vulkan) ===${NC}"
echo ""

# Detect GPU
GPU_VENDOR=$(lspci | grep -i "vga\|3d\|2d" | grep -iE "amd|nvidia|intel" | head -n1 | awk '{print tolower($0)}')

if [[ "$GPU_VENDOR" == *"nvidia"* ]]; then
    GPU_TYPE="nvidia"
    echo -e "${GREEN}Detected GPU: NVIDIA${NC}"
elif [[ "$GPU_VENDOR" == *"amd"* ]] || [[ "$GPU_VENDOR" == *"radeon"* ]]; then
    GPU_TYPE="amd"
    echo -e "${GREEN}Detected GPU: AMD${NC}"
elif [[ "$GPU_VENDOR" == *"intel"* ]]; then
    GPU_TYPE="intel"
    echo -e "${GREEN}Detected GPU: Intel${NC}"
else
    GPU_TYPE="unknown"
    echo -e "${YELLOW}Could not detect GPU vendor${NC}"
fi

echo ""

USER_HOME=$(getentpasswd $(whoami) | cut -d':' -f6)
ENV_FILE="$USER_HOME/.config/cachyos-optimization/graphics-env.conf"
mkdir -p "$USER_HOME/.config/cachyos-optimization"

echo -e "${BLUE}Applying graphics optimizations...${NC}"

# Common optimizations for all GPUs
cat > "$ENV_FILE" << 'EOF'
# Graphics Optimization Environment Variables
# Created by cachyos-optimization-tool
# Based on Reddit and Arch Wiki recommendations

# Common Mesa optimizations
export MESA_GL_VERSION_OVERRIDE=4.6
export MESA_VK_VERSION_OVERRIDE=1.3
EOF

if [ "$GPU_TYPE" == "nvidia" ]; then
    # NVIDIA-specific optimizations (Reddit/CachyOS Forum)
    cat >> "$ENV_FILE" << 'EOF'

# NVIDIA-specific optimizations
export __GL_THREADED_OPTIMIZATIONS=1
export __GL_SHADER_DISK_CACHE=1
export __GL_SHADER_DISK_CACHE_PATH=$HOME/.cache/nvidia
export __GL_MAX_FRAMES_ALLOWED=0
export __GL_SYNC_TO_VBLANK=0
export __GL_YIELD=USLEEP

# Force NVIDIA driver for Vulkan (use Mesa NVK if needed)
# Uncomment to use NVK instead of proprietary:
# export __GLX_VENDOR_LIBRARY_NAME=mesa
# export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
# export MESA_LOADER_DRIVER_OVERRIDE=zink
# export GALLIUM_DRIVER=zink
EOF

elif [ "$GPU_TYPE" == "amd" ]; then
    # AMD-specific optimizations (Reddit/CachyOS Forum)
    cat >> "$ENV_FILE" << 'EOF'

# AMD-specific optimizations (RADV/RadeonSI)
export RADV_TEX_ANISO=16
export AMD_TEX_ANISO=16
export RADV_PERFTEST=aco
export mesa_glthread=true

# Enable async compute for better performance
export RADV_DEBUG=nohang

# Force RADV driver (instead of AMDVLK if both installed)
export AMD_VULKAN_ICD=radv

# Anti-aliasing improvements
export vkBasalt=enable
EOF

elif [ "$GPU_TYPE" == "intel" ]; then
    # Intel-specific optimizations
    cat >> "$ENV_FILE" << 'EOF'

# Intel-specific optimizations
export INTEL_DEBUG=nobatch
export mesa_glthread=true
EOF
fi

# Proton-specific optimizations (CachyOS Forum/Reddit)
cat >> "$ENV_FILE" << 'EOF'

# Proton/Steam optimizations (CachyOS Proton)
# Add these to Steam launch options per game or set globally
# PROTON_DXVK_GPLASYNC=1
# PROTON_USE_NTSYNC=1
# PROTON_FSR3_UPGRADE=1
# PROTON_ENABLE_WAYLAND=1
# PROTON_ENABLE_NVAPI=1
# PROTON_ENABLE_FSR4=1
# PROTON_ENABLE_HDR=1

# DXVK optimizations
# DXVK_ASYNC=1
# DXVK_HUD=fps,frametimes,devinfo

# vkBasalt post-processing (FidelityFX CAS, sharpening, etc.)
# export ENABLE_VKBASALT=1
# export VKBASALT_CONFIG_FILE=$HOME/.config/vkBasalt/vkBasalt.conf
EOF

echo -e "${GREEN}✓ Graphics environment variables written to $ENV_FILE${NC}"

# Source the file in .bashrc if not already present
BASHRC="$USER_HOME/.bashrc"
if ! grep -q "cachyos-optimization/graphics-env.conf" "$BASHRC" 2>/dev/null; then
    echo "" >> "$BASHRC"
    echo "# Load graphics optimizations" >> "$BASHRC"
    echo "source $ENV_FILE" >> "$BASHRC"
    echo -e "${GREEN}✓ Added to .bashrc${NC}"
fi

# Source in .zshrc if zsh is used
ZSHRC="$USER_HOME/.zshrc"
if [ -f "$ZSHRC" ] && ! grep -q "cachyos-optimization/graphics-env.conf" "$ZSHRC" 2>/dev/null; then
    echo "" >> "$ZSHRC"
    echo "# Load graphics optimizations" >> "$ZSHRC"
    echo "source $ENV_FILE" >> "$ZSHRC"
    echo -e "${GREEN}✓ Added to .zshrc${NC}"
fi

# Create vkBasalt configuration for AMD/NVIDIA (Reddit recommendation)
if [ "$GPU_TYPE" == "amd" ] || [ "$GPU_TYPE" == "nvidia" ]; then
    VKBASALT_DIR="$USER_HOME/.config/vkBasalt"
    mkdir -p "$VKBASALT_DIR"
    
    cat > "$VKBASALT_DIR/vkBasalt.conf" << 'EOF'
# vkBasalt Configuration
# FidelityFX CAS - Contrast Adaptive Sharpening
effects = cas

[cas]
sharpness = 0.8

# Enable for testing and debugging
# effects = cas:fxaa:smaa
# [cas]
# sharpness = 0.8
# [fxaa]
# edgeThreshold = 0.031
# [smaa]
# edgeDetection = luma
EOF
    
    echo -e "${GREEN}✓ vkBasalt configuration created${NC}"
fi

# Install Vulkan tools if not present
if ! command -v vulkaninfo &> /dev/null; then
    echo -e "${YELLOW}⚠ vulkan-tools not installed. Install with: sudo pacman -S vulkan-tools${NC}"
fi

if ! command -v vkcube &> /dev/null; then
    echo -e "${YELLOW}⚠ vulkan-tools demo not installed. Install with: sudo pacman -S vulkan-tools${NC}"
fi

echo ""
echo -e "${GREEN}=== Graphics Optimization Complete ===${NC}"
echo ""
echo -e "${WHITE}Applied optimizations based on Reddit and Arch Wiki recommendations:${NC}"
echo ""
echo -e "${CYAN}For $GPU_TYPE GPU:${NC}"
if [ "$GPU_TYPE" == "nvidia" ]; then
    echo -e "  • Threaded optimizations enabled"
    echo -e "  • Shader disk cache enabled"
    echo -e "  • Sync to vblank disabled (reduce input lag)"
elif [ "$GPU_TYPE" == "amd" ]; then
    echo -e "  • RADV ACO compiler enabled"
    echo -e "  • 16x anisotropic filtering forced"
    echo -e "  • OpenGL threading enabled"
    echo -e "  • vkBasalt post-processing configured"
elif [ "$GPU_TYPE" == "intel" ]; then
    echo -e "  • OpenGL threading enabled"
    echo -e "  • Intel debugging disabled for performance"
fi
echo ""
echo -e "${WHITE}Steam/Proton launch options to try:${NC}"
echo -e "  PROTON_DXVK_GPLASYNC=1 PROTON_USE_NTSYNC=1 %command%"
echo -e "  PROTON_FSR3_UPGRADE=1 %command%"
echo -e "  PROTON_ENABLE_NVAPI=1 %command%"
echo ""
echo -e "${YELLOW}⚠ To apply changes, restart your terminal or run:${NC}"
echo -e "  source $ENV_FILE"
echo ""
echo -e "${YELLOW}⚠ Some Proton variables should be set per-game in Steam launch options${NC}"
echo -e "${YELLOW}  rather than globally, as they can cause issues in some games${NC}"
echo ""
echo -e "${CYAN}Created by litebiter & auxmeet${NC}"
