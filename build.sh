#!/bin/bash

# Exit on error
set -e

# Colors for terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Function to print section headers with some styling
print_section() {
  echo ""
  echo -e "🔹 ${BLUE}$1${NC}"
}

# Function to print a beautiful welcome message
welcome_message() {
  echo -e "${PURPLE}"
  echo -e "🎉🎉🎉 Welcome to Clippy's Build Script! 🎉🎉🎉"
  echo -e "🖥️ You're about to build Clippy and create a macOS DMG package with ease."
  echo -e "🚀 Let's get things rolling! 🌟"
  echo -e "${NC}"
}

# Check if command exists
check_command() {
  if ! command -v "$1" &> /dev/null; then
    return 1
  fi
  return 0
}

# Install create-dmg if missing, using Homebrew
install_create_dmg() {
  if check_command brew; then
    echo -e "${YELLOW}⚠️ 'create-dmg' is not installed.${NC}"
    read -p "Would you like to install it via Homebrew? (y/n): " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
      echo -e "${GREEN}📦 Installing 'create-dmg' via Homebrew...${NC}"
      brew install create-dmg
    else
      echo -e "${RED}❌ Installation cancelled. Exiting.${NC}"
      exit 1
    fi
  else
    echo -e "${RED}❌ 'create-dmg' is not installed, and Homebrew is not available.${NC}"
    echo -e "👉 Please install Homebrew from: https://brew.sh"
    echo -e "👉 After that, install 'create-dmg' with: brew install create-dmg"
    exit 1
  fi
}

# Begin script execution
welcome_message

echo -e "${CYAN}🔍 Checking for required tools...${NC}"

# Check if xcodebuild is available
if ! check_command xcodebuild; then
  echo -e "${RED}❌ 'xcodebuild' is not available.${NC}"
  echo "👉 Please install Xcode from the App Store: https://apps.apple.com/us/app/xcode/id497799835"
  exit 1
fi

# Check for create-dmg and install if necessary
check_command create-dmg || install_create_dmg

# Cleaning old artifacts
print_section "🧹 Cleaning old build artifacts..."
rm -rf dist build ./Clippy.dmg

# Creating build directory
print_section "📁 Creating build directory..."
mkdir dist

# Building Clippy app
print_section "🛠 Building Clippy app in Release mode..."
xcodebuild -scheme Clippy \
           -configuration Release \
           -derivedDataPath ./dist/build \
           -destination 'generic/platform=macOS' \
           CONFIGURATION_BUILD_DIR=$(pwd)/dist

# Creating DMG package
print_section "📦 Creating DMG package..."
create-dmg \
  --volname "Clippy" \
  --window-pos 200 120 \
  --window-size 500 300 \
  --icon-size 100 \
  --icon "Clippy.app" 130 130 \
  --icon "Applications" 360 130 \
  --app-drop-link 360 130 \
  --background "./assets/bg.jpg" \
  ./Clippy.dmg \
  ./dist/Clippy.app

# Success message and DMG location
echo -e "${GREEN}✅ DMG package created at ./Clippy.dmg${NC}"

# Opening the DMG for the user
print_section "🚀 Opening DMG..."
open ./Clippy.dmg

# Final message with a friendly tone
echo -e "${CYAN}🎉🎉🎉 All Done! 🎉🎉🎉${NC}"
echo -e "The DMG package has been successfully created at ${GREEN}./Clippy.dmg${NC}."
echo -e "To install, simply drag the Clippy app into your Applications folder."
echo -e "Enjoy using Clippy! If you encounter any issues or have any questions:"
echo -e "👉 Check out the README file."
echo -e "👉 Open an issue on GitHub: https://github.com/duyduc-dev/clippy/issues"
echo -e "We’re always happy to help! 😊"
echo -e "Thank you for building with us! 🚀"
echo -e "If you have feedback or suggestions, feel free to reach out. 🌱"
echo -e "Happy coding and take care! 💻✨"
echo -e "${NC}"
echo -e "${CYAN}💻✨ Clippy Build Script Completed! ✨💻${NC}"
echo -e "${PURPLE}🌟 Thank you for using Clippy! 🌟${NC}"
echo -e "${GREEN}🚀 Have a great day! 🚀${NC}"
echo -e "${NC}"
echo -e "${YELLOW}🔚 End of Script 🔚${NC}"
