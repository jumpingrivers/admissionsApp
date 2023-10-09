#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @noRd
app_ui <- function(request) {
  shiny::tagList(
    shiny::tags$head(
      golem_add_external_resources()
    ),
    shiny::navbarPage(
      title = title_logo(
        right_aligned_title = "Admissions Dashboard",
        alt = "UT Data"
      ),
      theme = litera_theme(),
      shiny::tabPanel(
        "Daily Enrollment",
        mod_over_time_line_chart_ui("daily_enrollment_line_chart")
      ),
      if (get_golem_config("show_sunburst")) {
        # The data that will be presented in the sunburst plot/page has yet to be finalized.
        # Hence, the page is being hidden until it is required in the app.
        shiny::tabPanel(
          "Admission Funnel",
          mod_sunburst_ui("sunburst_1")
        )
      } else {
        NULL
      },
      shiny::tabPanel(
        "Help",
        mod_help_ui("help_module")
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
golem_add_external_resources <- function() {
  golem::add_resource_path(
    "www",
    app_sys("app/www")
  )

  shiny::tags$head(
    shiny::tags$link(rel = "icon", type = "image/png", href = "www/favicon.png"),
    waiter::useWaiter()
  )
}
