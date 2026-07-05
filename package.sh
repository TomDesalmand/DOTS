#!/bin/bash

# Install packages for Arch Linux with pacman and yay
# Includes AMD GPU drivers and AUR packages

set -e  # Exit on error

echo "=== Arch Linux Package Installer ==="
echo ""

# Check if not running as root (yay should run as regular user)
if [[ $EUID -eq 0 ]]; then
   echo "This script should NOT run as root (especially for yay)."
   echo "Please run as your regular user (without sudo)."
   exit 1
fi

# Define packages for pacman (official repos)
PACMAN_PACKAGES=(
  "base-devel"
  "thunar"
  "mesa"
  "vulkan-radeon"
  "lib32-mesa"
  "lib32-vulkan-radeon"
  "amd-ucode"
)

# Define packages for yay (AUR packages)
YAY_PACKAGES=(
  "hyprpaper"
  "hyprshot"
  "nwg-look"
  "pwvucontrol"
)

echo "=== Pacman Packages ==="
printf '%s\n' "${PACMAN_PACKAGES[@]}"
echo ""
echo "=== Yay/AUR Packages ==="
printf '%s\n' "${YAY_PACKAGES[@]}"
echo ""

# Update package database
echo "Updating package database..."
sudo pacman -Sy

# Install pacman packages
echo ""
echo "Installing official repository packages..."
sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"

# Install yay if not already installed
echo ""
echo "Checking for yay..."
if ! command -v yay &> /dev/null; then
  echo "yay not found. Installing yay from official repos..."
  sudo pacman -S --needed --noconfirm yay
fi

# Install AUR packages with yay
echo ""
echo "Installing AUR packages with yay..."
yay -S --needed --noconfirm "${YAY_PACKAGES[@]}"

echo ""
echo "=== Installation Complete ==="
echo "All packages have been installed successfully!"
echo ""
echo "AMD GPU drivers installed:"
echo "  - mesa (graphics driver)"
echo "  - vulkan-radeon (Vulkan support)"
echo "  - lib32-mesa (32-bit support)"
echo "  - lib32-vulkan-radeon (32-bit Vulkan)"
echo "  - amd-ucode (CPU microcode)"
