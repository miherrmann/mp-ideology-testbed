## Estimate shift and stretch parameters

## Use different estimators to recover shift and
## stretch parameters and store estimation results


library(lme4)


# Run no-pooling estimation (very time consuming with n > 1e4)?
estimate_m1 <- TRUE


## Initialize estimation ----

ab <- c("shift", "stretch")
est <- list()

load("user-inputs.RData")
dt <- read.csv(sprintf("data-%s.csv", data))


## 0. OLS complete pooling (reference only: no estimation of MP parameters) ----

m0 <- lm(perceived ~ true, data = dt)


## 1. OLS no pooling ----

if (estimate_m1) {

  m1 <- lm(perceived ~ -1 + mp + mp:true, data = dt)

  est$m1 <-
    c("", ":true") |>
    setNames(nm = ab) |>
    sapply(
      \(.ab)
      coef(m1)[paste0("mp", unique(dt$mp), .ab)] |>
      as.vector()
    )

}


## 2. REML partial pooling, assuming uncorrelated a and b ----

optimizer <- lmerControl(optimizer = "bobyqa")

m2 <- lmer(
  perceived ~ true + (true || country / mp),
  data = dt,
  control = optimizer
)

est$m2_new <-
  m2 |>
  coef() |>
  getElement("mp:country") |>
  setNames(nm = ab)


## Store results ----

ab_estimates <- data.frame(mp = unique(dt$mp), lapply(est, data.frame))
names(ab_estimates) <- gsub(
  pattern = "\\.",
  replacement = "_",
  names(ab_estimates)
)

write.csv(ab_estimates, file = "ab-estimates.csv", row.names = FALSE)
save(list = paste0("m", 0:2), file = "estimation-results.RData")

rm(list = ls())
