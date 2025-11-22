# CLAUDE.md - AI Assistant Guide for MatrixFilter

> **Last Updated**: 2025-11-22
> **Project**: MatrixFilter - Multi-format Audio Filter Plugin
> **Version**: 1.0.0
> **Repository**: flarkflarkflark/MatrixFilter

---

## Table of Contents

1. [Repository Overview](#repository-overview)
2. [Project Architecture](#project-architecture)
3. [Directory Structure](#directory-structure)
4. [Plugin Formats](#plugin-formats)
5. [Build System](#build-system)
6. [Development Workflow](#development-workflow)
7. [Code Conventions](#code-conventions)
8. [Key Files Reference](#key-files-reference)
9. [Testing & Validation](#testing--validation)
10. [Git Workflow](#git-workflow)
11. [AI Assistant Guidelines](#ai-assistant-guidelines)

---

## Repository Overview

### Purpose
MatrixFilter is a professional audio filter plugin that supports multiple plugin formats (CLAP, VST3, LV2) across multiple platforms (Linux, Windows, macOS). It features:
- 7 filter types: Low-pass, High-pass, Band-pass, Notch, Peaking, Low-shelf, High-shelf
- Real-time Matrix-style visual effects using OpenGL
- Professional biquad filter implementation
- Cross-platform audio processing with zero latency

### Technology Stack
- **Languages**: C (C11), C++ (C++17)
- **Build System**: CMake 3.17+
- **Graphics**: OpenGL 3.0+
- **Plugin Formats**: CLAP, VST3, LV2
- **Platforms**: Linux, Windows (MSVC), macOS

### Project Status
- ✅ Core DSP implementation complete
- ✅ CLAP format implemented
- ✅ VST3 format implemented
- ✅ LV2 format implemented
- ✅ Cross-platform build scripts
- ✅ OpenGL visualization complete
- ⚠️ GitHub Actions CI/CD not yet configured

---

## Project Architecture

### Component Overview

```
┌─────────────────────────────────────────────────┐
│            Plugin Host (DAW)                    │
└─────────────────────────────────────────────────┘
                      │
         ┌────────────┴────────────┐
         │                         │
    ┌────▼─────┐           ┌──────▼──────┐
    │   CLAP   │           │  VST3/LV2   │
    │  Entry   │           │    Entry    │
    └────┬─────┘           └──────┬──────┘
         │                        │
         └────────────┬───────────┘
                      │
         ┌────────────▼────────────┐
         │   Plugin Core Logic     │
         │   (plugin.cpp)          │
         └────────┬────────────────┘
                  │
         ┌────────┴────────┐
         │                 │
    ┌────▼─────┐    ┌─────▼──────┐
    │   DSP    │    │    GUI     │
    │ Engine   │    │  Renderer  │
    │(dsp.cpp) │    │ (gui.cpp)  │
    └──────────┘    └────────────┘
```

### Core Components

1. **DSP Engine** (`src/dsp.cpp`, `include/dsp.h`)
   - Biquad filter implementation
   - Filter coefficient calculation
   - Audio processing (sample and block)
   - Frequency response calculation

2. **Plugin Core** (`src/plugin.cpp`)
   - CLAP plugin descriptor and lifecycle
   - Parameter management
   - State management
   - Audio routing

3. **GUI Renderer** (`src/gui.cpp`, `include/gui.h`)
   - OpenGL-based matrix visualization
   - Real-time spectrum analysis
   - Audio-responsive graphics

4. **Plugin Extensions** (`src/plugin-extensions.cpp`)
   - CLAP parameter extension
   - CLAP state extension
   - CLAP audio ports extension
   - CLAP latency extension

5. **Format-Specific Implementations**
   - **CLAP**: `src/plugin-*.cpp` (primary implementation)
   - **VST3**: `vst3/*.cpp` (VST3 adapter layer)
   - **LV2**: `lv2/*.cpp` (LV2 adapter layer)

---

## Directory Structure

```
MatrixFilter/
├── 📄 CMakeLists.txt           # Root CMake configuration (CLAP build)
├── 📄 README.md                # User-facing documentation
├── 📄 QUICKSTART.md            # Quick start guide
├── 📄 FORMATS.md               # Plugin format comparison
├── 📄 NAMING_CHECKLIST.md      # Naming consistency checklist
├── 📄 PACKAGE_SUMMARY.md       # Package overview
├── 📄 INSTRUCTIONS.md          # Detailed setup instructions
├── 📄 START_HERE.txt           # Initial orientation file
│
├── 🔧 build-all.sh             # Universal build script (all formats)
├── 🔧 build-linux.sh           # Linux CLAP build
├── 🔧 build-windows.bat        # Windows CLAP build
├── 🔧 build-macos.sh           # macOS CLAP build
├── 🔧 build-clap.sh            # CLAP-specific build
├── 🔧 build-vst3.sh            # VST3-specific build
├── 🔧 build-lv2.sh             # LV2-specific build
├── 🔧 validate.sh              # Plugin validation script
├── 🔧 fix_all.sh               # Automated naming fix script
├── 🔧 fix_naming.sh            # Manual naming fix script
│
├── 📁 src/                     # Primary source code (CLAP)
│   ├── dsp.cpp                 # DSP implementation
│   ├── dsp.h                   # DSP header (internal)
│   ├── gui.cpp                 # GUI implementation
│   ├── gui.h                   # GUI header (internal)
│   ├── plugin.cpp              # Main plugin logic
│   ├── plugin-extensions.cpp   # CLAP extensions
│   ├── plugin-factory.cpp      # Plugin factory
│   ├── plugin-entry.cpp        # CLAP entry point
│   ├── gui-extension.cpp       # GUI extension
│   ├── symbols.map             # Linux symbol exports
│   └── symbols-windows.txt     # Windows symbol exports
│
├── 📁 include/                 # Public headers
│   ├── dsp.h                   # DSP public interface
│   └── gui.h                   # GUI public interface
│
├── 📁 vst3/                    # VST3 implementation
│   ├── CMakeLists.txt          # VST3 build configuration
│   ├── plugin.cpp              # VST3 plugin wrapper
│   ├── processor.cpp           # VST3 processor
│   ├── controller.cpp          # VST3 controller
│   ├── editcontroller.cpp      # VST3 edit controller
│   ├── vst3plugin.cpp          # VST3 plugin class
│   ├── vst3processor.cpp       # VST3 processor class
│   └── vst3controller.cpp      # VST3 controller class
│
├── 📁 lv2/                     # LV2 implementation
│   ├── CMakeLists.txt          # LV2 build configuration
│   ├── matrixfilter-lv2.cpp    # LV2 plugin implementation
│   ├── matrixfilter-ui-lv2.cpp # LV2 UI implementation
│   ├── manifest.ttl            # LV2 manifest
│   ├── flark-matrixfilter.ttl  # LV2 plugin descriptor
│   └── flark-matrixfilter-ui.ttl # LV2 UI descriptor
│
├── 📁 releases/                # Release notes
│   └── v1.0.0.md               # Version 1.0.0 release notes
│
├── 📁 imgs/                    # Images and assets
│
└── 📄 build.yml                # GitHub Actions workflow (not yet deployed)
```

---

## Plugin Formats

### CLAP (Primary Format)
- **ID**: `com.flark.matrixfilter`
- **Name**: `flark's MatrixFilter`
- **Entry Point**: `src/plugin-entry.cpp`
- **Build Output**: `build/linux/install/MatrixFilter/flark-MatrixFilter.clap`
- **Features**: Modern, open-source, low-latency
- **Extensions**: params, state, latency, audio-ports, gui

### VST3 (Industry Standard)
- **Bundle ID**: `com.flark.matrixfilter.vst3`
- **Name**: `flark-MatrixFilter`
- **Entry Point**: `vst3/vst3plugin.cpp`
- **Build Output**: `flark-MatrixFilter.vst3` (bundle)
- **Features**: Maximum DAW compatibility
- **Architecture**: Component/Controller model

### LV2 (Linux-focused)
- **URI**: `http://flark.dev/plugins/matrixfilter`
- **Name**: `flark's MatrixFilter`
- **Entry Point**: `lv2/matrixfilter-lv2.cpp`
- **Build Output**: `flark-matrixfilter.lv2/` (bundle directory)
- **Features**: Open-source, flexible, Linux-native
- **Components**: Plugin DSP + separate UI module

---

## Build System

### CMake Structure

The project uses a **multi-configuration CMake build system**:

1. **Root CMakeLists.txt**: Builds CLAP format
2. **vst3/CMakeLists.txt**: Builds VST3 format (independent)
3. **lv2/CMakeLists.txt**: Builds LV2 format (independent)

### Build Scripts

| Script | Purpose | Platform | Output |
|--------|---------|----------|--------|
| `build-all.sh` | Builds all formats | Linux/macOS | All plugin formats |
| `build-linux.sh` | Quick CLAP build | Linux | CLAP only |
| `build-windows.bat` | Quick CLAP build | Windows | CLAP only |
| `build-macos.sh` | Quick CLAP build | macOS | CLAP only |
| `build-clap.sh` | CLAP format only | Linux/macOS | CLAP |
| `build-vst3.sh` | VST3 format only | Linux/macOS | VST3 |
| `build-lv2.sh` | LV2 format only | Linux/macOS | LV2 |

### Platform-Specific Considerations

#### Linux
- Uses `.map` file for symbol exports
- Links against: `libclap`, `pthread`, `OpenGL`, `m`
- Output extension: `.clap`

#### Windows
- Uses `.txt` DEF file for symbol exports
- Visual Studio 2019+ required
- Output extension: `.clap`

#### macOS
- Uses exported symbols list
- Creates bundles for VST3/LV2
- Bundle identifier: `com.flark.matrixfilter`

### Dependencies

**Required**:
- CMake 3.17+
- C11/C++17 compiler
- pkg-config
- CLAP SDK (for CLAP builds)
- VST3 SDK (for VST3 builds)
- LV2 SDK (for LV2 builds)

**Platform Libraries**:
- OpenGL (3.0+)
- pthread (Linux/macOS)
- Math library (`m`)

---

## Development Workflow

### Making Code Changes

1. **DSP Changes** → Edit `src/dsp.cpp` and `include/dsp.h`
   - All format builds will pick up changes automatically
   - DSP code is shared across all formats

2. **GUI Changes** → Edit `src/gui.cpp` and `include/gui.h`
   - OpenGL rendering logic
   - Shared across all formats

3. **CLAP-Specific** → Edit files in `src/`
   - Primary implementation
   - Other formats wrap this implementation

4. **VST3-Specific** → Edit files in `vst3/`
   - VST3 adapter layer only
   - Core logic should remain in `src/`

5. **LV2-Specific** → Edit files in `lv2/`
   - LV2 adapter layer only
   - Core logic should remain in `src/`

### Build Workflow

```bash
# Quick iteration (CLAP only)
./build-linux.sh

# Full build (all formats)
./build-all.sh

# Specific format
./build-vst3.sh
./build-lv2.sh

# Manual CMake
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .
```

### Testing Workflow

```bash
# Validate plugin
./validate.sh

# Test in DAW
cp build/linux/install/MatrixFilter/flark-MatrixFilter.clap ~/.clap/
# Launch DAW and test

# Check for naming issues
./fix_naming.sh --check
```

---

## Code Conventions

### Naming Conventions

#### Variables and Functions
```c
// C code (dsp.h, dsp.cpp)
filter_type_t type;          // lowercase_with_underscores
void filter_init(...);       // function_name_with_underscores
float cutoff_freq;           // descriptive names

// C++ code (plugin.cpp)
audio_filter_plugin_t *plugin;   // struct/type names with _t suffix
const clap_plugin_t *plugin;     // CLAP types follow CLAP conventions
```

#### Constants and Enums
```c
// Enums
typedef enum {
    FILTER_TYPE_LOWPASS = 0,     // UPPERCASE_WITH_UNDERSCORES
    FILTER_TYPE_HIGHPASS = 1,
    // ...
} filter_type_t;

// Parameter IDs
enum {
    PARAM_CUTOFF = 0,            // UPPERCASE
    PARAM_RESONANCE = 1,
    // ...
};
```

#### File Names
- Headers: `dsp.h`, `gui.h` (lowercase, descriptive)
- Implementation: `dsp.cpp`, `plugin-extensions.cpp` (lowercase, hyphenated)
- Build scripts: `build-linux.sh` (lowercase, hyphenated)

### Code Style

**Indentation**: 4 spaces (no tabs)

**Braces**: K&R style
```c
void function(int param) {
    if (condition) {
        // code
    } else {
        // code
    }
}
```

**Include Guards**: `#pragma once` (modern style)

**Comments**:
```c
// Single-line comments for brief explanations

/* Multi-line comments for
   longer explanations and
   documentation */
```

### Plugin-Specific Conventions

#### Plugin IDs (⚠️ CRITICAL - DO NOT CHANGE)
Once published, these must remain constant:
- CLAP: `"com.flark.matrixfilter"`
- VST3 GUIDs: (in VST3 source files)
- LV2 URI: `http://flark.dev/plugins/matrixfilter`

#### Display Names (✅ Safe to Change)
- CLAP: `"flark's MatrixFilter"`
- VST3: `"flark-MatrixFilter"`
- LV2: `"flark's MatrixFilter"`

---

## Key Files Reference

### Critical Files (DO NOT DELETE)

| File | Purpose | Notes |
|------|---------|-------|
| `src/plugin.cpp` | Main plugin descriptor | Contains plugin ID - DO NOT CHANGE |
| `src/dsp.cpp` | DSP implementation | Core audio processing |
| `include/dsp.h` | DSP public API | Used by all formats |
| `CMakeLists.txt` | Build configuration | Root build file |
| `src/symbols.map` | Linux exports | Required for Linux builds |
| `src/symbols-windows.txt` | Windows exports | Required for Windows builds |

### Documentation Files

| File | Audience | Purpose |
|------|----------|---------|
| `README.md` | End users | Quick start, features |
| `QUICKSTART.md` | Developers | Development guide |
| `FORMATS.md` | Users/Devs | Format comparison |
| `NAMING_CHECKLIST.md` | Developers | Naming consistency |
| `INSTRUCTIONS.md` | Setup | Detailed setup steps |
| `CLAUDE.md` | AI Assistants | **This file** - comprehensive guide |

### Build Artifacts (Git Ignored)

```
build/           # All build outputs
*.o              # Object files
*.so             # Linux shared libraries
*.dll            # Windows libraries
*.clap           # CLAP plugins (built)
*.vst3/          # VST3 bundles (built)
*.lv2/           # LV2 bundles (built)
```

---

## Testing & Validation

### Manual Testing

1. **Build Validation**
   ```bash
   ./build-linux.sh && echo "Build successful"
   ```

2. **Plugin Loading**
   - Copy to plugin directory
   - Load in CLAP-compatible DAW
   - Verify plugin appears in list

3. **Audio Testing**
   - Create audio track
   - Add MatrixFilter
   - Test each filter type
   - Verify audio processing works

4. **GUI Testing**
   - Open plugin GUI
   - Verify matrix visualization appears
   - Check that visuals respond to audio
   - Test parameter changes

### Automated Checks

**Naming Consistency**:
```bash
./fix_naming.sh --check
# or
grep -r -i "flanger" . --exclude-dir={.git,build*}
```

**Symbol Exports**:
```bash
nm -D build/linux/install/MatrixFilter/flark-MatrixFilter.clap | grep clap_entry
```

**Dependencies**:
```bash
ldd build/linux/install/MatrixFilter/flark-MatrixFilter.clap
```

---

## Git Workflow

### Branch Strategy

**Main Branch**: `main` (or unspecified default)
- Stable, production-ready code
- All releases tagged from main

**Feature Branches**: `claude/claude-md-*`
- Created by AI assistants for tasks
- Follow naming: `claude/claude-md-{session-id}`
- Must be pushed to matching branch name

### Commit Conventions

**Format**:
```
<type>: <brief description>

[optional detailed explanation]
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `build`: Build system changes
- `refactor`: Code refactoring
- `test`: Test additions/changes

**Examples**:
```
feat: Add high-shelf filter type
fix: Correct resonance calculation for bandpass filter
docs: Update QUICKSTART with macOS build instructions
build: Add GitHub Actions CI workflow
```

### Git Operations

**Push Requirements**:
- Always use: `git push -u origin <branch-name>`
- Branch must start with `claude/` for AI-created branches
- Branch must end with matching session ID
- Retry up to 4 times with exponential backoff on network errors

**Commit Workflow**:
1. Stage changes: `git add <files>`
2. Commit with message: `git commit -m "message"`
3. Push to branch: `git push -u origin <branch-name>`

---

## AI Assistant Guidelines

### General Principles

1. **Read Before Modifying**
   - Always read a file before editing it
   - Understand existing patterns before making changes
   - Check related files for context

2. **Minimal Changes**
   - Only change what's necessary for the task
   - Avoid refactoring unrelated code
   - Don't add unnecessary features

3. **Consistency**
   - Follow existing naming conventions
   - Match the style of surrounding code
   - Use same patterns as existing code

4. **Testing**
   - Build after making changes
   - Test in a DAW if possible
   - Run validation scripts

### Common Tasks

#### Adding a New Filter Type

1. Update `include/dsp.h`:
   - Add enum value to `filter_type_t`

2. Update `src/dsp.cpp`:
   - Add coefficient calculation in `filter_set_parameters()`
   - Add case in switch statements

3. Update `src/plugin.cpp`:
   - Update parameter max value
   - Update parameter text display

4. Build and test:
   ```bash
   ./build-linux.sh
   # Test in DAW
   ```

#### Modifying Build Configuration

1. **CLAP**: Edit root `CMakeLists.txt`
2. **VST3**: Edit `vst3/CMakeLists.txt`
3. **LV2**: Edit `lv2/CMakeLists.txt`
4. **All formats**: Edit `build-all.sh`

Test all platforms if possible:
```bash
./build-all.sh
```

#### Updating Documentation

1. **User docs**: Update `README.md` or `QUICKSTART.md`
2. **Developer docs**: Update this file (`CLAUDE.md`)
3. **Format info**: Update `FORMATS.md`
4. Commit with `docs:` prefix

#### Fixing Naming Issues

Use the automated script:
```bash
./fix_all.sh
```

Or manually:
```bash
./fix_naming.sh
git add -A
git commit -m "fix: Correct naming inconsistencies"
```

### What NOT to Change

❌ **Plugin IDs** (breaks existing installations):
- CLAP: `com.flark.matrixfilter`
- VST3: GUIDs in source
- LV2: URIs in `.ttl` files

❌ **Core DSP Logic** (without thorough testing):
- Filter coefficients
- Sample processing
- Audio routing

❌ **Symbol Exports** (breaks plugin loading):
- `src/symbols.map`
- `src/symbols-windows.txt`

✅ **Safe to Change**:
- Display names
- Documentation
- Build scripts (carefully)
- GUI appearance
- Comments

### Creating Pull Requests

When creating a PR:

1. Analyze changes from branch divergence:
   ```bash
   git log main..HEAD
   git diff main...HEAD
   ```

2. Write comprehensive PR description:
   - Summary of changes (2-3 bullet points)
   - Test plan (how to verify)
   - Related issues (if any)

3. Use format:
   ```bash
   gh pr create --title "descriptive title" --body "$(cat <<'EOF'
   ## Summary
   - Change 1
   - Change 2

   ## Test plan
   - [ ] Built on Linux
   - [ ] Tested in Bitwig Studio
   - [ ] Verified all filter types
   EOF
   )"
   ```

### File Operations

**Reading Files**:
- Use `Read` tool for specific files
- Use `Grep` for searching content
- Use `Glob` for finding files by pattern

**Editing Files**:
- Use `Edit` for targeted changes
- Preserve exact indentation
- Match existing line endings

**Writing Files**:
- Only write new files when absolutely necessary
- Prefer editing existing files
- Don't create documentation files unless requested

### Common Patterns

**Searching for Definitions**:
```bash
# Find filter type usage
Grep: pattern="FILTER_TYPE_" output_mode="content"

# Find all DSP functions
Grep: pattern="^[a-z_]+\(" path="src/dsp.cpp"
```

**Reading Related Files**:
```bash
# When modifying DSP, read both header and implementation
Read: src/dsp.cpp
Read: include/dsp.h
```

**Testing Builds**:
```bash
Bash: ./build-linux.sh
# Check output for errors
```

---

## Quick Reference

### Project Identity
- **Name**: MatrixFilter (not MatrixFlanger!)
- **Vendor**: flark
- **Version**: 1.0.0
- **Formats**: CLAP, VST3, LV2

### Key Parameters
- Cutoff Frequency: 20-20000 Hz
- Resonance (Q): 0.1-10.0
- Gain: -60 to +60 dB
- Filter Type: 0-6 (7 types)
- Enabled: 0-1 (bool)

### Build Outputs
- **Linux**: `build/linux/install/MatrixFilter/flark-MatrixFilter.clap`
- **Windows**: `build\windows\install\MatrixFilter\flark-MatrixFilter.clap`
- **macOS**: `build/macos/install/MatrixFilter/flark-MatrixFilter.clap`

### Quick Commands
```bash
# Build
./build-linux.sh

# Validate
./validate.sh

# Check naming
grep -r -i "flanger" . --exclude-dir=.git

# Test load
cp build/*/install/MatrixFilter/*.clap ~/.clap/

# Git status
git status
git log --oneline -5
```

---

## Conclusion

This guide provides comprehensive information for AI assistants working on the MatrixFilter project. When in doubt:

1. **Read existing code** for patterns
2. **Follow conventions** established in codebase
3. **Test changes** before committing
4. **Ask questions** when requirements are unclear
5. **Keep changes minimal** and focused

The codebase is well-structured with clear separation of concerns. Respect the existing architecture and maintain consistency with established patterns.

---

**Document Maintenance**: Update this file when:
- Project structure changes significantly
- New plugin formats are added
- Build system is modified
- New conventions are established
- CI/CD is configured

**Last Review**: 2025-11-22
