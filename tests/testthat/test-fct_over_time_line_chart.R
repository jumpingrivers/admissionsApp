describe("get_enrollment_over_time_df", {
  get_enrollment_partial <- purrr::partial(
    get_enrollment_over_time_df,
    time_col = "date",
    metric_col = "enrollment",
    metric_summarization_function = sum
  )

  it("doesn't summarize over different dates", {
    df <- tibble::tibble(
      college = rep("A", 2),
      date = lubridate::ymd(c("2023-08-07", "2023-08-08")),
      enrollment = 1,
      year = 2023
    )

    results <- get_enrollment_partial(
      df,
      grouping_selection = "college",
      filter_control = "year",
      filter_values = list("year_filter" = 2023)
    )

    expect_equal(
      results[["date"]],
      lubridate::ymd(c("2023-08-07", "2023-08-08"))
    )
  })

  it("summarizes over matching dates", {
    df <- tibble::tibble(
      college = rep("A", 2),
      date = lubridate::ymd(c("2023-08-08", "2023-08-08")),
      enrollment = 1,
      year = 2023
    )

    results <- get_enrollment_partial(
      df,
      grouping_selection = "college",
      filter_control = "year",
      filter_values = list("year_filter" = 2023)
    )

    expect_equal(
      results[c("date", "y_plot")],
      tibble::tibble(
        date = lubridate::ymd("2023-08-08"),
        y_plot = 2
      )
    )
  })

  it("handles having no filters", {
    df <- tibble::tibble(
      college = "A",
      date = lubridate::ymd("2023-08-07"),
      enrollment = 1,
      year = 2023
    )

    results <- get_enrollment_partial(
      df,
      grouping_selection = "college",
      filter_control = NULL,
      filter_values = list()
    )

    expect_equal(
      results[c("date", "y_plot")],
      tibble::tibble(
        date = lubridate::ymd("2023-08-07"),
        y_plot = 1
      )
    )
  })

  it("handles multiple filters", {
    df <- tibble::tibble(
      college = c("A", "A", "B", "B"),
      date = lubridate::ymd(c("2022-08-07", "2023-08-08", "2022-08-07", "2023-08-08")),
      enrollment = 1,
      year = c(2022, 2023, 2022, 2023)
    )

    results <- get_enrollment_partial(
      df,
      grouping_selection = "college",
      filter_control = c("year", "college"),
      filter_values = list("year_filter" = 2023, "college_filter" = "A")
    )

    expect_equal(
      results[c("date", "y_plot")],
      tibble::tibble(
        date = lubridate::ymd("2023-08-08"),
        y_plot = 1
      )
    )
  })
})
