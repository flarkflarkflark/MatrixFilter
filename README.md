# MatrixFilter Complete Fix - Quick Start

## One Command to Fix Everything!

This package contains a single script that will fix all naming issues and set up GitHub Actions for your MatrixFilter repository.

## What It Does

The `fix_all.sh` script will automatically:

1. ✅ Find and replace all "Filter" → "Filter" references
2. ✅ Create GitHub Actions workflows for Linux, Windows, and macOS
3. ✅ Make all build scripts executable
4. ✅ Commit all changes to git
5. ✅ Push to GitHub (with your confirmation)

## Installation

1. **Download the script** to your MatrixFilter repository root:
   ```bash
   cd /path/to/MatrixFilter
   # Copy fix_all.sh here
   ```

2. **Make it executable** (if not already):
   ```bash
   chmod +x fix_all.sh
   ```

## Usage

Simply run:
```bash
./fix_all.sh
```

The script will:
- Show you what it's going to change (preview)
- Ask for confirmation before making changes
- Apply all fixes automatically
- Ask if you want to push to GitHub

## What Happens After

Once pushed to GitHub:

1. **GitHub Actions will automatically build** your plugins for:
   - Linux (CLAP, VST3, LV2)
   - Windows (CLAP, VST3)
   - macOS (CLAP, VST3, LV2)

2. **Check build status** at:
   ```
   https://github.com/flarkflarkflark/MatrixFilter/actions
   ```

3. **Download built plugins** from the Actions tab (Artifacts section)

## Creating a Release

To create a tagged release with automatic builds:

```bash
git tag v1.0.0
git push origin v1.0.0
```

This will trigger builds and create a GitHub release with all platform binaries attached!

## Safety Features

The script includes:
- Preview of changes before applying
- Confirmation prompts
- Git repository checks
- Warns about uncommitted changes
- Skips files that are already correct

## Troubleshooting

**"Not a git repository"**
- Make sure you're in the root of your MatrixFilter repository

**"Permission denied"**
- Run: `chmod +x fix_all.sh`

**Push failed**
- You may need to set up git credentials
- Or push manually: `git push origin main`

**Build fails on GitHub**
- Check that build scripts exist and are correct
- Review the Actions log for specific errors

## Manual Alternatives

If you prefer to do things manually, see:
- `INSTRUCTIONS.md` - Detailed step-by-step guide
- `NAMING_CHECKLIST.md` - Complete checklist of what to fix
- `fix_naming.sh` - Just the naming fixes (no git operations)

## Support

After running this script:
1. Verify changes with `git diff HEAD~1`
2. Test a local build if possible
3. Monitor GitHub Actions for build results

---

**Ready?** Just run: `./fix_all.sh`
