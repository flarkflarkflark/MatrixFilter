# MatrixFilter

[![Build Status](https://github.com/flarkflarkflark/MatrixFilter/actions/workflows/build.yml/badge.svg)](https://github.com/flarkflarkflark/MatrixFilter/actions/workflows/build.yml)
[![Latest Release](https://img.shields.io/github/v/release/flarkflarkflark/MatrixFilter)](https://github.com/flarkflarkflark/MatrixFilter/releases/latest)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A high-quality stereo audio filter plugin in CLAP format, featuring biquad filter implementation for professional audio processing.

## Features

- 🎚️ **Biquad Filter DSP** - Professional-grade digital filter implementation
- 🎧 **Stereo Processing** - Independent left/right channel filtering
- 🔌 **CLAP Plugin Format** - Modern, open audio plugin standard
- 🖥️ **Cross-Platform** - Builds on Linux, Windows, and macOS
- ⚡ **High Performance** - Optimized C++ implementation
- 🎛️ **Parametric Control** - Adjustable filter parameters via host automation

## Download

Pre-built binaries are available from the [Releases](https://github.com/flarkflarkflark/MatrixFilter/releases) page.

Download the appropriate package for your platform:
- **Linux**: `MatrixFilter-Linux.zip`
- **Windows**: `MatrixFilter-Windows.zip`
- **macOS**: `MatrixFilter-macOS.zip`

## Installation

### Linux
```bash
unzip MatrixFilter-Linux.zip
mkdir -p ~/.clap
cp MatrixFilter.clap ~/.clap/
```

### Windows
1. Extract `MatrixFilter-Windows.zip`
2. Copy `MatrixFilter.clap` to one of:
   - `C:\Program Files\Common Files\CLAP\` (system-wide)
   - `%LOCALAPPDATA%\Programs\Common\CLAP\` (user-specific)

### macOS
```bash
unzip MatrixFilter-macOS.zip
mkdir -p ~/Library/Audio/Plug-Ins/CLAP
cp MatrixFilter.clap ~/Library/Audio/Plug-Ins/CLAP/
```

## Usage

1. **Load in your DAW**: MatrixFilter will appear in your CLAP-compatible DAW's plugin list
2. **Insert on a track**: Add MatrixFilter to any audio track
3. **Adjust parameters**: Use your DAW's automation to control filter parameters
4. **Process audio**: The biquad filter will process incoming stereo audio in real-time

### Compatible DAWs

MatrixFilter works with any DAW that supports CLAP plugins, including:
- Bitwig Studio 4.0+
- Reaper 6.68+
- MultitrackStudio
- And other CLAP-compatible hosts

## Building from Source

### Requirements

- **CMake** 3.15 or higher
- **C++20** compatible compiler:
  - GCC 8+ (Linux)
  - MSVC 19.29+ / Visual Studio 2019+ (Windows)
  - Clang 10+ (macOS)
- **Git** (for submodule management)

### Build Instructions

#### Linux / macOS
```bash
# Clone repository with submodules
git clone --recursive https://github.com/flarkflarkflark/MatrixFilter.git
cd MatrixFilter

# Configure and build
mkdir build && cd build
cmake ..
cmake --build .

# The plugin binary will be in: MatrixFilter.clap
```

#### Windows
```powershell
# Clone repository with submodules
git clone --recursive https://github.com/flarkflarkflark/MatrixFilter.git
cd MatrixFilter

# Configure and build
mkdir build
cd build
cmake ..
cmake --build . --config Release

# The plugin binary will be in: Release\MatrixFilter.clap
```

### If You Forgot --recursive
```bash
git submodule update --init --recursive
```

## Development

### Project Structure
```
MatrixFilter/
├── src/
│   ├── plugin.cpp              # Main plugin implementation
│   ├── plugin-factory.cpp      # Plugin factory
│   ├── plugin-entry.cpp        # CLAP entry point
│   ├── plugin-extensions.cpp   # Plugin extensions (params, state)
│   ├── dsp.cpp                 # DSP implementation
│   └── gui.cpp                 # GUI implementation (optional)
├── include/
│   ├── plugin.h                # Plugin interface
│   ├── dsp.h                   # DSP interface
│   └── gui.h                   # GUI interface
├── external/
│   └── clap/                   # CLAP SDK (submodule)
├── .github/
│   └── workflows/
│       └── build.yml           # CI/CD configuration
└── CMakeLists.txt              # Build configuration
```

### Architecture

MatrixFilter follows the CLAP plugin specification and implements:

- **Plugin Descriptor**: Metadata and feature declarations
- **Plugin Factory**: Plugin instantiation
- **Audio Processing**: Biquad filter DSP in `process()` callback
- **Parameter Management**: Exposing filter parameters to the host
- **State Management**: Saving/loading plugin state

### Code Quality

The codebase has been extensively reviewed and fixed:
- ✅ All compiler warnings resolved
- ✅ MSVC, GCC, and Clang compatibility
- ✅ Proper C/C++ linkage with `extern "C"`
- ✅ Platform-specific symbol exports
- ✅ Modern C++20 features where appropriate

See [BUGS.md](BUGS.md) for detailed documentation of issues found and fixed.

## CI/CD

Automated builds run on every push via GitHub Actions:
- **Multi-platform builds** (Linux, Windows, macOS)
- **Automated testing** of build process
- **Artifact generation** for easy distribution

View build status: [Actions](https://github.com/flarkflarkflark/MatrixFilter/actions)

## Technical Details

### DSP Implementation
- **Filter Type**: Biquad (2nd order IIR)
- **Processing**: 32-bit floating point
- **Channels**: Stereo (2 channels)
- **Sample Rate**: Adaptive (supports all standard rates)

### CLAP Features
- Audio effect processing
- Stereo input/output
- Parameter automation
- State save/restore
- Thread-safe audio processing

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

### Building and Testing Changes
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on your platform
5. Submit a pull request

The CI/CD pipeline will automatically build and test your changes on all platforms.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **CLAP SDK** - [CLever Audio Plugin API](https://github.com/free-audio/clap)
- **Biquad Filter** - Classic digital filter design

## Links

- [CLAP Specification](https://github.com/free-audio/clap)
- [Issue Tracker](https://github.com/flarkflarkflark/MatrixFilter/issues)
- [Releases](https://github.com/flarkflarkflark/MatrixFilter/releases)

---

**Made with 🎵 for audio developers and musicians**
