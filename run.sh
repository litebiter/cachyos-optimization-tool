#!/bin/bash

# CachyOS Optimization Project - Main Launcher
# Created by litebiter & auxmeet

# Colors and animations
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Animation functions
loading_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

print_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
 ██████╗ ██████╗ ███████╗ █████╗ ███╗   ███╗███████╗
██╔════╝██╔═══██╗██╔════╝██╔══██╗████╗ ████║██╔════╝
██║     ██║   ██║███████╗███████║██╔████╔██║███████╗
██║     ██║   ██║╚════██║██╔══██║██║╚██╔╝██║╚════██║
╚██████╗╚██████╔╝███████║██║  ██║██║ ╚═╝ ██║███████║
 ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
EOF
    echo -e "${GREEN}"
    cat << "EOF"
   ██████╗ ██████╗ ███████╗ █████╗ ███╗   ███╗███████╗
  ██╔════╝██╔═══██╗██╔════╝██╔══██╗████╗ ████║██╔════╝
  ██║     ██║   ██║███████╗███████║██╔████╔██║███████╗
  ██║     ██║   ██║╚════██║██╔══██║██║╚██╔╝██║╚════██║
  ╚██████╗╚██████╔╝███████║██║  ██║██║ ╚═╝ ██║███████║
   ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
EOF
    echo -e "${YELLOW}"
    echo "    Universal System Optimization Tool"
    echo -e "${WHITE}    Created by ${CYAN}litebiter${WHITE} & ${CYAN}auxmeet${WHITE}"
    echo -e "${NC}"
}

show_loading() {
    local message=$1
    echo -e "${BLUE}▶ ${message}${NC}"
    sleep 0.5
}

show_success() {
    local message=$1
    echo -e "${GREEN}✓ ${message}${NC}"
    sleep 0.3
}

show_error() {
    local message=$1
    echo -e "${RED}✗ ${message}${NC}"
    sleep 0.3
}

show_info() {
    local message=$1
    echo -e "${CYAN}ℹ ${message}${NC}"
    sleep 0.3
}

detect_hardware() {
    show_loading "Detecting system hardware..."
    sleep 1
    
    # CPU Detection
    CPU_VENDOR=$(grep 'vendor_id' /proc/cpuinfo | head -n1 | awk '{print $3}')
    CPU_MODEL=$(grep 'model name' /proc/cpuinfo | head -n1 | cut -d':' -f2 | xargs)
    CPU_CORES=$(nproc)
    
    if [[ "$CPU_VENDOR" == "AuthenticAMD" ]]; then
        CPU_TYPE="AMD"
    elif [[ "$CPU_VENDOR" == "GenuineIntel" ]]; then
        CPU_TYPE="Intel"
    else
        CPU_TYPE="Unknown"
    fi
    
    show_success "CPU Detected: $CPU_TYPE ($CPU_MODEL, $CPU_CORES cores)"
    
    # GPU Detection
    sleep 0.5
    GPU_INFO=$(lspci | grep -i vga)
    if echo "$GPU_INFO" | grep -qi nvidia; then
        GPU_TYPE="NVIDIA"
        GPU_MODEL=$(echo "$GPU_INFO" | grep NVIDIA | cut -d':' -f3 | xargs)
    elif echo "$GPU_INFO" | grep -qi amd; then
        GPU_TYPE="AMD"
        GPU_MODEL=$(echo "$GPU_INFO" | grep AMD | cut -d':' -f3 | xargs)
    elif echo "$GPU_INFO" | grep -qi intel; then
        GPU_TYPE="Intel"
        GPU_MODEL=$(echo "$GPU_INFO" | grep Intel | cut -d':' -f3 | xargs)
    else
        GPU_TYPE="Unknown"
        GPU_MODEL="Unknown GPU"
    fi
    
    show_success "GPU Detected: $GPU_TYPE ($GPU_MODEL)"
    
    # Memory Detection
    sleep 0.5
    RAM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
    show_success "Memory: $RAM_TOTAL"
    
    # Storage Detection
    sleep 0.5
    SSD_COUNT=$(lsblk -d -o name,rota | awk '$2 == "0" {count++} END {print count+0}')
    HDD_COUNT=$(lsblk -d -o name,rota | awk '$2 == "1" {count++} END {print count+0}')
    show_success "Storage: $SSD_COUNT SSD(s), $HDD_COUNT HDD(s)"
    
    echo ""
}

welcome_screen() {
    print_banner
    echo -e "${GREEN}Welcome to CachyOS Optimization Project!${NC}"
    echo ""
    echo -e "${CYAN}This tool will automatically detect your hardware and apply${NC}"
    echo -e "${CYAN}the best performance optimizations for your system.${NC}"
    echo ""
    detect_hardware
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read
}

