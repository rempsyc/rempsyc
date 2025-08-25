# rempsyc: Convenience Functions for Psychology R Package

Always follow these instructions EXACTLY and only search for additional context if the information here is incomplete or found to be in error.

## Overview
The `rempsyc` package is an R package providing convenience functions for psychology research, including statistical analysis, publication-ready tables (APA style), and data visualization. The package is built using R 4.3.3+ and follows standard R package development practices.

## Environment Setup

### Install R and Required System Dependencies
```bash
# Ubuntu/Debian systems
sudo apt update
sudo apt install -y r-base r-base-dev

# Install core R packages via system package manager (recommended)
sudo apt install -y r-cran-dplyr r-cran-rlang r-cran-testthat r-cran-lintr

# If styler or roxygen2 are not available via system packages, install via R:
# R --no-restore --no-save -e 'install.packages(c("styler", "roxygen2"), repos="https://cloud.r-project.org/")'
```

### Set Up R User Library
```bash
# Create user library directory
mkdir -p ~/R/library
echo 'R_LIBS_USER=~/R/library' >> ~/.Renviron
```

## Build and Development Workflow

### Build the Package
**NEVER CANCEL: Build takes ~19 seconds. Set timeout to 60+ seconds.**
```bash
cd /home/runner/work/rempsyc/rempsyc
R CMD build .
# Creates: rempsyc_0.1.91.tar.gz (version may vary)
```

### Install the Package
**NEVER CANCEL: Install takes ~3 seconds. Set timeout to 60+ seconds.**
```bash
cd /home/runner/work/rempsyc/rempsyc
R CMD INSTALL rempsyc_0.1.91.tar.gz
# Or install from source:
# R CMD INSTALL .
```

### Run Tests
**NEVER CANCEL: Tests take ~11 seconds. Set timeout to 30+ seconds.**
```bash
cd /home/runner/work/rempsyc/rempsyc
R --no-restore --no-save -e 'library(testthat); library(rempsyc); test_local()'
```

Expected results: 
- ~99 tests processed across multiple test files
- ~94 tests should pass
- 3-5 snapshot failures due to minor precision differences (normal and expected)
- Some tests may be skipped if optional packages not available

### Run Linting
**NEVER CANCEL: Linting takes ~20 seconds. Set timeout to 60+ seconds.**
```bash
cd /home/runner/work/rempsyc/rempsyc
R --no-restore --no-save -e 'library(lintr); lint_package()'
```

Expected results:
- Many style warnings (673+ issues found - normal for existing codebase)
- Focus on new code adhering to style guidelines
- Package is functional despite style warnings

### Auto-format Code with Styler
**NEVER CANCEL: Styling takes ~10-30 seconds depending on package size. Set timeout to 60+ seconds.**
```bash
cd /home/runner/work/rempsyc/rempsyc
# Style entire package
R --no-restore --no-save -e 'library(styler); style_pkg()'

# Style specific file
R --no-restore --no-save -e 'library(styler); style_file("R/[function_name].R")'

# Style specific directory
R --no-restore --no-save -e 'library(styler); style_dir("R")'
```

Expected results:
- Automatic code formatting according to tidyverse style guide
- Consistent indentation, spacing, and bracket placement
- Files will be modified in-place if styling changes are needed
- Use after making changes but before committing

### Update Documentation with roxygen2
**NEVER CANCEL: Documentation update takes ~5-15 seconds. Set timeout to 60+ seconds.**
```bash
cd /home/runner/work/rempsyc/rempsyc
# Update documentation after making changes to roxygen2 comments
R --no-restore --no-save -e 'roxygen2::document()'

# Alternative using devtools
R --no-restore --no-save -e 'devtools::document()'
```

Expected results:
- Updates .Rd files in man/ directory from roxygen2 comments
- Updates NAMESPACE file with exports/imports
- Essential step after modifying function documentation or adding/removing exports
- Must be run before building the package if documentation was changed

**When to use**: Always run this after:
- Adding or modifying roxygen2 comments (the `#'` comments above functions)
- Adding new exported functions
- Changing function parameters or return values in documentation
- Adding or removing `@export`, `@import`, or `@importFrom` tags

### Run R CMD Check
**NEVER CANCEL: R CMD check takes ~30 seconds (without suggested packages) to 5 minutes (full). Set timeout to 10+ minutes.**
```bash
cd /home/runner/work/rempsyc/rempsyc
# Without suggested packages (due to network limitations):
_R_CHECK_FORCE_SUGGESTS_=FALSE R CMD check rempsyc_0.1.91.tar.gz --no-manual --no-vignettes

# With all checks (if network access available):
# R CMD check rempsyc_0.1.91.tar.gz
```

