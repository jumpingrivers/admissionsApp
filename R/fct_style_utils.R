#' Create title logo
#'
#' Returns UT logo with correct dimensions for app title.
title_logo <- function() {
  shiny::div(
    style = "text-align: justify; width:150;",
    shiny::tags$img(
      style = "display: block;
               margin-left:-20px;
               margin-top:-10px;
               margin-bottom:-20px",
      src = "www/ie_logo.png",
      width = "170",
      height = "50",
      alt = "UT Data"
    ),
    shiny::h3("Admissions dashboard",
      style = "position: absolute; right: 1%; top: 0%; margin-top: 10px;"
    )
  )
}

#' Create custom litera theme
#'
#' Modify litera theme with custom fonts and colours.
litera_theme <- function() {
  bslib::bs_theme(
    bootswatch = "litera",
    bg = "#FFFFFF", fg = "#000",
    primary = "#B5302A",
    base_font = bslib::font_google("Source Serif Pro"),
    heading_font = bslib::font_google("Josefin Sans", wght = 100)
  )
}

#' 8-color palette
colors_8 <- function() {
  c(
    "#ba1c21",
    "#001f82",
    "#61333d",
    "#626370",
    "#1b2442",
    "#0b8581",
    "#7e9e9c",
    "#2a571d"
  )
}

#' 10-color palette
colors_10 <- function() {
  c(
    "#ba1c21",
    "#001f82",
    "#61333d",
    "#626370",
    "#1b2442",
    "#0b8581",
    "#7e9e9c",
    "#575978",
    "#2a571d",
    "#0e3303"
  )
}

#' Value box color palette
colors_value_boxes <- function() {
  c(
    "#1cb05c",
    "#bc5b10",
    "#8897be",
    "#9e557f",
    "#aec2b6",
    "#03518c"
  )
}

#' Utah Tech Color Palette
#'
#' A rotating color palette from colors defined by the Utah Tech University branding guide.
#'
#' @param n The number of colors to include from the color palette.
#'
#' @return A vector of hex colors, of length n.
#' @export
#'
#' @examples
#' ut_color_palette(2)
#' ut_color_palette(100)
ut_color_palette <- function(n) {
  brookes_blues <- c(
    "#003058",
    "#004782",
    "#005eac",
    "#0075d7",
    "#028cff",
    "#2c9fff"
  )

  rock_reds <- c(
    "#BA1C21",
    "#95161A",
    "#771215",
    "#5F0E11",
    "#4C0B0E",
    "#3D090B"
  )

  desert_sands <- c(
    "#E6CCB3",
    "#B8A38F",
    "#938272",
    "#76685B",
    "#5E5349",
    "#4B423A"
  )

  color_palette <- c(brookes_blues, rock_reds, desert_sands)

  return(rep(color_palette, length.out = n))
}
