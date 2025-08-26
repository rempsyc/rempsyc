# nice_table

    Code
      my_table
    Output
      a flextable object.
      col_keys: `mpg`, `cyl`, `disp`, `hp`, `drat`, `wt`, `qsec`, `vs`, `am`, `gear`, `carb` 
      header has 3 row(s) 
      body has 3 row(s) 
      original dataset sample: 
      'data.frame':	3 obs. of  11 variables:
       $ mpg : num  21 21 22.8
       $ cyl : num  6 6 4
       $ disp: num  160 160 108
       $ hp  : num  110 110 93
       $ drat: num  3.9 3.9 3.85
       $ wt  : num  2.62 2.88 2.32
       $ qsec: num  16.5 17 18.6
       $ vs  : num  0 0 1
       $ am  : num  1 1 1
       $ gear: num  4 4 4
       $ carb: num  4 4 1

---

    Code
      nice_table(stats.table, highlight = TRUE)
    Output
      a flextable object.
      col_keys: `Term`, `B`, `SE`, `t`, `p`, `95% CI` 
      header has 1 row(s) 
      body has 5 row(s) 
      original dataset sample: 
      'data.frame':	5 obs. of  7 variables:
       $ Term  : chr  "(Intercept)" "cyl" "wt" "hp" ...
       $ B     : num  -0.184 -0.108 -0.623 -0.287 0.288
       $ SE    : num  0.0853 0.1507 0.1093 0.1196 0.089
       $ t     : num  -2.151 -0.718 -5.701 -2.405 3.233
       $ p     : num  4.06e-02 4.79e-01 4.66e-06 2.33e-02 3.22e-03
       $ 95% CI: chr  "[-0.36, -0.01]" "[-0.42, 0.20]" "[-0.85, -0.40]" "[-0.53, -0.04]" ...
       $ signif: logi  TRUE FALSE TRUE TRUE TRUE

---

    Code
      nice_table(test)
    Output
      a flextable object.
      col_keys: `dR`, `N`, `M`, `SD`, `b`, `np2`, `ges`, `p`, `r`, `R2`, `sr2` 
      header has 1 row(s) 
      body has 6 row(s) 
      original dataset sample: 
      'data.frame':	6 obs. of  11 variables:
       $ dR : num  21 21 22.8 21.4 18.7 18.1
       $ N  : num  6 6 4 6 8 6
       $ M  : num  160 160 108 258 360 225
       $ SD : num  110 110 93 110 175 105
       $ b  : num  3.9 3.9 3.85 3.08 3.15 2.76
       $ np2: num  2.62 2.88 2.32 3.21 3.44 ...
       $ ges: num  16.5 17 18.6 19.4 17 ...
       $ p  : num  0 0 1 1 0 1
       $ r  : num  1 1 1 0 0 0
       $ R2 : num  0.4 0.4 0.4 0.3 0.3 0.3
       $ sr2: num  0.4 0.4 0.1 0.1 0.2 0.1

---

    Code
      nice_table(test[8:11], col.format.p = 2:4, highlight = 0.001)
    Output
      a flextable object.
      col_keys: `p`, `r`, `R2`, `sr2` 
      header has 1 row(s) 
      body has 6 row(s) 
      original dataset sample: 
      'data.frame':	6 obs. of  5 variables:
       $ p     : num  0 0 1 1 0 1
       $ r     : num  1 1 1 0 0 0
       $ R2    : num  0.4 0.4 0.4 0.3 0.3 0.3
       $ sr2   : num  0.4 0.4 0.1 0.1 0.2 0.1
       $ signif: logi  TRUE TRUE FALSE FALSE TRUE FALSE

---

    Code
      nice_table(test[8:11], col.format.r = 1:4)
    Output
      a flextable object.
      col_keys: `p`, `r`, `R2`, `sr2` 
      header has 1 row(s) 
      body has 6 row(s) 
      original dataset sample: 
      'data.frame':	6 obs. of  4 variables:
       $ p  : num  0 0 1 1 0 1
       $ r  : num  1 1 1 0 0 0
       $ R2 : num  0.4 0.4 0.4 0.3 0.3 0.3
       $ sr2: num  0.4 0.4 0.1 0.1 0.2 0.1

---

    Code
      nice_table(test[8:11], col.format.custom = 2:4, format.custom = "fun")
    Output
      a flextable object.
      col_keys: `p`, `r`, `R2`, `sr2` 
      header has 1 row(s) 
      body has 6 row(s) 
      original dataset sample: 
      'data.frame':	6 obs. of  4 variables:
       $ p  : num  0 0 1 1 0 1
       $ r  : num  1 1 1 0 0 0
       $ R2 : num  0.4 0.4 0.4 0.3 0.3 0.3
       $ sr2: num  0.4 0.4 0.1 0.1 0.2 0.1

---

    Code
      nice_table(test[8:11], col.format.custom = 2:4, format.custom = "fun")
    Output
      a flextable object.
      col_keys: `p`, `r`, `R2`, `sr2` 
      header has 1 row(s) 
      body has 6 row(s) 
      original dataset sample: 
      'data.frame':	6 obs. of  4 variables:
       $ p  : num  0 0 1 1 0 1
       $ r  : num  1 1 1 0 0 0
       $ R2 : num  0.4 0.4 0.4 0.3 0.3 0.3
       $ sr2: num  0.4 0.4 0.1 0.1 0.2 0.1

---

    Code
      nice_table(header.data, separate.header = TRUE, italics = 2:4)
    Output
      a flextable object.
      col_keys: `Variable`, `setosa.M`, `setosa.SD`, `versicolor.M`, `versicolor.SD` 
      header has 2 row(s) 
      body has 3 row(s) 
      original dataset sample: 
      'data.frame':	3 obs. of  5 variables:
       $ Variable     : chr  "Sepal.Length" "Sepal.Width" "Petal.Length"
       $ setosa.M     : num  5.01 3.43 1.46
       $ setosa.SD    : num  0.35 0.38 0.17
       $ versicolor.M : num  5.94 2.77 4.26
       $ versicolor.SD: num  0.52 0.31 0.47

