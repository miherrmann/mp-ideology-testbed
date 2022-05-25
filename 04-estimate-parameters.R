## Estimate shift and stretch parameters

## Use different estimators to recover shift and  
## stretch parameters and store estimation results


load("user-inputs.RData")
dt <- read.csv(sprintf("data-%s.csv", data))


## Initialize estimation ----

ab <- c("shift", "stretch")
est <- list()
dt$mp <- as.factor(dt$mp)


## 0. OLS complete pooling (reference only: no estimation of MP parameters) ----

m0 <- lm(perceived ~ 1 + true, data = dt)


## 1. OLS no pooling ----

m1 <- lm(perceived ~ 0 + mp + mp:true, data = dt)

est$m1 <- sapply(
  setNames(c("", ":true"), nm = ab), 
  \(.ab) as.vector(coef(m1)[paste0("mp", seq_len(n$mp), .ab)])
)


## 2. REML partial pooling, assuming uncorrelated a and b ----

m2 <- lmer(perceived ~ true + ((1 | mp) + (0 + true | mp)), data = dt)

est$m2 <- setNames(coef(m2)$mp, nm = ab)


## Store results ----

ab_estimates <- data.frame(mp = unique(dt$mp), lapply(est, data.frame))
names(ab_estimates) <- gsub("\\.", "_", names(ab_estimates))

rm(ab, est)

write.csv(ab_estimates, file = "ab-estimates.csv", row.names = FALSE)
save(list = paste0("m", 0:2), file = "estimation-results.RData")
