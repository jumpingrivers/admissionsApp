#' help UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_help_ui = function(id) {
  ns = shiny::NS(id) # nolint
  shiny::tabPanel(
    "Help",
    "Awaiting content"
  )
}

#' help Server Functions
#'
#' @noRd
mod_help_server = function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    ns = session$ns # nolint

  })
}
