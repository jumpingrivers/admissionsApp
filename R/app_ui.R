#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @noRd
app_ui = function(request) {
  shiny::tagList(
    shiny::tags$head(
      golem_add_external_resources()
    ),
    shiny::navbarPage(
      title = title_logo(),
      windowTitle = "Admissions",
      theme = litera_theme(),
      mod_line_ui("line_1"),
      mod_sunburst_ui("sunburst_1"),
      mod_help_ui("help_1")
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
golem_add_external_resources = function() {
  golem::add_resource_path(
    "www",
    app_sys("app/www")
  )

  shiny::tags$head(
    shiny::tags$link(rel = "icon", type = "image/png", href = "www/favicon.png")
  )
}

#' Create title logo
#'
#' Returns UT logo with correct dimensions for app title.
title_logo = function() {
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
    )
  )
}

#' Create custom litera theme
#'
#' Modify litera theme with custom fonts and colours.
litera_theme = function() {
  bslib::bs_theme(
    bootswatch = "litera",
    bg = "#FFFFFF", fg = "#000",
    primary = "#B5302A",
    base_font = bslib::font_google("Source Serif Pro"),
    heading_font = bslib::font_google("Josefin Sans", wght = 100))
}
