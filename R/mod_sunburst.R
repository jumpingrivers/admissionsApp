#' sunburst UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_sunburst_ui <- function(id){
  ns <- NS(id)
  shiny::tabPanel(
    "Sunburst",
    shiny::fluidRow(
      shiny::column(width = 6, shiny::wellPanel()),
      shiny::column(width = 6, shiny::wellPanel())
    )
  )
}

#' sunburst Server Functions
#'
#' @noRd
mod_sunburst_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}
