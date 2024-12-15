nback_create_trial_table <- function(txt) {
  df <- results_to_df(txt) %>%
    filter(!is.na(is_target)) %>%
    mutate(block = c(rep("abstract", 15), rep("fractals", 15),
                     rep("fractal3d", 15), rep("planets", 15)),
           response = !is.na(response),
           correct = (is_target == response))
  return(df)
}

nback_analyze_performance <- function(df) {
  df_out <- df %>%
    group_by(block) %>%
    summarise(correct = sum(correct) / n(),
              .groups = "drop")
  return(df_out)
}
