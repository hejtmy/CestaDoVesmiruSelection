# Using graphql in R connect to supabse database and fetch data
library(dotenv)
library(jsonlite)
library(dplyr)
library(RPostgres)
library(DBI)

source("functions/process.R")
source("functions/gonogo.R")

load_dot_env()

con <- dbConnect(
  RPostgres::Postgres(),
  dbname = Sys.getenv("DB_NAME"),
  host = Sys.getenv("DB_HOST"),
  port = Sys.getenv("DB_PORT"),
  user = Sys.getenv("DB_USER"),
  password = Sys.getenv("DB_PASS")
)

query <- 'SELECT * FROM "TestResults" LIMIT 50'

results <- dbGetQuery(con, query)
participant <- results$id[45]
txt <- results$test_results[47]
arr <- fromJSON(txt)
df <- as.data.frame(fromJSON(arr[[1]]))
df
# Send query
query <- dbSendQuery(con, "SELECT * FROM TestResults")

# Fetch in batches
while (!dbHasCompleted(query)) {
  chunk <- dbFetch(query, n = 1000)  # Get 1000 rows at a time
  # Process chunk here
}

# Clear the result
dbClearResult(query)

## GONOGO
txt <- results$test_results[40]
arr <- fromJSON(txt)
df <- as.data.frame(fromJSON(arr[[1]]))
get_browser_information(df)

df_gng <- gonogo_create_trial_table(df)
gonogo_analyze_performance(df_gng)

## NBACK
txt <- results$test_results[47]
arr <- fromJSON(txt)
df <- as.data.frame(fromJSON(arr[[1]]))
colnames(df)
View(df)

df <- select(df, trial_index, time_elapsed, rt,
               response, block_number, image)


## EMOTIONS
txt <- results$test_results[48]
arr <- fromJSON(txt)
df <- as.data.frame(fromJSON(arr[[1]]))
head(df)


## Spatial
txt <- results$test_results[42]
arr <- fromJSON(txt)
df <- as.data.frame(fromJSON(arr[[1]]))
View(df)


#  from the following image tag extract the final name of hte image and the rotation from the rotate_X class
#  <img src="https://unyavwofnmwihnpvkjji.supabase.co/storage/v1/object/public/test-stimuli/spatialcognition/map_right_1_135.png" class="max-w-none rotate_0" width="512" height="512" alt="Mapa">
extract_image_info <- function(df) {
  df <- df %>%
    mutate(
      image = gsub("https://unyavwofnmwihnpvkjji.supabase.co/storage/v1/object/public/test-stimuli/spatialcognition/", "", image),
      image = gsub(".png", "", image),
      rotation = as.numeric(gsub("rotate_", "", gsub(".*rotate_", "", image)))
    )
  return(df)
}
