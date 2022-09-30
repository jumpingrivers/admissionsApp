#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @noRd
app_server <- function(input, output, session) {
  waiter::waiter_show(
    html = shiny::HTML(paste(waiter::spin_fading_circles(),
                             shiny::br(),
                             shiny::p("Waiting for brilliance...")))
  )

  #daily_enrollment <- get_daily_enrollment(method="from_sql")

  daily_enrollment_df <- utHelpR::get_data_from_sql_file("daily_enrollment.sql", dsn="edify", context="shiny")

  admissions_funnel_df <- utHelpR::get_data_from_sql_file("admissions_funnel.sql", dsn="edify", context="shiny")

  waiter::waiter_hide()

  #mod_line_server("line_1", daily_enrollment)
  #mod_sunburst_server("sunburst_1", utVizSunburst::admissions)
  #mod_help_server("help_1")

  # Daily Enrollment Module ####
  utShinyMods::mod_over_time_line_chart_server("daily_enrollment_line_chart",
                                               df=daily_enrollment_df,
                                               time_col=c("Days Until Class Start"="days_to_class_start"),
                                               metric_col=c("Headcount"="student_id"),
                                               metric_summarization_function=dplyr::n_distinct,
                                               grouping_cols=c("Term" = "term_desc",
                                                               "Season" = "season",
                                                               "Academic Year" = "academic_year",
                                                               "College" = "college",
                                                               "Department" = "department",
                                                               "Program" = "program",
                                                               "Gender" = "gender",
                                                               "Race/Ethnicity"="race_ethnicity"),
                                               filter_cols=c("Term" = "term_desc",
                                                             "Season" = "season",
                                                             "Academic Year" = "academic_year",
                                                             "College" = "college",
                                                             "Department" = "department",
                                                             "Program" = "program",
                                                             "Gender" = "gender",
                                                             "Race/Ethnicity"="race_ethnicity"),
                                               module_title="Daily Enrollment")

  #utShinyMods::mod_over_time_line_chart_server("daily_enrollment_line_chart")

  utShinyMods::mod_sunburst_diagram_server("admissions_funnel_sunburst_diagram",
                                           df=admissions_funnel_df,
                                           step_cols=c("prospect_status", "admit_status"),
                                           module_title="Admissions Funnel")

  utShinyMods::mod_help_server("help_module")
}
