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
  tagList(
 
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
    
## To be copied in the UI
# mod_sunburst_ui("sunburst_1")
    
## To be copied in the server
# mod_sunburst_server("sunburst_1")
