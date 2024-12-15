library(ggplot2)

# GONOGO -------------
# Inverse Efficiency Score (IES)
# The Inverse Efficiency Score is a commonly used method that combines speed and accuracy:
# IES = Mean Reaction Time / (1 - Proportion of Errors)
df_gng <- read.csv("processed/gonogo_performance.csv") %>%
  mutate(IES = mean_rt / correct)

ggplot(df_gng, aes(IES)) +
  geom_histogram(binwidth = 25) +
  facet_wrap(~block_number)

View(df_gng)

## EMOTION ------------
df_emotion <- read.csv("processed/emotion_performance.csv")
head(df_emotion)
ggplot(df_emotion, aes(performance_metric)) +
  geom_histogram() +
  facet_wrap(~block, scales = "free")

## NBACK -----------
df_nback <- read.csv("processed/nback_performance.csv")
head(df_nback)
group_by(df_nback, block) %>%
  summarise(mean(correct))

ggplot(df_nback, aes(block, correct)) +
  geom_boxplot() +
  geom_jitter(width = 0.2, height = 0)

ggplot(df_nback, aes(correct)) +
  geom_histogram()

## SPATIAL COGNITION -----------
