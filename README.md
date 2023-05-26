## shinyAdmissions

An R package, created with the {golem} paradigm, to house the admissions data exploration application.

The [GitHub public repository](https://github.com/jumpingrivers/shinyAdmissions) can be linked to the GitLab private repository by running the following line after cloning the GitLab repo `git remote set-url --add origin git@github.com:jumpingrivers/shinyAdmissions.git`.

### Running the app

The config settings defined in `inst/golem-config.yaml` can be used to run the app in different
contexts. To switch between these settings, use the `GOLEM_CONFIG_ACTIVE` environment variable
(described in
["Engineering Production-Grade Shiny Apps"](https://engineering-shiny.org/golem.html?q=config#golem-config)
).

To run the app locally, against data stored in an ".rds" file within the package, set the 
environment variable to "dev":

To run the app locally, against data stored in an ".rds" file within the package

```r
Sys.setenv("GOLEM_CONFIG_ACTIVE" = "dev")
```

To run the app locally, against the production data stored on the pins board on the Utah-Tech
Connect server (ensure that your user has read-access for the `daily_enrollment_pin` on Connect
first):

```r
Sys.setenv("GOLEM_CONFIG_ACTIVE" = "local-staging")

# You will need to define your user account and an API key for accessing the Connect server
Sys.setenv("CONNECT_ACCOUNT" = "my_user_id")
Sys.setenv("CONNECT_API_KEY" = "api_key_obtained_from_connect")
```

After defining these variables, the app can be ran as follows:

```r
pkgload::load_all(export_all = FALSE)
run_app()
```

### Testing

{shinytest2} tests need to be run manually using either `shinytest2::test_app()` or `testthat::test_file("tests/testthat/test-shinytest2.R")`
