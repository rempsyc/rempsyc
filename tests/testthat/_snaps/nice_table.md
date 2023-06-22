# nice_table

    Code
      my_table
    Output
      a flextable object.
      col_keys: `mpg`, `cyl`, `disp`, `hp`, `drat`, `wt`, `qsec`, `vs`, `am`, `gear`, `carb` 
      header has 3 row(s) 
      body has 3 row(s) 
      original dataset sample: 
                     mpg cyl disp  hp drat    wt  qsec vs am gear carb
      Mazda RX4     21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
      Mazda RX4 Wag 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
      Datsun 710    22.8   4  108  93 3.85 2.320 18.61  1  1    4    1

---

    Code
      nice_table(stats.table, highlight = TRUE)
    Output
      a flextable object.
      col_keys: `Term`, `B`, `SE`, `t`, `p`, `95% CI` 
      header has 1 row(s) 
      body has 5 row(s) 
      original dataset sample: 
                         Term          B         SE          t            p
      (Intercept) (Intercept) -0.1835269 0.08532112 -2.1510135 4.058431e-02
      cyl                 cyl -0.1082286 0.15071576 -0.7180977 4.788652e-01
      wt                   wt -0.6230206 0.10927573 -5.7013627 4.663587e-06
      hp                   hp -0.2874898 0.11955935 -2.4045781 2.331865e-02
      wt:hp           wt × hp  0.2875867 0.08895462  3.2329593 3.221753e-03
                          95% CI signif
      (Intercept) [-0.36, -0.01]   TRUE
      cyl          [-0.42, 0.20]  FALSE
      wt          [-0.85, -0.40]   TRUE
      hp          [-0.53, -0.04]   TRUE
      wt:hp         [0.11, 0.47]   TRUE

---

    Code
      nice_table(test)
    Output
      a flextable object.
      col_keys: `dR`, `N`, `M`, `SD`, `b`, `np2`, `ges`, `p`, `r`, `R2`, `sr2` 
      header has 1 row(s) 
      body has 6 row(s) 
      original dataset sample: 
                          dR N   M  SD    b   np2   ges p r  R2 sr2
      Mazda RX4         21.0 6 160 110 3.90 2.620 16.46 0 1 0.4 0.4
      Mazda RX4 Wag     21.0 6 160 110 3.90 2.875 17.02 0 1 0.4 0.4
      Datsun 710        22.8 4 108  93 3.85 2.320 18.61 1 1 0.4 0.1
      Hornet 4 Drive    21.4 6 258 110 3.08 3.215 19.44 1 0 0.3 0.1
      Hornet Sportabout 18.7 8 360 175 3.15 3.440 17.02 0 0 0.3 0.2

---

    Code
      nice_table(test[8:11], col.format.p = 2:4, highlight = 0.001)
    Output
      a flextable object.
      col_keys: `p`, `r`, `R2`, `sr2` 
      header has 1 row(s) 
      body has 6 row(s) 
      original dataset sample: 
                        p r  R2 sr2 signif
      Mazda RX4         0 1 0.4 0.4   TRUE
      Mazda RX4 Wag     0 1 0.4 0.4   TRUE
      Datsun 710        1 1 0.4 0.1  FALSE
      Hornet 4 Drive    1 0 0.3 0.1  FALSE
      Hornet Sportabout 0 0 0.3 0.2   TRUE

---

    Code
      nice_table(test[8:11], col.format.r = 1:4)
    Output
      a flextable object.
      col_keys: `p`, `r`, `R2`, `sr2` 
      header has 1 row(s) 
      body has 6 row(s) 
      original dataset sample: 
                        p r  R2 sr2
      Mazda RX4         0 1 0.4 0.4
      Mazda RX4 Wag     0 1 0.4 0.4
      Datsun 710        1 1 0.4 0.1
      Hornet 4 Drive    1 0 0.3 0.1
      Hornet Sportabout 0 0 0.3 0.2

---

    Code
      nice_table(test[8:11], col.format.custom = 2:4, format.custom = "fun")
    Output
      a flextable object.
      col_keys: `p`, `r`, `R2`, `sr2` 
      header has 1 row(s) 
      body has 6 row(s) 
      original dataset sample: 
                        p r  R2 sr2
      Mazda RX4         0 1 0.4 0.4
      Mazda RX4 Wag     0 1 0.4 0.4
      Datsun 710        1 1 0.4 0.1
      Hornet 4 Drive    1 0 0.3 0.1
      Hornet Sportabout 0 0 0.3 0.2

---

    Code
      nice_table(test[8:11], col.format.custom = 2:4, format.custom = "fun")
    Output
      a flextable object.
      col_keys: `p`, `r`, `R2`, `sr2` 
      header has 1 row(s) 
      body has 6 row(s) 
      original dataset sample: 
                        p r  R2 sr2
      Mazda RX4         0 1 0.4 0.4
      Mazda RX4 Wag     0 1 0.4 0.4
      Datsun 710        1 1 0.4 0.1
      Hornet 4 Drive    1 0 0.3 0.1
      Hornet Sportabout 0 0 0.3 0.2

---

    Code
      nice_table(header.data, separate.header = TRUE, italics = 2:4)
    Output
      a flextable object.
      col_keys: `Variable`, `setosa.M`, `setosa.SD`, `versicolor.M`, `versicolor.SD` 
      header has 2 row(s) 
      body has 3 row(s) 
      original dataset sample: 
            Variable setosa.M setosa.SD versicolor.M versicolor.SD
      1 Sepal.Length     5.01      0.35         5.94          0.52
      2  Sepal.Width     3.43      0.38         2.77          0.31
      3 Petal.Length     1.46      0.17         4.26          0.47

