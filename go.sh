#!/bin/bash
# MatrixFilter GitHub Build - ONE COMMAND DOES EVERYTHING
# Just run: ./go.sh

set -e
C='\033[0;36m';G='\033[0;32m';Y='\033[1;33m';N='\033[0m'
echo -e "${C}🚀 MatrixFilter → GitHub Builder${N}\n"

# Check we're in a git repo
[ ! -d ".git" ] && echo -e "${Y}⚠ Run this from MatrixFilter repo root${N}" && exit 1

# Fix naming
echo -e "${C}Fixing naming...${N}"
find . -type f -not -path "./.git/*" -not -path "*/build*/*" -not -path "*/external/*" \
  -not -name "*.o" -not -name "*.so" -not -name "*.dll" -not -name "*.dylib" -not -name "go.sh" 2>/dev/null | \
  xargs -I {} sed -i 's/MatrixFlanger/MatrixFilter/g;s/MATRIXFLANGER/MATRIXFILTER/g;s/MATRIX_FLANGER/MATRIX_FILTER/g;s/matrix-flanger/matrix-filter/g;s/Flanger/Filter/g;s/FLANGER/FILTER/g;s/flanger/filter/g' {} 2>/dev/null || true
echo -e "${G}✓ Naming fixed${N}"

# Create GitHub Actions
echo -e "${C}Creating GitHub Actions...${N}"
mkdir -p .github/workflows
cat > .github/workflows/build.yml << 'EOF'
name: Build MatrixFilter
on: [push, pull_request, workflow_dispatch]
jobs:
  build-linux:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        format: [clap, vst3, lv2]
    steps:
    - uses: actions/checkout@v4
      with:
        submodules: recursive
    - name: Install dependencies
      run: |
        sudo apt-get update
        sudo apt-get install -y cmake build-essential libgl1-mesa-dev libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev libasound2-dev libjack-jackd2-dev lv2-dev
    - name: Download SDKs
      run: |
        mkdir -p external
        [ "${{ matrix.format }}" = "clap" ] && git clone https://github.com/free-audio/clap.git external/clap || true
        [ "${{ matrix.format }}" = "vst3" ] && git clone --recursive https://github.com/steinbergmedia/vst3sdk.git external/vst3sdk || true
    - name: Build
      run: |
        chmod +x build-${{ matrix.format }}.sh 2>/dev/null || true
        if [ -f build-${{ matrix.format }}.sh ]; then ./build-${{ matrix.format }}.sh; else mkdir -p build-${{ matrix.format }} && cd build-${{ matrix.format }} && cmake .. -DCMAKE_BUILD_TYPE=Release && make; fi
    - uses: actions/upload-artifact@v4
      with:
        name: MatrixFilter-Linux-${{ matrix.format }}
        path: build-${{ matrix.format }}/**/*.{so,clap,vst3,lv2}

  build-windows:
    runs-on: windows-latest
    strategy:
      matrix:
        format: [clap, vst3]
    steps:
    - uses: actions/checkout@v4
      with:
        submodules: recursive
    - uses: microsoft/setup-msbuild@v2
    - name: Download SDKs
      shell: bash
      run: |
        mkdir -p external
        [ "${{ matrix.format }}" = "clap" ] && git clone https://github.com/free-audio/clap.git external/clap || true
        [ "${{ matrix.format }}" = "vst3" ] && git clone --recursive https://github.com/steinbergmedia/vst3sdk.git external/vst3sdk || true
    - name: Build
      shell: cmd
      run: |
        if exist build-${{ matrix.format }}.bat (call build-${{ matrix.format }}.bat) else (mkdir build-${{ matrix.format }} && cd build-${{ matrix.format }} && cmake .. -G "Visual Studio 17 2022" -A x64 && cmake --build . --config Release)
    - uses: actions/upload-artifact@v4
      with:
        name: MatrixFilter-Windows-${{ matrix.format }}
        path: build-${{ matrix.format }}/**/*.{dll,clap,vst3}

  build-macos:
    runs-on: macos-latest
    strategy:
      matrix:
        format: [clap, vst3, lv2]
    steps:
    - uses: actions/checkout@v4
      with:
        submodules: recursive
    - run: brew install cmake pkg-config
    - name: Download SDKs
      run: |
        mkdir -p external
        [ "${{ matrix.format }}" = "clap" ] && git clone https://github.com/free-audio/clap.git external/clap || true
        [ "${{ matrix.format }}" = "vst3" ] && git clone --recursive https://github.com/steinbergmedia/vst3sdk.git external/vst3sdk || true
    - name: Build
      run: |
        chmod +x build-${{ matrix.format }}.sh 2>/dev/null || true
        if [ -f build-${{ matrix.format }}.sh ]; then ./build-${{ matrix.format }}.sh; else mkdir -p build-${{ matrix.format }} && cd build-${{ matrix.format }} && cmake .. -DCMAKE_BUILD_TYPE=Release && make; fi
    - uses: actions/upload-artifact@v4
      with:
        name: MatrixFilter-macOS-${{ matrix.format }}
        path: build-${{ matrix.format }}/**/*.{dylib,clap,vst3,lv2}
EOF
echo -e "${G}✓ GitHub Actions created${N}"

# Make build scripts executable
for s in build-*.sh; do [ -f "$s" ] && chmod +x "$s" && git add "$s"; done 2>/dev/null || true

# Commit and push
echo -e "${C}Committing...${N}"
git add -A
git commit -m "Fix naming and add GitHub Actions" 2>/dev/null || echo "Nothing to commit"
BRANCH=$(git rev-parse --abbrev-ref HEAD)
REMOTE=$(git remote | head -n 1)

echo -e "${C}Pushing to ${REMOTE}/${BRANCH}...${N}"
if git push $REMOTE $BRANCH; then
  echo -e "\n${G}════════════════════════════════════════${N}"
  echo -e "${G}✓ SUCCESS! Builds starting on GitHub! 🎉${N}"
  echo -e "${G}════════════════════════════════════════${N}\n"
  echo -e "Watch: ${C}https://github.com/flarkflarkflark/MatrixFilter/actions${N}\n"
else
  echo -e "\n${Y}⚠ Push failed. Try: git push $REMOTE $BRANCH${N}\n"
fi
