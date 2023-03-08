patterns1 <- c(
  'style="width:60.0%" />',
  'style="width:80.0%" />',
  '<img src="paper_files/figure-markdown_strict/broom-1.png"',
  '<img src="paper_files/figure-markdown_strict/report-1.png"',
  '<img src="paper_files/figure-markdown_strict/highlight-1.png"',
  '<img src="paper_files/figure-markdown_strict/nice_t_test-1.png"',
  '<img src="paper_files/figure-markdown_strict/nice_contrasts-1.png"',
  '<img src="paper_files/figure-markdown_strict/nice_lm-1.png"',
  '<img src="paper_files/figure-markdown_strict/nice_lm_slopes-1.png"',
  '<img src="paper_files/figure-markdown_strict/nice_violin-1.png" width="60%" />',
  '<img src="paper_files/figure-markdown_strict/nice_scatter-1.png" width="60%" />',
  '<img src="paper_files/figure-markdown_strict/nice_scatter-2.png" width="60%" />',
  '<img src="paper_files/figure-markdown_strict/overlap_circle-1.png" width="40%" />',
  '![](paper_files/figure-markdown_strict/nice_normality-1.png){width=100%}',
  '<img src="paper_files/figure-markdown_strict/plot_outliers-1.png" width="60%" />',
  '<img src="paper_files/figure-markdown_strict/nice_var-1.png" width="70%" />',
  '<img src="paper_files/figure-markdown_strict/nice_var_plot-1.png" width="70%" />'
)

patterns2 <- c(
  "",
  "",
  "![](paper_files/figure-markdown_strict/broom-1.png){width=60%}",
  "![](paper_files/figure-markdown_strict/report-1.png){width=80%}",
  "![](paper_files/figure-markdown_strict/highlight-1.png){width=80%}",
  "![](paper_files/figure-markdown_strict/nice_t_test-1.png){width=70%}",
  "![](paper_files/figure-markdown_strict/nice_contrasts-1.png){width=80%}",
  "![](paper_files/figure-markdown_strict/nice_lm-1.png){width=80%}",
  "![](paper_files/figure-markdown_strict/nice_lm_slopes-1.png){width=80%}",
  "![](paper_files/figure-markdown_strict/nice_violin-1.png){width=60%}",
  "![](paper_files/figure-markdown_strict/nice_scatter-1.png){width=60%}",
  "![](paper_files/figure-markdown_strict/nice_scatter-2.png){width=60%}",
  "![](paper_files/figure-markdown_strict/overlap_circle-1.png){width=40%}",
  "![](paper_files/figure-markdown_strict/nice_normality-1.png){width=100%}",
  "![](paper_files/figure-markdown_strict/plot_outliers-1.png){width=60%}",
  "![](paper_files/figure-markdown_strict/nice_var-1.png){width=70%}",
  "![](paper_files/figure-markdown_strict/nice_var_plot-1.png){width=70%}"
)

tx  <- readLines("paper/paper.md")

for (i in 1:length(patterns1)) {
  tx <- gsub(patterns1[i], patterns2[i], tx, fixed = TRUE)
}

writeLines(tx, con="paper/paper.md")
