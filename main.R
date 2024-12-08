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
txt <- results$test_results[40]
participant <- results$id[40]
arr <- fromJSON(txt)
df <- as.data.frame(fromJSON(arr[[1]]))
View(df)

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
df <- as.data.frame(fromJSON(arr[[1]]))
colnames(df)
get_browser_information(df)

df_gng <- gonogo_create_trial_table(df)



View(df_gng)
