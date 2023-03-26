## Evaluate estimation results

## Compute mean absolute error in recovering true
## shift and stretch parameters


load("user-inputs.RData")

est <- read.csv("ab-estimates.csv")
dt <-
  "data-%s.csv" |>
  sprintf(data) |>
  read.csv()


## Mean absolute error ----

est_true <-
  est |>
  merge(dt[c("mp", "shift", "stretch")], by = "mp", all.y = TRUE) |>
  unique()

what <- c("no_pooling", "partial_pooling")

mae <-
  setNames(nm = c("shift", "stretch")) |>
  sapply(
    \(.ab)
    est_true[grep(pattern = paste0("m?_", .ab), names(est_true))] |>
    setNames(nm = what) |>
    sapply(\(.m_ab) mean(abs(.m_ab - est_true[[.ab]])))
  )

save(mae, file = "estimation-evaluation.RData")

rm(list = ls())
