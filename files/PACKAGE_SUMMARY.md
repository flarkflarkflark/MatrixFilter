# MatrixFilter Fix Package - Complete Package

## 📦 What You Got

This package contains everything you need to fix your MatrixFilter repository and set up automated builds on GitHub.

## 🚀 Quick Start (Recommended)

**The easiest way - just one command:**

1. Copy `fix_all.sh` to your MatrixFilter repository root
2. Run:
   ```bash
   cd /path/to/MatrixFilter
   ./fix_all.sh
   ```
3. Follow the prompts - that's it!

The script will fix all naming issues, set up GitHub Actions, commit, and push automatically.

## 📁 Files Included

### Main Script (Use This!)
- **`fix_all.sh`** ⭐ - ONE script that does everything automatically
  - Fixes all Filter → Filter naming
  - Sets up GitHub Actions workflows
  - Commits and pushes changes
  - Interactive with confirmations

### Documentation
- **`README.md`** - Quick start guide (read this first!)
- **`INSTRUCTIONS.md`** - Detailed manual instructions if you prefer step-by-step
- **`NAMING_CHECKLIST.md`** - Comprehensive checklist of everything to fix

### Alternative Scripts (Optional)
- **`fix_naming.sh`** - Just fixes naming (no git operations)
- **`build.yml`** - Full GitHub Actions workflow (copy to `.github/workflows/`)
- **`quick-check.yml`** - Lightweight CI check workflow (optional)

## 🎯 What Gets Fixed

### Naming Issues
All variations of "Filter" will be replaced with "Filter":
- `MatrixFilter` → `MatrixFilter`
- `MATRIXFILTER` → `MATRIXFILTER`
- `matrix-filter` → `matrix-filter`
- `filter` → `filter`
- And more...

### Files Affected
- Source code (`.cpp`, `.h`, `.hpp`)
- Build scripts (`.sh`, `.bat`)
- CMake files
- Documentation
- README files
- Plugin descriptors (CLAP, VST3, LV2)

### GitHub Actions Setup
- Automated builds for Linux, Windows, macOS
- All formats: CLAP, VST3, LV2
- Artifact uploads
- Automatic releases on tags

## 📋 Step-by-Step Usage

### Option 1: Automatic (Recommended) 🚀

```bash
# 1. Copy fix_all.sh to your repo
cp fix_all.sh /path/to/MatrixFilter/

# 2. Go to your repo
cd /path/to/MatrixFilter

# 3. Run it
./fix_all.sh
```

Done! The script handles everything.

### Option 2: Manual

If you prefer to do things step by step:

1. **Fix naming:**
   ```bash
   cp fix_naming.sh /path/to/MatrixFilter/
   cd /path/to/MatrixFilter
   ./fix_naming.sh
   ```

2. **Set up GitHub Actions:**
   ```bash
   mkdir -p .github/workflows
   cp build.yml .github/workflows/
   cp quick-check.yml .github/workflows/  # optional
   ```

3. **Commit and push:**
   ```bash
   git add -A
   git commit -m "Fix naming and add GitHub Actions"
   git push
   ```

## 🔍 Verification

After running the fix script:

```bash
# Check what changed
git diff HEAD~1

# Look for any remaining "filter" references
grep -r -i "filter" . --exclude-dir=.git

# Test a local build
./build-clap.sh
```

## 🌐 GitHub Actions

Once pushed, your builds will automatically run on GitHub!

**Check status:**
```
https://github.com/flarkflarkflark/MatrixFilter/actions
```

**Download builds:**
1. Go to Actions tab
2. Click on latest workflow run
3. Scroll to "Artifacts"
4. Download for your platform

**Create a release:**
```bash
git tag v1.0.0
git push origin v1.0.0
```
This creates a GitHub release with all binaries attached!

## ⚠️ Important Notes

### Plugin IDs
If your plugin is already published/distributed:
- ✅ DO change display names
- ❌ DON'T change VST3 GUIDs
- ❌ DON'T change CLAP IDs
- ❌ DON'T change LV2 URIs

The script only changes display names, not IDs, so you're safe!

### Testing
After applying fixes:
1. Build locally to verify it works
2. Test in your DAW
3. Check all three formats (CLAP, VST3, LV2)

### Backup
The script will warn you about uncommitted changes. It's always good to:
```bash
git status  # Check what's uncommitted
git stash   # Save uncommitted work (if needed)
```

## 🐛 Troubleshooting

**Script won't run:**
```bash
chmod +x fix_all.sh
```

**Not in a git repo:**
- Make sure you're in the MatrixFilter repository root
- Check with: `git status`

**Build fails on GitHub:**
- Check Actions logs for specific errors
- Verify build scripts exist and are correct
- SDK downloads might fail - check URLs

**Push fails:**
- May need to set up git credentials
- Try: `git config credential.helper store`
- Or push manually later

## 📞 What to Do After

1. ✅ Verify naming changes: `git diff`
2. ✅ Check GitHub Actions builds
3. ✅ Test plugins locally
4. ✅ Update MatrixFilter repo (if it should be different)

## 🎁 Bonus: Workflow Features

The GitHub Actions workflows include:
- ✅ Multi-platform builds (Linux, Windows, macOS)
- ✅ All plugin formats (CLAP, VST3, LV2)
- ✅ Automatic artifact uploads
- ✅ Release creation on tags
- ✅ Quick CI checks
- ✅ Naming verification

## 📚 Additional Resources

- **GitHub Actions Docs:** https://docs.github.com/actions
- **CLAP Format:** https://cleveraudio.org/
- **VST3 SDK:** https://github.com/steinbergmedia/vst3sdk
- **LV2 Spec:** http://lv2plug.in/

---

## 🎉 Quick Summary

**For the impatient:**
```bash
cd /path/to/MatrixFilter
./fix_all.sh
# Press 'y' a few times
# Done!
```

**What you get:**
- ✅ All naming fixed
- ✅ GitHub Actions set up
- ✅ Builds for all platforms
- ✅ Ready to release

**Next:** Check https://github.com/flarkflarkflark/MatrixFilter/actions

---

Questions? Issues? Check the INSTRUCTIONS.md for detailed explanations!
