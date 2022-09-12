## Resubmission rempsyc 0.0.8

> Please omit "+ file LICENSE" and the file itself which is part of R anyway. It is only used to specify additional restrictions to the GPL such as attribution requirements.

* Fixed.

> openxlsx2 [...] This seems to be still in development and the web page warns about API changes. Something in there why you cannot use openxlsx?

* rempsyc package already has a function `cormatrix_excel` that relies on openxlsx. There is also a second version of this function, `cormatrix_excel2`, that relies on openxlsx2 for a specific feature that openxlsx does not support. Documentation for `cormatrix_excel2` warns users about this: "WARNING: This function will replace `cormatrix_excel` (the original one) as soon as `openxlsx2` is available from CRAN. In the meanwhile, it is experimental and subject to change. Use with care."

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

* There is a message about a suggested package not in mainstream repositories. This package is available on the r-universe repository, and is only used for an optional function that checks if the package is installed, and asks whether to install it, if desired. This package is not available on CRAN yet but is necessary for that particular optional feature.

* There is a message about (possibly) invalid URLs (https://doi.org/10.1177/17470218211024826 and https://doi.org/10.1111/jac.12220) with Status: 503. However, these links were confirmed valid and both their doi version and journal version exhibit the same behaviour.
