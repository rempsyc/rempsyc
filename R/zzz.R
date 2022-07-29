.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
"Tutorials: https://remi-theriault.com/tutorials
Bug reports, support, or special requests:
https://github.com/rempsyc/rempsyc/issues

Suggested APA citation:
Th\u00e9riault, R. (2022). rempsyc: Convenience functions ",
"for psychology (R package version ",
utils::packageVersion("rempsyc"),
") [Computer software]. https://rempsyc.remi-theriault.com "
  )
}
