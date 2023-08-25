# Development objectives (to-do list)

* `cormatrix_excel`:
  * add argument to specify only half of matrix (lower half) for cormatrix_excel function?
* `nice_lm_contrasts`:
  * improve function and add to contrasts vignette!
* `nice_contrasts`
  * Need to accommodate: interactions/moderations in the models [kind of done with `nice_lm_contrasts`?]
  * Also add option to specify contrasts manually [maybe just refer users to other packages for this?]
  * Add option to not use bootstrapping (waiting on dgerlanc/bootES#11)
* `rcompanion_groupwiseMean`
  * Rewrite with only the `boot` package and `dplyr::group_by`?
* `nice_t_test`
  * Add other optional corrections argument (other than Bonferroni) - can use easystats' effectsize maybe?
  * Add option to specify `robust.d` for a robust version of Cohen's d
  * Add option `bootstrapped.CI` to use a bootstrapped version of the 95% CI
  * Add option to display group means(?)
* `nice_varplot`
  * Add option to standardize or not
  * Also add option to annotate Levene test on the plot
  * Use violin points, and group-mean centered (but not standardized)
* `nice_table`
  * Integration: add meaningful error messages when using `lm` or `t.test` with wrong model type.
  * Remove unwanted italic formatting of headers when using `separate.header = TRUE`.
* `nice_normality`
  * Change `shapiro = T/F` for `test = Shapiro/KS/auto(Shapiro for n<=50, KS for above)`
  * Fix error if no dv variation in one of the groups.
  * Add option to add SEs, skewness, kurtosis 
* all `lm` functions
  * Correct bug with factors in `lm` models (use data matrix as in `easystats`?)
* `nice_lm_slopes`
  * Support second moderator
* `nice_slopes`
  * Add support for multiple moderators (like for `nice_mod`)
* All functions
  * Check for consistency among argument names like response/variable
      * Check other packages to see what's most typically used
  * Triple check support for missing values
