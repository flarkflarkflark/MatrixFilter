# MatrixFilter Repository Fix Guide

This guide will help you fix all naming issues and set up GitHub Actions for automated builds.

## Step 1: Fix Naming Issues

### Option A: Automated Fix (Recommended)

1. Copy `fix_naming.sh` to the root of your MatrixFilter repository
2. Make it executable:
   ```bash
   chmod +x fix_naming.sh
   ```
3. Run the script:
   ```bash
   ./fix_naming.sh
   ```
4. Choose option 1 to preview changes
5. Choose option 2 to apply the fixes
6. Review the changes with `git diff`
7. If everything looks good, choose option 4 to clean up backup files

### Option B: Manual Fix

Search for these patterns and replace them:

| Find | Replace |
|------|---------|
| `MatrixFlanger` | `MatrixFilter` |
| `MATRIXFLANGER` | `MATRIXFILTER` |
| `MATRIX_FLANGER` | `MATRIX_FILTER` |
| `matrix-flanger` | `matrix-filter` |
| `matrix_flanger` | `matrix_filter` |
| `matrixflanger` | `matrixfilter` |
| `Flanger` | `Filter` |
| `FLANGER` | `FILTER` |
| `flanger` | `filter` |

### Files to Check Manually

Pay special attention to:
- Plugin IDs/GUIDs (should be unique, don't change if already published)
- CMakeLists.txt (project names)
- Package.json or similar config files
- Documentation files
- Build scripts

## Step 2: Set Up GitHub Actions

1. Create the directory structure:
   ```bash
   mkdir -p .github/workflows
   ```

2. Copy the workflow file:
   ```bash
   cp github-workflows-build.yml .github/workflows/build.yml
   ```

3. Commit and push:
   ```bash
   git add .github/workflows/build.yml
   git commit -m "Add GitHub Actions CI/CD workflow"
   git push
   ```

## Step 3: Verify Everything Works

1. Check the Actions tab on GitHub: `https://github.com/flarkflarkflark/MatrixFilter/actions`
2. The build should start automatically
3. You'll see builds for:
   - Linux (CLAP, VST3, LV2)
   - Windows (CLAP, VST3, LV2)
   - macOS (CLAP, VST3, LV2)

## Step 4: Download Build Artifacts

After the builds complete:
1. Go to the Actions tab
2. Click on the latest workflow run
3. Scroll down to "Artifacts"
4. Download the builds for your platform

## Optional: Create a Release

To create a release with automatic builds:

1. Create and push a tag:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. GitHub Actions will automatically:
   - Build for all platforms
   - Create a GitHub release
   - Attach all build artifacts

## Troubleshooting

### Build Fails on GitHub Actions

**Missing SDKs:**
- The workflow automatically downloads CLAP and VST3 SDKs
- If builds fail, check the SDK URLs are still valid

**Build Script Not Found:**
- Ensure `build-clap.sh`, `build-vst3.sh`, `build-lv2.sh` exist
- Make sure they're marked as executable in git:
  ```bash
  git add --chmod=+x build-*.sh
  ```

**Dependencies Missing:**
- Check the workflow's dependency installation section
- Add any missing libraries to the install steps

### Naming Issues Persist

1. Run: `grep -r -i "flanger" . --exclude-dir=.git`
2. Manually review each occurrence
3. Some might be intentional (e.g., in comments about different plugins)

## Next Steps

After fixing MatrixFilter, you can:
1. Apply the same process to MatrixFlanger (if it should actually be a flanger effect)
2. Create unique plugin IDs for each
3. Differentiate the plugins' DSP algorithms
4. Update documentation to reflect differences

## Files Included

- `fix_naming.sh` - Automated naming fix script
- `github-workflows-build.yml` - GitHub Actions workflow
- `INSTRUCTIONS.md` - This file

## Important Notes

⚠️ **Before applying fixes:**
- Make sure you have committed all current work
- The fix script creates .bak backups, but use git as your primary backup

⚠️ **Plugin IDs:**
- If your plugins are already published/distributed, DO NOT change:
  - VST3 GUIDs
  - CLAP IDs  
  - LV2 URIs
- Only change display names and code references

⚠️ **Test After Changes:**
- Build locally after applying naming fixes
- Test in a DAW before pushing to production
- Verify all three formats (CLAP, VST3, LV2) work correctly
