# nice_var

    Code
      nice_var(data = iris, variable = "Sepal.Length", group = "Species")
    Output
             Species Setosa Versicolor Virginica Variance.ratio Criteria
      1 Sepal.Length  0.124      0.266     0.404            3.3        4
        Heteroscedastic
      1           FALSE

---

    Code
      nice_var(data = iris, variable = names(iris[1:4]), group = "Species")
    Output
             Species Setosa Versicolor Virginica Variance.ratio Criteria
      1 Sepal.Length  0.124      0.266     0.404            3.3        4
      2  Sepal.Width  0.144      0.098     0.104            1.5        4
      3 Petal.Length  0.030      0.221     0.305           10.2        4
      4  Petal.Width  0.011      0.039     0.075            6.8        4
        Heteroscedastic
      1           FALSE
      2           FALSE
      3            TRUE
      4            TRUE

