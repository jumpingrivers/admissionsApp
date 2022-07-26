#' line UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_line_ui <- function(id){
  ns <- NS(id)
  shiny::tabPanel(
    "Enrollment",
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        shiny::selectInput(
          ns("col_1"),
          "Select col 1:",
          choices = c("Choice 1", "Choice 2")
        ),
        shiny::selectInput(
          ns("col_2"),
          "Select col 2:",
          choices = c("Choice 1", "Choice 2")
        )
      ),
      shiny::mainPanel(
        shiny::wellPanel()
      )
    )
  )
}

#' line Server Functions
#'
#' @noRd
mod_line_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}
