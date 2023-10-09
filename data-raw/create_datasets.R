library(dplyr)
load("data-raw/admission.rda")

term_id_to_season <- function(x) {
  stopifnot(all(nchar(x) == 6))
  term_code <- substr(x, 5, 6)
  mapping <- c(
    "40" = "Fall",
    "20" = "Spring",
    "30" = "Summer"
  )

  mapping[term_code]
}

term_id_to_desc <- function(x) {
  stopifnot(all(nchar(x) == 6))
  year <- substr(x, 1, 4)
  season <- term_id_to_season(x)
  paste(season, year, sep = " ")
}

daily_enrollment <- daily_enrollment %>%
  dplyr::mutate(
    term_desc = term_id_to_desc(term_id),
    days_to_class_start = days_to_term_start
  ) %>%
  dplyr::select(
    -"days_to_term_start"
  ) %>%
  dplyr::filter(
    is_enrolled,
    days_to_class_start < 21
  ) %>%
  tidyr::nest(
    data = "days_to_class_start"
  )

saveRDS(daily_enrollment, "inst/app/fake_data/daily_enrollment.rds")
