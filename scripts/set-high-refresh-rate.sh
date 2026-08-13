#!/bin/bash

# High Refresh Rate Script
# Sets monitor to highest available refresh rate permanently
# Based on Reddit and Arch Wiki recommendations
# Created by litebiter & auxmeet

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}=== High Refresh Rate Setup ===${NC}"

# Check if X11 is running
if [ -z "$DISPLAY" ]; then
    echo -e "${RED}Error: X11 not running. DISPLAY environment variable not set.${NC}"
    echo -e "${YELLOW}This script requires an active X11 session.${NC}"
    exit 1
fi

# Check if xrandr is available
if ! command -v xrandr &> /dev/null; then
    echo -e "${RED}Error: xrandr not found. Install xorg-xrandr${NC}"
    exit 1
fi

echo -e "${BLUE}Detecting connected displays...${NC}"

# Get connected displays
CONNECTED_DISPLAYS=$(xrandr | grep " connected" | cut -d' ' -f1)

if [ -z "$CONNECTED_DISPLAYS" ]; then
    echo -e "${RED}No connected displays found${NC}"
    exit 1
fi

echo -e "${GREEN}Found connected displays:${NC}"
echo "$CONNECTED_DISPLAYS"
echo ""

# Set highest refresh rate for each display
for display in $CONNECTED_DISPLAYS; do
    echo -e "${BLUE}Processing display: $display${NC}"
    
    # Get current resolution
    CURRENT_MODE=$(xrandr | grep "^$display" -A 1 | grep -o "[0-9]*x[0-9]*" | head -n1)
    
    if [ -z "$CURRENT_MODE" ]; then
        echo -e "${YELLOW}Could not determine current resolution for $display${NC}"
        continue
    fi
    
    echo -e "${WHITE}Current resolution: $CURRENT_MODE${NC}"
    
    # Get available refresh rates for current resolution
    AVAILABLE_RATES=$(xrandr | grep "$CURRENT_MODE" | grep -o "[0-9]*\.[0-9]*" | sort -rn)
    
    if [ -z "$AVAILABLE_RATES" ]; then
        echo -e "${YELLOW}No refresh rates found for $CURRENT_MODE${NC}"
        continue
    fi
    
    echo -e "${WHITE}Available refresh rates:${NC}"
    echo "$AVAILABLE_RATES"
    
    # Get highest refresh rate
    HIGHEST_RATE=$(echo "$AVAILABLE_RATES" | head -n1)
    
    echo -e "${GREEN}Setting $display to $CURRENT_MODE at $HIGHEST_RATE Hz${NC}"
    
    # Set the refresh rate
    if xrandr --output "$display" --mode "$CURRENT_MODE" --rate "$HIGHEST_RATE"; then
        echo -e "${GREEN}✓ Successfully set $display to $HIGHEST_RATE Hz${NC}"
    else
        echo -e "${RED}✗ Failed to set refresh rate for $display${NC}"
    fi
    
    echo ""
done

# Create systemd service for automatic refresh rate setting
echo -e "${BLUE}Creating systemd service for automatic refresh rate setting...${NC}"

USER_HOME=$(getentpasswd $(whoami) | cut -d':' -f6)
SYSTEMD_DIR="$USER_HOME/.config/systemd/user"
SCRIPT_PATH="$(realpath "$0")"

mkdir -p "$SYSTEMD_DIR"

# Create service file
cat > "$SYSTEMD_DIR/set-high-refresh-rate.service" << EOF
[Unit]
Description=Set High Refresh Rate on Login
After=graphical.target suspend.target

[Service]
Type=oneshot
Environment="DISPLAY=:0"
ExecStart=$SCRIPT_PATH
RemainAfterExit=no

[Install]
WantedBy=default.target
EOF

echo -e "${GREEN}Systemd service created at $SYSTEMD_DIR/set-high-refresh-rate.service${NC}"

# Enable the service
echo -e "${BLUE}Enabling systemd service...${NC}"
systemctl --user enable set-high-refresh-rate.service > /dev/null 2>&1
echo -e "${GREEN}Service enabled${NC}"

# Also add to autostart for desktop environments
AUTOSTART_DIR="$USER_HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"

cat > "$AUTOSTART_DIR/set-high-refresh-rate.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Set High Refresh Rate
Exec=$SCRIPT_PATH
Terminal=false
X-GNOME-Autostart-enabled=true
EOF

echo -e "${GREEN}Autostart entry created${NC}"

echo ""
echo -e "${GREEN}=== High Refresh Rate Setup Complete ===${NC}"
echo ""
echo -e "${WHITE}The highest refresh rate has been set for all connected displays${NC}"
echo -e "${WHITE}A systemd service has been created to maintain this setting${NC}"
echo ""
echo -e "${YELLOW}⚠ If you experience issues with specific refresh rates, you can manually set them:${NC}"
echo -e "${WHITE}xrandr --output <display> --mode <resolution> --rate <refresh_rate>${NC}"
echo ""
echo -e "${CYAN}Created by litebiter & auxmeet${NC}"