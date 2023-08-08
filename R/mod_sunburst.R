#' sunburst UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_sunburst_ui <- function(id) {
  ns <- shiny::NS(id) # nolint
  shiny::tabPanel(
    "Sunburst",
    shiny::fluidRow(
      shiny::column(
        width = 6,
        utVizSunburst::sunburstOutput(ns("sunburst"))
      ),
      shiny::column(
        width = 6,
        reactable::reactableOutput(ns("table"))
      )
    )
  )
}

#' sunburst Server Functions
#'
#' @noRd
mod_sunburst_server <- function(id, admissions) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns # nolint

    mouseover_handler <- utVizSunburst::get_shiny_input_handler(
      inputId = ns("sunburst_sector_data"),
      type = "path_data"
    )
    output$sunburst <- utVizSunburst::renderSunburst({
      utVizSunburst::sunburst(admissions,
        palette = colors_8(),
        steps = c("college", "student_type", "outcome", "gpa"),
        mouseover_handler = mouseover_handler
      )
    })

    sector_data <- shiny::eventReactive(input$sunburst_sector_data, {
      input$sunburst_sector_data
    })

    output$table <- reactable::renderReactable({
      reactable::reactable(sector_data(),
        columns = list(color = reactable::colDef(
          style = function(value) {
            list(
              background = value,
              color = "transparent"
            )
          }
        ))
      )
    })
  })
}