main_menu() {
    while true; do
        clear
        print_banner
        echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
        echo -e "${WHITE}                    MAIN MENU${NC}"
        echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
        echo ""
        echo -e "${CYAN}  [1]${NC} ${WHITE}Check System Status${NC}"
        echo -e "${CYAN}  [2]${NC} ${WHITE}Install Optimizations${NC}"
        echo -e "${CYAN}  [3]${NC} ${WHITE}View Installation Guide${NC}"
        echo -e "${CYAN}  [4]${NC} ${WHITE}Run Daily Maintenance${NC}"
        echo -e "${CYAN}  [5]${NC} ${WHITE}Rollback Changes${NC}"
        echo -e "${CYAN}  [6]${NC} ${WHITE}Hardware Information${NC}"
        echo -e "${CYAN}  [7]${NC} ${WHITE}Set High Refresh Rate${NC}"
        echo -e "${CYAN}  [8]${NC} ${WHITE}Low Latency Gaming Mode${NC}"
        echo -e "${CYAN}  [9]${NC} ${WHITE}Advanced Kernel Tweaks${NC}"
        echo -e "${CYAN}  [10]${NC} ${WHITE}Graphics Optimization (OpenGL/Vulkan)${NC}"
        echo -e "${CYAN}  [11]${NC} ${WHITE}About${NC}"
        echo -e "${CYAN}  [0]${NC} ${RED}Exit${NC}"
        echo ""
        echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
        echo ""
        echo -ne "${YELLOW}Enter your choice [0-11]: ${NC}"
        read choice
        
        case $choice in
            1)
                system_status
                ;;
            2)
                install_optimizations
                ;;
            3)
                view_guide
                ;;
            4)
                daily_maintenance
                ;;
            5)
                rollback_changes
                ;;
            6)
                hardware_info
                ;;
            7)
                set_high_refresh_rate
                ;;
            8)
                low_latency_mode
                ;;
            9)
                advanced_kernel_tweaks
                ;;
            10)
                graphics_optimization
                ;;
            11)
                about
                ;;
            0)
                exit_message
                exit 0
                ;;
            *)
                show_error "Invalid choice. Please try again."
                sleep 1
                ;;
        esac
    done
}

system_status() {
    clear
    print_banner
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}                SYSTEM STATUS CHECK${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    bash check-status.sh
    
    echo ""
    echo -e "${YELLOW}Press Enter to return to main menu...${NC}"
    read
}

install_optimizations() {
    clear
    print_banner
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}            INSTALLATION WIZARD${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}This will install system optimizations for your hardware.${NC}"
    echo -e "${YELLOW}⚠ Requires sudo privileges${NC}"
    echo ""
    echo -e "${RED}The following changes will be made:${NC}"
    echo -e "${WHITE}• CPU governor optimization${NC}"
    echo -e "${WHITE}• GPU performance tuning${NC}"
    echo -e "${WHITE}• Memory and swap optimization${NC}"
    echo -e "${WHITE}• Network driver optimization${NC}"
    echo -e "${WHITE}• Storage I/O optimization${NC}"
    echo -e "${WHITE}• Kernel parameter tuning${NC}"
    echo ""
    echo -ne "${YELLOW}Do you want to continue? [y/N]: ${NC}"
    read confirm
    
    if [[ "$confirm" == "y" ]] || [[ "$confirm" == "Y" ]]; then
        echo ""
        show_loading "Starting installation process..."
        sleep 1
        
        sudo bash setup.sh
        
        if [ $? -eq 0 ]; then
            echo ""
            show_success "Installation completed successfully!"
            echo ""
            echo -e "${YELLOW}⚠ Please reboot your system to apply all changes${NC}"
            echo -ne "${YELLOW}Reboot now? [y/N]: ${NC}"
            read reboot_confirm
            
            if [[ "$reboot_confirm" == "y" ]] || [[ "$reboot_confirm" == "Y" ]]; then
                sudo reboot
            fi
        else
            echo ""
            show_error "Installation failed. Please check the error messages above."
        fi
    else
        show_info "Installation cancelled."
    fi
    
    echo ""
    echo -e "${YELLOW}Press Enter to return to main menu...${NC}"
    read
}

view_guide() {
    clear
    print_banner
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}            INSTALLATION GUIDE${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    if [ -f "INSTALL.md" ]; then
        cat INSTALL.md
    else
        show_error "Installation guide not found."
    fi
    
    echo ""
    echo -e "${YELLOW}Press Enter to return to main menu...${NC}"
    read
}

