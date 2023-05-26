#' Read daily enrollment data for the app
#'
#' Enrollment data is obtained by SQL query, from a pin or using a packaged `.rds` file.
#'
#' @param   method   Scalar character. Which method should be used for accessing the enrollment
#' data? Valid choices: `from_rds` (the default; reads from a package-embedded dataset), `from_sql`
#' (pulls from a database), `from_pin` (pulls from a pin-board on Posit connect).
#'
#' @return   data.frame containing the daily enrollment data.

get_daily_enrollment <- function(method = "from_rds") {
  if (method == "from_sql") {
    daily_enrollment_df <- utHelpR::get_data_from_sql_file(
      "daily_enrollment.sql",
      dsn = "edify", context = "shiny"
    )
  } else if (method == "from_rds") {
    daily_enrollment_df <- readRDS(
      here::here("inst", "app", "fake_data", "daily_enrollment.rds")
    ) %>%
      dplyr::mutate(
        year = as.character(
          sample(1978:2022, length(term_id), replace = TRUE)
        ),
        season = as.character(
          sample(c("Spring", "Fall", "Summer"), length(term_id), replace = TRUE)
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
