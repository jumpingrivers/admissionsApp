#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @noRd
app_server = function(input, output, session) {
  mod_line_server("line_1")
  mod_sunburst_server("sunburst_1")
  mod_help_server("help_1")
}
