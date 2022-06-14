### rempsyc 0.0.4.5
* `nice_violin`: Added the ability to add the cohen's d to the plot

### rempsyc 0.0.4.4
* `find_mad`: improved reporting of ID and row number

### rempsyc 0.0.4.3
* `nice_table`: changed default table width (again)

### rempsyc 0.0.4.2
* `nice_table`: changed default table width

### rempsyc 0.0.4.1
* `find_mad`: corrected a bug whereas having a dataframe with no outliers in certain situations generated an error

### rempsyc 0.0.4.0
* `nice_density` and `nice_normality`: added the `histogram` option to add an histogram to the density plot.

### rempsyc 0.0.3.9
* Created an internal ggplot2 APA "theme" to avoid code redundancy across plots

### rempsyc 0.0.3.8
* `nice_table`: greatly improved underlying code: more clarity (dplyr) and less repetition (with added internal functions)

### rempsyc 0.0.3.7
* `nice_violin`: reverted theme to original default (alpha = 1 and black border) from modified theme some time ago (alpha = .70, white border). Users wishing to keep the original style can simply specify these options in their script.

### rempsyc 0.0.3.6
* New function: `nice_contrasts` for planned contrasts (multiple group pairwise comparisons)

### rempsyc 0.0.3.5
* `nice_t_test`: Fixed `mu` value for one-sample t-test

### rempsyc 0.0.3.4
* Added `ggplot2::waiver` to reexports
* Added table of content to readme

### rempsyc 0.0.3.3
* `find_mad`: Now only prints individual variables that do have outliers. However, it now lists all variables checked at the top to avoid possible confusion.
* Also reformatted arguments vertically instead of horizontally within functions for clarity (doesn't affect users or documentation proper).

### rempsyc 0.0.3.2
* `nice_t_test`: Added support for one-sample t-test.

### rempsyc 0.0.3.1
* new functions for the median absolute deviation (MAD): `find_mad` to find outliers based on the MAD, `scale_mad` to scale (standardize) data based on the MAD, and winsorize_mad to winsorize (bring outliers in +/3 SD) based on the MAD.

### rempsyc 0.0.3.0
* `nice_table`: brought a correction to the automatic 95% CI so that when numbers are rounded to 0, the zeros still show (e.g., 0.20 instead of 0.2).

### rempsyc 0.0.2.9
* `nice_normality`: improved implementation of the `title` argument
* `nice_table`: added *N* as italic in header

### rempsyc 0.0.2.8
* `nice_table` 
    * integration with `broom` package: moved columns Method and Alternative to beginning for consistency with treatment of the `report` package.
    * Fixed appropriate decimals display for degrees of freedom with actual decimals (e.g., for Welch t-test).
* `nice_t_test`: Added optional Bonferroni correction argument (and other corrections if possible). Other corrections to be implemented in the future.

### rempsyc 0.0.2.7
* `nice_t_test`: changed from package `effsize` to `effectsize` for effect size because the Cohen's d value for paired samples wasn't consistent with other packages.

### rempsyc 0.0.2.6
* Integration with `report` package: combined CI_low and CI_high for method `t.test` (just like for method `lm`)
* Added an optional `short` argument to get a more concise table output from the `report` package integration

### rempsyc 0.0.2.5
* Fixed a slight model number mix-up in `nice_slopes`.

### rempsyc 0.0.2.4
* Added support for paired t-tests (only adaptation of Cohen's d was necessary) and updated documentation to give multiple examples of t-test customization.

### rempsyc 0.0.2.3
* Added warning to `nice_t_test` informing users about the Welch t-test being used per default (through base R `t.test`'s default) and how to change it. Also added option to turn off this warning.

### rempsyc 0.0.2.2

* new function: `nice_lm` to format any existing `lm` model object in a proper format for `nice_table`, including sr2
* new function: `nice_lm_slopes` to format simple slopes for any existing `lm` model object in a proper format for `nice_table`, including sr2
* `nice_mod` and `nice_slopes`: 
    * Added model number when more then one model.
    * Also added an optional `mod.id = TRUE` argument, to display the model number, when there is more than one model.
    * Also reordered default order of rows when there is a second moderator present as it makes more sense to group the same models completely together for different levels of the second moderator.
    * By combining the row names within the list object rather than in the combined dataframed, we also don't have to worry about changing names, etc. anymore. Thus it is now cleaner and not missing with variable names.

### rempsyc 0.0.2.1
* `nice_mod` and `nice_slopes`: Added an argument `b.label` to rename b, e.g., to capital B if using standardized data for it to be converted to the Greek beta symbol automatically in the `nice_table` function.

### rempsyc 0.0.2.0
* nice_mod and nice_slopes: Corrected a bug whereas having column names with periods would cut off the variable names before the dots because of the automatic correction of the interaction term row names which contain periods as well.

### rempsyc 0.0.1.9
* Added a `NEWS.md` file to track changes to the package.
* Improved `report` package integration with `nice_table`
 
### rempsyc 0.0.1.8
* Moved some packages to suggest with `rlang::check_installed`. Make the package lighter.
* Added compatibility of `nice_table` with the `report` package

### rempsyc 0.0.1.7
* `nice_table`: changed argument name `dataframe` for `data` for consistency.

### rempsyc 0.0.1.6
* Added compatibility of `nice_table` with the broom package
* `nice_randomize`: sorted 'within' group by id (as it should have always been)
* Realized that trying to have tidy selection and not having to quote arguments creates problems for vectorization. So we are back to quoted arguments on `nice_scatter` and `nice_varplot`.
* Integrated `format_p` internally in the other functions
* `nice_scatter` and `nice_varplot`: now allow to directly provide the group argument without having to convert to factor manually. Also allow to remove line to just keep points.
* Added jitter to `varplot` function

### rempsyc 0.0.1.5
* Added criteria argument to `nice_var` to specify the desired threshold. Also moved data argument first for pipe compatibility.
* Significant overhaul to functions, such as changes of argument names order.

### rempsyc 0.0.1.4
* new function: `nice_normality`

### rempsyc 0.0.1.3
* added new function: `format_values`
* Added new function: `cormatrix_excel`
* Fixed the `geom_smooth() using formula 'y ~ x'" warning in nice_scatter()` error
* removed row names from `nice_t_test`
* added width argument to `nice_table`

### rempsyc 0.0.1.2
* removed dependency on `plyr`

### rempsyc 0.0.1.1
* added new function: `nice_reverse()`

### rempsyc 0.0.0.9000
* integrated `rcompanion::groupwiseMean` internally with documentation
* removed `lmSupport_modelEffectSizes` from exports to use as internal function only
* removed `crayon` package dependency
