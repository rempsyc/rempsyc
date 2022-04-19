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
