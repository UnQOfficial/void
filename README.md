# Void AI Code Editor for Android

A simple and elegant installer script for the Void AI Code Editor - a powerful tool for Android developers.

<p align="center">
  <img src="logo.png" alt="Void AI Code Editor" width="300">
</p>

## 🌟 Features

- Easy installation process with dependency management
- Support for Android devices
- Simple uninstallation process
- User-friendly terminal interface
- Automatic detection of system architecture
- Compatible with Termux and other Android terminals

## 📋 Requirements

- Android device with terminal access (Termux recommended)
- Internet connection for downloading packages
- Basic dependencies: `curl` and `jq` (automatically installed if missing)

## 🚀 Installation

### Option 1: Direct Download and Run

```bash
# Download the installer script
curl -L -o void.sh https://raw.githubusercontent.com/MaheshTechnicals/Void-Ai-Code-Editor-On-Android/main/void.sh

# Make it executable
chmod +x void.sh

# Run the installer
./void.sh
```

### Option 2: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/MaheshTechnicals/Void-Ai-Code-Editor-On-Android.git

# Navigate to the directory
cd Void-Ai-Code-Editor-On-Android

# Make the script executable
chmod +x void.sh

# Run the installer
./void.sh
```

## 💻 Usage

The installer provides a simple terminal-based menu:

1. Install Void AI Code Editor - Downloads and installs the latest version
2. Uninstall Void AI Code Editor - Removes the application from your system
3. Exit - Closes the installer

## 🏗️ How It Works

The script performs the following operations:

1. Checks and installs required dependencies (`curl` and `jq`)
2. Detects your system architecture (arm64, armhf)
3. Fetches the latest release URL from GitHub
4. Downloads and installs the appropriate package for your Android device

## 👨‍💻 Author

Mahesh Technicals

## 📜 License

MIT License - see the [LICENSE](LICENSE) file for details

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/MaheshTechnicals/Void-Ai-Code-Editor-On-Android/issues).

## ⭐ Star this Repository

If you find this installer useful, please consider giving it a star on GitHub to show your support! 