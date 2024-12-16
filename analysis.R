library(ggplot2)

# GONOGO -------------
# Inverse Efficiency Score (IES)
# The Inverse Efficiency Score is a commonly used method that combines speed and accuracy:
# IES = Mean Reaction Time / (1 - Proportion of Errors)
df_gng <- read.csv("processed/gonogo_performance.csv")
head(df_gng)
# GONOGO percentiles ----
# lower is always better - lower RT and the performance is inversed for the long blocks
df_gng_percentile <- df_gng %>%
  group_by(block) %>%
  mutate(percentile = 1 - (ecdf(performance)(performance)),
         .groups = "drop") %>%
  group_by(participant) %>%
  summarise(gng_percentile = mean(percentile), .groups = "drop")

## One participant never clicked on anything
df_gng %>%
  filter(participant %in% df_gng_percentile$participant[is.na(df_gng_percentile$gng_percentile)])

ggplot(df_gng_percentile, aes(mean_percentile)) +
  geom_histogram(binwidth = 0.05)
## EMOTION ------------
df_emotion <- read.csv("processed/emotion_performance.csv")
head(df_emotion)
ggplot(df_emotion, aes(performance)) +
  geom_histogram() +
  facet_wrap(~block, scales = "free")

# Emotion Percentiles ----
# lower is always better - lower RT and the performance is inversed for the long blocks
df_emotion_percentile <- df_emotion %>%
  group_by(block) %>%
  mutate(percentile = 1 - (ecdf(performance)(performance)),
         .groups = "drop") %>%
  group_by(participant) %>%
  summarise(emotion_percentile = mean(percentile), .groups = "drop")

ggplot(df_emotion_percentile, aes(mean_percentile)) +
  geom_histogram(binwidth = 0.05)
is.na(df_emotion_percentile$emotion_percentile)
## NBACK -----------
df_nback <- read.csv("processed/nback_performance.csv")
head(df_nback)

ggplot(df_nback, aes(block, correct)) +
  geom_boxplot() +
  geom_jitter(width = 0.2, height = 0)

ggplot(df_nback, aes(correct)) +
  geom_histogram()

# NBACK OUTPUT
df_nback_percentiles <- df_nback %>%
  group_by(block) %>%
  mutate(percentile = ecdf(correct)(correct), .groups = "drop") %>%
  group_by(participant) %>%
  summarise(nback_percentile = mean(percentile), .groups = "drop")

ggplot(df_nback_percentiles, aes(percentile)) +
  geom_histogram(binwidth = 0.05)

## SPATIAL COGNITION -----------
df_spatial <- read.csv("processed/spatial_performance.csv")
head(df_spatial)

# spatial percentilesa
df_spatial_percentiles <- df_spatial %>%
  group_by(block) %>%
  mutate(percentile = 1 - (ecdf(performance)(performance)),
         .groups = "drop") %>%
  group_by(participant) %>%
  summarise(spatial_percentile = mean(percentile), .groups = "drop")

ggplot(df_spatial_percentiles, aes(spatial_percentile)) +
  geom_histogram(binwidth = 0.05)

# Merge all ------
nrow(df_gng_percentile)
nrow(df_emotion_percentile)
nrow(df_nback_percentiles)
nrow(df_spatial_percentiles)
df_all <- full_join(df_gng_percentile, df_emotion_percentile, by = "participant") %>%
  left_join(df_nback_percentiles, by = "participant")

nrow(df_all)
full_join(df_nback_percentiles, by = "participant") %>%
full_join(df_spatial_percentiles, by = "participant")

head(df_all)
View(df_all)
