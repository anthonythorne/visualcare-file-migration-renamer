# VisualCare File Migration Renamer – Project Summary & AI Context

**Purpose:**  
A robust, configuration-driven tool for migrating and renaming files in real-world scenarios. It extracts names, dates, user IDs, and (optionally) categories from filenames, then generates normalized filenames using flexible templates. The tool is designed for accuracy, safety, and extensibility, with comprehensive testing and documentation.

---

## Key Features

- **Smart Name Extraction:**  
  Advanced pattern matching (shorthand, initials, fuzzy, full names) to extract person names from filenames.
- **Date Recognition:**  
  Supports ISO, US, European, and written date formats.
- **User ID Mapping:**  
  Maps user IDs to names for consistent, template-based filename generation. If a user ID is not found, the name (from the directory) is still always included in the filename; only the `{id}` field is omitted.
- **Category & Directory Logic:**  
  - **Category Detection:** (Planned/partial) Can assign categories to files based on folder names or keywords, with future support for automatic category detection and category-aware filename templates.
  - **Directory Processing:** Processes all files in a directory tree, supporting input/output directory specification and batch operations.
- **Template-Based Formatting:**  
  Output filenames are generated from configurable templates with placeholders (e.g., `{id}_{name}_{category}_{remainder}_{date}`).
- **Management Flag Detection:**  
  Flags management/admin files automatically based on keywords.
- **Dry-Run Mode:**  
  Preview all changes before applying them.
- **Comprehensive Testing:**  
  174+ tests, including unit and integration, with automated test generation from CSV matrices.

---

## Architecture

- **Hybrid Bash/Python:**  
  - Python: Core logic for name/date/category extraction, user mapping, configuration.
  - Bash: Shell wrappers for integration and BATS-based testing.
- **Configuration-Driven:**  
  All logic (separators, templates, keywords, category mappings) is controlled via YAML and CSV files in the config directory.
- **CLI Application:**  
  `main.py` provides a flexible command-line interface for all operations, including directory and batch processing.

---

## Usage

- **Test Mode:**  
  Safely test with built-in file structures before processing real files.
- **CSV Mapping:**  
  Map old filenames to new ones using a CSV file.
- **Directory Processing:**  
  Process all files in a directory tree, using a name mapping CSV for person matching and supporting category assignment based on directory or folder mapping.
- **Configuration:**  
  - `config/components.yaml`: Main settings (separators, templates, flags, category logic).
  - `config/user_mapping.csv`: Maps user IDs to names.

---

## Name, Category, and Directory Logic

- **Order of Extraction:**  
  1. Shorthand patterns (e.g., `jdoe`, `j-doe`)
  2. First names
  3. Last names
  4. Clean up separators in the remainder
- **Category Assignment:**  
  - Categories can be assigned based on directory names or keywords (see `Category` section in `config/components.yaml`).
  - Category-aware filename templates are supported and extensible.
- **Directory Traversal:**  
  - Recursively processes files in input directories, preserving or transforming directory structure as configured.
- **Separator Handling:**  
  All valid separators are defined in YAML and can be extended without code changes.
- **Fuzzy Matching:**  
  Handles case, character substitutions, and mixed/multiple separators.
- **Template System:**  
  Output filenames are built from templates, skipping empty components and cleaning up separators.

---

## Documentation References

- **User Guide:**  
  [docs/USAGE_GUIDE.md](docs/USAGE_GUIDE.md) – Step-by-step usage, directory/category examples, troubleshooting.
- **Implementation Summary:**  
  [docs/IMPLEMENTATION_SUMMARY.md](docs/IMPLEMENTATION_SUMMARY.md) – Technical architecture, algorithms, directory/category logic, and design decisions.
- **Naming Conventions:**  
  [docs/NAMING_CONVENTIONS.md](docs/NAMING_CONVENTIONS.md) – Detailed extraction and matching rules, including category and directory handling.
- **Testing Guide:**  
  [docs/TESTING.md](docs/TESTING.md) – How to run and interpret tests.
- **Category System Summary:**  
  [docs/CATEGORY_SYSTEM_SUMMARY.md](docs/CATEGORY_SYSTEM_SUMMARY.md) – (If present) Details on category logic and mapping.

---

## Extensibility & Future Plans

- **Category support:** Automatic detection and folder mapping, with category-aware templates.
- **Advanced matching:** ML-based, context-aware extraction.
- **Performance optimizations:** Parallel processing, caching.
- **Integration features:** REST API, web config, plugin architecture.

---

**In summary:**  
VisualCare File Migration Renamer is a production-ready, highly configurable tool for safe, accurate, and automated file renaming and migration, with a strong focus on real-world edge cases, extensibility, and reliability.  
**For details on any feature, see the referenced documentation in the `docs/` directory.** 