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
  shiny::tabPanel("Sunburst",
                  shiny::fluidRow(
                    shiny::column(width = 6,
                                  utVizSunburst::sunburstOutput(ns("sunburst"))),
                    shiny::column(width = 6,
                                  reactable::reactableOutput(ns("table")))
                  ))
}

#' sunburst Server Functions
#'
#' @noRd
mod_sunburst_server = function(id, admissions) {
  shiny::moduleServer(id, function(input, output, session) {
    ns = session$ns # nolint

    output$sunburst = utVizSunburst::renderSunburst({
      utVizSunburst::sunburst(admissions,
                              steps = c("gpa", "club", "student_type", "outcome"))
    })

    output$table = reactable::renderReactable({
      admissions_subset = admissions[c("gpa", "club", "student_type", "outcome")][1:4, ]
      admissions_subset["color"] = c("#4e79a7", "#7792b3", "#97acc9", "#b5c8e1")
      reactable::reactable(admissions_subset,
                           columns = list(
                             color = reactable::colDef(style =  function(value) {
                               list(background = value,
                                    color = "transparent")
                             }
                           )))
    })
  })
}
