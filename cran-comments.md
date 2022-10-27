## Submission rempsyc 0.1.0

R CMD check results

0 errors | 0 warnings | 0 notes

## Resubmission rempsyc 0.0.9

> Please omit the redundant "Convenience functions to" at the start of your description.

* Fixed.

> Please add \value to .Rd files regarding exported methods and explain the functions results in the documentation. Please write about the structure of the output (class) and also what the output means.
(If a function does not return a value, please document that too, e.g.
\value{No return value, called for side effects} or similar) Missing Rd-tags in up to 26 .Rd files, e.g.:
      cormatrix_excel.Rd: \value
      cormatrix_excel2.Rd: \value
      find_mad.Rd: \value
      format_value.Rd: \value
      lmSupport_modelEffectSizes.Rd: \value
      nice_assumptions.Rd: \value
      ...

* Fixed.

> Some code lines in examples are commented out.
Please never do that. Ideally find toy examples that can be regularly executed and checked. Lengthy examples (> 5 sec), can be wrapped in \donttest{}.
Examples in comments in:
       overlap_circle.Rd

* Fixed.

> \dontrun{} should only be used if the example really cannot be executed (e.g. because of missing additional software, missing API keys, ...) by the user. That's why wrapping examples in \dontrun{} adds the comment ("# Not run:") as a warning for the user.
Does not seem necessary.
Please replace \dontrun with \donttest.

* Fixed.

> You write information messages to the console that cannot be easily suppressed.
It is more R like to generate objects that can be used to extract the information a user is interested in, and then print() that object.
Instead of print()/cat() rather use message()/warning() or
if(verbose)cat(..) (or maybe stop()) if you really have to write text to the console.
(except for print, summary, interactive functions)

* Fixed.

> Please ensure that your functions do not write by default or in your examples/vignettes/tests in the user's home filespace (including the package directory and getwd()). This is not allowed by CRAN policies.
Please omit any default path in writing functions. -> R/cormatrix_excel2.R In your examples/vignettes/tests you can write to tempdir(). -> man/nice_scatter.Rd; man/nice_violin.Rd

* Fixed.

## Resubmission rempsyc 0.0.8

> Please omit "+ file LICENSE" and the file itself which is part of R anyway. It is only used to specify additional restrictions to the GPL such as attribution requirements.

* Fixed.

> openxlsx2 [...] This seems to be still in development and the web page warns about API changes. Something in there why you cannot use openxlsx?

* rempsyc package already has a function `cormatrix_excel` that relies on openxlsx. There is also a second version of this function, `cormatrix_excel2`, that relies on openxlsx2 for a specific feature that openxlsx does not support. Documentation for `cormatrix_excel2` warns users about this: "WARNING: This function will replace `cormatrix_excel` (the original one) as soon as `openxlsx2` is available from CRAN. In the meanwhile, it is experimental and subject to change. Use with care."

## R CMD check results

0 errors | 0 warnings | 2 notes

* This is a new release.

* There is a note about a suggested package not in mainstream repositories. This package is available on the r-universe repository, and is only used for an optional function that checks if the package is installed, and asks whether to install it, if desired. This package is not available on CRAN yet but is necessary for that particular optional feature.

* There is a message about (possibly) invalid URLs (https://doi.org/10.1177/17470218211024826 and https://doi.org/10.1111/jac.12220) with Status: 503. However, these links were confirmed valid and both their doi version and journal version exhibit the same behaviour.
