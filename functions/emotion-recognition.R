emotion_create_trial_table <- function(txt) {
  emotion_values <- c(`0` = "neutral", `1` = "sad", `2` = "happy",
                      `3` = "surprised", `4` = "angry")
  df <- results_to_df(txt) %>%
    emotions_extract_emotion() %>%
    filter(!is.na(response), !is.na(emotion)) %>%
    mutate(emotion_response = emotion_values[response + 1],
           correct = emotion == emotion_response,
           index = 1:n(),
           block = c(rep("regular", 15), rep("quick", 15), rep("rotated", 15))) %>%
    select(emotion, emotion_response, correct, index, block, image, rt)
  return(df)
}

emotion_analyze_performance <- function(df) {
  df_out <- df %>%
    group_by(block) %>%
    summarise(correct = sum(correct) / n(),
              mean_rt = mean(rt),
              .groups = "drop") %>%
    rowwise() %>%
    # We are making the performance metric to be the inverse of the correct
    # so that lower values are always better (mean RT is better lower)
    mutate(performance = ifelse(block == "quick", 1-correct, mean_rt/correct)) %>%
    ungroup()
  return(df_out)
}

emotions_extract_emotion <- function(df) {
  URL <- "https://unyavwofnmwihnpvkjji.supabase.co/storage/v1/object/public/test-stimuli/emotions//final/"
  df <- df %>%
    mutate(
      image = emotion,
      emotion = gsub(URL, "", emotion),
      emotion = gsub(".png", "", emotion),
      emotion = gsub("_\\d+", "", emotion)
    )
  return(df)
}
