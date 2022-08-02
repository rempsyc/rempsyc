#' @title Easy export of correlation matrix to Excel
#'
#' @description Easily output a correlation matrix and export it to
#' Microsoft Excel, with the first row and column frozen, and
#' correlation coefficients colour-coded based on effect size
#' (0.0-0.2: small (no colour); 0.2-0.4: medium (pink); 0.4-1.0:
#' large (red)), following Cohen's suggestions for small (.10),
#' medium (.30), and large (.50) correlation effect sizes.
#'
#' Based on the `correlation` and `openxlsx` packages.
#'
#' @param data The data frame
#' @param filename Desired filename (path can be added before hand
#' but no need to specify extension).
#' @param overwrite Whether to allow overwriting previous file.
#' @param ... Parameters to be passed to the `correlation` package
#' (see `?correlation::correlation`)
#'
#' @keywords correlation, matrix, Excel
#' @author Original author: @JanMarvin
#' @export
#' @examples
#' \dontrun{
#' # Basic example
#' cormatrix_excel2(mtcars)
#' cormatrix_excel2(iris, p_adjust = "none")
#' cormatrix_excel2(airquality, method = "spearman")
#' }
#'

cormatrix_excel2 <- function(data,
                             filename = "cormatrix",
                             overwrite = TRUE,
                             ...) {
  rlang::check_installed("openxlsx2", reason = "for this function.")

# create correlation matrix with p values
cm <- data %>%
  correlation::correlation(...) %>%
  summary(redundant = TRUE)
all.columns <- 2:(ncol(cm))
print(cm)
pf <- attr(cm, "p")

# Define colours
style_gray <- c(rgb = "C1CDCD")
style_black <- c(rgb = "000000")
style_white <- c(rgb = "FFFFFF")
style_red <- c(rgb = "F65534")
style_orange <- c(rgb = "FFA500")
style_pink <- c(rgb = "FBCAC0")
style_green1 <- c(rgb = "698B22")
style_green2 <- c(rgb = "9ACD32")
style_green3 <- c(rgb = "B3EE3A")
style_lightblue <- c(rgb = "97FFFF")
style_darkblue <- c(rgb = "00BFFF")

# Colours
gray_style <- openxlsx2::create_dxfs_style(bgFill = style_gray,
                                           font_color = style_black,
                                           numFmt = "#.#0 _*_*_*")
red_style <- openxlsx2::create_dxfs_style(bgFill = style_green3,
                                          font_color = style_black,
                                          numFmt = "#.#0 _*_*_*")
pink_style <- openxlsx2::create_dxfs_style(bgFill = style_pink,
                                           font_color = style_black,
                                           numFmt = "#.#0 _*_*_*")

p_style <- openxlsx2::create_dxfs_style(bgFill = style_white,
                                        font_color = style_black,
                                        numFmt = "#.##0")
p_style1 <- openxlsx2::create_dxfs_style(bgFill = style_green1,
                                         font_color = style_black,
                                         numFmt = "#.##0")
p_style2 <- openxlsx2::create_dxfs_style(bgFill = style_green2,
                                         font_color = style_black,
                                         numFmt = "#.##0")
p_style3 <- openxlsx2::create_dxfs_style(bgFill = style_green3,
                                         font_color = style_black,
                                         numFmt = "#.##0")


# Stars
no_star    <- openxlsx2::create_dxfs_style(numFmt = "#.#0 _*_*_*",
                                             font_color = style_black,
                                             bgFill = style_white)

# one star
one_star <- openxlsx2::create_dxfs_style(numFmt = "#.#0 \\*_*_*",
                                             font_color = style_black,
                                             bgFill = style_white)
one_star_pink <- openxlsx2::create_dxfs_style(numFmt = "#.#0 \\*_*_*",
                                              font_color = style_black,
                                              bgFill = style_pink)
one_star_red <- openxlsx2::create_dxfs_style(numFmt = "#.#0 \\*_*_*",
                                             font_color = style_black,
                                             bgFill = style_red)
one_star_lightblue <- openxlsx2::create_dxfs_style(numFmt = "#.#0 \\*_*_*",
                                                   font_color = style_black,
                                                   bgFill = style_lightblue)
one_star_darkblue <- openxlsx2::create_dxfs_style(numFmt = "#.#0 \\*_*_*",
                                                  font_color = style_black,
                                                  bgFill = style_darkblue)

# two stars
two_stars <- openxlsx2::create_dxfs_style(numFmt = "#.#0 \\*\\*_*",
                                          font_color = style_black,
                                          bgFill = style_white)
two_stars_pink <- openxlsx2::create_dxfs_style(numFmt = "#.#0 \\*\\*_*",
                                               font_color = style_black,
                                               bgFill = style_pink)
two_stars_red <- openxlsx2::create_dxfs_style(numFmt = "#.#0 \\*\\*_*",
                                              font_color = style_black,
                                              bgFill = style_red)
two_stars_lightblue <- openxlsx2::create_dxfs_style(numFmt = "#.#0 \\*\\*_*",
                                                    font_color = style_black,
                                                    bgFill = style_lightblue)
two_stars_darkblue <- openxlsx2::create_dxfs_style(numFmt = "#.#0 \\*\\*_*",
                                                   font_color = style_black,
                                                   bgFill = style_darkblue)

# three stars
three_stars <- openxlsx2::create_dxfs_style(numFmt = "#.#0 \\*\\*\\*",
                                            font_color = style_black,
                                            bgFill = style_white)
three_stars_pink <- openxlsx2::create_dxfs_style(numFmt = "#.#0 \\*\\*\\*",
                                                 font_color = style_black,
                                                 bgFill = style_pink)
three_stars_red <- openxlsx2::create_dxfs_style(numFmt = "#.#0 \\*\\*\\*",
                                                font_color = style_black,
                                                bgFill = style_red)
three_stars_lightblue <- openxlsx2::create_dxfs_style(numFmt = "#.#0 \\*\\*\\*",
                                                      font_color = style_black,
                                                      bgFill = style_lightblue)
three_stars_darkblue <- openxlsx2::create_dxfs_style(numFmt = "#.#0 \\*\\*\\*",
                                                     font_color = style_black,
                                                     bgFill = style_darkblue)

# create openxlsx2 workbook
wb <- openxlsx2::wb_workbook()

# assign all the required styles to the workbook
wb$styles_mgr$add(red_style, "red_style")
wb$styles_mgr$add(red_style, "pink_style")
wb$styles_mgr$add(gray_style, "gray_style")
wb$styles_mgr$add(no_star, "no_star")
wb$styles_mgr$add(one_star, "one_star")
wb$styles_mgr$add(one_star_pink, "one_star_pink")
wb$styles_mgr$add(one_star_red, "one_star_red")
wb$styles_mgr$add(one_star_lightblue, "one_star_lightblue")
wb$styles_mgr$add(one_star_darkblue, "one_star_darkblue")
wb$styles_mgr$add(two_stars, "two_stars")
wb$styles_mgr$add(two_stars_pink, "two_stars_pink")
wb$styles_mgr$add(two_stars_red, "two_stars_red")
wb$styles_mgr$add(two_stars_lightblue, "two_stars_lightblue")
wb$styles_mgr$add(two_stars_darkblue, "two_stars_darkblue")
wb$styles_mgr$add(three_stars, "three_stars")
wb$styles_mgr$add(three_stars_pink, "three_stars_pink")
wb$styles_mgr$add(three_stars_red, "three_stars_red")
wb$styles_mgr$add(three_stars_lightblue, "three_stars_lightblue")
wb$styles_mgr$add(three_stars_darkblue, "three_stars_darkblue")
wb$styles_mgr$add(p_style, "p_style")
wb$styles_mgr$add(p_style1, "p_style1")
wb$styles_mgr$add(p_style2, "p_style2")
wb$styles_mgr$add(p_style3, "p_style3")
wb$styles_mgr$styles$dxfs
wb$styles_mgr$dxf

# create the worksheets and write the data to the worksheets.
wb$add_worksheet("r_values")$add_data(x = cm)
wb$add_worksheet("p_values")$add_data(x = pf)

# create conditional formatting for the stars (as well as colours as we have no)
# one star
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(r_values!B2 >= 0.2, p_values!B2 < .05)",
  style = "one_star_pink")
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(r_values!B2 >= 0.4, p_values!B2 < .05)",
  style = "one_star_red")
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(r_values!B2 < 0.2, r_values!B2 > -0.2, p_values!B2 < .05)",
  style = "one_star")
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(r_values!B2 <= -.02, p_values!B2 < .05)",
  style = "one_star_lightblue")
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(r_values!B2 <= -0.4, p_values!B2 < .05)",
  style = "one_star_darkblue")

