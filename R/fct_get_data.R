#' Read daily enrollment from pin
#'
#' Read parsed daily enrollment from pin.
#' Requires env var `PIN_USER` for path to data file called `daily_enrollment_pin`.
#'
#' @param   method   Scalar character. Which method should be used for accessing the enrollment
#' data? Valid choices: `from_rds` (the default; reads from a package-embedded dataset), `from_sql`
#' (pulls from a database), `from_pin` (pulls from a pin-board on Posit connect).
#'
#' @return   data.frame containing the daily enrollment data.

get_daily_enrollment = function(method="from_rds") {

  if (method == "from_sql") {
    daily_enrollment_df <- utHelpR::get_data_from_sql_file("daily_enrollment.sql", dsn="edify", context="shiny")
  }
  else if (method == "from_rds") {
   daily_enrollment_df <- readRDS(here::here("inst", "app", "fake_data", "daily_enrollment.rds")) %>%
    dplyr::mutate( year = as.character( sample(1978:2022, length(term_id), replace = TRUE) ),
                   season = as.character( sample(c("Spring", "Fall", "Summer"), length(term_id), replace = TRUE) ))
  }
  else if (method == "from_pin") {
    pin_user = get_pin_user()
    board_rsc = pins::board_rsconnect()
    enrollment_path = glue::glue("{pin_user}/daily_enrollment_pin")
    daily_enrollment_df = pins::pin_read(board_rsc, enrollment_path)
  }
  else {
    stop("Method for gathering daily enrollment data is not defined.")
  }
  return(daily_enrollment_df)
}


#' Get user for pinned data
#'
#' Read environment variable which sets
#' which RStudio Connect account pinned data is read from
get_pin_user = function() {
  pin_user = Sys.getenv("PIN_USER")
  if (pin_user == "") {
    cli::cli_alert_warning("Ensure you have an environment variable called PIN_USER")
    cli::cli_alert_warning("PIN_USER should be the user where data pins are uploaded")
    stop("Fix env variable PIN_USER and try again")
  }
  return(pin_user)
}
