# rempsyc 0.1.x
* Future updates here.

## rempsyc 0.0.9.6
* We get rid of `car_Anova` and `lmsupport_modeleffectsizes` and now compute the sr2 ourselves! With the help of our friends `insight` and `performance`.

## rempsyc 0.0.9.5
* `rempsyc` gets lighter, as we get rid of the rather large `car` package dependency (by incorporating the single function we were using, `Anova`), and move other packages (`boot`, `lmtest`, `ggrepel`, `ggsignif`, and `qqplotr`) from required to suggested packages.

## rempsyc 0.0.9.4
* `nice_table`: automatic formatting (of p-values, confidence intervals, etc.) now supports more than two levels of headers (with the `separate.header` argument).

## rempsyc 0.0.9.3
* Now that `openxlsx2` is on CRAN, `cormatrix_excel2` now replaces `cormatrix_excel` (and `rempsyc` package does not rely on an external GitHub dependency anymore, yeah!).

## rempsyc 0.0.9.2
* `nice_table`: Multilevel headings, with the `separate.header` argument, now supports automatic formatting (of p-values, confidence intervals, etc.).

## rempsyc 0.0.9.1
* `nice_table`: 
    * fixed sr2 incorrectly showing leading zero.
    * new argument: `col.format.ci`, to format confidence intervals (accepts lists of lower and upper thresholds)
* `find_mad` and `nice_assumptions`: fixed printing method

# rempsyc 0.0.9
* CRAN resubmission!

## rempsyc 0.0.8.2
* `nice_var`: now returns a dataframe instead of a tibble
* Updated docs: all functions now have `value`/`return` fields describing the function's output.
* `cormatrix_excel` and `cormatrix_excel2`: now require an explicit file name, as per CRAN policies.

## rempsyc 0.0.8.1
* New function: `extract_duplicates`, to extract all duplicates (including first one) for closer inspection
* New function: `best_duplicate`, to keep only the best duplicate based on the number of missing values
* nice_na: `all_na` output column now also counts non-numeric variables

# rempsyc 0.0.8
* CRAN resubmission!

# rempsyc 0.0.7
* First CRAN submission!
* This requires bumping the package version to 2 decimals only.

## rempsyc 0.0.6.6
* Preparing for CRAN submission.

## rempsyc 0.0.6.5
* `nice_normality`: `breaks.auto` argument now uses `na.rm = TRUE` to support missing values

## rempsyc 0.0.6.4
* `nice_normality`: `breaks.auto` argument added to allow control of the density plot in this aspect.

## rempsyc 0.0.6.3
* `nice_density`: Switch back to not using the Sturges method per default.
* `nice_table`: Internal change to stay compatible with new `flextable` version

## rempsyc 0.0.6.2
* `nice_density`: Now uses `na.rm = TRUE` internally to support data with missing values.

## rempsyc 0.0.6.1
* `find_mad`: New argument `mad.scores` to return robust zscore (MAD) scores instead of raw scores (now default to TRUE).

# rempsyc 0.0.6
* `nice_density`: Now uses the Sturges method to define the optimal number of bins automatically. Also adds two new arguments: `breaks.auto = TRUE`, if one does not want to use the Sturges method, and `bins = 30`, to define bins manually, if needed.

## rempsyc 0.0.5.9
* `cormatrix_excel2`: Added a third (sixth) colour for one star significances (* = p < .05), and add an argument for printing the correlation matrix to the console too (or not), `print.mat`.

## rempsyc 0.0.5.8
* `nice_table`: Added `chi2` automatic formatting (+ `chi2.df` formatting)

## rempsyc 0.0.5.7
* `nice_na`: integrated a feature request to include the number of rows that were all NAs.

## rempsyc 0.0.5.6
* New function: `cormatrix_excel2`: a new version of `cormatrix_excel` relying on the `openxlsx2` package and that allows incorporating significance stars along the correlation matrix, as well as a second sheet containing the matrix of p-values. Experimental until `openxlsx2` reaches CRAN.

## rempsyc 0.0.5.5
* Fixed `nice_randomize` as it had been outputting the wrong output format for within-subject designs when moving from plyr to dplyr (+ updated runsheet tutorial).
* `nice_table`: changed back from `layout = "fixed"` to `layout = "autofit"` now that `flextable` fixed the unnecessary line breaks for confidence intervals

## rempsyc 0.0.5.4
* `cormatrix_excel`: corrected values for small, medium, large correlations (from 0.0-0.3: small; 0.3-0.6: medium; 0.6-1.0: large to 0.0-0.2: small; 0.2-0.4: medium; 0.4-1.0: large).

