# format_value

    Code
      format_value(0.00041231, "p")
    Output
      [1] "< .001"

---

    Code
      format_value(0.00041231, "r")
    Output
      [1] ".00"

---

    Code
      format_value(1.341231, "d")
    Output
      [1] "1.34"

---

    Code
      format_p(0.0041231)
    Output
      [1] ".004"

---

    Code
      format_p(0.00041231)
    Output
      [1] "< .001"

---

    Code
      format_r(0.41231)
    Output
      [1] ".41"

---

    Code
      format_r(0.041231)
    Output
      [1] ".04"

---

    Code
      format_d(1.341231)
    Output
      [1] "1.34"

---

    Code
      format_d(0.341231)
    Output
      [1] "0.34"

