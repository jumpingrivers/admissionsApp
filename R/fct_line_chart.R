#' Create tab 1 line chart
#'
#' Line chart showing enrollment counts
#' over days before start of classes
#' @param df Tibble containing enrollment by college data
#' @param group What to group line chart by
#' @param custom_colors Named character vector containing custom colors
#' @param pct_change Show pct_change or not?
#' @param input_year Currently selected year (only used if pct_change is TRUE)
enrollment_line_chart = function(df, group, custom_colors, pct_change, input_year) {
  g = ggplot2::ggplot(df, ggplot2::aes(x = .data$days_to_term_start,
                                       y = .data$headcount))
  if (group != "none") {
    g = g +
      ggplot2::aes(color = !!rlang::sym(group))
  }

  if (pct_change) {
    previous_year = as.numeric(input_year) - 1
    formatted = dplyr::mutate(df,
                              pct_change = paste0("% change from ",
                                                  previous_year,
                                                  ": ",
                                                  pct_change,
                                                  "%"))
    g = g +
      ggplot2::aes(text = formatted$pct_change,
                   group = 1)
  }
  g = g +
    ggplot2::geom_line() +
    ggplot2::scale_x_continuous(breaks = scales::pretty_breaks()) +
    ggplot2::scale_y_continuous(labels = scales::comma) +
    custom_theme() +
    ggplot2::labs(
      title = "Daily Headcount",
      subtitle = "Daily Headcount",
      caption = "Data supplied by OIE",
      x = "Days before start of classes",
      y = "Enrollment",
      color = stringr::str_to_title(gsub("_", " ", group))
    ) +
    ggplot2::scale_colour_manual(values = custom_colors)

  if (pct_change) {
    g = g %>% plotly::ggplotly(tooltip = c("college", "days_to_term_start", "headcount", "text"))
    return(g)
  }
  return(g)
}

#' Custom plot theme
#'
#' Returns custom plot theme, which is a modification of
#' `ggplot2::theme_minimal()`.
custom_theme = function() {
  ggplot2::theme_minimal() +
    ggplot2::theme(
      panel.grid.major.x = ggplot2::element_blank(),
      panel.grid.minor.x = ggplot2::element_blank(),
      panel.grid.minor.y = ggplot2::element_blank(),
      plot.subtitle = ggplot2::element_text(color = "#a6a6a6", size = 10),
      plot.caption = ggplot2::element_text(color = "#a6a6a6", size = 8, face = "italic")
    )
}
