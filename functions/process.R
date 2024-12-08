get_browser_information <- function(df) {
  browser_information <- filter(df, trial_type == "browser-check")
  browser_information <- select(browser_information, os, mobile,
                                fullscreen, vsync_rate, webcam, microphone,
                                browser, browser_version, webaudio, width, height)
  return(browser_information)
}