# nice_lm_slopes

    Code
      nice_lm_slopes(model, predictor = "gear", moderator = "wt")
    Output
        Dependent Variable Predictor (+/-1 SD) df        b        t          p
      1                mpg       gear (LOW-wt) 28 7.540509 2.010656 0.05408136
      2                mpg      gear (MEAN-wt) 28 5.615951 1.943711 0.06204275
      3                mpg      gear (HIGH-wt) 28 3.691393 1.795568 0.08336403
               sr2 CI_lower   CI_upper
      1 0.03048448        0 0.08823243
      2 0.02848830        0 0.08418650
      3 0.02431123        0 0.07551496

---

    Code
      nice_lm_slopes(my.models, predictor = "gear", moderator = "wt")
    Output
        Model Number Dependent Variable Predictor (+/-1 SD) df         b          t
      1            1                mpg       gear (LOW-wt) 28  7.540509  2.0106560
      2            1                mpg      gear (MEAN-wt) 28  5.615951  1.9437108
      3            1                mpg      gear (HIGH-wt) 28  3.691393  1.7955678
      4            2               qsec       gear (LOW-wt) 28 -1.933515 -0.8847558
      5            2               qsec      gear (MEAN-wt) 28 -1.742853 -1.0351610
      6            2               qsec      gear (HIGH-wt) 28 -1.552191 -1.2956736
                 p        sr2 CI_lower   CI_upper
      1 0.05408136 0.03048448        0 0.08823243
      2 0.06204275 0.02848830        0 0.08418650
      3 0.08336403 0.02431123        0 0.07551496
      4 0.38382325 0.02280057        0 0.11642689
      5 0.30945179 0.03121151        0 0.14035904
      6 0.20566798 0.04889790        0 0.18442862

