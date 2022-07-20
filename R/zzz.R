.onAttach <- function(libname, pkgname){
packageStartupMessage(

"Welcome to rempsyc package version ", utils::packageVersion("rempsyc"),
"!
For tutorials visit: https://remi-theriault.com/tutorials

This package is under active development.
For bug reports, support, or special requests, visit:
https://github.com/rempsyc/rempsyc/issues")
}
