
rm -rf dist && mkdir dist
rm -rf build
rm -rf ./Clippy.dmg

xcodebuild -scheme Clippy -configuration Release \
  -derivedDataPath ./dist/build \
  -destination 'generic/platform=macOS' \
  CONFIGURATION_BUILD_DIR=$(pwd)/dist
  
create-dmg --app-drop-link 400 100 ./Clippy.dmg ./dist/Clippy.app

