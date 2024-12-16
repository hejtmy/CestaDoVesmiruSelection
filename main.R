# Using graphql in R connect to supabse database and fetch data
library(dotenv)
library(jsonlite)
library(dplyr)
library(RPostgres)
library(DBI)

source("functions/process.R")
source("functions/gonogo.R")
source("functions/n-back.R")
source("functions/emotion-recognition.R")
source("functions/spatial-cognition.R")

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
query <- dbSendQuery(con, 'SELECT * FROM "OfficialResults"')

all <- list()
i <- 1
while (!dbHasCompleted(query)) {
  chunk <- dbFetch(query, n = 500)  # Get 1000 rows at a time
  message("Fetched ", nrow(chunk), " rows")
  all[[i]] <- chunk
  i <- i + 1
}
dbClearResult(query)

# rbind all the results
all <- do.call(rbind, all)
class(all)
save(all, file = "all.RData")


## EMOTION ------
txt <- all[5, ]$results
df <- emotion_create_trial_table(txt)
emotion_analyze_performance(df)

## NBACK
head(all)
all$test_name[1:20]

txt <- all[15, ]$results
nback_create_trial_table(txt)

## Spatial
txt <- all[4, ]$results
df <- results_to_df(txt)
df_spatial <- spatial_create_trial_table(txt)
