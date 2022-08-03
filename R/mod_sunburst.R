#' sunburst UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_sunburst_ui = function(id) {
  ns = shiny::NS(id) # nolint
  shiny::tabPanel(
    "Sunburst",
    shiny::fluidRow(
      shiny::column(width = 6, shiny::wellPanel("Sunburst widget")),
      shiny::column(width = 6, shiny::wellPanel("Sunburst table"))
    )
  )
}

#' sunburst Server Functions
#'
#' @noRd
mod_sunburst_server = function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    ns = session$ns # nolint

  })
}
