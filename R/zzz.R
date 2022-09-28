.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
"Suggested APA citation: Th\u00e9riault, R. (2022). ",
"rempsyc: Convenience functions ",
"for psychology \n(R package version ",
utils::packageVersion("rempsyc"),
") [Computer software]. https://rempsyc.remi-theriault.com "
  )
}

#' @noRd
