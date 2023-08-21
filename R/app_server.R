#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @noRd
app_server <- function(input, output, session) {
  waiter::waiter_show(
    html = shiny::HTML(paste(
      waiter::spin_fading_circles(),
      shiny::br(),
      shiny::p("Waiting for brilliance...")
    ))
  )

  daily_enrollment_df <- get_daily_enrollment(
    method = get_golem_config("data_source")
  )

  waiter::waiter_hide()

  # Daily Enrollment Module ####
  mod_over_time_line_chart_server("daily_enrollment_line_chart",
    df = daily_enrollment_df,
    time_col = c("Days Until Class Start" = "days_to_class_start"),
    metric_col = c("Headcount" = "student_id"),
    metric_summarization_function = dplyr::n_distinct,
    grouping_cols = c(
      "Term" = "term_desc",
      "Season" = "season",
      "Academic Year" = "academic_year",
      "College" = "college",
      "Department" = "department",
      "Program" = "program",
      "Gender" = "gender",
      "Race/Ethnicity" = "race_ethnicity"
    ),
    filter_cols = c(
      "Term" = "term_desc",
      "Season" = "season",
      "Academic Year" = "academic_year",
      "College" = "college",
      "Department" = "department",
      "Program" = "program",
      "Gender" = "gender",
      "Race/Ethnicity" = "race_ethnicity"
    ),
    module_title = "Daily Enrollment"
  )

  # The data that will be presented in the sunburst plot has yet to be finalized.
  # Hence, the page is being hidden until it is required in the app.
  # When finalized a pin should be added for the admissions funnel data.
  if (get_golem_config("show_sunburst")) {
    admissions_funnel_df <- shiny::reactive(
      get_admissions_funnel(
        method = "from_fake_data" # get_golem_config("data_source")
      )
    )

    mod_sunburst_server("sunburst_1", admissions_funnel_df())
  }

  mod_help_server("help_module")
}
