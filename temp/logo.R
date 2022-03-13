# logo

library(hexSticker) # Create Hexagon Sticker in R
library(showtext)   # Using Fonts More Easily in R Graphs

## Loading Google fonts (http://www.google.com/fonts)
font_add_google("Inconsolata", "incon")

sticker(
  # Subplot (image)
  subplot = "logo-image.png",       # Image name
  s_y = 0.88,                       # Position of the sub plot (y)
  s_x = 1.05,                       # Position of the sub plot (x)
  s_width = 0.90,                   # Width of the sub plot
  s_height=0.005,                   # Height of the sub plot
  # Font
  package = "rempsyc",              # Package name (will be printed on the sticker)
  p_size = 90,                      # Font size of the text
  p_y = 0.8,                        # Position of the font (y)
  p_x=0.75,                         # Position of the font (x)
  p_family = "incon",               # Defines font
  # Spotlight
  spotlight = TRUE,                 # Enables spotlight
  l_y=0.8,                          # Position of spotlight (y)
  l_x=0.7,                          # Position of spotlight (x)
  # Sticker colors
  h_fill = "#5d8aa6",               # Color for background
  h_color = "#2A5773",              # Color for border
  # Resolution
  dpi=1200,                         # Sets DPI
  # Save
  filename="logo.png"               # Sets file name and location where to store the sticker
) -> my.logo
plot(my.logo)

