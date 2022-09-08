#' Read daily enrollment from pin
#'
#' Read parsed daily enrollment from pin.
#' Requires env var PIN_USER for path to data file
#' called daily_enrollment.
get_daily_enrollment = function() {
  pin_user = get_pin_user()
  board_rsc = pins::board_rsconnect()
  enrollment_path = glue::glue("{pin_user}/enrollment")
  enrollment = pins::pin_read(board_rsc, enrollment_path)
  return(enrollment)
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