## rempsyc 0.0.5.3
* Corrected spelling of all code with `devtools::spell_check()`
* Restyled all code according to the tidyverse guidelines with `styler::style_pkg()`
* `nice_table`: greatly improved APA title feature thanks to @Buedenbender (and shout-out to his package [datscience](https://buedenbender.github.io/datscience/) and function [flex_table1](https://buedenbender.github.io/datscience/reference/format_flextable.html) on which this improvement was based!)

## rempsyc 0.0.5.2
* `nice_table`: added new argument, `separate.header`, a logical (and simplified) form of the `flextable::separate_header` argument.

## rempsyc 0.0.5.1
* New package site, hooray!
* `cormatrix_excel`: 
    * Changed default method of base `cor` function from "na.or.complete" to the most liberal one to match SPSS: "pairwise.complete.obs".
    * Added a `use` argument to specify which one to use in case a user wants a different option.
* `nice_table`:
    * Automatized integration with the `report` package so we don't have to specify the e.g. `report = "lm"` argument manually.
    * Added optional arguments for table title and footnote.
* Many functions (based on `goodpractice` package recommendations): 
    * Changed `sapply` for `lapply` since `sapply` is not recommended and using `vapply` with list outputs was too complicated.
    * Shortened line codes to < 80 characters.
    * Replaced 1:length(...) or 1:nrow(...) by seq_along(...).

# rempsyc 0.0.5
* `nice_na`: added scales argument to specify specific scales

## rempsyc 0.0.4.9
* New function: `nice_NA`; nicely reports NA values according to existing guidelines. This function reports both absolute and percentage values of specified column lists.

## rempsyc 0.0.4.8
* `nice_density` and `nice_normality`: added the possibility to provide no group argument so as to have a plot of all data.

## rempsyc 0.0.4.7
* `nice_violin`: made default contour lines thicker, but also added argument `border.size` to allow customization.

## rempsyc 0.0.4.6
* `nice_violin`: Corrected a bug whereas the Cohen's *d* wasn't added to the plot if manual annotation (as opposed to automatic) comparisons were made. Also, the default test used in `geom_signif::geom_signif()` was the Wilcox test. It has been changed to the t-test to avoid confusion when results mismatch. Finally, the contour lines were made thicker since at high resolution they appeared too thin.
* New function: `format_d` to format d values as e.g., `0.30` instead of `0.3` e.g., on violin plots.

## rempsyc 0.0.4.5
* `nice_violin`: Added the ability to add the Cohen's d to the plot

## rempsyc 0.0.4.4
* `find_mad`: improved reporting of ID and row number

## rempsyc 0.0.4.3
* `nice_table`: changed default table width (again)

## rempsyc 0.0.4.2
* `nice_table`: changed default table width

## rempsyc 0.0.4.1
* `find_mad`: corrected a bug whereas having a dataframe with no outliers in certain situations generated an error

# rempsyc 0.0.4
* `nice_density` and `nice_normality`: added the `histogram` option to add an histogram to the density plot.

## rempsyc 0.0.3.9
* Created an internal ggplot2 APA "theme" to avoid code redundancy across plots

## rempsyc 0.0.3.8
* `nice_table`: greatly improved underlying code: more clarity (dplyr) and less repetition (with added internal functions)

## rempsyc 0.0.3.7
* `nice_violin`: reverted theme to original default (alpha = 1 and black border) from modified theme some time ago (alpha = .70, white border). Users wishing to keep the original style can simply specify these options in their script.

## rempsyc 0.0.3.6
* New function: `nice_contrasts` for planned contrasts (multiple group pairwise comparisons)

## rempsyc 0.0.3.5
* `nice_t_test`: Fixed `mu` value for one-sample t-test

## rempsyc 0.0.3.4
* Added `ggplot2::waiver` to reexports
* Added table of content to readme

## rempsyc 0.0.3.3
* `find_mad`: Now only prints individual variables that do have outliers. However, it now lists all variables checked at the top to avoid possible confusion.
* Also reformatted arguments vertically instead of horizontally within functions for clarity (doesn't affect users or documentation proper).

## rempsyc 0.0.3.2
* `nice_t_test`: Added support for one-sample t-test.

## rempsyc 0.0.3.1
* new functions for the median absolute deviation (MAD): `find_mad` to find outliers based on the MAD, `scale_mad` to scale (standardize) data based on the MAD, and winsorize_mad to winsorize (bring outliers in +/3 SD) based on the MAD.

# rempsyc 0.0.3
* `nice_table`: brought a correction to the automatic 95% CI so that when numbers are rounded to 0, the zeros still show (e.g., 0.20 instead of 0.2).

## rempsyc 0.0.2.9
* `nice_normality`: improved implementation of the `title` argument
* `nice_table`: added *N* as italic in header

## rempsyc 0.0.2.8
* `nice_table` 
    * integration with `broom` package: moved columns Method and Alternative to beginning for consistency with treatment of the `report` package.
    * Fixed appropriate decimals display for degrees of freedom with actual decimals (e.g., for Welch t-test).
* `nice_t_test`: Added optional Bonferroni correction argument (and other corrections if possible). Other corrections to be implemented in the future.

## rempsyc 0.0.2.7
* `nice_t_test`: changed from package `effsize` to `effectsize` for effect size because the Cohen's d value for paired samples wasn't consistent with other packages.

## rempsyc 0.0.2.6
* Integration with `report` package: combined CI_low and CI_high for method `t.test` (just like for method `lm`)
* Added an optional `short` argument to get a more concise table output from the `report` package integration

## rempsyc 0.0.2.5
* Fixed a slight model number mix-up in `nice_slopes`.

## rempsyc 0.0.2.4
* Added support for paired t-tests (only adaptation of Cohen's d was necessary) and updated documentation to give multiple examples of t-test customization.

## rempsyc 0.0.2.3
* Added warning to `nice_t_test` informing users about the Welch t-test being used per default (through base R `t.test`'s default) and how to change it. Also added option to turn off this warning.

## rempsyc 0.0.2.2
* new function: `nice_lm` to format any existing `lm` model object in a proper format for `nice_table`, including sr2
* new function: `nice_lm_slopes` to format simple slopes for any existing `lm` model object in a proper format for `nice_table`, including sr2
* `nice_mod` and `nice_slopes`: 
    * Added model number when more then one model.
    * Also added an optional `mod.id = TRUE` argument, to display the model number, when there is more than one model.
    * Also reordered default order of rows when there is a second moderator present as it makes more sense to group the same models completely together for different levels of the second moderator.
    * By combining the row names within the list object rather than in the combined dataframe, we also don't have to worry about changing names, etc. anymore. Thus it is now cleaner and not missing with variable names.

## rempsyc 0.0.2.1
* `nice_mod` and `nice_slopes`: Added an argument `b.label` to rename b, e.g., to capital B if using standardized data for it to be converted to the Greek beta symbol automatically in the `nice_table` function.

# rempsyc 0.0.2
* nice_mod and nice_slopes: Corrected a bug whereas having column names with periods would cut off the variable names before the dots because of the automatic correction of the interaction term row names which contain periods as well.

## rempsyc 0.0.1.9
* Added a `NEWS.md` file to track changes to the package.
* Improved `report` package integration with `nice_table`
 
## rempsyc 0.0.1.8
* Moved some packages to suggest with `rlang::check_installed`. Make the package lighter.
* Added compatibility of `nice_table` with the `report` package

## rempsyc 0.0.1.7
* `nice_table`: changed argument name `dataframe` for `data` for consistency.

## rempsyc 0.0.1.6
* Added compatibility of `nice_table` with the broom package
* `nice_randomize`: sorted 'within' group by id (as it should have always been)
* Realized that trying to have tidy selection and not having to quote arguments creates problems for vectorization. So we are back to quoted arguments on `nice_scatter` and `nice_varplot`.
* Integrated `format_p` internally in the other functions
* `nice_scatter` and `nice_varplot`: now allow to directly provide the group argument without having to convert to factor manually. Also allow to remove line to just keep points.
* Added jitter to `varplot` function

## rempsyc 0.0.1.5
* Added criteria argument to `nice_var` to specify the desired threshold. Also moved data argument first for pipe compatibility.
* Significant overhaul to functions, such as changes of argument names order.

## rempsyc 0.0.1.4
* new function: `nice_normality`

## rempsyc 0.0.1.3
* added new function: `format_values`
* Added new function: `cormatrix_excel`
* Fixed the `geom_smooth() using formula 'y ~ x'" warning in nice_scatter()` error
* removed row names from `nice_t_test`
* added width argument to `nice_table`

## rempsyc 0.0.1.2
* removed dependency on `plyr`

## rempsyc 0.0.1.1
* added new function: `nice_reverse()`

# rempsyc 0.0.1
* integrated `rcompanion::groupwiseMean` internally with documentation
* removed `lmSupport_modelEffectSizes` from exports to use as internal function only
* removed `crayon` package dependency
