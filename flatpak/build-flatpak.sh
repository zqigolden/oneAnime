#!/bin/bash
set -e

# OneAnime Flatpak Build Script

echo "🚀 Starting OneAnime Flatpak build process..."

# Configuration
APP_ID="com.zqigolden.oneanime"
MANIFEST="$APP_ID.yaml"
BUILD_DIR="build"
REPO_DIR="repo"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if flatpak-builder is installed
if ! command -v flatpak-builder &> /dev/null; then
    echo -e "${RED}❌ flatpak-builder is not installed${NC}"
    echo "Install it with: sudo apt install flatpak-builder"
    exit 1
fi

# Check if required runtimes are installed
echo -e "${YELLOW}🔍 Checking Flatpak runtimes...${NC}"
if ! flatpak list | grep -q "org.freedesktop.Platform.*23.08"; then
    echo -e "${YELLOW}📥 Installing required Flatpak runtime...${NC}"
    flatpak install -y flathub org.freedesktop.Platform//23.08
    flatpak install -y flathub org.freedesktop.Sdk//23.08
fi

# Create directories
mkdir -p "$BUILD_DIR"
mkdir -p "$REPO_DIR"

# Download AppImage structure if not present
if [ ! -d "AppDir" ]; then
    echo -e "${YELLOW}📥 AppImage structure not found locally${NC}"
    echo "Please download and extract the linux_appimage_structure artifact from GitHub Actions"
    echo "Or update the manifest to use the GitHub release URL"
    exit 1
fi

# Build Flatpak
echo -e "${YELLOW}🔨 Building Flatpak package...${NC}"
flatpak-builder --force-clean --sandbox --user --install-deps-from=flathub \
    --ccache --require-changes --repo="$REPO_DIR" "$BUILD_DIR" "$MANIFEST"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Flatpak build successful!${NC}"
else
    echo -e "${RED}❌ Flatpak build failed${NC}"
    exit 1
fi

# Install locally for testing
echo -e "${YELLOW}📦 Installing Flatpak locally for testing...${NC}"
flatpak install --user --assumeyes "$REPO_DIR" "$APP_ID"

# Create bundle for distribution
echo -e "${YELLOW}📦 Creating Flatpak bundle...${NC}"
flatpak build-bundle "$REPO_DIR" "$APP_ID.flatpak" "$APP_ID"

echo -e "${GREEN}🎉 Build process completed successfully!${NC}"
echo ""
echo -e "${GREEN}📋 Next steps:${NC}"
echo "1. Test the application: flatpak run $APP_ID"
echo "2. Distribute the bundle: $APP_ID.flatpak"
echo "3. Submit to Flathub: https://github.com/flathub/flathub/wiki/App-Submission"

echo ""
echo -e "${YELLOW}🧪 Testing commands:${NC}"
echo "- Run app: flatpak run $APP_ID"
echo "- Debug: flatpak run --devel $APP_ID"
echo "- Uninstall: flatpak uninstall --user $APP_ID"