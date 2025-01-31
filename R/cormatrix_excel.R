#' @title Easy export of correlation matrix to Excel
#'
#' @description Easily output a correlation matrix and export it to
#' Microsoft Excel, with the first row and column frozen, and
#' correlation coefficients colour-coded based on effect size
#' (0.0-0.2: small (no colour); 0.2-0.4: medium (pink/light blue);
#' 0.4-1.0: large (red/dark blue)), following Cohen's suggestions
#' for small (.10), medium (.30), and large (.50) correlation sizes.
#'
#' Based on the `correlation` and `openxlsx2` packages.
#'
#' @param data The data frame
#' @param filename Desired filename (path can be added before hand
#' but no need to specify extension).
#' @param overwrite Whether to allow overwriting previous file.
#' @param p_adjust Default p-value adjustment method (default is "none",
#' although [correlation::correlation()]'s default is "holm")
#' @param print.mat Logical, whether to also print the correlation matrix
#'                  to console.
#' @param ... Parameters to be passed to the `correlation` package
#' (see [correlation::correlation()])
#'
#' @keywords correlation matrix Excel
#' @author Adapted from @JanMarvin (JanMarvin/openxlsx2#286) and
#' the original `rempsyc::cormatrix_excel`.
#' @return A Microsoft Excel document, containing the colour-coded
#'         correlation matrix with significance stars, on the first
#'         sheet, and the colour-coded p-values on the second sheet.
#' @export
#' @examplesIf requireNamespace("correlation", quietly = TRUE) && requireNamespace("openxlsx2", quietly = TRUE)
#' \dontshow{
#' .old_wd <- setwd(tempdir())
#' }
#' # Basic example
#' cormatrix_excel(mtcars, select = c("mpg", "cyl", "disp", "hp", "carb"), filename = "cormatrix1")
#' cormatrix_excel(iris, p_adjust = "none", filename = "cormatrix2")
#' cormatrix_excel(airquality, method = "spearman", filename = "cormatrix3")
#' \dontshow{
#' setwd(.old_wd)
#' }
cormatrix_excel <- function(data,
                            filename,
                            overwrite = TRUE,
                            p_adjust = "none",
                            print.mat = TRUE,
                            ...) {

  rlang::check_installed(c("correlation", "openxlsx2"),
                         reason = "for this function."
  )

  correlation::cormatrix_to_excel(
    data = data,
    filename = filename,
    overwrite = overwrite,
    print.mat = print.mat,
    ...
  )
}
