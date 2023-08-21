testthat::test_that("enrollment calculation works", {
  file_path <- system.file("app/fake_data/daily_enrollment.rds",
    package = "shinyAdmissions",
    mustWork = TRUE
  )
  raw_enrollment <- readRDS(file_path)
  daily_enrollment <- raw_enrollment %>%
    tidyr::separate(.data$term_id, c("year", "season"), sep = 4) %>%
    dplyr::mutate(season = dplyr::if_else(.data$season == 40, "Fall", "Spring"))
  filter_by <- c("gender")
  filter_values <- list(
    "gender" = "F",
    "race_ethnicity" = "Hispanic",
    "college" = unique(daily_enrollment$college)
  )
  group <- "college"
  year <- 2018
  season <- "Fall"
  pct_change <- FALSE
  enrollment <- shinyAdmissions:::calculate_enrollment(
    daily_enrollment, # nolint
    year,
    season,
    group,
    filter_by,
    filter_values,
    pct_change
  )
  testthat::expect_equal(enrollment$headcount[1], 4)
  testthat::expect_equal(nrow(enrollment), 1547)
  testthat::expect_equal(ncol(enrollment), 3)
  testthat::expect_false(any(is.na(enrollment$headcount)))
  testthat::expect_snapshot(enrollment)
})
