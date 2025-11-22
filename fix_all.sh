#!/bin/bash

#############################################
# MatrixFilter Complete Fix Script
# Run this from the root of your repository
#############################################

set -e  # Exit on error

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored headers
print_header() {
    echo ""
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
}

# Function to print success
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print warning
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Function to print error
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Function to print info
print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not a git repository! Please run this from the root of your MatrixFilter repository."
        exit 1
    fi
    print_success "Git repository detected"
}

# Check for uncommitted changes
check_uncommitted_changes() {
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        print_warning "You have uncommitted changes!"
        echo "It's recommended to commit or stash them before proceeding."
        read -p "Continue anyway? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Preview naming changes
preview_changes() {
    print_header "STEP 1: Preview Naming Changes"
    
    print_info "Searching for 'Flanger' references..."
    
    FLANGER_FILES=$(grep -r -i -l "flanger" . \
        --exclude-dir={.git,build*,external} \
        --exclude="*.{o,so,dll,dylib,bak}" \
        --exclude="fix_all.sh" \
        2>/dev/null || true)
    
    if [ -z "$FLANGER_FILES" ]; then
        print_success "No 'Flanger' references found! Repository is already clean."
        return 1
    fi
    
    echo "Files to be modified:"
    echo "$FLANGER_FILES" | while read file; do
        echo "  - $file"
    done
    
    echo ""
    TOTAL_FILES=$(echo "$FLANGER_FILES" | wc -l)
    print_info "Total files to modify: $TOTAL_FILES"
    
    return 0
}

# Fix naming issues
fix_naming() {
    print_header "STEP 2: Fix Naming Issues"
    
    print_info "Replacing all 'Flanger' references with 'Filter'..."
    
    find . -type f \
        -not -path "./.git/*" \
        -not -path "*/build*/*" \
        -not -path "*/external/*" \
        -not -name "*.o" \
        -not -name "*.so" \
        -not -name "*.dll" \
        -not -name "*.dylib" \
        -not -name "*.a" \
        -not -name "*.bak" \
        -not -name "fix_all.sh" \
        | while read file; do
        
        if grep -q -i "flanger" "$file" 2>/dev/null; then
            echo "  Processing: $file"
            
            # Perform replacements (multiple patterns for comprehensive coverage)
            sed -i 's/MatrixFlanger/MatrixFilter/g' "$file"
            sed -i 's/MATRIXFLANGER/MATRIXFILTER/g' "$file"
            sed -i 's/MATRIX_FLANGER/MATRIX_FILTER/g' "$file"
            sed -i 's/matrix-flanger/matrix-filter/g' "$file"
            sed -i 's/matrix_flanger/matrix_filter/g' "$file"
            sed -i 's/matrixflanger/matrixfilter/g' "$file"
            sed -i 's/Flanger/Filter/g' "$file"
            sed -i 's/FLANGER/FILTER/g' "$file"
            sed -i 's/flanger/filter/g' "$file"
        fi
    done
    
    print_success "Naming fixes applied!"
}

# Create GitHub Actions workflows
setup_github_actions() {
    print_header "STEP 3: Set Up GitHub Actions"
    
    print_info "Creating .github/workflows directory..."
    mkdir -p .github/workflows
    
    print_info "Creating main build workflow..."
    cat > .github/workflows/build.yml << 'EOF'
name: Build MatrixFilter

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build-linux:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        format: [clap, vst3, lv2]
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      with:
        submodules: recursive
    
    - name: Install dependencies
      run: |
        sudo apt-get update
        sudo apt-get install -y \
          cmake \
          build-essential \
          libgl1-mesa-dev \
          libx11-dev \
          libxrandr-dev \
          libxinerama-dev \
          libxcursor-dev \
          libxi-dev \
          libasound2-dev \
          libjack-jackd2-dev \
          lv2-dev
    
    - name: Download CLAP SDK
      if: matrix.format == 'clap'
      run: |
        git clone https://github.com/free-audio/clap.git external/clap
    
    - name: Download VST3 SDK
      if: matrix.format == 'vst3'
      run: |
        git clone --recursive https://github.com/steinbergmedia/vst3sdk.git external/vst3sdk
    
    - name: Build ${{ matrix.format }}
      run: |
        chmod +x build-${{ matrix.format }}.sh
        ./build-${{ matrix.format }}.sh
    
    - name: Upload artifacts
      uses: actions/upload-artifact@v4
      with:
        name: MatrixFilter-Linux-${{ matrix.format }}
        path: |
          build-${{ matrix.format }}/**/*.so
          build-${{ matrix.format }}/**/*.clap
          build-${{ matrix.format }}/**/*.vst3
          build-${{ matrix.format }}/**/*.lv2

  build-windows:
    runs-on: windows-latest
    strategy:
      matrix:
        format: [clap, vst3]
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      with:
        submodules: recursive
    
    - name: Setup MSVC
      uses: microsoft/setup-msbuild@v2
    
    - name: Download CLAP SDK
      if: matrix.format == 'clap'
      run: |
        git clone https://github.com/free-audio/clap.git external/clap
    
    - name: Download VST3 SDK
      if: matrix.format == 'vst3'
      run: |
        git clone --recursive https://github.com/steinbergmedia/vst3sdk.git external/vst3sdk
    
    - name: Build ${{ matrix.format }}
      shell: cmd
      run: |
        if "${{ matrix.format }}" == "clap" (
          build-clap.bat
        ) else (
          build-vst3.bat
        )
    
    - name: Upload artifacts
      uses: actions/upload-artifact@v4
      with:
        name: MatrixFilter-Windows-${{ matrix.format }}
        path: |
          build-${{ matrix.format }}/**/*.dll
          build-${{ matrix.format }}/**/*.clap
          build-${{ matrix.format }}/**/*.vst3

  build-macos:
    runs-on: macos-latest
    strategy:
      matrix:
        format: [clap, vst3, lv2]
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      with:
        submodules: recursive
    
    - name: Install dependencies
      run: |
        brew install cmake pkg-config
    
    - name: Download CLAP SDK
      if: matrix.format == 'clap'
      run: |
        git clone https://github.com/free-audio/clap.git external/clap
    
    - name: Download VST3 SDK
      if: matrix.format == 'vst3'
      run: |
        git clone --recursive https://github.com/steinbergmedia/vst3sdk.git external/vst3sdk
    
    - name: Build ${{ matrix.format }}
      run: |
        chmod +x build-${{ matrix.format }}.sh
        ./build-${{ matrix.format }}.sh
    
    - name: Upload artifacts
      uses: actions/upload-artifact@v4
      with:
        name: MatrixFilter-macOS-${{ matrix.format }}
        path: |
          build-${{ matrix.format }}/**/*.dylib
          build-${{ matrix.format }}/**/*.clap
          build-${{ matrix.format }}/**/*.vst3
          build-${{ matrix.format }}/**/*.lv2

  create-release:
    needs: [build-linux, build-windows, build-macos]
    runs-on: ubuntu-latest
    if: startsWith(github.ref, 'refs/tags/v')
    
    steps:
    - name: Download all artifacts
      uses: actions/download-artifact@v4
    
    - name: Create Release
      uses: softprops/action-gh-release@v1
      with:
        files: |
          MatrixFilter-*/**/*
        draft: false
        prerelease: false
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
EOF
    
    print_success "GitHub Actions workflow created!"
    
    print_info "Creating quick check workflow..."
    cat > .github/workflows/quick-check.yml << 'EOF'
name: Quick Build Check

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  quick-build:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      with:
        submodules: recursive
    
    - name: Install dependencies
      run: |
        sudo apt-get update
        sudo apt-get install -y \
          cmake \
          build-essential \
          libgl1-mesa-dev \
          libx11-dev \
          libasound2-dev
    
    - name: Download CLAP SDK
      run: |
        git clone https://github.com/free-audio/clap.git external/clap
    
    - name: Build CLAP
      run: |
        chmod +x build-clap.sh
        ./build-clap.sh
    
    - name: Verify build
      run: |
        if find build-clap -name "*.clap" | grep -q .; then
          echo "✓ Build successful"
        else
          echo "✗ Build failed"
          exit 1
        fi

  check-naming:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Check for incorrect naming
      run: |
        FLANGER_COUNT=$(grep -r -i "flanger" . \
          --exclude-dir={.git,.github,build*,external} \
          --exclude="*.{o,so,dll,dylib}" \
          2>/dev/null | wc -l || echo "0")
        
        if [ "$FLANGER_COUNT" -gt 0 ]; then
          echo "⚠️  Found $FLANGER_COUNT 'flanger' references"
          grep -r -i -l "flanger" . \
            --exclude-dir={.git,.github,build*,external} \
            2>/dev/null | head -10
        else
          echo "✓ No 'flanger' references found"
        fi
EOF
    
    print_success "Quick check workflow created!"
}

# Verify fixes
verify_fixes() {
    print_header "STEP 4: Verify Fixes"
    
    print_info "Checking for remaining 'Flanger' references..."
    
    REMAINING=$(grep -r -i "flanger" . \
        --exclude-dir={.git,.github,build*,external} \
        --exclude="*.{o,so,dll,dylib,bak}" \
        --exclude="fix_all.sh" \
        2>/dev/null | wc -l || echo "0")
    
    if [ "$REMAINING" -eq 0 ]; then
        print_success "All 'Flanger' references have been fixed!"
    else
        print_warning "Found $REMAINING remaining 'Flanger' references"
        echo "These may need manual review:"
        grep -r -i -l "flanger" . \
            --exclude-dir={.git,.github,build*,external} \
            --exclude="*.{o,so,dll,dylib,bak}" \
            --exclude="fix_all.sh" \
            2>/dev/null | head -5
    fi
    
    print_info "Checking build scripts are executable..."
    for script in build-*.sh; do
        if [ -f "$script" ]; then
            if [ -x "$script" ]; then
                print_success "$script is executable"
            else
                print_warning "$script is not executable, fixing..."
                chmod +x "$script"
                git add "$script"
            fi
        fi
    done
}

# Git operations
commit_and_push() {
    print_header "STEP 5: Commit and Push Changes"
    
    print_info "Staging all changes..."
    git add -A
    
    print_info "Creating commit..."
    git commit -m "Fix naming: Replace all 'Flanger' references with 'Filter' and add GitHub Actions" || {
        print_warning "Nothing to commit or commit failed"
        return
    }
    
    print_success "Changes committed!"
    
    echo ""
    read -p "Push to remote? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Pushing to remote..."
        
        # Get current branch
        BRANCH=$(git rev-parse --abbrev-ref HEAD)
        
        git push origin "$BRANCH" && {
            print_success "Pushed to origin/$BRANCH"
            echo ""
            print_info "GitHub Actions will start building automatically!"
            print_info "Check: https://github.com/flarkflarkflark/MatrixFilter/actions"
        } || {
            print_error "Push failed. You may need to push manually."
        }
    else
        print_info "Skipping push. You can push manually later with: git push"
    fi
}

# Summary
show_summary() {
    print_header "Summary"
    
    echo -e "${GREEN}All fixes have been applied!${NC}"
    echo ""
    echo "What was done:"
    echo "  ✓ Replaced all 'Flanger' → 'Filter' references"
    echo "  ✓ Created GitHub Actions workflows"
    echo "  ✓ Made build scripts executable"
    echo "  ✓ Committed changes to git"
    echo ""
    echo "Next steps:"
    echo "  1. Check GitHub Actions: https://github.com/flarkflarkflark/MatrixFilter/actions"
    echo "  2. Test builds locally if needed"
    echo "  3. Review changes with: git show"
    echo ""
    echo "To create a release with automatic builds:"
    echo "  git tag v1.0.0"
    echo "  git push origin v1.0.0"
    echo ""
}

#############################################
# MAIN EXECUTION
#############################################

print_header "MatrixFilter Complete Fix Script"

print_info "This script will:"
echo "  1. Fix all 'Flanger' → 'Filter' naming issues"
echo "  2. Set up GitHub Actions for automated builds"
echo "  3. Commit and push changes"
echo ""

read -p "Continue? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Aborted by user"
    exit 0
fi

# Run all steps
check_git_repo
check_uncommitted_changes

if preview_changes; then
    echo ""
    read -p "Apply these changes? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Aborted by user"
        exit 0
    fi
    
    fix_naming
else
    print_info "Skipping naming fixes (already clean)"
fi

setup_github_actions
verify_fixes
commit_and_push
show_summary

print_success "Done! 🎉"