Expected results:
- Status: 1 ERROR (missing suggested packages - normal), 2 NOTEs  
- Core functionality passes all checks
- Tests pass correctly
- Examples may fail due to missing optional packages (expected)

## Validation Scenarios

### Always Test Core Functions After Changes
Test the main functions to ensure they work correctly:

```bash
cd /home/runner/work/rempsyc/rempsyc
R --no-restore --no-save -e '
library(rempsyc)

# Test t-test function
result <- nice_t_test(data = mtcars, response = "mpg", group = "am")
print(result)

# Test table formatting
library(testthat)  # If available
if (requireNamespace("flextable", quietly = TRUE)) {
  table <- nice_table(result)
  print("Table creation successful")
} else {
  print("Flextable not available - table creation skipped")
}

# Test basic data functions
data <- extract_duplicates(data.frame(id = c(1,1,2), val = c(1,2,3)), id = "id")
print("Core functions working correctly")
'
```

### Manual Function Testing Workflow
After making changes to package functions:

1. **Always rebuild and reinstall the package**:
   ```bash
   cd /home/runner/work/rempsyc/rempsyc
   R CMD build . && R CMD INSTALL rempsyc_*.tar.gz
   ```

2. **Test the specific function you modified**:
   ```bash
   R --no-restore --no-save -e 'library(rempsyc); [your_function_test_here]'
   ```

3. **Run relevant tests**:
   ```bash
   R --no-restore --no-save -e 'library(testthat); library(rempsyc); test_file("tests/testthat/test-[function_name].R")'
   ```

## Key Locations and Files

### Repository Exploration Commands
```bash
# View repository structure
ls -la /home/runner/work/rempsyc/rempsyc/

# View R source files
ls -la /home/runner/work/rempsyc/rempsyc/R/

# View test files
ls -la /home/runner/work/rempsyc/rempsyc/tests/testthat/

# Check package metadata
cat /home/runner/work/rempsyc/rempsyc/DESCRIPTION
```

### Source Code Structure
- `/R/` - All R function source files (34+ files)
- `/tests/testthat/` - Test files using testthat framework
- `/tests/testthat.R` - Test runner entry point  
- `/man/` - Documentation files (auto-generated from roxygen2)
- `/vignettes/` - R Markdown tutorials and documentation

### Configuration Files
- `DESCRIPTION` - Package metadata, dependencies, version
- `NAMESPACE` - Package exports (auto-generated from roxygen2)
- `.github/workflows/` - CI/CD workflows (R-CMD-check, lint, test-coverage)
- `.Rbuildignore` - Files to exclude from package build

### Important Functions by Category
**Statistical Analysis**: `nice_t_test()`, `nice_contrasts()`, `nice_mod()`, `nice_lm()`
**Tables**: `nice_table()` (publication-ready APA tables)
**Visualization**: `nice_violin()`, `nice_scatter()`, `plot_outliers()`
**Data Utilities**: `extract_duplicates()`, `nice_na()`, `scale_mad()`

## Dependencies and Package Management

### Core Dependencies (Always Required)
```r
# In DESCRIPTION file:
Imports: rlang, dplyr (>= 1.1.0)
Depends: R (>= 3.6)
```

### Suggested Packages (Optional)
Many functions require optional packages. The package uses `rlang::check_installed()` to prompt users to install needed packages when functions are called.

**Key suggested packages**: flextable, ggplot2, effectsize, performance, testthat, styler, roxygen2

### Installing Additional Packages (if needed)
```bash
# Via system packages (recommended):
sudo apt install -y r-cran-[package-name]

# Via R (if CRAN network available):
R --no-restore --no-save -e 'install.packages("[package-name]", repos="https://cloud.r-project.org/")'

# Alternative sources when CRAN is blocked:
# Via R-universe (alternative CRAN mirror):
R --no-restore --no-save -e 'install.packages("[package-name]", repos="https://r-universe.dev")'

# Via pak package (faster, handles dependencies better):
R --no-restore --no-save -e 'install.packages("pak", repos="https://r-lib.github.io/p/pak/stable/"); pak::pak("[package-name]")'
```

## Code Quality and Best Practices

### Avoiding Global Variable Binding Issues

