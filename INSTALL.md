# 🚀 CachyOS Optimization Project - Installation Guide

<div align="center">

**Universal System Optimization Tool for CachyOS/Arch Linux**

Created by [litebiter](https://github.com/litebiter) & [auxmeet](https://github.com/auxmeet)

[![GitHub](https://img.shields.io/badge/Github-cachyos--optimization--tool-blue.svg)](https://github.com/iromenero/cachyos-optimization-tool)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![CachyOS](https://img.shields.io/badge/CachyOS-supported-orange.svg)](https://cachyos.org/)

</div>

## 📋 System Requirements

- **Operating System:** CachyOS or Arch Linux
- **Privileges:** Sudo access
- **Internet:** Required for git clone
- **Disk Space:** 500MB free space
- **RAM:** Minimum 4GB (8GB+ recommended)

## 🔧 Installation Methods

### Method 1: Git Clone (Recommended)

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

### Method 2: Download & Extract

<div align="center">

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

</div>

## 🎯 Quick Start Guide

### Step 1: Launch the Application

<div align="center">

```bash
cd cachyos-optimization-tool
bash run.sh
```

</div>

### Step 2: Welcome Screen

The application will display:
- **Animated ASCII Art Banner**
- **Hardware Detection Results**
- **System Information**
- **Performance Recommendations**

### Step 3: Main Menu

Select from the following options:

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

### Step 4: Install Optimizations

Select option **[2]** to begin the installation process:

- **Hardware Detection** ✅
- **Package Installation** ✅
- **Configuration Application** ✅
- **Service Setup** ✅
- **Kernel Parameter Tuning** ✅

### Step 5: Reboot System

After installation completes, reboot to apply all changes:

<div align="center">

```bash
sudo reboot
```

</div>

## 🔍 Verification

### Check System Status

<div align="center">

```bash
bash check-status.sh
```

</div>

Expected output:
```
Overall Performance Score: 5/5
✓ CPU Governor: OPTIMIZED
✓ GPU Persistence: OPTIMIZED
✓ Memory Swappiness: OPTIMIZED
✓ PCIe Speed: OPTIMIZED
✓ System Services: OPTIMIZED
```

### Check CPU Performance

<div align="center">

```bash
cpupower frequency-info
```

</div>

Expected: `Governor: performance`

### Check GPU Status

<div align="center">

```bash
nvidia-smi
```

</div>

Expected: `Persistence Mode: On`

## 🛠️ Manual Installation

If the automatic installation fails, perform manual installation:

### 1. Install Required Packages

<div align="center">

```bash
sudo pacman -S cpupower thermald
```

</div>

### 2. Apply Sysctl Configurations

<div align="center">

```bash
sudo cp config/sysctl/99-performance.conf /etc/sysctl.d/
sudo cp config/sysctl/99-cachyos-tweaks.conf /etc/sysctl.d/
sudo sysctl --system
```

</div>

### 3. Setup Systemd Services

<div align="center">

```bash
sudo cp config/systemd/cpupower-performance.service /etc/systemd/system/
sudo systemctl enable cpupower-performance.service
sudo systemctl start cpupower-performance.service
```

</div>

### 4. Configure Display Server

<div align="center">

```bash
sudo mkdir -p /etc/X11/xorg.conf.d
sudo cp config/xorg/10-nvidia-performance.conf /etc/X11/xorg.conf.d/
```

</div>

### 5. Configure Kernel Parameters

<div align="center">

```bash
sudo nano /etc/default/grub
```

</div>

Add to `GRUB_CMDLINE_LINUX_DEFAULT`:
```
amd_pstate=active pcie_aspm=off pci=nommconf
```

<div align="center">

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

</div>

### 6. Run Optimization Scripts

<div align="center">

```bash
sudo bash scripts/cpu-optimization.sh
sudo bash scripts/gpu-optimization.sh
sudo bash scripts/memory-optimization.sh
sudo bash scripts/network-optimization.sh
sudo bash scripts/storage-optimization.sh
```

</div>

## 🔧 Troubleshooting

### PCIe Speed Issues

**Problem:** PCIe running at low speed (2.5 GT/s instead of 16.0 GT/s)

**Solution:** Check BIOS settings:
- PCIe Lane Configuration: x16
- Above 4G Decoding: Enabled
- Resizable BAR: Enabled
- PCIe ASPM: Disabled

### Network Driver Issues

**Problem:** Network connection issues after optimization

**Solution:** Check driver status:
<div align="center">

```bash
lsmod | grep r8168
```

</div>

If not loaded:
<div align="center">

```bash
sudo modprobe r8168
```

</div>

### GPU Optimization Issues

**Problem:** GPU optimizations not applying

**Solution:** Ensure X11 is running:
<div align="center">

```bash
echo $DISPLAY
```

</div>

If empty, restart X11 or reboot system.

### Installation Failures

**Problem:** Installation script fails with errors

**Solution:** Check system logs:
<div align="center">

```bash
journalctl -xe
```

</div>

Ensure all dependencies are installed:
<div align="center">

```bash
sudo pacman -S base-devel git
```

</div>

## 🔄 Rollback

To revert all changes and restore default settings:

<div align="center">

```bash
sudo bash rollback.sh
```

</div>

This will:
- Remove custom sysctl configurations
- Restore default CPU governor
- Reset GPU settings to defaults
- Remove systemd services
- Restore GRUB defaults
- Reset network drivers

## 📚 Additional Resources

### Official Documentation
- [CachyOS Wiki](https://wiki.cachyos.org/)
- [CachyOS Settings GitHub](https://github.com/CachyOS/CachyOS-Settings)
- [CachyOS Kernel GitHub](https://github.com/CachyOS/linux-cachyos)
- [Arch Wiki](https://wiki.archlinux.org/)

### Community Support
- [CachyOS Forum](https://discuss.cachyos.org/)
- [Arch Forum](https://bbs.archlinux.org/)
- [Reddit r/CachyOS](https://reddit.com/r/CachyOS)

### Project Documentation
- [README.md](README.md) - Project overview
- [PROJECT-OVERVIEW.md](PROJECT-OVERVIEW.md) - Detailed project information
- [LICENSE](LICENSE) - MIT License information

## 🎨 Features

### Hardware Detection
- ✅ Automatic CPU detection (AMD/Intel)
- ✅ Automatic GPU detection (NVIDIA/AMD/Intel)
- ✅ Storage type detection (NVMe/SSD/HDD)
- ✅ Network adapter detection

### Optimization Modules
- ✅ CPU governor tuning
- ✅ GPU performance optimization
- ✅ Memory and swap optimization
- ✅ Network driver optimization
- ✅ Storage I/O optimization
- ✅ Kernel parameter tuning

### User Interface
- ✅ Beautiful animated terminal UI
- ✅ Interactive menu system
- ✅ Color-coded output
- ✅ Real-time progress indicators
- ✅ Hardware status display

### Safety Features
- ✅ Automatic backup creation
- ✅ One-click rollback functionality
- ✅ Non-destructive installation
- ✅ System verification tools
- ✅ Performance scoring system

## 📊 Performance Improvements

### Expected Gains
- **CPU Performance:** 10-20% improvement in single-threaded tasks
- **GPU Performance:** 5-15% improvement in gaming workloads
- **System Responsiveness:** 15-30% improvement in desktop usage
- **I/O Performance:** 20-40% improvement in storage operations

### Benchmarking
Use the built-in status checker to measure improvements:
<div align="center">

```bash
bash check-status.sh
```

</div>

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

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Creators

- **[litebiter](https://github.com/litebiter)** - Main Developer
- **[auxmeet](https://github.com/auxmeet)** - Co-Developer

---

<div align="center">

**⚡ Optimized for Performance • Crafted with Care • Made for CachyOS ⚡**

Created by **litebiter** & **auxmeet**

</div>