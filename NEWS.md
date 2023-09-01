# shinyAdmissions 0.1.4

* Updated the fake `daily_enrollment` dataset that is stored in inst/app/fake_data to contain all
  columns necessary for the app to start.
* Compressed the fake `daily_enrollment` dataset by nesting on the `days_to_class_start` column.
* Speed up initial app load by using a version of the `daily_enrollment` pin dataset that has been
  nested on `days_to_class_start`
* Removed `calculate_enrollment()` function (and it's tests) as it was no longer used in the app.
* Ensured the repository passes `R CMD check`

# shinyAdmissions 0.1.3

* Added a feature-flag to the config to indicate whether the sunburst page should be shown.
* Hid the sunburst page/plot in the production app, but still display it in a staging deployment.
* Add a button to prevent recomputation of the admissions line-chart and data too eagerly.

# shinyAdmissions 0.1.2

* Remove dependency on {utShinyMods}.

# shinyAdmissions 0.1.0

* Added the ability to pull enrollment data from a pins board
