# MatrixFilter Naming Verification Checklist

Use this checklist to ensure all naming has been corrected.

## Root Directory Files

- [ ] `README.md`
  - [ ] Title and headers
  - [ ] Plugin name references
  - [ ] File paths and directory names
  - [ ] Example commands

- [ ] `README-SUITE.md`
  - [ ] All plugin name references
  - [ ] Documentation links

- [ ] `FORMATS.md`
  - [ ] Plugin names in examples
  - [ ] File paths

- [ ] `QUICKSTART.md`
  - [ ] Quick start guide references
  - [ ] Command examples

- [ ] `CMakeLists.txt` (if exists)
  - [ ] `project(` name
  - [ ] `set(PLUGIN_NAME ...)` or similar
  - [ ] Target names
  - [ ] Output filenames

- [ ] `.gitignore`
  - [ ] Check for any hardcoded plugin names

## Build Scripts

- [ ] `build-all.sh`
  - [ ] Comments
  - [ ] Output messages
  - [ ] Directory names

- [ ] `build-clap.sh`
  - [ ] Script headers/comments
  - [ ] Build output names
  - [ ] Installation paths

- [ ] `build-vst3.sh`
  - [ ] Script headers/comments
  - [ ] Build output names
  - [ ] Installation paths

- [ ] `build-lv2.sh`
  - [ ] Script headers/comments
  - [ ] Build output names
  - [ ] Installation paths

- [ ] `build-linux.sh`
  - [ ] All plugin references

- [ ] `build-windows.bat`
  - [ ] All plugin references
  - [ ] Output paths

- [ ] `build-macos.sh`
  - [ ] All plugin references

## Source Code (`src/` directory)

- [ ] All `.cpp` files
  - [ ] Class names
  - [ ] Namespace declarations
  - [ ] String literals (plugin display names)
  - [ ] Comments and documentation
  - [ ] Debug messages
  - [ ] Error messages

- [ ] All `.c` files
  - [ ] Function names
  - [ ] String literals
  - [ ] Comments

## Headers (`include/` directory)

- [ ] All `.h` files
  - [ ] Include guards (e.g., `#ifndef MATRIX_FILTER_H`)
  - [ ] Class declarations
  - [ ] Namespace declarations
  - [ ] Comments
  - [ ] Constants/defines

- [ ] All `.hpp` files
  - [ ] Same as `.h` files

## CLAP Plugin (`clap/` directory)

- [ ] `clap/CMakeLists.txt`
  - [ ] Project name
  - [ ] Target names
  - [ ] Output filename
  - [ ] Installation paths

