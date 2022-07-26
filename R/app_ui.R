#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  shiny::tagList(
    tags$head(
      golem_add_external_resources()
    ),
    shiny::navbarPage(
      title = "Admissions Data Explorer",
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
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  golem::add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    golem::favicon(),
    golem::bundle_resources(
      path = app_sys("app/www"),
      app_title = "admissionsApp"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
