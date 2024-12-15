library(dplyr)
source("functions/gonogo.R")
load(file = "all.RData")

# GONOGO ------------
df_gng <- filter(all, test_name == "gonogo")
df_gng_perf <- data.frame()
for (i in seq_len(nrow(df_gng))) {
  message("Processing participant ", df_gng[i, ]$user_id)
  txt <- df_gng[i, ]$results
  if (is.na(txt)) {
    message("Skipping participant ", df_gng[i, ]$user_id)
    next
  }
  df <- gonogo_create_trial_table(txt)
  df_out <- gonogo_analyze_performance(df)
  df_out$participant <- df_gng[i, ]$user_id
  df_gng_perf <- rbind(df_gng_perf, df_out)
}
write.csv(df_gng_perf, "processed/gonogo_performance.csv")

# EMOTION ------------
df_emotion <- filter(all, test_name == "emotion-recognition")
df_emotion_perf <- data.frame()
for (i in seq_len(nrow(df_emotion))) {
  message("Processing participant ", df_emotion[i, ]$user_id)
  txt <- df_emotion[i, ]$results
  if (is.na(txt)) {
    message("Skipping participant ", df_emotion[i, ]$user_id)
    next
  }
  df <- emotion_create_trial_table(txt)
  df_out <- emotion_analyze_performance(df)
  df_out$participant <- df_emotion[i, ]$user_id
  df_emotion_perf <- rbind(df_emotion_perf, df_out)
}
write.csv(df_emotion_perf, "processed/emotion_performance.csv")

# NBACK ------------
df_nback <- filter(all, test_name == "n-back")
df_nback_perf <- data.frame()
validate_order <- which(nback_create_trial_table(df_nback[1, ]$results)$is_target)
for (i in seq_len(nrow(df_nback))) {
  message("Processing participant ", df_nback[i, ]$user_id)
  txt <- df_nback[i, ]$results
  if (is.na(txt)) {
    message("Skipping participant ", df_nback[i, ]$user_id)
    next
  }
  df <- nback_create_trial_table(txt)
  if (!all(which(df$is_target) == validate_order)) {
    error("Invalid order of n-back trials")
    stop()
  }
  df_out <- nback_analyze_performance(df)
  df_out$participant <- df_nback[i, ]$user_id
  df_nback_perf <- rbind(df_nback_perf, df_out)
}
write.csv(df_nback_perf, "processed/nback_performance.csv")
