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
  tagList(
 
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
    
## To be copied in the UI
# mod_line_ui("line_1")
    
## To be copied in the server
# mod_line_server("line_1")
