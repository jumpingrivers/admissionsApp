#' over_time_line_chart UI Function
#'
#' To be copied in the UI
#' mod_over_time_line_chart_ui("over_time_line_chart_1")
#'
#' To be copied in the server
#' mod_over_time_line_chart_server("over_time_line_chart_1")'
#'
#' @description A shiny Module.
#'
#' @param   id   A unique identifier, linking the UI to the Server
#'
#' @importFrom shiny NS tagList
#'
#' @export

mod_over_time_line_chart_ui <- function(id) {
  ns <- NS(id)
  shiny::tagList(
    shiny::uiOutput(ns("module_title_ui")),
    shiny::fluidRow(
      shiny::column(2, shiny::tagList(
        shiny::uiOutput(ns("grouping_selection_ui")),
        shiny::uiOutput(ns("filter_control_ui")),
        shiny::uiOutput(ns("create_enrollment_ui"))
      )),
      shiny::column(
        10,
        shiny::tagList(plotly::plotlyOutput(ns("over_time_line_chart"), width = NULL))
      )
    )
  )
}

#' over_time_line_chart Server Functions
#'
#' To be copied in the UI
#' mod_over_time_line_chart_ui("over_time_line_chart_1")
#'
#' To be copied in the server
#' mod_over_time_line_chart_server("over_time_line_chart_1")'
#'
#' Justification for using extra parameters in the Server function, can be found in the following
#' documentation: https://shiny.rstudio.com/articles/modules.html
#' Quote from documentation:
#' "You can define the function so that it takes any number of additional parameters, including ...,
#' so that whoever uses the module can customize what the module does."
#'
#' @param   id   A unique identifier, linking the UI to the Server.
#' @param   df   A data frame.
#' @param   time_col   The time column.
#' @param   metric_col   The metric column.
#' @param   metric_summarization_function   A function for summarising the metric.
#' @param   grouping_cols   The columns to be used for grouping.
#' @param   filter_cols   The columns to be used for filtering.
#' @param   module_title   Title for the chart.
#' @param   module_sub_title   Subtitle for the chart.
#'
#' @export

mod_over_time_line_chart_server <- function(id,
                                            df,
                                            time_col = c("Time" = "time_column"),
                                            metric_col = c("Metric" = "metric_column"),
                                            metric_summarization_function = sum,
                                            grouping_cols = c(
                                              "Category 1" = "entity_category_1",
                                              "Category 2" = "entity_category_2",
                                              "Category 3" = "entity_category_3"
                                            ),
                                            filter_cols = c(
                                              "Category 1" = "entity_category_1",
                                              "Category 2" = "entity_category_2",
                                              "Category 3" = "entity_category_3"
                                            ),
                                            module_title = "Title of Module",
                                            module_sub_title = "Sub Title for module.") {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # UI Generation ####
    output$module_title_ui <- shiny::renderUI({
      shiny::tagList(
        htmltools::h2(module_title),
        htmltools::p(module_sub_title)
      )
    })
    output$grouping_selection_ui <- shiny::renderUI({
      shiny::tagList(
        shinyWidgets::pickerInput(ns("grouping_selection"),
          htmltools::tags$b("Group By"),
          choices = grouping_cols,
          multiple = TRUE,
          selected = grouping_cols[1],
          options = list(`actions-box` = TRUE)
        )
      )
    })
    # Filter controls
    output$filter_control_ui <- shiny::renderUI({
      filter_panel_name <- "filter_control"
      filter_control <- shinyWidgets::pickerInput(ns(filter_panel_name),
        htmltools::tags$b("Add/Remove Filter"),
        choices = filter_cols,
        multiple = TRUE,
        options = list(`actions-box` = TRUE)
      )
      filter_displays <- lapply(names(filter_cols), function(filter_label) {
        conditional_filter_panel(filter_cols[[filter_label]], filter_panel_name, session)
      })
      do.call(tagList, list(filter_control, filter_displays))
    })

    for (filter_label in names(filter_cols)) {
      local({
        local_filter_cols <- filter_cols
        local_filter_label <- filter_label
        col_name <- local_filter_cols[[local_filter_label]]
        output_name <- glue::glue("{col_name}_panel")
        output[[output_name]] <- conditional_filter_input(df, col_name, local_filter_label, session)
      })
    }

    # This action button controls when the line-chart is regenerated
    # - This prevents recomputation of the data-frame and plot for the line-chart when the user
    #   incompletely selects the parameters for their chosen line-chart
    # - The reason the button is added using renderUI/uiOutput rather than directly adding the
    #   button to the UI function (mod_over_time_line_chart_ui()) are three-fold:
    #   - a grouping-selection must be specified before it is possible to generate the data-frame
    #     for the line-chart
    #   - changes to the grouping-selection should not directly lead to a newly-generated chart
    #   - we want to generate a default plot when the app starts (i.e., the first chart is generated
    #     without clicking the actionButton)
    #   - so if the actionButton were added in *_ui() it would be ready before the
    #     grouping-selection and would attempt to trigger making the line-chart before the grouping
    #     selection is ready
    output$create_enrollment_ui <- shiny::renderUI({
      shiny::req(input$grouping_selection)
      shiny::actionButton(ns("show_enrollment"), "Update admissions chart")
    })

    # Reactive Dataframe ####
    reactive_over_time_plot_df <- shiny::reactive({
      # Pause plot execution while input values evaluate. This eliminates an error message.
      shiny::req(shiny::isolate(input$grouping_selection))

      plot_df <- get_enrollment_over_time_df(
        df,
        grouping_selection = shiny::isolate(input[["grouping_selection"]]),
        filter_control = shiny::isolate(input[["filter_control"]]),
        filter_values = shiny::isolate(input),
        time_col = time_col,
        metric_col = metric_col,
        metric_summarization_function = metric_summarization_function
      )

      # Pause plot execution if df has no values. This eliminates an error message.
      shiny::req(nrow(plot_df) > 0)
      return(plot_df)
    }) %>%
      # Display the default enrollment chart when the app loads
      # But only update it when the user clicks "Create admissions chart"
      shiny::bindEvent(input$show_enrollment, ignoreNULL = FALSE)

    # Enrollment chart creation ####
    enrollment_chart <- shiny::reactive({
      reactive_plot_df <- reactive_over_time_plot_df()

      x_is_continuous <- !is.character(reactive_plot_df[["x_plot"]])
      if (!x_is_continuous) {
        reactive_plot_df[["x_plot"]] <- as.factor(reactive_plot_df[["x_plot"]])
      }

      group_label <- paste(
        names(grouping_cols)[grouping_cols %in% shiny::isolate(input$grouping_selection)],
        collapse = " | "
      )

      generate_line_chart(
        reactive_plot_df,
        x = .data[["x_plot"]],
        y = .data[["y_plot"]],
        x_is_continuous = x_is_continuous,
        grouping = grouping, # name of a column
        x_label = names(time_col),
        y_label = names(metric_col),
        group_labeling = paste("Grouping Label: ", group_label,
          "</br>",
          "Grouping Value: ", grouping,
          "</br>",
          sep = ""
        ),
        legend_title = group_label
      )
    })

    # Enrollment chart rendering ####
    output$over_time_line_chart <- plotly::renderPlotly(enrollment_chart())
  })
}
