# MatrixFilter

[![Build Status](https://github.com/flarkflarkflark/MatrixFilter/actions/workflows/build.yml/badge.svg)](https://github.com/flarkflarkflark/MatrixFilter/actions/workflows/build.yml)
[![Latest Release](https://img.shields.io/github/v/release/flarkflarkflark/MatrixFilter)](https://github.com/flarkflarkflark/MatrixFilter/releases/latest)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A high-quality stereo audio filter plugin available in both CLAP and VST3 formats, featuring biquad filter implementation for professional audio processing.

## Features

- 🎚️ **Biquad Filter DSP** - Professional-grade digital filter implementation
- 🎧 **Stereo Processing** - Independent left/right channel filtering
- 🔌 **Dual Plugin Formats** - Available as both CLAP and VST3
- 🖥️ **Cross-Platform** - Builds on Linux, Windows, and macOS
- ⚡ **High Performance** - Optimized C++ implementation
- 🎛️ **Parametric Control** - Adjustable filter parameters via host automation
- 🎼 **7 Filter Types** - Lowpass, Highpass, Bandpass, Notch, Peaking, Low Shelf, High Shelf

## Download

Pre-built binaries are available from the [Releases](https://github.com/flarkflarkflark/MatrixFilter/releases) page.

Download the appropriate package for your platform:
- **Linux**: `MatrixFilter-Linux.zip`
- **Windows**: `MatrixFilter-Windows.zip`
- **macOS**: `MatrixFilter-macOS.zip`

## Installation

### Linux
```bash
# CLAP format
unzip MatrixFilter-Linux-CLAP.zip
mkdir -p ~/.clap
cp MatrixFilter.clap ~/.clap/

# VST3 format
unzip MatrixFilter-Linux-VST3.zip
mkdir -p ~/.vst3
cp -r MatrixFilterVST.vst3 ~/.vst3/
```

### Windows
```powershell
# CLAP format
# Extract MatrixFilter-Windows-CLAP.zip
# Copy MatrixFilter.clap to:
#   - C:\Program Files\Common Files\CLAP\ (system-wide)
#   - %LOCALAPPDATA%\Programs\Common\CLAP\ (user-specific)

# VST3 format
# Extract MatrixFilter-Windows-VST3.zip
# Copy MatrixFilterVST.vst3 to:
#   - C:\Program Files\Common Files\VST3\ (system-wide)
#   - %LOCALAPPDATA%\Programs\Common\VST3\ (user-specific)
```

### macOS
```bash
# CLAP format
unzip MatrixFilter-macOS-CLAP.zip
mkdir -p ~/Library/Audio/Plug-Ins/CLAP
cp -r MatrixFilter.clap ~/Library/Audio/Plug-Ins/CLAP/

# VST3 format
unzip MatrixFilter-macOS-VST3.zip
mkdir -p ~/Library/Audio/Plug-Ins/VST3
cp -r MatrixFilterVST.vst3 ~/Library/Audio/Plug-Ins/VST3/
```

## Usage

1. **Load in your DAW**: MatrixFilter will appear in your plugin list (CLAP or VST3)
2. **Insert on a track**: Add MatrixFilter to any audio track
3. **Adjust parameters**: Control filter type, cutoff, resonance, and gain via automation
4. **Process audio**: The biquad filter will process incoming stereo audio in real-time

### Parameters

- **Filter Type**: Lowpass, Highpass, Bandpass, Notch, Peaking, Low Shelf, High Shelf
- **Cutoff Frequency**: 20Hz - 20kHz (logarithmic scale)
- **Resonance (Q)**: 0.1 - 10.0
- **Gain**: -24dB to +24dB (for shelf and peaking filters)

### Compatible DAWs

**CLAP Format:**
- Bitwig Studio 4.0+
- Reaper 6.68+
- MultitrackStudio
- And other CLAP-compatible hosts

**VST3 Format:**
- Ableton Live 11+
- Cubase/Nuendo
- FL Studio 21+
- Logic Pro (with VST3 support)
- Reaper
- Studio One
- And most modern DAWs

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