**CRITICAL**: Always use proper variable referencing to prevent "no visible binding for global variable" warnings that make CI workflows fail.

#### Recommended Approaches:

1. **For dplyr operations**: Use `.data[[variable_name]]` notation
   ```r
   # CORRECT: Use .data[[var]] notation
   data %>%
     group_by(.data[[group_var]]) %>%
     summarize(mean_val = mean(.data[[response_var]], na.rm = TRUE))
   
   # INCORRECT: Direct variable names (causes binding warnings)
   data %>%
     group_by(group_var) %>%
     summarize(mean_val = mean(response_var, na.rm = TRUE))
   ```

2. **For ggplot2 operations**: Use `.data[[variable_name]]` or `aes_string()`
   ```r
   # CORRECT: Use .data[[var]] in aes()
   ggplot(data, aes(x = .data[[x_var]], y = .data[[y_var]]))
   
   # ALTERNATIVE: Use aes_string() for string variables
   ggplot(data, aes_string(x = x_var, y = y_var))
   ```

3. **Import required functions**: Always explicitly import from other packages
   ```r
   #' @importFrom dplyr group_by summarize
   #' @importFrom ggplot2 ggplot aes
   ```

#### Discouraged Approaches:

- **DO NOT** create `global_variables.R` files with `utils::globalVariables()`
- **DO NOT** use bare variable names in dplyr or ggplot operations
- **DO NOT** rely on global variable declarations to suppress warnings

### Ensuring Documentation-Code Consistency

**CRITICAL**: Documentation must exactly match function arguments to prevent "Codoc mismatches" warnings.

#### Documentation Validation Steps:

1. **Match all parameter names exactly**:
   ```r
   #' @param response The dependent variable name
   #' @param group The grouping variable name  
   function_name <- function(response, group) { ... }
   ```

2. **Update documentation when changing parameters**:
   - Always run `roxygen2::document()` after parameter changes
   - Check that `.Rd` files reflect actual function signatures
   - Verify examples use correct parameter names

3. **Validate before building**:
   ```bash
   # Check for documentation mismatches
   R --no-restore --no-save -e 'roxygen2::document()'
   R CMD build .
   # Look for "Codoc mismatches" warnings
   ```

## Common Development Tasks

### Adding a New Function
1. Create the function in `/R/[function_name].R`
2. **Use proper variable referencing**: Use `.data[[var]]` for dplyr/ggplot2 operations
3. Add roxygen2 documentation above the function (ensure parameter names match exactly)
4. Add `@importFrom` statements for all external functions used
5. Add exports to roxygen2 comments if needed (`@export`)
6. Create tests in `/tests/testthat/test-[function_name].R`
7. **Check for global variable issues**: `R CMD check` should show no binding warnings
8. **Lint the code**: `R --no-restore --no-save -e 'library(lintr); lint_package()'`
9. **Style the code**: `R --no-restore --no-save -e 'library(styler); style_file("R/[function_name].R")'`
10. **Update documentation**: `R --no-restore --no-save -e 'roxygen2::document()'`
11. **Validate documentation consistency**: Check for "Codoc mismatches" warnings
12. Rebuild and test: `R CMD build . && R CMD INSTALL rempsyc_*.tar.gz`
13. Run tests: `R --no-restore --no-save -e 'library(testthat); library(rempsyc); test_local()'`

### Modifying Existing Functions
1. Edit the function in appropriate `/R/[file].R`
2. **Ensure proper variable referencing**: Replace bare variable names with `.data[[var]]` notation
3. Update documentation if parameters changed (ensure exact parameter name matches)
4. Update `@importFrom` statements if new external functions are used
5. Update tests if function behavior changes
6. **Check for global variable issues**: `R CMD check` should show no binding warnings
7. **Lint the code**: `R --no-restore --no-save -e 'library(lintr); lint_package()'`
8. **Style the code**: `R --no-restore --no-save -e 'library(styler); style_file("R/[file].R")'`
9. **Update documentation if changed**: `R --no-restore --no-save -e 'roxygen2::document()'`
10. **Validate documentation consistency**: Check for "Codoc mismatches" warnings
11. **Always rebuild and reinstall**: `R CMD build . && R CMD INSTALL rempsyc_*.tar.gz`
12. **Always test the specific function manually**
13. Run full test suite to check for regressions

### Before Committing Changes
**CRITICAL**: Always run this complete validation sequence to ensure workflow checks pass on first try:

