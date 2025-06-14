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

   # Install BATS for testing
   npm install -g bats
   # or
   brew install bats-core
   ```

## Development Guidelines

### Code Style

- Follow the [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Testing

The project uses BATS (Bash Automated Testing System) for automated testing. Follow these guidelines:

1. Test Structure:
   - Place unit tests in `tests/unit/`
   - Place integration tests in `tests/integration/`
   - Place test fixtures in `tests/fixtures/`
   - Use `test_helper.bash` for common test functions

2. Writing Tests:
   ```bash
   #!/usr/bin/env bats
   
   # Load test helper functions
   load 'test_helper'
   
   # Load the script to test
   load '../path/to/script.sh'
   
   setup() {
       # Setup runs before each test
       export TEST_TEMP_DIR=$(mktemp -d)
   }
   
   teardown() {
       # Cleanup runs after each test
       rm -rf "$TEST_TEMP_DIR"
   }
   
   @test "test description" {
       # Test implementation
       run your_function "arg1" "arg2"
       [ "$status" -eq 0 ]
       [ "$output" = "expected output" ]
   }
   ```

3. Running Tests:
   ```bash
   # Run all tests
   ./tests/run_tests.sh
   
   # Run specific test file
   bats tests/unit/your_test.bats
   ```

4. Test Coverage:
   - Write tests for all new functionality
   - Include edge cases and error conditions
   - Test both success and failure scenarios
   - Ensure tests are isolated and don't depend on external state

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

4. Write tests for your plugin:
   - Create a test file in `tests/unit/plugins/`
   - Test all plugin functionality
   - Include error cases and edge conditions

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
- Document any new test cases or testing patterns

## Project Structure

```
visualcare-file-migration-renamer/
├── bin/                    # Executable scripts
├── config/                 # Configuration files
├── core/                   # Core functionality
├── plugins/               # Plugin directory
├── tests/                # Test suite
│   ├── unit/            # Unit tests
│   ├── integration/     # Integration tests
│   └── fixtures/        # Test data and fixtures
└── docs/                 # Documentation
```

## Questions?

Feel free to open an issue for any questions or concerns. 