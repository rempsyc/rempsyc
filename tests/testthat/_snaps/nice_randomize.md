# nice_randomize

    Code
      nice_randomize(design = "between", Ncondition = 4, n = 8, condition.names = c(
        "BP", "CX", "PZ", "ZL"))
    Output
        id Condition
      1  1        CX
      2  2        PZ
      3  3        ZL
      4  4        BP
      5  5        PZ
      6  6        BP
      7  7        CX
      8  8        ZL

---

    Code
      nice_randomize(design = "within", Ncondition = 4, n = 6, condition.names = c(
        "SV", "AV", "ST", "AT"))
    Output
        id         Condition
      1  1 AV - ST - AT - SV
      2  2 ST - SV - AV - AT
      3  3 AT - ST - AV - SV
      4  4 AV - ST - AT - SV
      5  5 ST - AT - SV - AV
      6  6 AT - AV - SV - ST

---

    Code
      nice_randomize(design = "within", Ncondition = 4, n = 128, condition.names = c(
        "SV", "AV", "ST", "AT"), col.names = c("id", "Condition", "Date/Time",
        "SONA ID", "Age/Gd.", "Handedness", "Tester", "Notes"))
    Output
           id         Condition Date/Time SONA ID Age/Gd. Handedness Tester Notes
      1     1 AV - ST - AT - SV        NA      NA      NA         NA     NA    NA
      2     2 ST - SV - AV - AT        NA      NA      NA         NA     NA    NA
      3     3 AT - ST - AV - SV        NA      NA      NA         NA     NA    NA
      4     4 AV - ST - AT - SV        NA      NA      NA         NA     NA    NA
      5     5 ST - AT - SV - AV        NA      NA      NA         NA     NA    NA
      6     6 AT - AV - SV - ST        NA      NA      NA         NA     NA    NA
      7     7 ST - AT - AV - SV        NA      NA      NA         NA     NA    NA
      8     8 SV - AV - AT - ST        NA      NA      NA         NA     NA    NA
      9     9 AT - AV - ST - SV        NA      NA      NA         NA     NA    NA
      10   10 AT - SV - ST - AV        NA      NA      NA         NA     NA    NA
      11   11 SV - ST - AV - AT        NA      NA      NA         NA     NA    NA
      12   12 AV - SV - ST - AT        NA      NA      NA         NA     NA    NA
      13   13 AV - SV - ST - AT        NA      NA      NA         NA     NA    NA
      14   14 SV - ST - AT - AV        NA      NA      NA         NA     NA    NA
      15   15 ST - AT - AV - SV        NA      NA      NA         NA     NA    NA
      16   16 SV - AT - AV - ST        NA      NA      NA         NA     NA    NA
      17   17 ST - AT - SV - AV        NA      NA      NA         NA     NA    NA
      18   18 SV - AV - ST - AT        NA      NA      NA         NA     NA    NA
      19   19 ST - SV - AV - AT        NA      NA      NA         NA     NA    NA
      20   20 ST - AV - AT - SV        NA      NA      NA         NA     NA    NA
      21   21 ST - AT - AV - SV        NA      NA      NA         NA     NA    NA
      22   22 ST - AV - AT - SV        NA      NA      NA         NA     NA    NA
      23   23 ST - AT - SV - AV        NA      NA      NA         NA     NA    NA
      24   24 AT - ST - SV - AV        NA      NA      NA         NA     NA    NA
      25   25 AT - AV - ST - SV        NA      NA      NA         NA     NA    NA
      26   26 ST - SV - AV - AT        NA      NA      NA         NA     NA    NA
      27   27 AT - SV - ST - AV        NA      NA      NA         NA     NA    NA
      28   28 ST - SV - AV - AT        NA      NA      NA         NA     NA    NA
      29   29 SV - AV - ST - AT        NA      NA      NA         NA     NA    NA
      30   30 AT - SV - AV - ST        NA      NA      NA         NA     NA    NA
      31   31 ST - AT - SV - AV        NA      NA      NA         NA     NA    NA
      32   32 AV - AT - SV - ST        NA      NA      NA         NA     NA    NA
      33   33 ST - AV - SV - AT        NA      NA      NA         NA     NA    NA
      34   34 ST - AV - AT - SV        NA      NA      NA         NA     NA    NA
      35   35 AT - AV - SV - ST        NA      NA      NA         NA     NA    NA
      36   36 ST - AV - SV - AT        NA      NA      NA         NA     NA    NA
      37   37 AV - ST - SV - AT        NA      NA      NA         NA     NA    NA
      38   38 AV - ST - AT - SV        NA      NA      NA         NA     NA    NA
      39   39 ST - AV - AT - SV        NA      NA      NA         NA     NA    NA
      40   40 AV - ST - SV - AT        NA      NA      NA         NA     NA    NA
      41   41 SV - AV - ST - AT        NA      NA      NA         NA     NA    NA
      42   42 AT - ST - AV - SV        NA      NA      NA         NA     NA    NA
      43   43 AT - SV - AV - ST        NA      NA      NA         NA     NA    NA
      44   44 AT - SV - AV - ST        NA      NA      NA         NA     NA    NA
      45   45 ST - AV - SV - AT        NA      NA      NA         NA     NA    NA
      46   46 ST - SV - AV - AT        NA      NA      NA         NA     NA    NA
      47   47 AT - AV - ST - SV        NA      NA      NA         NA     NA    NA
      48   48 SV - ST - AV - AT        NA      NA      NA         NA     NA    NA
      49   49 SV - ST - AV - AT        NA      NA      NA         NA     NA    NA
      50   50 AT - AV - SV - ST        NA      NA      NA         NA     NA    NA
      51   51 ST - AV - SV - AT        NA      NA      NA         NA     NA    NA
      52   52 AT - SV - ST - AV        NA      NA      NA         NA     NA    NA
      53   53 SV - AV - AT - ST        NA      NA      NA         NA     NA    NA
      54   54 AV - AT - ST - SV        NA      NA      NA         NA     NA    NA
      55   55 AT - ST - SV - AV        NA      NA      NA         NA     NA    NA
      56   56 AV - SV - ST - AT        NA      NA      NA         NA     NA    NA
      57   57 AV - AT - ST - SV        NA      NA      NA         NA     NA    NA
      58   58 SV - ST - AT - AV        NA      NA      NA         NA     NA    NA
      59   59 ST - AT - SV - AV        NA      NA      NA         NA     NA    NA
      60   60 SV - AV - AT - ST        NA      NA      NA         NA     NA    NA
      61   61 AT - ST - SV - AV        NA      NA      NA         NA     NA    NA
      62   62 AT - AV - ST - SV        NA      NA      NA         NA     NA    NA
      63   63 AT - SV - ST - AV        NA      NA      NA         NA     NA    NA
      64   64 AT - SV - AV - ST        NA      NA      NA         NA     NA    NA
      65   65 AT - ST - AV - SV        NA      NA      NA         NA     NA    NA
      66   66 AT - ST - AV - SV        NA      NA      NA         NA     NA    NA
      67   67 AT - AV - ST - SV        NA      NA      NA         NA     NA    NA
      68   68 AT - AV - ST - SV        NA      NA      NA         NA     NA    NA
      69   69 ST - AT - SV - AV        NA      NA      NA         NA     NA    NA
      70   70 AV - AT - ST - SV        NA      NA      NA         NA     NA    NA
      71   71 AV - AT - SV - ST        NA      NA      NA         NA     NA    NA
      72   72 AT - AV - ST - SV        NA      NA      NA         NA     NA    NA
      73   73 ST - SV - AT - AV        NA      NA      NA         NA     NA    NA
      74   74 ST - AV - AT - SV        NA      NA      NA         NA     NA    NA
      75   75 AT - ST - SV - AV        NA      NA      NA         NA     NA    NA
      76   76 AV - ST - SV - AT        NA      NA      NA         NA     NA    NA
      77   77 SV - AV - AT - ST        NA      NA      NA         NA     NA    NA
      78   78 SV - AV - ST - AT        NA      NA      NA         NA     NA    NA
      79   79 AT - ST - AV - SV        NA      NA      NA         NA     NA    NA
      80   80 SV - ST - AT - AV        NA      NA      NA         NA     NA    NA
      81   81 ST - AT - SV - AV        NA      NA      NA         NA     NA    NA
      82   82 ST - SV - AT - AV        NA      NA      NA         NA     NA    NA
      83   83 SV - AV - AT - ST        NA      NA      NA         NA     NA    NA
      84   84 AV - AT - ST - SV        NA      NA      NA         NA     NA    NA
      85   85 SV - AV - AT - ST        NA      NA      NA         NA     NA    NA
      86   86 SV - ST - AV - AT        NA      NA      NA         NA     NA    NA
      87   87 ST - SV - AT - AV        NA      NA      NA         NA     NA    NA
      88   88 SV - ST - AV - AT        NA      NA      NA         NA     NA    NA
      89   89 AT - ST - SV - AV        NA      NA      NA         NA     NA    NA
      90   90 AT - ST - SV - AV        NA      NA      NA         NA     NA    NA
      91   91 AT - AV - SV - ST        NA      NA      NA         NA     NA    NA
      92   92 AV - SV - AT - ST        NA      NA      NA         NA     NA    NA
      93   93 SV - ST - AV - AT        NA      NA      NA         NA     NA    NA
      94   94 SV - AT - ST - AV        NA      NA      NA         NA     NA    NA
      95   95 AV - ST - AT - SV        NA      NA      NA         NA     NA    NA
      96   96 SV - AV - AT - ST        NA      NA      NA         NA     NA    NA
      97   97 SV - ST - AT - AV        NA      NA      NA         NA     NA    NA
      98   98 AT - SV - AV - ST        NA      NA      NA         NA     NA    NA
      99   99 ST - AV - SV - AT        NA      NA      NA         NA     NA    NA
      100 100 AT - AV - SV - ST        NA      NA      NA         NA     NA    NA
      101 101 ST - AV - AT - SV        NA      NA      NA         NA     NA    NA
      102 102 ST - AT - AV - SV        NA      NA      NA         NA     NA    NA
      103 103 SV - AT - ST - AV        NA      NA      NA         NA     NA    NA
      104 104 AV - SV - AT - ST        NA      NA      NA         NA     NA    NA
      105 105 SV - ST - AV - AT        NA      NA      NA         NA     NA    NA
      106 106 AV - SV - ST - AT        NA      NA      NA         NA     NA    NA
      107 107 AT - SV - AV - ST        NA      NA      NA         NA     NA    NA
      108 108 ST - SV - AV - AT        NA      NA      NA         NA     NA    NA
      109 109 SV - AV - AT - ST        NA      NA      NA         NA     NA    NA
      110 110 AT - AV - ST - SV        NA      NA      NA         NA     NA    NA
      111 111 SV - AV - AT - ST        NA      NA      NA         NA     NA    NA
      112 112 SV - AT - ST - AV        NA      NA      NA         NA     NA    NA
      113 113 ST - AT - AV - SV        NA      NA      NA         NA     NA    NA
      114 114 ST - SV - AT - AV        NA      NA      NA         NA     NA    NA
      115 115 AT - ST - AV - SV        NA      NA      NA         NA     NA    NA
      116 116 AV - SV - AT - ST        NA      NA      NA         NA     NA    NA
      117 117 AV - ST - AT - SV        NA      NA      NA         NA     NA    NA
      118 118 AT - AV - ST - SV        NA      NA      NA         NA     NA    NA
      119 119 ST - SV - AV - AT        NA      NA      NA         NA     NA    NA
      120 120 AT - AV - ST - SV        NA      NA      NA         NA     NA    NA
      121 121 AV - SV - ST - AT        NA      NA      NA         NA     NA    NA
      122 122 SV - ST - AT - AV        NA      NA      NA         NA     NA    NA
      123 123 AT - SV - ST - AV        NA      NA      NA         NA     NA    NA
      124 124 AT - SV - ST - AV        NA      NA      NA         NA     NA    NA
      125 125 SV - ST - AT - AV        NA      NA      NA         NA     NA    NA
      126 126 AV - AT - ST - SV        NA      NA      NA         NA     NA    NA
      127 127 ST - AT - SV - AV        NA      NA      NA         NA     NA    NA
      128 128 ST - SV - AT - AV        NA      NA      NA         NA     NA    NA

