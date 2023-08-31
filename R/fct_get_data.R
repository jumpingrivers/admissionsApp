#' Read daily enrollment data for the app
#'
#' Enrollment data is obtained by SQL query, from a pin or using a packaged `.rds` file containing
#' fake data.
#'
#' @param   method   Scalar character. Which method should be used for accessing the enrollment
#' data? Valid choices: `from_fake_data` (the default; reads from a package-embedded dataset),
#' `from_sql` (pulls from a database), `from_pin` (pulls from a pin-board on Posit connect).
#'
#' @return   data.frame containing the daily enrollment data.

get_daily_enrollment <- function(method = "from_fake_data") {
  method <- match.arg(method, c("from_fake_data", "from_sql", "from_pin"))

  if (method == "from_sql") {
    daily_enrollment_df <- utHelpR::get_data_from_sql_file(
      "daily_enrollment.sql",
      dsn = "edify", context = "shiny"
    )
  } else if (method == "from_fake_data") {
    daily_enrollment_df <- readRDS(
      here::here("inst", "app", "fake_data", "daily_enrollment.rds")
    ) %>%
      tidyr::unnest(cols = "data") %>%
      dplyr::mutate(
        year = as.character(
          sample(1978:2022, length(.data[["term_id"]]), replace = TRUE)
        ),
        season = as.character(
          sample(c("Spring", "Fall", "Summer"), length(.data[["term_id"]]), replace = TRUE)
        )
      )
  } else if (method == "from_pin") {
    board <- get_pins_board()
    pin_owner <- "rsconnectapi!service"
    pin_name <- "daily_enrollment_pin"
    daily_enrollment_df <- pins::pin_read(board, name = glue::glue("{pin_owner}/{pin_name}"))
  } else {
    stop("Method for gathering daily enrollment data is not defined.")
  }

  return(daily_enrollment_df)
}

#' Read admissions funnel data
#'
#' @param   method   Scalar character. Which method should be used to obtain admissions-funnel data?
#'   Options are `from_sql` and `from_fake_data` (the default).
#'
#' @return   data-frame containing the admissions-funnel data.

get_admissions_funnel <- function(method = "from_fake_data") {
  method <- match.arg(method, choices = c("from_sql", "from_fake_data"))

  if (method == "from_sql") {
    return(
      utHelpR::get_data_from_sql_file("admissions_funnel.sql", dsn = "edify", context = "shiny")
    )
  } else if (method == "from_fake_data") {
    return(utVizSunburst::admissions)
  } else {
    stop("Method for gathering admissions-funnel data is not defined.")
  }
}

#' Access the pins board that contains data for this app
#'
#' If running outside of Connect, this requires the {pins} server/account/key to be defined in the
#' {golem} config for this app. These values are typically stored in the environment variables
#' `CONNECT_SERVER`, `CONNECT_ACCOUNT` and `CONNECT_API_KEY`. They are accessed from the fields
#' `connect_server`, `connect_account`, `connect_api_key` in the config.
#'
#' If running on Connect, the server/account/key information is not used.
#'
#' @return   A {pins} board object

get_pins_board <- function() {
  if (is_connect()) {
    return(pins::board_connect())
  }

  pins::board_connect(
    server = get_golem_config("connect_server"),
    account = get_golem_config("connect_account"),
    key = get_golem_config("connect_api_key")
  )
}
