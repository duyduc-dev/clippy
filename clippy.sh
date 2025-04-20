#!/bin/bash

# Exit on error
set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print a section title with a custom color
print_section() {
  echo ""
  echo -e "🔹 ${CYAN}$1${NC}"
}

# Check if command exists
check_command() {
  if ! command -v "$1" &> /dev/null; then
    return 1
  fi
  return 0
}

# Clone the repository and run build.sh
clone_and_build() {
  print_section "🚀 Cloning the Clippy repository from GitHub..."
  rm -rf ./clippy 
  git clone https://github.com/duyduc-dev/clippy.git

  cd clippy || exit 1

  if [ -f "build.sh" ]; then
    print_section "🛠 Running build.sh script..."
    bash build.sh
  else
    echo -e "${RED}❌ 'build.sh' not found in the repository.${NC}"
    exit 1
  fi
}

# Start the process
print_section "🔍 Checking for git..."

# Ensure git is installed
if ! check_command git; then
  echo -e "${RED}❌ Git is not installed.${NC}"
  echo "👉 Please install Git from: https://git-scm.com/"
  exit 1
fi

# Clone the repository and run the build script
clone_and_build

echo -e "${GREEN}🎉 Clippy repository cloned and build script executed successfully!${NC}"
rm -rf ./clippy
