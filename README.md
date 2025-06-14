# Visualcare File Migration Renamer

A flexible, extensible command-line utility for migrating and renaming files to meet Visualcare's import requirements. This tool is designed to be modular and plugin-based, allowing for custom business rules and integration with various data sources.

## Features

- Recursive file discovery and processing in nested directories
- Configurable ID mapping from external data sources (CSV, JSON, etc.)
- Intelligent date extraction from filenames or metadata
- Robust filename sanitization
- Plugin system for custom business rules and processing
- Comprehensive reporting and logging

## Project Structure

```
visualcare-file-migration-renamer/
├── bin/                    # Executable scripts
│   └── vcmigrate          # Main entry point
├── config/                 # Configuration files
│   ├── default/           # Default configurations
│   └── examples/          # Example configurations
├── core/                   # Core functionality
│   ├── processors/        # File processing modules
│   ├── mappers/          # ID mapping modules
│   └── utils/            # Utility functions
├── plugins/               # Plugin directory
│   ├── pre-process/      # Pre-processing hooks
│   ├── post-process/     # Post-processing hooks
│   └── custom/           # Custom business rules
├── tests/                # Test suite
└── docs/                 # Documentation
```

## Quick Start

1. Clone the repository
2. Copy `config/examples/config.yaml` to `config/config.yaml`
3. Customize the configuration for your needs
4. Run the migration:
   ```bash
   ./bin/vcmigrate --config config/config.yaml
   ```

## Configuration

The tool is configured using YAML files. Key configuration areas include:

- ID mapping sources and rules
- Date format patterns
- File naming conventions
- Plugin configurations
- Processing rules

See `config/examples/` for sample configurations.

## Plugin System

The tool supports plugins in several ways:

1. **Pre/Post Processing Hooks**: Execute custom code before or after main processing
2. **Custom Processors**: Add new file type handlers or processing logic
3. **Custom Mappers**: Implement custom ID mapping logic
4. **Business Rules**: Add organization-specific rules and validations

See `docs/plugins.md` for detailed plugin development guide.

## Contributing

We welcome contributions! Please see `CONTRIBUTING.md` for guidelines.

## Roadmap

- [ ] Python port with enhanced plugin capabilities
- [ ] Node.js port for web integration
- [ ] GUI interface
- [ ] Additional data source integrations
- [ ] Enhanced reporting and analytics

## License

This project is licensed under the MIT License - see the LICENSE file for details.
