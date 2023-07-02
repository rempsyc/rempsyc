# nice_contrasts

    Code
      nice_contrasts(data = mtcars, response = "mpg", group = "cyl", bootstraps = 1000)
    Output
        Dependent Variable  Comparison df        t            p        d  CI_lower
      1                mpg cyl4 - cyl6 29 4.441099 1.194696e-04 2.147244 1.4164969
      2                mpg cyl4 - cyl8 29 8.904534 8.568209e-10 3.587739 2.7375959
      3                mpg cyl6 - cyl8 29 3.111825 4.152209e-03 1.440495 0.8245536
        CI_upper
      1 3.057725
      2 4.378084
      3 2.002842

---

    Code
      nice_contrasts(data = mtcars, response = "disp", group = "gear", bootstraps = 2500)
    Output
        Dependent Variable    Comparison df         t            p          d
      1               disp gear3 - gear4 29  6.385087 5.569503e-07  2.4729335
      2               disp gear3 - gear5 29  2.916870 6.759287e-03  1.5062653
      3               disp gear4 - gear5 29 -1.816053 7.971420e-02 -0.9666682
          CI_lower  CI_upper
      1  1.2689566 3.3113265
      2 -0.1537929 3.0415180
      3 -2.3673531 0.1462472

---

    Code
      nice_contrasts(data = mtcars, response = c("mpg", "disp", "hp"), group = "cyl",
      bootstraps = 800)
    Output
        Dependent Variable  Comparison df          t            p         d
      1                mpg cyl4 - cyl6 29   4.441099 1.194696e-04  2.147244
      2                mpg cyl4 - cyl8 29   8.904534 8.568209e-10  3.587739
      3                mpg cyl6 - cyl8 29   3.111825 4.152209e-03  1.440495
      4               disp cyl4 - cyl6 29  -3.131986 3.945539e-03 -1.514296
      5               disp cyl4 - cyl8 29 -11.920787 1.064054e-12 -4.803022
      6               disp cyl6 - cyl8 29  -7.104461 8.117219e-08 -3.288726
      7                 hp cyl4 - cyl6 29  -2.162695 3.894886e-02 -1.045650
      8                 hp cyl4 - cyl8 29  -8.285112 3.915144e-09 -3.338167
      9                 hp cyl6 - cyl8 29  -4.952403 2.895434e-05 -2.292517
          CI_lower   CI_upper
      1  1.3548989  2.9415058
      2  2.7040950  4.3986680
      3  0.8738635  2.0477362
      4 -2.2801066 -0.8823378
      5 -5.8508448 -3.6672234
      6 -4.3232186 -2.1938845
      7 -1.6771629 -0.4609753
      8 -4.2642806 -2.4908319
      9 -3.2151098 -1.3586919

---

    Code
      nice_contrasts(data = mtcars, response = "mpg", group = "cyl", covariates = c(
        "disp", "hp"), bootstraps = 500)
    Output
        Dependent Variable  Comparison df          t          p        d  CI_lower
      1                mpg cyl4 - cyl6 27  2.3955766 0.02379338 2.147244 1.2831781
      2                mpg cyl4 - cyl8 27  0.7506447 0.45935889 3.587739 2.7405544
      3                mpg cyl6 - cyl8 27 -0.6550186 0.51799786 1.440495 0.7828333
        CI_upper
      1 2.985932
      2 4.582310
      3 1.978447

---

    Code
      nice_contrasts(data = mtcars, response = "mpg", group = "carb", bootstraps = 2500)
    Output
         Dependent Variable    Comparison df          t            p          d
      1                 mpg carb1 - carb2 26  1.2175073 0.2343463275  0.5999941
      2                 mpg carb1 - carb3 26  2.6717336 0.0128499280  1.8436713
      3                 mpg carb1 - carb4 26  3.9521705 0.0005295477  1.9476509
      4                 mpg carb1 - carb6 26  1.0761701 0.2917362452  1.1504742
      5                 mpg carb1 - carb8 26  1.9725244 0.0592726906  2.1087173
      6                 mpg carb2 - carb3 26  1.8892812 0.0700557269  1.2436772
      7                 mpg carb2 - carb4 26  3.0134521 0.0056962070  1.3476567
      8                 mpg carb2 - carb6 26  0.5248621 0.6041261067  0.5504801
      9                 mpg carb2 - carb8 26  1.4385111 0.1622188105  1.5087231
      10                mpg carb3 - carb4 26  0.1579563 0.8757116294  0.1039796
      11                mpg carb3 - carb6 26 -0.6003263 0.5534859747 -0.6931971
      12                mpg carb3 - carb8 26  0.2295365 0.8202480949  0.2650460
      13                mpg carb4 - carb6 26 -0.7600781 0.4540454635 -0.7971767
      14                mpg carb4 - carb8 26  0.1535708 0.8791339283  0.1610664
      15                mpg carb6 - carb8 26  0.6775802 0.5040233386  0.9582431
            CI_lower   CI_upper
      1  -0.60234627  1.8395673
      2   1.03259314  2.7547687
      3   0.97599639  2.9747198
      4   0.34963853  2.0168157
      5   1.34896979  2.9954722
      6   0.47359627  1.9302522
      7   0.49149010  2.2175294
      8  -0.16596284  1.3000669
      9   0.82474382  2.2397764
      10 -0.47941740  0.6565330
      11 -0.92957298 -0.4650258
      12  0.03897768  0.4683794
      13 -1.29702141 -0.2852145
      14 -0.35371414  0.6892946
      15  0.77084367  1.0930274

