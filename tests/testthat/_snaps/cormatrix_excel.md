# cormatrix_excel

    Code
      suppressWarnings(cormatrix_excel(mtcars, select = c("mpg", "cyl", "disp", "hp",
        "carb"), filename = "cormatrix1", verbose = FALSE))
    Output
      # Correlation Matrix (pearson-method)
      
      Parameter |      mpg |      cyl |     disp |       hp |    carb
      ---------------------------------------------------------------
      mpg       |          | -0.85*** | -0.85*** | -0.78*** | -0.55**
      cyl       | -0.85*** |          |  0.90*** |  0.83*** |  0.53**
      disp      | -0.85*** |  0.90*** |          |  0.79*** |   0.39*
      hp        | -0.78*** |  0.83*** |  0.79*** |          | 0.75***
      carb      |  -0.55** |   0.53** |    0.39* |  0.75*** |        
      
      p-value adjustment method: none
      
      
       [Correlation matrix 'cormatrix1.xlsx' has been saved to working directory (or where specified).]
      NULL

---

    Code
      suppressWarnings(cormatrix_excel(iris, p_adjust = "none", filename = "cormatrix2",
        verbose = FALSE))
    Output
      # Correlation Matrix (pearson-method)
      
      Parameter    | Sepal.Length | Sepal.Width | Petal.Length | Petal.Width
      ----------------------------------------------------------------------
      Sepal.Length |              |       -0.12 |      0.87*** |     0.82***
      Sepal.Width  |        -0.12 |             |     -0.43*** |    -0.37***
      Petal.Length |      0.87*** |    -0.43*** |              |     0.96***
      Petal.Width  |      0.82*** |    -0.37*** |      0.96*** |            
      
      p-value adjustment method: none
      
      
       [Correlation matrix 'cormatrix2.xlsx' has been saved to working directory (or where specified).]
      NULL

---

    Code
      suppressWarnings(cormatrix_excel(airquality, method = "spearman", filename = "cormatrix3",
        verbose = FALSE))
    Output
      # Correlation Matrix (spearman-method)
      
      Parameter |    Ozone | Solar.R |     Wind |     Temp |   Month |   Day
      ----------------------------------------------------------------------
      Ozone     |          | 0.35*** | -0.59*** |  0.77*** |    0.14 | -0.06
      Solar.R   |  0.35*** |         |     0.00 |    0.21* |   -0.13 | -0.15
      Wind      | -0.59*** |    0.00 |          | -0.45*** |   -0.16 |  0.04
      Temp      |  0.77*** |   0.21* | -0.45*** |          | 0.37*** | -0.16
      Month     |     0.14 |   -0.13 |    -0.16 |  0.37*** |         | -0.01
      Day       |    -0.06 |   -0.15 |     0.04 |    -0.16 |   -0.01 |      
      
      p-value adjustment method: none
      
      
       [Correlation matrix 'cormatrix3.xlsx' has been saved to working directory (or where specified).]
      NULL

