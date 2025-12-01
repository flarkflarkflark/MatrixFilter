# MatrixFilter v1.1.0 - Stable Multi-Platform Release

## Overview
This is the first stable, fully-working release of MatrixFilter with complete multi-platform build support.

## Features
- **Biquad filter implementation** for high-quality audio processing
- **Stereo audio support** with independent channel processing
- **Full CLAP 1.x plugin compatibility** following the official specification
- **Cross-platform support** for Linux, Windows, and macOS

## Build System Improvements
- ✅ Fixed all MSVC compilation errors
- ✅ Fixed symbol exports for all platforms (Linux version script, macOS symbol list, Windows DEF file)
- ✅ Added `extern "C"` linkage for proper C++ compatibility
- ✅ C++20 support for designated initializers (required for MSVC)
- ✅ Platform-specific compatibility fixes:
  - M_PI definition for Windows
  - strcasecmp → _stricmp mapping for Windows
  - Proper OpenGL header inclusion for macOS
- ✅ Replaced compound literals with static arrays for MSVC compatibility

## CI/CD Pipeline
- **GitHub Actions workflow** for automated builds on every push
- **Multi-platform builds** generating artifacts for:
  - Linux (Ubuntu 22.04) - `MatrixFilter.clap`
  - Windows (latest) - `MatrixFilter.clap`
  - macOS (latest) - `MatrixFilter.clap`
- **Automated artifact uploads** for easy distribution
- **Build status badges** available for README

## Changes Since v1.0.0
This release includes **9 commits** fixing critical compilation and build errors:

1. **Build system overhaul** (commit 3742863)
   - Fixed CMakeLists.txt source file paths
   - Removed incorrect `src/dsp.h` reference
   - Made OpenGL optional
   - Fixed CLAP SDK integration

2. **GitHub Actions CI/CD** (commit b837df6)
   - Multi-platform build workflow
   - Automatic artifact generation

3. **Bug documentation** (commit a0bef10)
   - Created comprehensive BUGS.md
   - Documented all 17+ issues found

4. **Major source code fixes** (commit fa1fa1d)
   - Removed `#pragma once` from .cpp files
   - Fixed CLAP feature constants
   - Fixed type names (`clap_process_status_t` → `clap_process_status`)
   - Fixed param_info field ordering

5. **C++ linkage fixes** (commit 69598b7)
   - Added `extern "C"` blocks
   - Removed `const` from global structures for proper symbol visibility
   - Created `include/plugin.h` header

6. **Symbol export fixes** (commit ad79518)
   - Fixed macOS symbol list format (`_clap_entry`)
   - Fixed Windows DEF file format (added EXPORTS header)
   - Updated CMakeLists.txt for platform-specific symbol files

7-9. **Windows compatibility** (commits b719afc, b17427f)
   - Fixed M_PI undefined error
   - Fixed strcasecmp identifier issue
   - Upgraded to C++20 for designated initializers
   - Fixed compound literal syntax error

## Technical Details

### CLAP SDK Integration
- CLAP SDK included as git submodule in `external/clap`
- Using official CLAP headers from clap-helpers

### Build Requirements
- **CMake** 3.15 or higher
- **C++20** compatible compiler:
  - GCC 8+ on Linux
  - MSVC 19.29+ (Visual Studio 2019) on Windows
  - Clang 10+ on macOS
- **Git** (for submodule initialization)

### Build Instructions
```bash
# Clone with submodules
git clone --recursive https://github.com/flarkflarkflark/MatrixFilter.git

# Or initialize submodules after cloning
git submodule update --init --recursive

# Build
mkdir build && cd build
cmake ..
cmake --build .

# Output: MatrixFilter.clap
```

## Installation

### Linux
```bash
mkdir -p ~/.clap
cp MatrixFilter.clap ~/.clap/
```

### Windows
Copy `MatrixFilter.clap` to:
- `%COMMONPROGRAMFILES%\CLAP\` (system-wide), or
- `%LOCALAPPDATA%\Programs\Common\CLAP\` (user-specific)

### macOS
```bash
cp MatrixFilter.clap ~/Library/Audio/Plug-Ins/CLAP/
```

## Known Issues
- None! All known compilation and build errors have been resolved.

## Credits
- Built with the CLAP audio plugin standard
- Biquad filter DSP implementation

## Release Artifacts
The following build artifacts are available from GitHub Actions:
- `MatrixFilter-Linux.zip` - Linux build
- `MatrixFilter-Windows.zip` - Windows build
- `MatrixFilter-macOS.zip` - macOS build

---

**Full Changelog**: v1.0.0...v1.1.0