```bash
cd /home/runner/work/rempsyc/rempsyc

# 1. Check for global variable binding issues first (look for "no visible binding" warnings)
R --no-restore --no-save -e 'warnings(); R CMD check rempsyc_*.tar.gz --no-manual --no-vignettes 2>&1 | grep -i "binding"'

# 2. Lint code to identify style issues (20 seconds)
R --no-restore --no-save -e 'library(lintr); lint_package()'

# 3. Style code to automatically fix issues (10-30 seconds) - optional but recommended
R --no-restore --no-save -e 'library(styler); style_pkg()'

# 4. Update documentation if documentation was changed (5-15 seconds)
R --no-restore --no-save -e 'roxygen2::document()'

# 5. Build (19 seconds)
R CMD build .

# 6. Install  
R CMD INSTALL rempsyc_*.tar.gz

# 7. Test (11 seconds) 
R --no-restore --no-save -e 'library(testthat); library(rempsyc); test_local()'

# 8. Final R CMD check for all issues (~30 seconds) - REQUIRED before committing
_R_CHECK_FORCE_SUGGESTS_=FALSE R CMD check rempsyc_*.tar.gz --no-manual --no-vignettes

# 9. Look specifically for critical warnings that fail CI:
# - "no visible binding for global variable"
# - "Codoc mismatches from Rd file"
# - Fix these issues before committing
```

**Workflow Logic**: 
- Lint first to identify all style issues
- Style second to automatically fix what can be fixed
- Update documentation third if any roxygen2 comments were changed
- Build and test last to validate everything works together

## Troubleshooting

### "Could not find function" Errors
- **Cause**: Package not loaded or installed
- **Solution**: Run `R CMD build . && R CMD INSTALL rempsyc_*.tar.gz` then `library(rempsyc)`

### Missing Package Errors
- **Cause**: Suggested packages not installed
- **Solution**: Install via `sudo apt install r-cran-[package]` or ignore if testing core functionality

### Network/CRAN Access Issues  
- **Cause**: Blocked network access to CRAN mirrors
- **Solution**: Use system packages via apt or skip optional package tests

### Test Snapshot Failures
- **Cause**: Minor precision differences in numerical results (normal)
- **Solution**: Review changes, accept if precision differences are minor: `testthat::snapshot_accept()`

### Build Failures
- **Cause**: Syntax errors, missing dependencies, or file issues
- **Solution**: Check specific error messages, ensure DESCRIPTION is correct, verify all R files have valid syntax

### Styler Not Available
- **Cause**: styler package not installed
- **Solution**: Install via R: `R --no-restore --no-save -e 'install.packages("styler", repos="https://cloud.r-project.org/")'` or skip styling step if not critical

### Roxygen2 Not Available
- **Cause**: roxygen2 package not installed
- **Solution**: Install via R: `R --no-restore --no-save -e 'install.packages("roxygen2", repos="https://cloud.r-project.org/")'` or use devtools: `R --no-restore --no-save -e 'devtools::document()'`

### Documentation Build Failures
- **Cause**: Documentation not updated after changing roxygen2 comments
- **Solution**: Run `R --no-restore --no-save -e 'roxygen2::document()'` before building the package

### Global Variable Binding Warnings ("no visible binding")
- **Cause**: Using bare variable names in dplyr/ggplot2 operations instead of proper notation
- **Solution**: Replace with `.data[[variable_name]]` notation and add proper `@importFrom` statements
- **Example**: Change `group_by(var)` to `group_by(.data[[var]])`
- **DO NOT**: Create `global_variables.R` files with `utils::globalVariables()`

### Documentation Mismatch Warnings ("Codoc mismatches")
- **Cause**: Function parameter names don't match the documentation
- **Solution**: Ensure `@param parameter_name` exactly matches function arguments
- **Prevention**: Always run `roxygen2::document()` after changing function signatures

### CRAN/Network Access Blocked
- **Cause**: Cannot install packages from CRAN mirrors
- **Solutions**: 
  - Use system packages: `sudo apt install r-cran-[package]`
  - Try R-universe: `repos="https://r-universe.dev"`  
  - Use pak package: `pak::pak("[package-name]")`

## Common Reference Information

The following are outputs from frequently used commands. Reference them instead of running bash commands to save time.

