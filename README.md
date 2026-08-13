# CachyOS Optimization Project

<div align="center">

**🚀 Universal System Optimization Tool for CachyOS/Arch Linux**

Created by [litebiter](https://github.com/litebiter) & [auxmeet](https://github.com/auxmeet)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![CachyOS](https://img.shields.io/badge/CachyOS-supported-green.svg)](https://cachyos.org/)
[![Arch Linux](https://img.shields.io/badge/Arch%20Linux-compatible-blue.svg)](https://archlinux.org/)
[![GitHub](https://img.shields.io/badge/Github-cachyos--optimization--tool-orange.svg)](https://github.com/iromenero/cachyos-optimization-tool)

</div>

## ✨ Features

- **🎯 Universal Hardware Support** - Automatic detection and optimization for all CPU/GPU combinations
- **⚡ Smart Performance Tuning** - Adaptive optimizations based on your specific hardware
- **🎨 Beautiful Interface** - Animated terminal UI with interactive menus and color-coded output
- **🛡️ Safe & Reversible** - All changes can be easily rolled back with one command
- **🔄 Regular Updates** - Integrated with official CachyOS configurations for latest optimizations

## 🚀 Quick Start

### Installation via Git Clone

<div align="center">

```bash
# Clone the repository
git clone https://github.com/iromenero/cachyos-optimization-tool.git

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
wget https://github.com/iromenero/cachyos-optimization-tool/archive/refs/heads/main.zip

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
  [7] About
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
│   └── storage-optimization.sh # Storage optimization
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
- **GitHub Issues:** [Project Issues](https://github.com/iromenero/cachyos-optimization-tool/issues)
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