- [ ] CLAP plugin descriptor files
  - [ ] Plugin ID (⚠️ DON'T change if already published!)
  - [ ] Plugin name (display name - safe to change)
  - [ ] Plugin description
  - [ ] Vendor/author info
  - [ ] Feature tags

- [ ] Source files in `clap/src/`
  - [ ] All class names
  - [ ] String literals

- [ ] Headers in `clap/include/`
  - [ ] Include guards
  - [ ] Class names

## VST3 Plugin (`vst3/` directory)

- [ ] `vst3/CMakeLists.txt`
  - [ ] Project name
  - [ ] Target names
  - [ ] VST3 category
  - [ ] Output filename

- [ ] VST3 descriptor/factory files
  - [ ] Plugin UID (⚠️ DON'T change if already published!)
  - [ ] Controller UID (⚠️ DON'T change if already published!)
  - [ ] Plugin name (display name - safe to change)
  - [ ] Vendor string
  - [ ] Category string

- [ ] Source files in `vst3/src/`
  - [ ] Class names (should match UID, be careful)
  - [ ] String literals

- [ ] Headers in `vst3/include/`
  - [ ] Include guards
  - [ ] Class names

- [ ] `resource/` directory (if exists)
  - [ ] Info.plist (macOS)
  - [ ] Plugin name
  - [ ] Bundle identifier

## LV2 Plugin (`lv2/` directory)

- [ ] `lv2/CMakeLists.txt`
  - [ ] Project name
  - [ ] Target names
  - [ ] LV2 URI
  - [ ] Output filename

- [ ] `manifest.ttl`
  - [ ] Plugin URI (⚠️ DON'T change if already published!)
  - [ ] Plugin name (display name - safe to change)
  - [ ] Binary filename

- [ ] `plugin.ttl` or similar
  - [ ] Plugin URI
  - [ ] Plugin name
  - [ ] Plugin description
  - [ ] Port names

- [ ] Source files in `lv2/src/`
  - [ ] LV2 descriptor
  - [ ] Plugin URI references
  - [ ] String literals

- [ ] Headers in `lv2/include/`
  - [ ] Include guards
  - [ ] URI definitions

## Documentation

- [ ] `docs/` directory (if exists)
  - [ ] All markdown files
  - [ ] User guides
  - [ ] Developer docs

- [ ] `LICENSE` file
  - [ ] Project name in copyright notice

- [ ] `CONTRIBUTING.md` (if exists)
  - [ ] Project references

## GitHub Specific

- [ ] `.github/workflows/`
  - [ ] Workflow names
  - [ ] Artifact names
  - [ ] Build output paths

- [ ] `.github/ISSUE_TEMPLATE/` (if exists)
  - [ ] Plugin name references

- [ ] `.github/PULL_REQUEST_TEMPLATE.md` (if exists)
  - [ ] Plugin name references

## Special Cases to Watch For

### Plugin IDs (⚠️ CRITICAL)

These should ONLY be changed if the plugin has never been distributed:

- [ ] VST3 Processor UID
- [ ] VST3 Controller UID  
- [ ] CLAP plugin ID
- [ ] LV2 plugin URI

**If already published:** Keep IDs the same, only change display names!

### Include Guards

Old format: `#ifndef MATRIX_FILTER_H`
New format: `#ifndef MATRIX_FILTER_H`

Make sure to update all three occurrences:
```cpp
#ifndef MATRIX_FILTER_H    // Change here
#define MATRIX_FILTER_H    // And here
...
#endif // MATRIX_FILTER_H  // And here
```

### Namespaces

Old: `namespace MatrixFilter { ... }`
New: `namespace MatrixFilter { ... }`

Check all:
- [ ] Namespace declarations
- [ ] Namespace usages (`MatrixFilter::SomeClass`)
- [ ] Using statements (`using namespace MatrixFilter;`)

### CMake Targets

Make sure target names are consistent:
```cmake
add_library(MatrixFilter ...)        # Should all match
set_target_properties(MatrixFilter ...) 
install(TARGETS MatrixFilter ...)
```

### File Paths in Code

If code references file paths, update them:
```cpp
// Old
"~/.lv2/MatrixFilter.lv2"
// New  
"~/.lv2/MatrixFilter.lv2"
```

## Testing After Changes

- [ ] Build CLAP version
  - [ ] Loads in DAW
  - [ ] Displays correct name
  - [ ] Parameters work

- [ ] Build VST3 version
  - [ ] Loads in DAW
  - [ ] Displays correct name
  - [ ] Parameters work

- [ ] Build LV2 version
  - [ ] Loads in DAW/host
  - [ ] Displays correct name
  - [ ] Parameters work

- [ ] Test on each platform
  - [ ] Linux build works
  - [ ] Windows build works
  - [ ] macOS build works

## Git Verification

Before committing:

```bash
# Check what will be committed
git diff

# Look for any remaining "filter" references
git diff | grep -i filter

# Check all tracked files
git ls-files | xargs grep -l -i "filter"
```

## Final Verification Commands

Run these to catch any stragglers:

```bash
# Find in all files
grep -r -i "filter" . --exclude-dir={.git,build*,external}

# Find in C++ files only
find . -name "*.cpp" -o -name "*.h" -o -name "*.hpp" | xargs grep -i "filter"

# Find in CMake files
find . -name "CMakeLists.txt" | xargs grep -i "filter"

# Find in scripts
find . -name "*.sh" -o -name "*.bat" | xargs grep -i "filter"
```

## Completion

Once all items are checked:

- [ ] All builds complete successfully
- [ ] Plugins load in test DAW
- [ ] No "filter" references found (except in this checklist!)
- [ ] GitHub Actions build passes
- [ ] Documentation updated
- [ ] Ready to commit and push

---

**Date completed:** ________________

**Verified by:** ________________

**Notes:**
