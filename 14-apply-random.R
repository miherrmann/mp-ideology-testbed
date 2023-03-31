## Select observations randomly

## Select n_obs per MP at random from complete Monte Carlo data set


load("user-inputs.RData")

for (country in names(n$party)) {

  n_p <- n$party[country]

  dt <-
    "data-complete/%s.csv" |>
    sprintf(country) |>
    read.csv()

  random_select <-
    c(TRUE, FALSE) |>
    rep(times = c(n$obs, n_p - n$obs)) |>
    list() |>
    rep(times = n$mp) |>
    lapply(sample, size = n_p) |>
    unlist()

  data_random <- dt[random_select, ]

  "data-random/%s.csv" |>
  sprintf(country) |>
  write.csv(data_random, file = _, row.names = FALSE)

}

rm(list = ls())
