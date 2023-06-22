# nice_slopes

    Code
      nice_slopes(data = mtcars, response = "mpg", predictor = "gear", moderator = "wt")
    Output
        Dependent Variable Predictor (+/-1 SD) df           B          t          p
      1                mpg       gear (LOW-wt) 28  0.14841920  1.0767040 0.29080233
      2                mpg      gear (MEAN-wt) 28 -0.08718042 -0.7982999 0.43141565
      3                mpg      gear (HIGH-wt) 28 -0.32278004 -1.9035367 0.06729622
                sr2 CI_lower   CI_upper
      1 0.008741702        0 0.03886052
      2 0.004805465        0 0.02702141
      3 0.027322839        0 0.08179662

---

    Code
      nice_slopes(data = mtcars, response = c("mpg", "disp", "hp"), predictor = "gear",
      moderator = "wt")
    Output
        Model Number Dependent Variable Predictor (+/-1 SD) df           B          t
      1            1                mpg       gear (LOW-wt) 28  0.14841920  1.0767040
      2            1                mpg      gear (MEAN-wt) 28 -0.08718042 -0.7982999
      3            1                mpg      gear (HIGH-wt) 28 -0.32278004 -1.9035367
      4            2               disp       gear (LOW-wt) 28  0.01269680  0.0935897
      5            2               disp      gear (MEAN-wt) 28 -0.07488985 -0.6967831
      6            2               disp      gear (HIGH-wt) 28 -0.16247650 -0.9735823
      7            3                 hp       gear (LOW-wt) 28  0.26999235  1.3416927
      8            3                 hp      gear (MEAN-wt) 28  0.42308208  2.6537930
      9            3                 hp      gear (HIGH-wt) 28  0.57617180  2.3275656
                 p          sr2     CI_lower    CI_upper
      1 0.29080233 8.741702e-03 0.0000000000 0.038860523
      2 0.43141565 4.805465e-03 0.0000000000 0.027021406
      3 0.06729622 2.732284e-02 0.0000000000 0.081796622
      4 0.92610159 6.397412e-05 0.0000000000 0.002570652
      5 0.49168336 3.546038e-03 0.0000000000 0.022301536
      6 0.33860037 6.922988e-03 0.0000000000 0.033253212
      7 0.19047626 2.892802e-02 0.0000000000 0.108167016
      8 0.01297126 1.131740e-01 0.0011317402 0.269289442
      9 0.02738736 8.705956e-02 0.0008705956 0.224382568

---

    Code
      nice_slopes(data = mtcars, response = "mpg", predictor = "gear", moderator = "wt",
        covariates = c("am", "vs"))
    Output
        Dependent Variable Predictor (+/-1 SD) df          B          t          p
      1                mpg       gear (LOW-wt) 26  0.1404206  0.8866848 0.38337713
      2                mpg      gear (MEAN-wt) 26 -0.1106937 -0.8787865 0.38756663
      3                mpg      gear (HIGH-wt) 26 -0.3618080 -2.2493043 0.03318541
                sr2     CI_lower   CI_upper
      1 0.004540512 0.0000000000 0.02282331
      2 0.004459982 0.0000000000 0.02257663
      3 0.029218824 0.0002921882 0.07802035

---

    Code
      nice_slopes(data = mtcars, response = "mpg", predictor = "gear", moderator = "wt",
        moderator2 = "am")
    Output
        Dependent Variable am Predictor (+/-1 SD) df           B          t
      1                mpg  0       gear (LOW-wt) 24  2.34802068  2.0297802
      2                mpg  0      gear (MEAN-wt) 24  0.54019914  2.7321453
      3                mpg  0      gear (HIGH-wt) 24 -1.26762239 -1.3171195
      4                mpg  1       gear (LOW-wt) 24 -0.25154857 -1.4054434
      5                mpg  1      gear (MEAN-wt) 24 -0.04783665 -0.1613202
      6                mpg  1      gear (HIGH-wt) 24  0.15587527  0.2795012
                 p          sr2     CI_lower    CI_upper
      1 0.05360579 0.0203900917 0.0000000000 0.056598989
      2 0.01161625 0.0369427073 0.0003694271 0.087760631
      3 0.20023635 0.0085856163 0.0000000000 0.031309188
      4 0.17270299 0.0097757007 0.0000000000 0.034108645
      5 0.87319157 0.0001287948 0.0000000000 0.002840222
      6 0.78225488 0.0003866236 0.0000000000 0.005088286

