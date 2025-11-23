# MatrixFilter - Bug Report & Compilation Errors

## Overview
This document lists all compilation errors found during code review and build testing. The build system has been fixed, but source code issues remain.

## Build System Fixes ✅ (Already Fixed)

1. ✅ **CMakeLists.txt** - Removed incorrect `src/dsp.h` from source files
2. ✅ **CMakeLists.txt** - Added CLAP SDK as submodule instead of using pkg-config
3. ✅ **CMakeLists.txt** - Made OpenGL optional for builds without GUI
4. ✅ **include/plugin.h** - Created header file for plugin interface
5. ✅ **plugin-factory.cpp** - Fixed to include plugin.h instead of plugin.cpp
6. ✅ **include/gui.h** - Added cross-platform OpenGL headers (macOS vs Linux)
7. ✅ **GitHub Actions** - Created multi-platform build workflow

## Source Code Errors ⚠️ (Need Fixes)

### 1. plugin.cpp - Remove #pragma once
**File:** `src/plugin.cpp:1`
**Error:** `warning: #pragma once in main file`
**Fix:** Remove the `#pragma once` directive (only needed in .h files, not .cpp)

```cpp
// DELETE THIS LINE:
#pragma once
```

### 2. plugin.cpp - Invalid CLAP Feature
**File:** `src/plugin.cpp:24`
**Error:** `'CLAP_PLUGIN_FEATURE_DYNAMICS' was not declared`
**Fix:** Use a valid CLAP feature constant

```cpp
// CHANGE FROM:
CLAP_PLUGIN_FEATURE_DYNAMICS,

// CHANGE TO:
CLAP_PLUGIN_FEATURE_FILTER,
// OR:
CLAP_PLUGIN_FEATURE_AUDIO_EFFECT,
```

### 3. plugin.cpp - Invalid logo_url Field
**File:** `src/plugin.cpp:19`
**Error:** `'const clap_plugin_descriptor_t' has no member named 'logo_url'`
**Fix:** Remove the `logo_url` field (not part of CLAP spec)

```cpp
// DELETE THIS LINE:
.logo_url = "https://flark.dev/matrixfilter/logo",
```

### 4. plugin.cpp - Wrong Type Name
**Files:** Multiple locations
**Error:** `'clap_process_status_t' does not name a type`
**Fix:** Change all `clap_process_status_t` to `clap_process_status`

```cpp
// CHANGE FROM:
static clap_process_status_t process(...)
static clap_process_status_t audio_filter_process(...)

// CHANGE TO:
static clap_process_status process(...)
static clap_process_status audio_filter_process(...)
```

### 5. plugin.cpp - Missing activate Function
**File:** `src/plugin.cpp:325`
**Error:** `'audio_filter_activate' was not declared in this scope`
**Fix:** Implement the missing activate function

```cpp
// ADD THIS FUNCTION:
static bool audio_filter_activate(const clap_plugin_t *plugin, double sample_rate) {
    audio_filter_plugin_t *p = (audio_filter_plugin_t *)plugin->plugin_data;
    p->sample_rate = (float)sample_rate;
    filter_set_sample_rate(&p->filter, (float)sample_rate);
    return true;
}
```

### 6. plugin.cpp - Const-Correctness Issues
**File:** `src/plugin.cpp:173, 292, 295`
**Error:** Various const-correctness violations
**Fix:** Remove `const` from plugin parameter in functions that modify state

```cpp
// CHANGE FROM:
static void reset(const audio_filter_plugin_t *plugin)
static void on_main_thread(const audio_filter_plugin_t *plugin)

// CHANGE TO:
static void reset(audio_filter_plugin_t *plugin)
static void on_main_thread(audio_filter_plugin_t *plugin)
```

### 7. plugin.cpp - Invalid host API Call
**File:** `src/plugin.cpp:292-293`
**Error:** `'const clap_host_t' has no member named 'get_sample_rate'`
**Fix:** Remove invalid API call or use correct CLAP host extension

```cpp
// DELETE OR REPLACE THIS CODE:
if (plugin->host && plugin->host->get_sample_rate) {
    double new_sample_rate = plugin->host->get_sample_rate(plugin->host);
    plugin->sample_rate = (float)new_sample_rate;
}
```

### 8. plugin.cpp - Uninitialized Extension Structures
**File:** `src/plugin.cpp:70-76`
**Error:** Multiple uninitialized const structures
**Fix:** These need to be properly initialized with function pointers. Example:

```cpp
// CHANGE FROM:
static const clap_plugin_params_t s_plugin_params;

// CHANGE TO:
static const clap_plugin_params_t s_plugin_params = {
    .count = params_count,
    .get_info = params_get_info,
    .get_value = params_get_value,
    .value_to_text = params_value_to_text,
    .text_to_value = params_text_to_value,
    .flush = params_flush,
};
```

You'll need to implement all these functions. See `plugin-extensions.cpp` for partial implementations.

### 9. gui.h - OpenGL Headers Without Guards
**File:** `include/gui.h:16-17`
**Status:** Partially fixed, but gui.cpp also needs guards
**Fix:** Wrap all OpenGL-related code with `#ifdef HAS_OPENGL`

```cpp
// In gui.cpp, wrap OpenGL functions:
#ifdef HAS_OPENGL
void opengl_init() {
    // ...OpenGL code...
}
#endif
```

### 10. plugin.cpp - Designator Order Error
**File:** `src/plugin.cpp:397`
**Error:** `designator order for field 'clap_param_info::flags' does not match declaration`
**Fix:** Reorder the struct initializers to match the CLAP API declaration order

## Summary

**Total Issues Found:** 10 categories
- **Fixed:** 7 build system issues ✅
- **Remaining:** 10 source code issues ⚠️

## Priority Fixes

To get a successful build, fix in this order:

1. **High Priority:**
   - Remove `#pragma once` from plugin.cpp
   - Fix `CLAP_PLUGIN_FEATURE_DYNAMICS`
   - Remove `logo_url` field
   - Fix `clap_process_status_t` → `clap_process_status`

2. **Medium Priority:**
   - Implement `audio_filter_activate` function
   - Fix const-correctness issues
   - Remove invalid `get_sample_rate` call

3. **Low Priority (but needed for full functionality):**
   - Initialize all plugin extension structures
   - Add OpenGL guards to gui.cpp
   - Fix param_info designator order

## Testing

After fixing these issues, rebuild with:

```bash
rm -rf build
mkdir build && cd build
cmake ..
make -j4
```

## See Also

- GitHub Actions will attempt to build automatically on push
- Check `.github/workflows/build.yml` for CI/CD configuration
- CLAP specification: https://github.com/free-audio/clap