# two stars
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(r_values!B2 >= 0.2, p_values!B2 < .01)",
  style = "two_stars_pink")
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(r_values!B2 >= 0.4, p_values!B2 < .01)",
  style = "two_stars_red")
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(r_values!B2 < 0.2, r_values!B2 > -0.2, p_values!B2 < .01)",
  style = "two_stars")
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(r_values!B2 <= -.02, p_values!B2 < .01)",
  style = "two_stars_lightblue")
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(r_values!B2 <= -0.4, p_values!B2 < .01)",
  style = "two_stars_darkblue")

# three stars
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(r_values!B2 >= 0.2, p_values!B2 < .001)",
  style = "three_stars_pink")
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(r_values!B2 >= 0.4, p_values!B2 < .001)",
  style = "three_stars_red")
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(r_values!B2 < 0.2, r_values!B2 > -0.2, p_values!B2 < .001)",
  style = "three_stars")
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(r_values!B2 <= -.02, p_values!B2 < .001)",
  style = "three_stars_lightblue")
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(r_values!B2 <= -0.4, p_values!B2 < .001)",
  style = "three_stars_darkblue")

# Other formatting
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(r_values!B2 = 1)",
  style = "gray_style")
wb$add_conditional_formatting(
  "r_values",
  cols = all.columns,
  rows = all.columns,
  rule = "AND(p_values!B2 >= .05)",
  style = "no_star")

