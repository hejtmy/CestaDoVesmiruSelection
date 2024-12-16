library(tidyr)
library(dplyr)
library(stringr)

spatial_analyze_performance <- function(df) {
  df_out <- df %>%
    group_by(block) %>%
    summarise(correct = sum(correct) / n(),
              mean_rt = mean(rt),
              performance = mean_rt/correct,
              .groups = "drop")
  return(df_out)
}

spatial_create_trial_table <- function(txt) {
  df <- results_to_df(txt) %>%
    filter(!is.na(stimulus),
           grepl("^<img src=", stimulus)) %>%
    spatial_extract_image_info()
  return(df)
}

spatial_extract_image_info <- function(df) {
  STORAGE_URL <- "https://unyavwofnmwihnpvkjji.supabase.co/storage/v1/object/public/test-stimuli/spatialcognition/"
  df <- df %>%
    mutate(image = gsub(".*src=\"", "", stimulus),
           image = gsub("\".*", "", image),
           image = gsub(STORAGE_URL, "", image),
           image = gsub(".png", "", image)) %>%
    # from the stimulus, there is a string rotate_number, extract that nuber
    mutate(rotation = as.numeric(str_extract(stimulus, "rotate_(\\d+)", group=1))) %>%
    separate(image, c("drop1", "direction", "distance", "angle"),
             sep = "_", extra = "drop") %>%
    mutate(response = ifelse(response == 1, "right", "left"),
           correct = response == direction) %>%
    select(-c(drop1, stimulus)) %>%
    mutate(block = c(rep("unrotated", 12),
                     rep("updown", 12),
                     rep("alldirections", 12)))
  return(df)
}