daily_maintenance() {
    clear
    print_banner
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}            DAILY MAINTENANCE${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}Running daily maintenance tasks...${NC}"
    echo ""
    
    sudo bash daily-tweaks.sh
    
    echo ""
    echo -e "${YELLOW}Press Enter to return to main menu...${NC}"
    read
}

rollback_changes() {
    clear
    print_banner
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}            ROLLBACK CHANGES${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}This will revert all optimizations to default settings.${NC}"
    echo -e "${YELLOW}⚠ Requires sudo privileges${NC}"
    echo ""
    echo -ne "${YELLOW}Are you sure you want to rollback? [y/N]: ${NC}"
    read confirm
    
    if [[ "$confirm" == "y" ]] || [[ "$confirm" == "Y" ]]; then
        if [ -f "rollback.sh" ]; then
            sudo bash rollback.sh
            show_success "Rollback completed!"
        else
            show_error "Rollback script not found."
        fi
    else
        show_info "Rollback cancelled."
    fi
    
    echo ""
    echo -e "${YELLOW}Press Enter to return to main menu...${NC}"
    read
}

hardware_info() {
    clear
    print_banner
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}            HARDWARE INFORMATION${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    detect_hardware
    
    echo -e "${CYAN}Detailed Information:${NC}"
    echo ""
    
    echo -e "${WHITE}CPU Details:${NC}"
    lscpu | grep -E "Architecture|CPU\(s\)|Thread|Model name|Vendor ID"
    echo ""
    
    echo -e "${WHITE}GPU Details:${NC}"
    lspci | grep -i vga
    echo ""
    
    echo -e "${WHITE}Memory Details:${NC}"
    free -h
    echo ""
    
    echo -e "${WHITE}Storage Details:${NC}"
    lsblk -d -o name,model,size,rota
    echo ""
    
    echo -e "${WHITE}Network Details:${NC}"
    lspci | grep -i network
    echo ""
    
    echo -e "${YELLOW}Press Enter to return to main menu...${NC}"
    read
}

low_latency_mode() {
    clear
    print_banner
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}            LOW LATENCY GAMING MODE${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}This mode applies Reddit and CachyOS Forum recommended${NC}"
    echo -e "${CYAN}optimizations for lowest input lag in gaming.${NC}"
    echo ""
    echo -e "${RED}⚠ These optimizations trade some performance for lower latency${NC}"
    echo -e "${YELLOW}⚠ Recommended for competitive gaming only${NC}"
    echo ""
    echo -e "${WHITE}The following changes will be made:${NC}"
    echo -e "${WHITE}• Disable proactive compaction (reduces jitter)${NC}"
    echo -e "${WHITE}• Low latency kernel parameters${NC}"
    echo -e "${WHITE}• USB autosuspend disabled${NC}"
    echo -e "${WHITE}• Split-lock detection disabled${NC}"
    echo -e "${WHITE}• Gaming-specific sysctl settings${NC}"
    echo -e "${WHITE}• CPU isolation recommendations${NC}"
    echo ""
    echo -ne "${YELLOW}Do you want to enable low latency mode? [y/N]: ${NC}"
    read confirm
    
    if [[ "$confirm" == "y" ]] || [[ "$confirm" == "Y" ]]; then
        echo ""
        show_loading "Applying low latency optimizations..."
        bash "$(dirname "$0")/scripts/low-latency-optimization.sh"
        
        if [ $? -eq 0 ]; then
            echo ""
            show_success "Low latency mode enabled!"
            echo ""
            echo -e "${YELLOW}⚠ For extreme low latency, consider adding these kernel parameters:${NC}"
            echo -e "${WHITE}processor.max_cstate=0 intel_idle.max_cstate=0 nowatchdog nosoftlockup audit=0 usbcore.autosuspend=-1${NC}"
            echo ""
            echo -e "${YELLOW}⚠ For competitive gaming, use X11 instead of Wayland${NC}"
            echo -e "${YELLOW}⚠ Consider disabling ananicy-cpp during gaming sessions${NC}"
        else
            echo ""
            show_error "Low latency mode failed. Please check the error messages above."
        fi
    else
        show_info "Low latency mode cancelled."
    fi
    
    echo ""
    echo -e "${YELLOW}Press Enter to return to main menu...${NC}"
    read
}

