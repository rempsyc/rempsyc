# find_mad

    Code
      find_mad(data = mtcars, col.list = names(mtcars), criteria = 3)
    Output
      20 outlier(s) based on 3 median absolute deviations for variable(s): 
       mpg, cyl, disp, hp, drat, wt, qsec, vs, am, gear, carb 
      
      The following participants were considered outliers for more than one variable: 
      
        Row n
      1   3 2
      2   9 2
      3  18 2
      4  19 2
      5  20 2
      6  26 2
      7  28 2
      8  31 2
      9  32 2
      
      Outliers per variable: 
      
      $qsec
        Row qsec_mad
      1   9 3.665557
      
      $vs
         Row vs_mad
      1    3    Inf
      2    4    Inf
      3    6    Inf
      4    8    Inf
      5    9    Inf
      6   10    Inf
      7   11    Inf
      8   18    Inf
      9   19    Inf
      10  20    Inf
      11  21    Inf
      12  26    Inf
      13  28    Inf
      14  32    Inf
      
      $am
         Row am_mad
      1    1    Inf
      2    2    Inf
      3    3    Inf
      4   18    Inf
      5   19    Inf
      6   20    Inf
      7   26    Inf
      8   27    Inf
      9   28    Inf
      10  29    Inf
      11  30    Inf
      12  31    Inf
      13  32    Inf
      
      $carb
        Row carb_mad
      1  31 4.046945
      

---

    Code
      find_mad(data = mtcars2, col.list = names(mtcars), ID = "car", criteria = 3)
    Output
      20 outlier(s) based on 3 median absolute deviations for variable(s): 
       mpg, cyl, disp, hp, drat, wt, qsec, vs, am, gear, carb 
      
      The following participants were considered outliers for more than one variable: 
      
        Row            car n
      1   3     Datsun 710 2
      2   9       Merc 230 2
      3  18       Fiat 128 2
      4  19    Honda Civic 2
      5  20 Toyota Corolla 2
      6  26      Fiat X1-9 2
      7  28   Lotus Europa 2
      8  31  Maserati Bora 2
      9  32     Volvo 142E 2
      
      Outliers per variable: 
      
      $qsec
        Row      car qsec_mad
      1   9 Merc 230 3.665557
      
      $vs
         Row            car vs_mad
      1    3     Datsun 710    Inf
      2    4 Hornet 4 Drive    Inf
      3    6        Valiant    Inf
      4    8      Merc 240D    Inf
      5    9       Merc 230    Inf
      6   10       Merc 280    Inf
      7   11      Merc 280C    Inf
      8   18       Fiat 128    Inf
      9   19    Honda Civic    Inf
      10  20 Toyota Corolla    Inf
      11  21  Toyota Corona    Inf
      12  26      Fiat X1-9    Inf
      13  28   Lotus Europa    Inf
      14  32     Volvo 142E    Inf
      
      $am
         Row            car am_mad
      1    1      Mazda RX4    Inf
      2    2  Mazda RX4 Wag    Inf
      3    3     Datsun 710    Inf
      4   18       Fiat 128    Inf
      5   19    Honda Civic    Inf
      6   20 Toyota Corolla    Inf
      7   26      Fiat X1-9    Inf
      8   27  Porsche 914-2    Inf
      9   28   Lotus Europa    Inf
      10  29 Ford Pantera L    Inf
      11  30   Ferrari Dino    Inf
      12  31  Maserati Bora    Inf
      13  32     Volvo 142E    Inf
      
      $carb
        Row           car carb_mad
      1  31 Maserati Bora 4.046945
      

