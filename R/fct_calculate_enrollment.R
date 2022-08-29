#' Calculate enrollment
#'
#' Using user-entered filters and columns for grouping
#' calculate enrollment headcount across days before term start.
#'
#' @param df Tibble containing daily enrollment data
#' @param input_year Year e.g. "2022"
#' @param input_season Season e.g. "Fall"
#' @param input_group Group e.g. College
#' @param input_filter_by Which filters are selected e.g. gender
#' @param input_filter_values List of selected values from filters
#' @param pct_change Should percent change from previous year be added to data?
calculate_enrollment = function(df,
                                input_year,
                                input_season,
                                input_group,
                                input_filter_by,
                                input_filter_values,
                                pct_change) {

  if (pct_change) {
    input_year = c(input_year, as.numeric(input_year) - 1)
  }

  filtered_data = filter_data(df,
                              input_year,
                              input_season,
                              input_filter_by,
                              input_filter_values)

  if (nrow(filtered_data) == 0) {
    return(filtered_data)
  }

  summarised_data = calculate_headcount(
filtered_data, input_group, input_year, pct_change)

  if (pct_change) {
    summarised_data = add_pct_change(summarised_data)
  }

  return(summarised_data)
}

#' Filter data
#'
#' Filter year, season and any added group filters.
#'
#' @param df Tibble containing enrollment data
#' @param input_year Year e.g. 2022
#' @param input_season Season e.g. "Fall"
#' @param input_filter_by Which filters are selected e.g. gender
#' @param input_filter_values List of selected values from filters
filter_data = function(df, input_year, input_season, input_filter_by, input_filter_values) {
  first_filter = dplyr::filter(
df, .data$year %in% input_year, .data$season %in% input_season)
  if (is.null(input_filter_by)) {
    return(first_filter)
  }
  second_filter = filter_groups(
first_filter, input_filter_by, input_filter_values)
  return(second_filter)
}

#' Filter groups
#'
#' Filter values based on user inputs.
#' @param df Tibble containing retention data
#' @param filter_by Which filters are selected e.g. gender
#' @param filter_values List of selected values from filters
filter_groups = function(df, filter_by, filter_values) {
  for (i in seq_along(filter_values)) {
    df = filter_group(
      df,
      filter_by = filter_by,
      group = names(filter_values)[i],
      values = filter_values[[i]]
    )
  }
  return(df)
}

#' Filter group
#'
#' Filter values based on user inputs, only if
#' group is actually selected.
#' @param df Tibble containing retention data
#' @param filter_by Which filters are selected e.g. gender
#' @param group Current filter e.g. gender
#' @param values Current values e.g. Male
filter_group = function(df, filter_by, group, values) {
  if (group %in% filter_by) {
    filtered_df = dplyr::filter(df, !!rlang::sym(group) %in% values)
    return(filtered_df)
  }
  return(df)
}

#' Calculate head count
#'
#' Sum enrolled students based on selected groupings
#' to calculate headcount.
#'
#' @param df Tibble containing filtered enrollment data
#' @param input_group Selected input group
#' @param input_year Selected input year
#' @param pct_change Should percent change from previous year be added to data?
calculate_headcount = function(df, input_group, input_year, pct_change) {
  grouped_data = dplyr::group_by(df, .data$days_to_term_start)
  if (input_group != "none") {
    grouped_data = dplyr::group_by(grouped_data,
                                   !!rlang::sym(input_group), .add = TRUE)
  }
  if (pct_change) {
    grouped_data = dplyr::group_by(grouped_data,
                                   .data$year, .add = TRUE)
  }
  grouped_data %>%
    dplyr::summarize(headcount = sum(.data$is_enrolled)) %>%
    dplyr::ungroup()
}

#' Add percent change
#'
#' Append column including percent change from previous year.
#' Only used if selected year is current year and current year only.
#' @param df Tibble containing summarised and filtered data.
add_pct_change = function(df) {

  current_year = lubridate::year(lubridate::today())
  previous_year = current_year - 1

  df = try({
    df %>%
      dplyr::filter(.data$year %in% c(current_year, previous_year)) %>%
      dplyr::mutate(year_name = dplyr::if_else(.data$year == current_year,
                                               "current",
                                               "previous")) %>%
      dplyr::select(-.data$year) %>%
      tidyr::pivot_wider(names_from = .data$year_name,
                         values_from = .data$headcount) %>%
      dplyr::mutate(year = 2022,
                    pct_change = round(
                      ((.data$current - .data$previous) / .data$previous) * 100
                      )) %>%
      tidyr::pivot_longer(c("previous", "current"),
                          names_to = "year_name",
                          values_to = "headcount") %>%
      dplyr::filter(.data$year_name == "current") %>%
      dplyr::select(-.data$year_name) %>%
      tidyr::drop_na()
  })
  if ("try-error" %in% class(df)) {
    return(dplyr::tibble())
  }
  return(df)
}
