#' @title Easy export of correlation matrix to Excel
#'
#' @description Easily output a correlation matrix and export it to
#' Microsoft Excel, with the first row and column frozen, and
#' correlation coefficients colour-coded based on their effect size
#' (0.0-0.2: small (no colour); 0.2-0.4: medium (pink); 0.4-1.0:
#' large (red)).
#'
#' @param data The data frame
#' @param filename Desired filename (path can be added before hand
#' but no need to specify extension).
#' @param overwrite Whether to allow overwriting previous file.
#' @param use How to handle NA (see `?cor` for options).
#'
#' @keywords correlation matrix Excel
#' @return A Microsoft Excel document, containing the colour-coded
#'         correlation matrix.
#' @export
#' @examples
#' \dontshow{.old_wd <- setwd(tempdir())}
#' # Basic example
#' cormatrix_excel(mtcars, "cormatrix")
#' \dontshow{setwd(.old_wd)}
cormatrix_excel <- function(data,
                            filename,
                            overwrite = TRUE,
                            use = "pairwise.complete.obs") {

  if (missing(filename)) {
    stop("Argument 'filename' now required (as per CRAN policies)")
  }

  rlang::check_installed("openxlsx", reason = "for this function.")
  my.cor.matrix <- stats::cor(data, use = use)
  my.cor.matrix <- as.data.frame(my.cor.matrix)

  print(round(my.cor.matrix, 2))

  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "Sheet 1")
  openxlsx::writeData(wb, sheet = 1, my.cor.matrix, rowNames = TRUE)

  all.columns <- 1:(ncol(my.cor.matrix) + 1)

  my.style <- openxlsx::createStyle(numFmt = "0.00")
  openxlsx::addStyle(wb,
    sheet = 1,
    style = my.style,
    rows = all.columns,
    cols = all.columns,
    gridExpand = TRUE
  )

  diagonalStyle <- openxlsx::createStyle(bgFill = "gray")
  mediumStyle <- openxlsx::createStyle(bgFill = "#FBCAC0")
  largeStyle <- openxlsx::createStyle(bgFill = "#F65534")

  openxlsx::conditionalFormatting(wb,
    "Sheet 1",
    cols = all.columns,
    rows = all.columns,
    rule = "==1",
    style = diagonalStyle
  )
  openxlsx::conditionalFormatting(wb,
    "Sheet 1",
    cols = all.columns,
    rows = all.columns,
    rule = c(0.2, 0.39999999),
    style = mediumStyle,
    type = "between"
  )
  openxlsx::conditionalFormatting(wb,
    "Sheet 1",
    cols = all.columns,
    rows = all.columns,
    rule = c(-0.2, -0.39999999),
    style = mediumStyle,
    type = "between"
  )
  openxlsx::conditionalFormatting(wb,
    "Sheet 1",
    cols = all.columns,
    rows = all.columns,
    rule = c(0.4, 0.9999999),
    style = largeStyle,
    type = "between"
  )
  openxlsx::conditionalFormatting(wb,
    "Sheet 1",
    cols = all.columns,
    rows = all.columns,
    rule = c(-0.4, -0.9999999),
    style = largeStyle,
    type = "between"
  )
  openxlsx::freezePane(wb, "Sheet 1", firstCol = TRUE, firstRow = TRUE)

  openxlsx::saveWorkbook(
    wb,
    file = paste0(filename, ".xlsx"),
    overwrite = overwrite
  )
  cat(paste0(
    "\n [Correlation matrix '", filename,
    ".xlsx' has been saved to working directory (or where specified).]"
  ))
}

