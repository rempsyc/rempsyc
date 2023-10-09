# nice_t_test

    Code
      nice_t_test(data = mtcars, response = "mpg", group = "am", verbose = FALSE)
    Output
        Dependent Variable         t       df           p         d  CI_lower
      1                mpg -3.767123 18.33225 0.001373638 -1.477947 -2.265973
          CI_upper
      1 -0.6705686

---

    Code
      nice_t_test(data = mtcars, response = names(mtcars)[1:7], group = "am",
      verbose = FALSE)
    Output
        Dependent Variable         t       df            p          d   CI_lower
      1                mpg -3.767123 18.33225 1.373638e-03 -1.4779471 -2.2659731
      2                cyl  3.354114 25.85363 2.464713e-03  1.2084550  0.4315896
      3               disp  4.197727 29.25845 2.300413e-04  1.4452210  0.6417834
      4                 hp  1.266189 18.71541 2.209796e-01  0.4943081 -0.2260466
      5               drat -5.646088 27.19780 5.266742e-06 -2.0030843 -2.8592770
      6                 wt  5.493905 29.23352 6.272020e-06  1.8924060  1.0300224
      7               qsec  1.287845 25.53421 2.093498e-01  0.4656285 -0.2532864
          CI_upper
      1 -0.6705686
      2  1.9683146
      3  2.2295592
      4  1.2066992
      5 -1.1245498
      6  2.7329218
      7  1.1770176

---

    Code
      nice_t_test(data = mtcars, response = "mpg", group = "am", var.equal = TRUE,
        verbose = FALSE)
    Output
        Dependent Variable         t df            p         d  CI_lower   CI_upper
      1                mpg -4.106127 30 0.0002850207 -1.477947 -2.265973 -0.6705686

---

    Code
      nice_t_test(data = mtcars, response = "mpg", group = "am", alternative = "less",
        verbose = FALSE)
    Output
        Dependent Variable         t       df            p         d  CI_lower
      1                mpg -3.767123 18.33225 0.0006868192 -1.477947 -2.265973
          CI_upper
      1 -0.6705686

---

    Code
      nice_t_test(data = mtcars, response = "mpg", mu = 10, verbose = FALSE)
    Output
        Dependent Variable        t df            p        d CI_lower CI_upper
      1                mpg 9.470995 31 1.154598e-10 1.674251  1.12797 2.208995