set_high_refresh_rate() {
    clear
    print_banner
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}            SET HIGH REFRESH RATE${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}This script will set your monitor to the highest available refresh rate${NC}"
    echo -e "${CYAN}and create a systemd service to maintain this setting permanently.${NC}"
    echo ""
    echo -e "${WHITE}Based on Reddit and Arch Wiki recommendations${NC}"
    echo ""
    echo -e "${RED}⚠ Requires active X11 session${NC}"
    echo ""
    echo -ne "${YELLOW}Do you want to set high refresh rate? [y/N]: ${NC}"
    read confirm
    
    if [[ "$confirm" == "y" ]] || [[ "$confirm" == "Y" ]]; then
        echo ""
        show_loading "Setting high refresh rate..."
        bash "$(dirname "$0")/scripts/set-high-refresh-rate.sh"
        
        if [ $? -eq 0 ]; then
            echo ""
            show_success "High refresh rate set successfully!"
            echo ""
            echo -e "${YELLOW}⚠ A systemd service has been created to maintain this setting${NC}"
            echo -e "${YELLOW}⚠ You may need to restart your display manager for the service to take effect${NC}"
        else
            echo ""
            show_error "High refresh rate setting failed. Please check the error messages above."
        fi
    else
        show_info "High refresh rate setting cancelled."
    fi
    
    echo ""
    echo -e "${YELLOW}Press Enter to return to main menu...${NC}"
    read
}

advanced_kernel_tweaks() {
    clear
    print_banner
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}            ADVANCED KERNEL TWEAKS${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}Advanced kernel parameters for maximum gaming performance${NC}"
    echo -e "${CYAN}Based on Reddit, Arch Wiki, and gaming optimization guides${NC}"
    echo ""
    echo -e "${RED}⚠ These are aggressive optimizations that may affect stability${NC}"
    echo -e "${YELLOW}⚠ Recommended for experienced users only${NC}"
    echo ""
    echo -e "${WHITE}The following will be applied:${NC}"
    echo -e "${WHITE}• Advanced sysctl settings for gaming${NC}"
    echo -e "${WHITE}• TCP BBR congestion control${NC}"
    echo -e "${WHITE}• Optimized scheduler parameters${NC}"
    echo -e "${WHITE}• Memory management for low latency${NC}"
    echo -e "${WHITE}• Advanced kernel parameters (mitigations=off, C-states disabled)${NC}"
    echo ""
    echo -e "${WHITE}⚠ WARNING: Some parameters disable security mitigations${NC}"
    echo ""
    echo -ne "${YELLOW}Do you want to apply advanced kernel tweaks? [y/N]: ${NC}"
    read confirm
    
    if [[ "$confirm" == "y" ]] || [[ "$confirm" == "Y" ]]; then
        echo ""
        show_loading "Applying advanced kernel tweaks..."
        
        # Apply advanced sysctl settings
        if [ -f "$(dirname "$0")/config/sysctl/99-advanced-kernel-tweaks.conf" ]; then
            sudo cp "$(dirname "$0")/config/sysctl/99-advanced-kernel-tweaks.conf" /etc/sysctl.d/
            sudo sysctl -p /etc/sysctl.d/99-advanced-kernel-tweaks.conf
            show_success "Advanced sysctl settings applied"
        else
            show_error "Advanced sysctl config not found"
        fi
        
        echo ""
        echo -e "${YELLOW}⚠ For advanced kernel parameters, add these to GRUB_CMDLINE_LINUX_DEFAULT:${NC}"
        echo -e "${WHITE}processor.max_cstate=0 intel_idle.max_cstate=0 idle=poll nowatchdog nosoftlockup audit=0 usbcore.autosuspend=-1${NC}"
        echo -e "${WHITE}For even more performance (security trade-off): mitigations=off${NC}"
        echo ""
        echo -e "${CYAN}Full list available in config/kernel/cmdline-advanced-gaming.conf${NC}"
        echo ""
        echo -e "${YELLOW}⚠ After modifying GRUB, run: sudo grub-mkconfig -o /boot/grub/grub.cfg${NC}"
        echo -e "${YELLOW}⚠ Then reboot the system${NC}"
        
        show_success "Advanced kernel tweaks completed"
    else
        show_info "Advanced kernel tweaks cancelled."
    fi
    
    echo ""
    echo -e "${YELLOW}Press Enter to return to main menu...${NC}"
    read
}

