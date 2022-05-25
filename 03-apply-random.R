## Select observations randomly

## Select n_obs per MP at random from complete Monte Carlo data set


load("user-inputs.RData")
data_complete <- read.csv("data-complete.csv")

random_select <- 
  rep(c(TRUE, FALSE), times = c(n$obs, n$party - n$obs)) |>
  list() |>
  rep(times = n$mp) |>
  lapply(sample, size = n$party) |>
  unlist()

data_random <- data_complete[random_select, ]

rm(random_select)

write.csv(data_random, "data-random.csv", row.names = FALSE)
