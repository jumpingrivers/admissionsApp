#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @noRd
app_server = function(input, output, session) {
  waiter::waiter_show(
    html = shiny::HTML(paste(waiter::spin_fading_circles(),
                             shiny::br(),
                             shiny::p("Waiting for brilliance...")))
  )
  daily_enrollment = get_daily_enrollment()
  waiter::waiter_hide()

  mod_line_server("line_1", daily_enrollment)
  mod_sunburst_server("sunburst_1")
  mod_help_server("help_1")
}
