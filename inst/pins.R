# Read raw data, parse, and add as pin to rsconnect
library("magrittr")

file_path = system.file("app/fake_data/daily_enrollment.rds",
                        package = "shinyAdmissions",
                        mustWork = TRUE)

raw_enrollment = readRDS(file_path)

parsed_enrollment = raw_enrollment %>%
  tidyr::separate(.data$term_id, c("year", "season"), sep = 4) %>%
  dplyr::mutate(season = dplyr::if_else(.data$season == 40, "Fall", "Spring"))

board_rsc = pins::board_rsconnect(auth = "rsconnect")
pins::pin_write(board_rsc, parsed_enrollment, name = "enrollment")
