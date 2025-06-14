# Contributing to Visualcare File Migration Renamer

Thank you for your interest in contributing to this project! This document provides guidelines and instructions for contributing.

## Development Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/your-username/visualcare-file-migration-renamer.git
   cd visualcare-file-migration-renamer
   ```
3. Install dependencies:
   ```bash
   # Install yq for YAML processing
   sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
   sudo chmod a+x /usr/local/bin/yq
   
   # Install csvlint for CSV validation (optional)
   gem install csvlint
   ```

## Development Guidelines

### Code Style

- Follow the [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Testing

1. Create test cases in the `tests/` directory
2. Run tests:
   ```bash
   ./tests/run_tests.sh
   ```
3. Ensure all tests pass before submitting a pull request

### Plugin Development

1. Create your plugin in the appropriate directory:
   - `plugins/pre-process/` for pre-processing hooks
   - `plugins/post-process/` for post-processing hooks
   - `plugins/custom/` for custom business rules

2. Follow the plugin template:
   ```bash
   #!/bin/bash
   
   # Source required utilities
   source "$(dirname "$0")/../../core/utils/logging.sh"
   
   # Your plugin function
   your_plugin_function() {
       local file=$1
       # Your logic here
   }
   
   # Register the hook
   register_hook "your_plugin_function"
   ```

3. Make your plugin executable:
   ```bash
   chmod +x your_plugin.sh
   ```

### Pull Request Process

1. Create a new branch for your feature/fix
2. Make your changes
3. Add tests if applicable
4. Update documentation
5. Submit a pull request

### Documentation

- Update README.md if adding new features
- Add comments to your code
- Update relevant documentation in the `docs/` directory

## Project Structure

```
visualcare-file-migration-renamer/
├── bin/                    # Executable scripts
├── config/                 # Configuration files
├── core/                   # Core functionality
├── plugins/               # Plugin directory
├── tests/                # Test suite
└── docs/                 # Documentation
```

## Questions?

Feel free to open an issue for any questions or concerns. 