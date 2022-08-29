get_daily_enrollment = function() {
  board_rsc = pins::board_rsconnect()
  enrollment = pins::pin_read(board_rsc, "mandy/daily_enrollment")
  return(enrollment)
}
