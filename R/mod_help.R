#' help UI Function
#'
#' @description A shiny Module.
#'
#' @param   id   Module ID for linking UI with server.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList

mod_help_ui <- function(id) {
  ns <- shiny::NS(id) # nolint
  shiny::tagList(
    "Awaiting content"
  )
}

#' help Server Functions
#'
#' @param   id   Module ID for linking UI with server.
#' @noRd

mod_help_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns # nolint
  })
}
