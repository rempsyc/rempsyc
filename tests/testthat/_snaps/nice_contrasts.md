# nice_contrasts

    Code
      nice_contrasts(data = mtcars, response = "mpg", group = "cyl", bootstraps = 200)
    Warning <simpleWarning>
      extreme order statistics used as endpoints
      extreme order statistics used as endpoints
    Output
        Dependent Variable Comparison df        t            p        d  CI_lower
      1                mpg      4 - 8 29 8.904534 8.568209e-10 3.587739 2.8061083
      2                mpg      6 - 8 29 3.111825 4.152209e-03 1.440495 0.7383624
      3                mpg      4 - 6 29 4.441099 1.194696e-04 2.147244 1.3861851
        CI_upper
      1 4.764200
      2 2.023367
      3 3.124025

---

    Code
      nice_contrasts(data = mtcars, response = "disp", group = "gear", bootstraps = 200)
    Warning <simpleWarning>
      extreme order statistics used as endpoints
    Output
        Dependent Variable Comparison df         t            p          d
      1               disp      3 - 5 29  2.916870 6.759287e-03  1.5062653
      2               disp      4 - 5 29 -1.816053 7.971420e-02 -0.9666682
      3               disp      3 - 4 29  6.385087 5.569503e-07  2.4729335
           CI_lower  CI_upper
      1 -0.09158538 3.0382031
      2 -2.22243618 0.1080452
      3  1.60440681 3.2530075

---

    Code
      nice_contrasts(data = mtcars, response = c("mpg", "disp", "hp"), group = "cyl",
      bootstraps = 200)
    Warning <simpleWarning>
      extreme order statistics used as endpoints
      extreme order statistics used as endpoints
      extreme order statistics used as endpoints
      extreme order statistics used as endpoints
      extreme order statistics used as endpoints
      extreme order statistics used as endpoints
    Output
        Dependent Variable Comparison df          t            p         d   CI_lower
      1                mpg      4 - 8 29   8.904534 8.568209e-10  3.587739  2.8061083
      2                mpg      6 - 8 29   3.111825 4.152209e-03  1.440495  0.8499847
      3                mpg      4 - 6 29   4.441099 1.194696e-04  2.147244  1.3576861
      4               disp      4 - 8 29 -11.920787 1.064054e-12 -4.803022 -5.9637776
      5               disp      6 - 8 29  -7.104461 8.117219e-08 -3.288726 -4.1910595
      6               disp      4 - 6 29  -3.131986 3.945539e-03 -1.514296 -2.0390034
      7                 hp      4 - 8 29  -8.285112 3.915144e-09 -3.338167 -4.2244897
      8                 hp      6 - 8 29  -4.952403 2.895434e-05 -2.292517 -2.9960503
      9                 hp      4 - 6 29  -2.162695 3.894886e-02 -1.045650 -1.7086206
          CI_upper
      1  4.7641996
      2  2.0791514
      3  3.0493787
      4 -3.7823637
      5 -2.2607447
      6 -0.7670360
      7 -2.4066053
      8 -1.3764735
      9 -0.4446562

---

    Code
      nice_contrasts(data = mtcars, response = "mpg", group = "cyl", covariates = c(
        "disp", "hp"), bootstraps = 200)
    Warning <simpleWarning>
      extreme order statistics used as endpoints
      extreme order statistics used as endpoints
    Output
        Dependent Variable Comparison df          t          p        d  CI_lower
      1                mpg      4 - 8 27  0.7506447 0.45935889 3.587739 2.8061083
      2                mpg      6 - 8 27 -0.6550186 0.51799786 1.440495 0.7383624
      3                mpg      4 - 6 27  2.3955766 0.02379338 2.147244 1.3861851
        CI_upper
      1 4.764200
      2 2.023367
      3 3.124025

