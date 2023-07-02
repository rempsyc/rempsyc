# nice_lm_contrasts

    Code
      nice_lm_contrasts(model, group = "cyl", data = mtcars, bootstraps = 500)
    Output
        Dependent Variable Comparison df         t         p        d  CI_lower
      1                mpg      4 - 8 26 0.7047256 0.4872464 3.587739 2.7596809
      2                mpg      6 - 8 26 0.1302365 0.8973817 1.440495 0.8175819
      3                mpg      4 - 6 26 0.8452452 0.4056854 2.147244 1.3584791
        CI_upper
      1 4.437877
      2 1.984898
      3 3.171867

---

    Code
      nice_lm_contrasts(my.models, group = "cyl", data = mtcars, bootstraps = 500)
    Output
        Dependent Variable Comparison df         t            p         d   CI_lower
      1                mpg      4 - 8 26 0.7047256 0.4872463657 3.5877388  2.7596809
      2                mpg      6 - 8 26 0.1302365 0.8973817161 1.4404949  0.7828333
      3                mpg      4 - 6 26 0.8452452 0.4056854062 2.1472439  1.3515026
      4               qsec      4 - 8 29 3.9396785 0.0004711519 1.5873417  0.6810767
      5               qsec      6 - 8 29 1.7470521 0.0912125385 0.8087280 -0.2872433
      6               qsec      4 - 6 29 1.6103903 0.1181454384 0.7786137 -0.4422873
        CI_upper
      1 4.437877
      2 1.978447
      3 3.026063
      4 2.194041
      5 1.773878
      6 1.902555

