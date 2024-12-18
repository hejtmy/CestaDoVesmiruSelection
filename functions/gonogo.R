gonogo_create_trial_table <- function(txt) {
  arr <- fromJSON(txt)
  df <- as.data.frame(fromJSON(arr[[1]]))
  GONOGO_IMAGE_PATH <- "https://unyavwofnmwihnpvkjji.supabase.co/storage/v1/object/public/test-stimuli/gonogo/"
  df <- filter(df, !is.na(image))
  df <- select(df, trial_index, time_elapsed, rt,
               response, block_number, image)
  df$image <- gsub(GONOGO_IMAGE_PATH, "", df$image)
  df$image <- gsub(".png", "", df$image)
  df <- df %>%
    mutate(
      should_go = case_when(
        block_number == 1 & grepl("astronaut_trans_1", image) ~ TRUE,
        block_number == 2 & grepl("alien_trans_1", image) ~ TRUE,
        block_number == 3 & grepl("rocket_trans_1", image) ~ TRUE,
        block_number == 4 & !grepl("rocket_trans_1", image) ~ TRUE,
        TRUE ~ FALSE),
      did_go = !is.na(response),
      correct = should_go == did_go
    )
  return(df)
}

gonogo_analyze_performance <- function(df) {
  df_out <- df %>%
    group_by(block = block_number) %>%
    summarise(correct = sum(correct) / n(),
              mean_rt = mean(rt[should_go], na.rm = TRUE),
              performance = mean_rt / correct,
              .groups = "drop")
  return(df_out)
}