graphics_optimization() {
    clear
    print_banner
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}        GRAPHICS OPTIMIZATION (OpenGL/Vulkan)${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}This script applies Reddit and Arch Wiki recommended${NC}"
    echo -e "${CYAN}optimizations for OpenGL and Vulkan graphics performance.${NC}"
    echo ""
    echo -e "${WHITE}Based on:${NC}"
    echo -e "${WHITE}• CachyOS Forum gaming recommendations${NC}"
    echo -e "${WHITE}• Steam community optimizations${NC}"
    echo -e "${WHITE}• Arch Wiki Mesa documentation${NC}"
    echo -e "${WHITE}• vkBasalt post-processing${NC}"
    echo ""
    echo -e "${WHITE}Includes:${NC}"
    echo -e "${WHITE}• GPU-specific environment variables${NC}"
    echo -e "${WHITE}• Proton/Steam launch optimizations${NC}"
    echo -e "${WHITE}• vkBasalt configuration (CAS sharpening)${NC}"
    echo -e "${WHITE}• DXVK/VKD3D tuning variables${NC}"
    echo ""
    echo -e "${YELLOW}⚠ These are per-user optimizations (no root required)${NC}"
    echo ""
    echo -ne "${YELLOW}Do you want to apply graphics optimizations? [y/N]: ${NC}"
    read confirm
    
    if [[ "$confirm" == "y" ]] || [[ "$confirm" == "Y" ]]; then
        echo ""
        show_loading "Applying graphics optimizations..."
        bash "$(dirname "$0")/scripts/graphics-optimization.sh"
        
        if [ $? -eq 0 ]; then
            echo ""
            show_success "Graphics optimizations applied!"
            echo ""
            echo -e "${YELLOW}⚠ Restart your terminal or run: source ~/.config/cachyos-optimization/graphics-env.conf${NC}"
            echo -e "${YELLOW}⚠ Some Proton variables should be set per-game in Steam launch options${NC}"
        else
            echo ""
            show_error "Graphics optimization failed. Please check the error messages above."
        fi
    else
        show_info "Graphics optimization cancelled."
    fi
    
    echo ""
    echo -e "${YELLOW}Press Enter to return to main menu...${NC}"
    read
}

about() {
    clear
    print_banner
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}                    ABOUT${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}CachyOS Optimization Project${NC}"
    echo ""
    echo -e "${WHITE}Version: 1.0.0${NC}"
    echo -e "${WHITE}License: MIT${NC}"
    echo ""
    echo -e "${GREEN}Creators:${NC}"
    echo -e "${CYAN}• litebiter${NC}  - Main Developer"
    echo -e "${CYAN}• auxmeet${NC}  - Co-Developer"
    echo ""
    echo -e "${GREEN}Features:${NC}"
    echo -e "${WHITE}• Universal hardware support${NC}"
    echo -e "${WHITE}• Automatic detection and optimization${NC}"
    echo -e "${WHITE}• Safe and reversible changes${NC}"
    echo -e "${WHITE}• Beautiful animated interface${NC}"
    echo -e "${WHITE}• Regular updates with official configs${NC}"
    echo ""
    echo -e "${GREEN}Acknowledgments:${NC}"
    echo -e "${WHITE}• CachyOS Team${NC}"
    echo -e "${WHITE}• Arch Linux Community${NC}"
    echo -e "${WHITE}• Open Source Contributors${NC}"
    echo ""
    echo -e "${YELLOW}Press Enter to return to main menu...${NC}"
    read
}

exit_message() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
 ██████╗ ██████╗ ███████╗ █████╗ ███╗   ███╗███████╗
██╔════╝██╔═══██╗██╔════╝██╔══██╗████╗ ████║██╔════╝
██║     ██║   ██║███████╗███████║██╔████╔██║███████╗
██║     ██║   ██║╚════██║██╔══██║██║╚██╔╝██║╚════██║
╚██████╗╚██████╔╝███████║██║  ██║██║ ╚═╝ ██║███████║
 ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
EOF
    echo -e "${WHITE}"
    echo "    Thank you for using CachyOS Optimization Project!"
    echo -e "${CYAN}    Created by litebiter & auxmeet${NC}"
    echo -e "${GREEN}"
    echo "    ██████╗ ██████╗ ███████╗ █████╗ ███╗   ███╗███████╗"
    echo "   ██╔════╝██╔═══██╗██╔════╝██╔══██╗████╗ ████║██╔════╝"
    echo "   ██║     ██║   ██║███████╗███████║██╔████╔██║███████╗"
    echo "   ██║     ██║   ██║╚════██║██╔══██║██║╚██╔╝██║╚════██║"
    echo "   ╚██████╗╚██████╔╝███████║██║  ██║██║ ╚═╝ ██║███████║"
    echo "    ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝"
    echo -e "${NC}"
    sleep 2
}

# Main execution
if [ "$1" == "--skip-welcome" ]; then
    main_menu
else
    welcome_screen
    main_menu
fi