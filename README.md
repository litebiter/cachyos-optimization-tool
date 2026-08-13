# CachyOS Optimization Project

<div align="center">

**🚀 Universal System Optimization Tool for CachyOS/Arch Linux**

Created by [litebiter](https://github.com/litebiter) & [auxmeet](https://github.com/auxmeet)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![CachyOS](https://img.shields.io/badge/CachyOS-supported-green.svg)](https://cachyos.org/)
[![Arch Linux](https://img.shields.io/badge/Arch%20Linux-compatible-blue.svg)](https://archlinux.org/)
[![GitHub](https://img.shields.io/badge/Github-cachyos--optimization--tool-orange.svg)](https://github.com/litebiter/cachyos-optimization-tool)

</div>

## ✨ Features

- **🎯 Universal Hardware Support** - Automatic detection and optimization for all CPU/GPU combinations
- **⚡ Smart Performance Tuning** - Adaptive optimizations based on your specific hardware
- **� Low Latency Gaming Mode** - Reddit and CachyOS Forum recommended optimizations for lowest input lag
- **�🎨 Beautiful Interface** - Animated terminal UI with interactive menus and color-coded output
- **🛡️ Safe & Reversible** - All changes can be easily rolled back with one command
- **🔄 Regular Updates** - Integrated with official CachyOS configurations for latest optimizations

## 🚀 Quick Start

### Installation via Git Clone

<div align="center">

```bash
# Clone the repository
git clone https://github.com/litebiter/cachyos-optimization-tool.git

# Navigate to the project directory
cd cachyos-optimization-tool

# Run the main launcher
bash run.sh
```

</div>

### Alternative Installation Methods

<details>
<summary>📥 Download & Extract</summary>

```bash
# Download the latest release
wget https://github.com/litebiter/cachyos-optimization-tool/archive/refs/heads/main.zip

# Extract the archive
unzip main.zip

# Navigate to the project directory
cd cachyos-optimization-tool-main

# Run the main launcher
bash run.sh
```
</details>

## 📋 Requirements

- **Operating System:** CachyOS or Arch Linux
- **Privileges:** Sudo access
- **Internet:** Required for git clone
- **Disk Space:** 500MB free space
- **RAM:** Minimum 4GB (8GB+ recommended)

## 🎯 Usage

### Main Menu Options

<div align="center">

```
═══════════════════════════════════════════════════════════════
                    MAIN MENU
═══════════════════════════════════════════════════════════════

  [1] Check System Status
  [2] Install Optimizations
  [3] View Installation Guide
  [4] Run Daily Maintenance
  [5] Rollback Changes
  [6] Hardware Information
  [7] Set High Refresh Rate
  [8] Low Latency Gaming Mode
  [9] Advanced Kernel Tweaks
  [10] Graphics Optimization (OpenGL/Vulkan)
  [11] Java Performance Optimization
  [12] About
  [0] Exit

═══════════════════════════════════════════════════════════════
```

</div>

### Quick Commands

```bash
# Check current system status
bash check-status.sh

# Install all optimizations
sudo bash setup.sh

# Run daily maintenance
sudo bash daily-tweaks.sh

# Rollback all changes
sudo bash rollback.sh

## 🎮 Low Latency Gaming Mode

For competitive gaming and lowest input lag, use the Low Latency Gaming Mode:

### Key Features
- **Reddit & CachyOS Forum Optimized** - Based on community recommendations
- **Ultra-Low Input Lag** - Optimizations for fastest response times
- **Gaming-Specific Tuning** - Trade some performance for lower latency
- **BORE Scheduler** - Already enabled in CachyOS kernel
- **Gamescope Integration** - Recommendations for best latency

### Enable Low Latency Mode
```bash
bash run.sh
# Select [7] Low Latency Gaming Mode
```

### What It Does
- Disables proactive compaction (reduces jitter)
- Applies low latency kernel parameters
- Disables USB autosuspend for input devices
- Disables split-lock detection
- Gaming-specific sysctl settings
- CPU isolation recommendations

### Additional Recommendations
- Use X11 instead of Wayland for competitive gaming
- Disable ananicy-cpp during gaming sessions
- Consider using Gamescope: `gamescope -W 1920 -H 1080 -r 144 -b -- %command%`
- Install Low Latency Layer from AUR for Vulkan games

## 🖥️ High Refresh Rate Setup

Automatically set your monitor to the highest available refresh rate and maintain it permanently:

### Enable High Refresh Rate
```bash
bash run.sh
# Select [7] Set High Refresh Rate
```

### What It Does
- **Automatic Detection** - Detects all connected displays
- **Maximum Refresh Rate** - Sets each display to its highest available refresh rate
- **Permanent Setting** - Creates systemd service to maintain setting across reboots
- **Desktop Autostart** - Adds autostart entry for desktop environments
- **Multi-Monitor Support** - Works with multiple displays

### Manual Control
```bash
# Check current refresh rates
xrandr

# Set specific refresh rate
xrandr --output DP-0 --mode 1920x1080 --rate 144
```

## ⚙️ Advanced Kernel Tweaks

For maximum gaming performance with Reddit and Arch Wiki recommended kernel parameters:

### Enable Advanced Kernel Tweaks
```bash
bash run.sh
# Select [9] Advanced Kernel Tweaks
```

### What It Optimizes
- **Advanced Sysctl Settings** - Gaming-specific kernel parameters
- **TCP BBR Congestion Control** - Better network performance
- **Scheduler Optimizations** - Low latency CPU scheduling
- **Memory Management** - Ultra-low latency memory settings
- **Advanced Kernel Parameters** - `mitigations=off`, C-states disabled, `idle=poll`

### Warning
- **Security Trade-off** - Some parameters disable CPU security mitigations
- **Stability Impact** - Aggressive optimizations may affect system stability
- **Recommended for** - Experienced users only
- **Test Before Use** - Try individual parameters first

## 🎮 Graphics Optimization (OpenGL/Vulkan)

Optimize OpenGL and Vulkan graphics performance with Reddit, CachyOS Forum, and Arch Wiki recommended settings:

### Enable Graphics Optimization
```bash
bash run.sh
# Select [10] Graphics Optimization (OpenGL/Vulkan)
```

### What It Optimizes
- **GPU-Specific Environment Variables** - Tailored for NVIDIA, AMD, and Intel GPUs
- **Proton/Steam Launch Optimizations** - CachyOS Proton-specific variables
- **vkBasalt Post-Processing** - FidelityFX CAS sharpening
- **DXVK/VKD3D Tuning** - DirectX to Vulkan translation optimizations
- **Mesa Driver Settings** - OpenGL threading and performance

### NVIDIA-Specific Optimizations
- Threaded optimizations enabled
- Shader disk cache enabled
- Sync to vblank disabled (reduce input lag)
- GL shader caching optimized

### AMD-Specific Optimizations
- RADV ACO compiler enabled
- 16x anisotropic filtering forced
- OpenGL threading enabled
- vkBasalt post-processing configured
- Async compute optimizations

### Proton/Steam Launch Options
The script generates environment variables that can be used in Steam launch options:
```bash
# Recommended for most games
PROTON_DXVK_GPLASYNC=1 PROTON_USE_NTSYNC=1 %command%

# For FSR 3.0 upscaling
PROTON_FSR3_UPGRADE=1 %command%

# For NVIDIA features in games
PROTON_ENABLE_NVAPI=1 %command%

# For Wayland gaming
PROTON_ENABLE_WAYLAND=1 %command%
```

### How to Apply
After running the script, restart your terminal or run:
```bash
source ~/.config/cachyos-optimization/graphics-env.conf
```

### Rollback
To remove graphics optimizations:
```bash
sudo bash rollback.sh
# This removes all user-level graphics optimizations
```

## ☕ Java Performance Optimization

Optimize Java performance for CachyOS/Arch Linux with Reddit, Arch Wiki, and Phoronix benchmarked settings:

### Enable Java Optimization
```bash
bash run.sh
# Select [11] Java Performance Optimization
```

### What It Optimizes
- **CachyOS Optimized Repositories** - Detection of x86-64-v3/v4 repositories (5-20% improvement)
- **Transparent Huge Pages** - Better memory access for Java applications
- **JVM Flags** - G1GC optimization with Aikar's widely-tested flags
- **NUMA Awareness** - Multi-socket system optimization
- **Code Cache** - Optimized JIT compilation cache sizes
- **System-Level Tuning** - Huge pages, memory overcommit, shared memory limits
- **Minecraft-Specific** - Aikar's flags for Minecraft servers/clients
- **Java 21+ Support** - Generational ZGC for low-latency applications

### System-Level Optimizations
- Transparent Huge Pages enabled
- 1024 huge pages allocated (configurable)
- Memory overcommit optimized
- Shared memory limits increased
- File descriptor limits increased
- Systemd service limits raised

### JVM Optimizations
The script sets `_JAVA_OPTIONS` with optimized flags:
- G1GC with tuned parameters for reduced GC pauses
- NUMA awareness for multi-socket systems
- Code cache optimization (400M reserved)
- Vectorization optimizations
- Thread priority optimization
- Performance monitoring optimizations

### Minecraft-Specific Optimizations
For Minecraft servers/clients, use Aikar's widely-tested flags:
```bash
java -Xms4G -Xmx4G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -jar server.jar
```

### Java 21+ Generational ZGC
For Java 21+ applications requiring ultra-low latency:
```bash
export _JAVA_OPTIONS="-XX:+UseZGC -XX:+ZGenerational -XX:ZCollectionInterval=5 -XX:ConcGCThreads=2 -XX:ParallelGCThreads=8"
```

### CachyOS Optimized Repositories
The script detects if CachyOS optimized repositories are configured:
- **x86-64-v3**: 5-20% performance improvement (AVX2 support)
- **x86-64-v4**: Additional gains with AVX512 support
- **Zen4/5**: Further optimizations for newer AMD CPUs

### How to Apply
After running the script, restart your terminal or run:
```bash
source ~/.config/cachyos-optimization/java-env.conf
```

### Expected Performance Improvements
- **5-20%** from CachyOS optimized repositories (if configured)
- **Reduced GC pauses** with G1GC tuning
- **Better memory access** with huge pages
- **Improved NUMA performance** on multi-socket systems
- **Lower latency** with Generational ZGC (Java 21+)

### Rollback
To remove Java optimizations:
```bash
sudo bash rollback.sh
# This removes all Java-specific optimizations
```

## 📁 Project Structure

```
cachyos-optimization-project/
├── README.md                    # This file
├── INSTALL.md                   # Detailed installation guide
├── PROJECT-OVERVIEW.md          # Comprehensive project overview
├── LICENSE                      # MIT License
├── run.sh                       # Main launcher with animated menu
├── setup.sh                     # Automated installation script
├── check-status.sh              # System status checker
├── rollback.sh                 # Rollback script
├── daily-tweaks.sh              # Daily maintenance script
├── config/                      # Configuration files
│   ├── sysctl/                 # Kernel parameters
│   │   ├── 99-performance.conf  # Performance optimizations
│   │   └── 99-cachyos-tweaks.conf # CachyOS-specific tweaks
│   ├── systemd/               # System services
│   │   └── cpupower-performance.service # CPU governor service
│   ├── xorg/                  # Display server configs
│   │   ├── 10-nvidia-performance.conf # NVIDIA optimization
│   │   └── 10-amd-performance.conf    # AMD optimization
│   └── kernel/                # Boot parameters
│       └── cmdline-optimizations.conf # Kernel parameters
├── scripts/                    # Optimization scripts
│   ├── detect-hardware.sh     # Hardware detection
│   ├── cpu-optimization.sh    # CPU optimization
│   ├── gpu-optimization.sh    # GPU optimization
│   ├── memory-optimization.sh # Memory optimization
│   ├── network-optimization.sh # Network optimization
│   ├── storage-optimization.sh # Storage optimization
│   ├── low-latency-optimization.sh # Low latency gaming mode
│   ├── set-high-refresh-rate.sh # High refresh rate setup
│   ├── graphics-optimization.sh # OpenGL/Vulkan optimization
│   └── java-optimization.sh   # Java performance optimization
└── sources/                    # Source files
    ├── CachyOS-Settings/      # Official CachyOS configs
    └── linux-cachyos/         # CachyOS kernel source
```

## 🎨 Features

### Hardware Detection
- **CPU Detection:** Automatic detection of AMD, Intel, and other processors
- **GPU Detection:** Support for NVIDIA, AMD, and Intel graphics cards
- **Storage Detection:** Automatic identification of NVMe, SSD, and HDD storage
- **Network Detection:** Realtek, Intel, and other network adapter optimization

### Optimization Modules
- **CPU Optimization:** AMD P-State EPP, Intel P-State, governor tuning
- **GPU Optimization:** Performance modes, power management, PCIe tuning
- **Memory Optimization:** Swap tuning, cache optimization, transparent hugepages
- **Network Optimization:** Driver selection, TCP/IP tuning
- **Storage Optimization:** I/O scheduler selection, TRIM setup
- **Low Latency Gaming:** Reddit and CachyOS Forum recommended optimizations for lowest input lag
- **High Refresh Rate:** Automatic detection and setting of maximum monitor refresh rate
- **Advanced Kernel Tweaks:** Reddit and Arch Wiki recommended kernel parameters for gaming

### User Interface
- **Animated Terminal UI:** Smooth animations and transitions
- **Interactive Menus:** Easy-to-use navigation system
- **Color-Coded Output:** Clear visual feedback with emojis
- **Progress Indicators:** Real-time status updates
- **Hardware Status Display:** Detailed system information

### Safety Features
- **Backup Creation:** Automatic backup of original configurations
- **Rollback Script:** One-click restoration of default settings
- **Non-Destructive:** Safe installation without data loss
- **Verification Tools:** Status checking and performance scoring

## 📊 Performance Improvements

### Expected Gains
- **CPU Performance:** 10-20% improvement in single-threaded tasks
- **GPU Performance:** 5-15% improvement in gaming workloads
- **System Responsiveness:** 15-30% improvement in desktop usage
- **I/O Performance:** 20-40% improvement in storage operations

### Performance Score
The project includes a status checker that provides a performance score (0-5) based on:
- CPU governor status
- GPU optimization status
- Memory swappiness
- PCIe link speed
- System service status

## 🔧 Troubleshooting

### PCIe Speed Issues
If PCIe still runs at low speed, check BIOS settings:
- PCIe Lane Configuration: x16
- Above 4G Decoding: Enabled
- Resizable BAR: Enabled
- PCIe ASPM: Disabled

### Network Driver Issues
Check if r8168 driver is loaded:
```bash
lsmod | grep r8168
```

If not loaded:
```bash
sudo modprobe r8168
```

### Installation Failures
If the automatic installation fails, use the manual installation guide:
```bash
# View detailed installation guide
cat INSTALL.md
```

## 🔄 Rollback

To revert all changes:
```bash
sudo bash rollback.sh
```

## 📚 Documentation

- [Installation Guide](INSTALL.md) - Detailed installation instructions
- [Project Overview](PROJECT-OVERVIEW.md) - Comprehensive project information
- [CachyOS Wiki](https://wiki.cachyos.org/) - Official CachyOS documentation
- [Arch Wiki](https://wiki.archlinux.org/) - Arch Linux documentation

## 🤝 Contributing

We welcome contributions! Please feel free to:
- Report bugs via GitHub Issues
- Suggest new features
- Submit pull requests
- Improve documentation
- Share optimization profiles

## 📞 Support

For issues and questions:
- **GitHub Issues:** [Project Issues](https://github.com/litebiter/cachyos-optimization-tool/issues)
- **CachyOS Forum:** https://discuss.cachyos.org/
- **Arch Forum:** https://bbs.archlinux.org/

## � License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Creators

- **[litebiter](https://github.com/litebiter)** - Main Developer
- **[auxmeet](https://github.com/auxmeet)** - Co-Developer

## 🙏 Acknowledgments

- [CachyOS Team](https://github.com/CachyOS) for the amazing OS and configurations
- [Arch Linux Community](https://archlinux.org/) for the excellent documentation
- All contributors to the open-source community

---

<div align="center">

**⚡ Optimized for Performance • Crafted with Care • Made for CachyOS ⚡**

Created by **litebiter** & **auxmeet**

</div>