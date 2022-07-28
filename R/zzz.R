.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to rempsyc package version ", utils::packageVersion("rempsyc"),
    "!
For tutorials visit: https://remi-theriault.com/tutorials

This package is under active development.
For bug reports, support, or special requests, visit:
https://github.com/rempsyc/rempsyc/issues

If this package is helpful to you, it would mean a lot ",

"if you would cite it!
Suggested APA citation:

Thériault, R. (2022). rempsyc: Convenience functions ",
"for psychology. https://rempsyc.remi-theriault.com. Version = ",
utils::packageVersion("rempsyc")
  )
}