# p-values
wb$add_conditional_formatting("p_values",
                              cols = all.columns,
                              rows = all.columns,
                              rule = "< 10",
                              style = "p_style")
wb$add_conditional_formatting("p_values",
                              cols = all.columns,
                              rows = all.columns,
                              rule = "< .05",
                              style = "p_style1")
wb$add_conditional_formatting("p_values",
                              cols = all.columns,
                              rows = all.columns,
                              rule = "< .01",
                              style = "p_style2")
wb$add_conditional_formatting("p_values",
                              cols = all.columns,
                              rows = all.columns,
                              rule = "< .001",
                              style = "p_style3")
wb$add_conditional_formatting("p_values",
                              cols = all.columns,
                              rows = all.columns,
                              rule = "== 0",
                              style = "gray_style")

## Freeze Panes
wb$freeze_pane("r_values", firstCol = TRUE, firstRow = TRUE)
wb$freeze_pane("p_values", firstCol = TRUE, firstRow = TRUE)

# open in Excel
#wb$open()

# Save Excel
cat(paste0(
  "\n\n [Correlation matrix '", filename,
  ".xlsx' has been saved to working directory (or where specified).]"
))
openxlsx2::wb_save(wb, path = paste0(filename, ".xlsx"), overwrite = TRUE)
openxlsx2::xl_open(paste0(filename, ".xlsx"))

#openxlsx::openXL(paste0(filename, ".xlsx"))

}
