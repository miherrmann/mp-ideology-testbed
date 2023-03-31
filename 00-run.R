## Pre-analysis simulation and assessment

## 1. Generate simulated responses
## 2. Estimate underlying response parameters
## 3. Compare parameter estimates to true values


library(lme4)


## Estimation options ----

# data to use in estimation: design, complete, or random
data <- "design"


## Simulation options ----

# perception error
sd_e <- 0.5

# hyperparameters: shift
mean_a <- 0
sd_a <- 0.1

# hyperparameters: stretch
mean_b <- 1
sd_b <- 0.3

# cross-country variation in hyperparameters
sd_a_country <- 0.1
sd_b_country <- 0.2

# number of MPs (min: 1)
n_mp <- 100

# number of citizens (min: 1)
n_citizen <- 1000

# number of parties per country (min: 2)
n_party <- c(3, 4, 4, 4, 5, 5, 5, 6, 6, 7, 7, 8, 9)

# obs per MP in random selection design (min: 2; max: n_party)
n_obs <- 2

# coarsen perceived positions into an 11-pt scale?
coarse <- TRUE

# rng seed
seed <- 123456


## Collect and save user inputs ----

source("11-collect-inputs.R")


## Simulate country data sets ----

source("12-simulate-data.R")
source("13-apply-design.R")
source("14-apply-random.R")


## Estimate parameters ----

source("21-pool-datasets.R")
source("22-estimate-parameters.R")


## Evaluate results ----

source("31-plot-predictions.R")
source("32-compute-mae.R")


## Inspect results ----

load("estimation-results.RData")
load("estimation-evaluation.RData")

summary(m2)
print(mae)
