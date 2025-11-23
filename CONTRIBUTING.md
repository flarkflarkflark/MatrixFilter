# Contributing to MatrixFilter

Thank you for your interest in contributing to MatrixFilter! This document provides guidelines and instructions for contributing.

## Code of Conduct

Be respectful, constructive, and professional in all interactions.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/flarkflarkflark/MatrixFilter/issues)
2. If not, create a new issue using the Bug Report template
3. Provide as much detail as possible:
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details (OS, DAW, plugin version)
   - Logs or error messages

### Suggesting Features

1. Check if the feature has already been suggested
2. Create a new issue using the Feature Request template
3. Clearly describe the use case and expected behavior
4. Be open to discussion and feedback

### Submitting Pull Requests

1. **Fork the repository**
   ```bash
   git clone https://github.com/YOUR-USERNAME/MatrixFilter.git
   cd MatrixFilter
   git submodule update --init --recursive
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the existing code style
   - Add comments for complex logic
   - Keep changes focused and atomic

4. **Test your changes**
   - Build on your platform
   - Test in at least one CLAP-compatible DAW
   - Ensure no new warnings or errors

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add feature: brief description"
   ```

   Commit message guidelines:
   - Use present tense ("Add feature" not "Added feature")
   - Use imperative mood ("Fix bug" not "Fixes bug")
   - First line: brief summary (50 chars or less)
   - Optional body: detailed explanation

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Use the PR template
   - Link related issues
   - Provide clear description of changes
   - Mark the PR as draft if it's work-in-progress

## Development Setup

### Prerequisites
- CMake 3.15+
- C++20 compatible compiler (GCC 8+, MSVC 19.29+, Clang 10+)
- Git

### Building
```bash
mkdir build && cd build
cmake ..
cmake --build .
```

### Project Structure
```
MatrixFilter/
├── src/              # Source code
├── include/          # Header files
├── external/         # Third-party dependencies
├── .github/          # GitHub workflows and templates
└── CMakeLists.txt    # Build configuration
```

## Code Style

### C++ Guidelines
- Use C++20 features where appropriate
- Prefer `const` and `constexpr` where possible
- Use meaningful variable and function names
- Keep functions focused and single-purpose
- Add `extern "C"` for plugin exports

### Formatting
- Indentation: 4 spaces (no tabs)
- Line length: 100 characters max (flexible)
- Braces: K&R style preferred
- Comments: Use `//` for single-line, `/* */` for multi-line

### Example
```cpp
// Good
void process_audio(const float *input, float *output, uint32_t frames) {
    for (uint32_t i = 0; i < frames; ++i) {
        output[i] = apply_filter(input[i]);
    }
}

// Avoid
void proc(const float *in,float *out,uint32_t n){for(uint32_t i=0;i<n;++i){out[i]=filt(in[i]);}}
```

## Testing

### Before Submitting
- [ ] Code compiles without warnings
- [ ] Plugin loads in a DAW
- [ ] Audio processing works as expected
- [ ] No crashes or memory leaks
- [ ] CI/CD builds pass

### Platform Testing
Try to test on multiple platforms if possible:
- Linux (Ubuntu, Fedora, Arch, etc.)
- Windows (10/11)
- macOS (10.15+)

## Documentation

### Code Documentation
- Add comments for complex algorithms
- Document public APIs and functions
- Explain "why" not just "what"

### User Documentation
- Update README.md if adding user-facing features
- Add examples for new functionality
- Update installation instructions if needed

## Review Process

1. **Automated Checks**: GitHub Actions will run builds on all platforms
2. **Code Review**: Maintainers will review your code
3. **Discussion**: Be open to feedback and suggestions
4. **Iterations**: Make requested changes
5. **Approval**: Once approved, your PR will be merged

### Review Timeline
- Initial response: Within 1 week
- Full review: Within 2 weeks
- Merge: Depends on complexity and changes needed

## Getting Help

- **Questions**: Open a discussion on GitHub
- **Chat**: (Add your preferred chat platform if any)
- **Email**: (Add contact email if appropriate)

## Areas Needing Help

Current areas where contributions are especially welcome:
- [ ] Additional filter types (low-pass, high-pass, band-pass)
- [ ] GUI implementation
- [ ] Preset management
- [ ] Additional platform testing
- [ ] Documentation improvements
- [ ] Performance optimizations

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors will be acknowledged in:
- Release notes
- README.md contributors section (if we add one)
- Git commit history

## Questions?

Don't hesitate to ask questions by opening an issue or discussion. We're here to help!

---

**Thank you for contributing to MatrixFilter!** 🎵
