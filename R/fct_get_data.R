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
    daily_enrollment_df <- utHelpR::get_data_from_sql_file("daily_enrollment.sql", dsn = "edify", context = "shiny")
  } else if (method == "from_rds") {
    daily_enrollment_df <- readRDS(here::here("inst", "app", "fake_data", "daily_enrollment.rds")) %>%
      dplyr::mutate(
        year = as.character(sample(1978:2022, length(term_id), replace = TRUE)),
        season = as.character(sample(c("Spring", "Fall", "Summer"), length(term_id), replace = TRUE))
      )
  } else if (method == "from_pin") {
    daily_enrollment_df <- read_enrollment_pin()
  } else {
    stop("Method for gathering daily enrollment data is not defined.")
  }

  return(daily_enrollment_df)
}

#' Read daily enrollment data from pin
#'
#' If running outside of Connect, this requires the {pins} server/account/key to be defined in the
#' {golem} config for this app. The pins key is typically obtained from the environment variable
#' `RSCONNECT_SERVICE_USER_API_KEY`.
#'
#' @return   data.frame containing the daily enrollment data.

read_enrollment_pin <- function() {
  pin_name <- "daily_enrollment_pin"
  pin_path <- glue::glue("rsconnectapi!service/{pin_name}")

  board <- if (is_connect()) {
    pins::board_connect()
  } else {
    pins::board_connect(
      server = get_golem_config("pins_server", config = "testing"),
      account = get_golem_config("pins_account", config = "testing"),
      key = get_golem_config("pins_key", config = "testing")
    )
  }

  pins::pin_read(board, pin_path)
}
