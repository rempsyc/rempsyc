# Development objectives (to-do list)
* Plot functions
    * Make my own `ggplot2` theme to reuse in my functions and shorten the code
* `nice_t_test`
    * Add optional Bonferroni correction argument (and other corrections if possible)
* `nice_mod`
    * Add an optional `mod.id` argument to tease apart the different models
    * Add support for more complicated models
* `nice_slopes`
    * Add support for multiple moderators (like for `nice_mod`)
    * Add support for more complicated models
* `nice_qq`
    * Add support for only 1 group like for nice_violin
* `nice_table`
    * Add the ability to pass a model instead of individual arguments
    * Add the ability to pass existing flextables
    * Tutorial: show how to add different levels of headers, etc.
    * Add optional arguments for table header and footnote
    * Remove redundant code in flextable formatters by making it a function
* `nice_varplot`
    * Add option to standardize or not
    * Also add option to annotate Levene test on the plot
* `nice_contrasts`
    * Publish function
    * Check error with `iris` dataset
    * Need to accommodate: interactions/moderations in the models
    * Also add option to specify contrasts manually
* Fix recommended practices
    * Change for `vapply` instead of `sapply`
* All functions
    * Check for consistency among argument names like response/variable
        * Check at other functions to see what's most typically used
    * Add documentation for outputs
* Finish writing all function tests
* Write a manual
* Write a vignette
* Make a website
* Suggest collaboration with easystats
* Submit to CRAN
