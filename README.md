# Homebrew Tap for Code Pathfinder

This is the official [Homebrew](https://brew.sh/) tap for [Code Pathfinder](https://github.com/shivasurya/code-pathfinder), an open-source security suite with structural code analysis and AI-powered vulnerability detection.

## Installation

```bash
# Add the tap
brew tap shivasurya/tap

# Install pathfinder
brew install pathfinder
```

## Usage

```bash
# Show version
pathfinder version

# Scan a project
pathfinder scan --project /path/to/code --rules /path/to/rules

# Get help
pathfinder --help
```

## Updating

```bash
brew update
brew upgrade pathfinder
```

## Troubleshooting

### Python DSL not working

The formula installs a Python virtual environment with the `codepathfinder` DSL package. If you encounter issues:

```bash
# Verify Python venv is set up
$(brew --prefix)/Cellar/pathfinder/*/libexec/venv/bin/python -c "import codepathfinder; print('OK')"
```

### Reinstall

```bash
brew reinstall pathfinder
```

## Documentation

- [Code Pathfinder Documentation](https://codepathfinder.dev/)
- [GitHub Repository](https://github.com/shivasurya/code-pathfinder)

## License

AGPL-3.0