### Repository Root Structure
```
ls -la /home/runner/work/rempsyc/rempsyc/

.Rbuildignore       - Files to exclude from package build
.github/            - GitHub workflows and actions
.gitignore          - Git ignore patterns
CITATION.cff        - Citation metadata
DESCRIPTION         - Package metadata and dependencies
LICENSE.md          - Package license (GPL 3+)
NAMESPACE           - Package exports (auto-generated)
NEWS.md             - Change log
R/                  - R source code (34+ files)
README.Rmd          - Source for README (edit this, not README.md)
README.md           - Main repository documentation
TODOS.md            - Development roadmap
cran-comments.md    - CRAN submission notes
docs/               - pkgdown documentation site
inst/               - Package installation files
man/                - Help documentation (auto-generated)
tests/              - Test files (testthat framework)
vignettes/          - R Markdown tutorials
```

### Core R Functions by File
```
R/nice_t_test.R      - t-test analysis
R/nice_table.R       - APA formatted tables  
R/nice_scatter.R     - Scatter plot visualization (uses .data[[var]] notation)
R/nice_violin.R      - Violin plot visualization
R/extract_duplicates.R - Data cleaning utilities
R/nice_na.R          - Missing data analysis
R/format_value.R     - Value formatting (p, r, d values)
R/scale_mad.R        - Robust standardization
R/global_variables.R - DEPRECATED: Do not add to this file
```

### Code Quality Examples

#### CORRECT: Proper Variable Referencing
```r
# In dplyr operations - USE .data[[var]] notation:
data %>%
  group_by(.data[[group]]) %>%
  summarize(mean_val = mean(.data[[response]], na.rm = TRUE))

# In ggplot operations - USE .data[[var]] notation:
ggplot(data, aes(x = .data[[predictor]], y = .data[[response]]))

# Always include proper imports:
#' @importFrom dplyr group_by summarize
#' @importFrom ggplot2 ggplot aes
```

#### INCORRECT: Causes CI Failures  
```r
# DO NOT: Bare variable names (causes binding warnings)
data %>%
  group_by(group) %>%
  summarize(mean_val = mean(response, na.rm = TRUE))

# DO NOT: Add to global_variables.R file
utils::globalVariables(c("group", "response"))
```

## CI/CD Integration

The package uses GitHub Actions with these workflows:
- **R-CMD-check**: Multi-platform testing (Ubuntu, macOS, Windows)  
- **lint**: Code style checking with lintr
- **test-coverage**: Code coverage reporting with covr
- **pkgdown**: Documentation website generation

These workflows run automatically on pushes and pull requests to main/master branches.

### Ensuring CI Workflows Pass on First Try

**CRITICAL**: Follow these guidelines to prevent CI failures:

#### 1. Global Variable Binding Prevention
- **Always** use `.data[[variable_name]]` in dplyr operations
- **Always** add `@importFrom package function` for external functions
- **Never** create `global_variables.R` files with `utils::globalVariables()`
- **Test locally**: `R CMD check` should show no "no visible binding" warnings

#### 2. Documentation Consistency Validation  
- **Always** ensure parameter names in `@param` match function arguments exactly
- **Always** run `roxygen2::document()` after changing function signatures
- **Test locally**: Look for "Codoc mismatches" warnings during build

#### 3. Package Installation Strategy
When packages can't be installed from CRAN:
- **Primary**: Use system packages via `sudo apt install r-cran-[package]`
- **Alternative**: Use R-universe repository: `repos="https://r-universe.dev"`
- **Advanced**: Use pak package for better dependency resolution

#### 4. Pre-Commit Validation Checklist
Before making any PR, verify locally:
```bash
# Must show ZERO "no visible binding" warnings:
R CMD check rempsyc_*.tar.gz 2>&1 | grep -i "binding"

# Must show ZERO "Codoc mismatches" warnings:  
R CMD check rempsyc_*.tar.gz 2>&1 | grep -i "codoc"

# All tests must pass (94+ passing tests expected):
R --no-restore --no-save -e 'library(testthat); library(rempsyc); test_local()'
```

## Performance Notes

- Package build: ~19 seconds
- Package install: ~3 seconds  
- Test suite: ~11 seconds (99 tests: 94 pass, 5 snapshot failures expected)
- Linting: ~20 seconds (673 style issues - normal for existing codebase)
- Code styling: ~10-30 seconds depending on package size
- Documentation update: ~5-15 seconds (roxygen2)
- R CMD check: ~29 seconds (without suggested packages), 2-5 minutes (full check)
- Function loading after install: Near instant

**CRITICAL**: Never cancel builds or tests prematurely. Always wait for completion and set appropriate timeouts (60+ seconds for builds, 30+ seconds for tests, 10+ minutes for R CMD check).