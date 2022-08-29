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
      windowTitle = "Admissions Dashboard",
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
    shiny::tags$link(rel = "icon", type = "image/png", href = "www/favicon.png"),
    waiter::useWaiter()
  )
}
