#' Is the app running on Connect?
#'
#' @return   Boolean. TRUE if the app is running on a Connect server.

is_connect <- function() {
  # This environment variable is "rsconnect" when running on a Connect server.
  context <- Sys.getenv("R_CONFIG_ACTIVE", "")
  return(context == "rsconnect")
}

#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#' @return The result of calling `rhs(lhs)`.
NULL

#' @keywords internal
"_PACKAGE"
#' @importFrom rlang .data
NULL
