# Building a Prod-Ready, Robust Shiny Application.
#
# README: each step of the dev files is optional, and you don't have to
# fill every dev scripts before getting started.
# 01_start.R should be filled at start.
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
#
#
########################################
#### CURRENT FILE: ON START SCRIPT #####
########################################

## Fill the DESCRIPTION ----
## Add meta data about your application
##
## /!\ Note: if you want to change the name of your app during development,
## either re-run this function, call golem::set_golem_name(), or don't forget
## to change the name in the app_sys() function in app_config.R /!\
##
golem::fill_desc(
  pkg_name = "shinyAdmissions", # The Name of the package containing the App
  pkg_title = "Admissions Exploration", # The Title of the package containing the App
  pkg_description = "A Shiny application, implemented as an R package, for exploring admissions metrics.", # The Description of the package containing the App
  author_first_name = "", # Your First Name
  author_last_name = "", # Your Last Name
  author_email = "", # Your Email
  repo_url = "https://github.com/dsu-effectiveness/shinyAdmissions" # The URL of the GitHub Repo (optional)
)

## Set {golem} options ----
golem::set_golem_options()

## Create Common Files ----
## See ?usethis for more information
usethis::use_mit_license("Golem User") # You can set another license here
# Setting the license as CC-BY: Free to share and adapt, must give appropriate credit.
# Rather than using the default MIT license.
# usethis::use_ccby_license()

## use rmd to generate the README for the repo
usethis::use_readme_rmd(open = FALSE)
# README.Rmd will need to be filled out and knit,
# this will generate the README.md.

# Note that `contact` is required since usethis version 2.1.5
# If your {usethis} version is older, you can remove that param
# usethis::use_code_of_conduct(contact = "Golem User")
usethis::use_lifecycle_badge("Experimental") # this will likely change to stable once functioning
# usethis::use_news_md(open = FALSE)

## Use git ----
usethis::use_git()

## Init Testing Infrastructure ----
## Create a template for tests
# golem::use_recommended_tests()

## Favicon ----
# If you want to change the favicon (default is golem's one)
# Note: the url for this favicon could change
# Just using this to download the latest icon from Utah Tech's website
golem::use_favicon("https://utahtech.edu/wp-content/themes/dixie-state-university/assets/media/favicons/ms-icon-144x144.png") # path = "path/to/ico". Can be an online file.
golem::remove_favicon()
# rename the favicon from favicon.png to favicon.ico
file.rename(here::here("inst/app/www/favicon.png"), here::here("inst/app/www/favicon.ico"))

## Add helper functions ----
# golem::use_utils_ui(with_test = TRUE)
# golem::use_utils_server(with_test = TRUE)

# You're now set! ----

# go to dev/02_dev.R
rstudioapi::navigateToFile("dev/02_dev.R")
