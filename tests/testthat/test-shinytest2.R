library(shinytest2)

testthat::test_that("{shinytest2} recording: Initial app screen", {
  if (interactive()) {
    myapp <- shinyAdmissions::run_app()
    app <- AppDriver$new(
      myapp,
      name = "Initial loading screen",
      height = 980, width = 1619
    )
    navbar_items <- app$get_text(".nav-item")
    squished_navbar_items <- stringr::str_squish(navbar_items)
    expected_navbar_items <- c("Enrollment", "Sunburst", "Help")
    testthat::expect_equal(squished_navbar_items, expected_navbar_items)
  }
})
