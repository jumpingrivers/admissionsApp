#' line UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_line_ui = function(id) {
  ns = shiny::NS(id) # nolint

  year_min <- 2017
  year_max <- this_year()

  shiny::tabPanel(
    "Enrollment",
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        shiny::selectInput(
          ns("group"),
          "Select Group",
          choices = c(
            c("College" = "college"),
            c("Gender" = "gender"),
            c("Race/Ethnicity" = "race_ethnicity"),
            c("None" = "none")),
          selected = "college"
        ),
        shinyWidgets::pickerInput(
          ns("season"),
          label = "Season",
          choices = c("Fall", "Spring"),
          selected = "Fall",
          options = list(`actions-box` = TRUE)),
        shinyWidgets::pickerInput(
          ns("year"),
          label = "Year",
          choices = as.character(seq(from = year_min, to = year_max)),
          selected = as.character(year_max),
          multiple = TRUE,
          options = list(`actions-box` = TRUE)),
        shinyWidgets::pickerInput(
          ns("add_filter"),
          "Add Filter",
          choices = c(
            c("College" = "college"),
            c("Gender" = "gender"),
            c("Race/Ethnicity" = "race_ethnicity")),
          multiple = TRUE,
          options = list(`actions-box` = TRUE)
        ),
        conditional_filter_panel("gender", "Gender", id),
        conditional_filter_panel("race_ethnicity", "Race/Ethnicity", id),
        conditional_filter_panel("college", "College", id)),
      shiny::mainPanel(
        plotly::plotlyOutput(ns("enrollment_lines")) %>% shinycssloaders::withSpinner()
      )
    )
  )
}

#' line Server Functions
#'
#' @noRd
mod_line_server = function(id, daily_enrollment) {
  shiny::moduleServer(id, function(input, output, session) {
    ns = session$ns # nolint

    shiny::observeEvent(input$group, {
      remaining_choices = remaining_group_choices(input$group)
      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "add_filter",
        label = "Add Filter",
        choices = remaining_choices
      )
    })

    output$gender_panel = conditional_filter_input(
      daily_enrollment,
      "gender",
      "Gender",
      id,
      session)

    output$race_ethnicity_panel = conditional_filter_input(
      daily_enrollment,
      "race_ethnicity",
      "Race/Ethnicity",
      id,
      session)

    output$college_panel = conditional_filter_input(
      daily_enrollment,
      "college",
      "College",
      id,
      session)

    filter_inputs = shiny::reactive({
      list(
        "gender" = input$gender,
        "race_ethnicity" = input$race_ethnicity,
        "college" = input$college
      )
    })

    current_year = format(Sys.time(), "%Y")
    pct_change = shiny::reactive(all(input$year == current_year))

    enrollment_data = shiny::reactive({
      df = calculate_enrollment(
        daily_enrollment,
        input_year = input$year,
        input_season = input$season,
        input_group = input$group,
        input_filter_by = input$add_filter,
        input_filter_values = filter_inputs(),
        pct_change()
      )
      shiny::validate(
        shiny::need(nrow(df) != 0,
                    "There is no data which matches these filters.
                    \n Please update your filters.")
      )
      return(df)
    })

    output$enrollment_lines = plotly::renderPlotly({
      enrollment_line_chart(enrollment_data(),
                            input$group,
                            colors_10(),
                            pct_change(),
                            input$year)
    })
  })
}

#' Return the current year based on the system time
#'
#' @return The current year as a scalar number.

this_year <- function() {
  as.numeric(format(Sys.time(), "%Y"))
}

#' Create remaining group choices
#'
#' Return all group choices except the selected group.
#'
#' @param selected_group Group selected in input widget
remaining_group_choices = function(selected_group = "") {
  all_choices = c(
    c("College" = "college"),
    c("Gender" = "gender"),
    c("Race/Ethnicity" = "race_ethnicity"))
  without_selected = all_choices[all_choices != selected_group]
  return(without_selected)
}


#' Create conditional filter input
#'
#' Create conditional panel containing pickerInput
#' created by `conditional_filter_input()`.
#' This function is used in the UI (contains `shiny::uiOutput`)
#' @param col_name Which column to create filter for
#' @param input_label Label for pickerInput
#' @param id ID for namespace
conditional_filter_panel = function(col_name, input_label, id) {
  ns = shiny::NS(id)
  shiny::conditionalPanel(
    condition = glue::glue("input.add_filter.includes('{col_name}')"),
    shiny::uiOutput(ns(glue::glue("{col_name}_panel"))),
    ns = shiny::NS(id)
  )
}

#' Create conditional filter input
#'
#' Create pickerInput to be used in
#' conditional panel created by `conditional_filter_panel()`
#' This function is used in the server (contains `shiny::renderUI`)
#' @param df Tibble containing retentions data
#' @inheritParams conditional_filter_panel
#' @param session Shiny session
conditional_filter_input = function(df, col_name, input_label, id, session) {
  ns = session$ns
  shiny::renderUI({
    shinyWidgets::pickerInput(
      ns(glue::glue("{col_name}")),
      label = input_label,
      choices = unique(df[[col_name]]),
      selected = unique(df[[col_name]]),
      multiple = TRUE,
      options = list(`actions-box` = TRUE)
    )
  })
}
