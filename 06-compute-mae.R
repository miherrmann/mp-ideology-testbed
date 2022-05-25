## Evaluate estimation results

## Compute mean absolute error in recovering true 
## shift and stretch parameters


load("user-inputs.RData")
dt <- read.csv(sprintf("data-%s.csv", data))
est <- read.csv("ab-estimates.csv")


## Mean absolute error ----

est_true <- merge(est, dt[c("mp", "shift", "stretch")], by = "mp", all.y = TRUE)
est_true <- est_true[seq(from = 1, to = nrow(est_true), by = n$party), ]

what <- c("no_pooling", "partial_pooling")

mae <- sapply(
  c(shift = "shift", stretch = "stretch"),
  \(.ab) sapply(
    setNames(est_true[grep(paste0("m?_", .ab), names(est_true))], nm = what),
    \(.m_ab) mean(abs(.m_ab - est_true[[.ab]]))
  )
)

rm(dt, what, list = ls(pattern = "^est"))
