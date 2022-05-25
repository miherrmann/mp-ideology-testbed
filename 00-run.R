## Test estimation strategy

## Recovering n_mp shift and stretch parameters: a, b

## Simulated data sets
## 1. data_complete.csv: each MP rates all parties
## 2. data_design.csv: each MP rates own party and PM party
##    (resp. 2nd largest party if own party is PM party)
## 3. data_random.csv: each MP rates n_obs randomly selected
##    parties

## Estimation strategies
## 1. No pooling: independent OLS regressions 
## 2. Partial pooling/shrinkage: REML hierarchical linear   
##    random effects regression
## 3. TBA: Bayesian hierarchical linear random effects 
##    regression

## Output
## 1. model-comparison.pdf
##    - solid: true regression line
##    - dotted: no pooling
##    - dashed: partial pooling/shrinkage
##    - red: PM party
##    - black: own party
## 2. mae (R object): mean absolute error of estimated shift
##    and stretch parameters



library(lme4)

# start clean
rm(list = ls())



### User inputs ----

## Estimation options ----

# data to use in estimation: design, complete, or random
data <- "design"


## Simulation options ----

# MP perception error
sd_e <- 0.5

# hyper-parameters: stretch
mean_b <- 1
sd_b <- 0.5

# hyper-parameters: shift
mean_a <- 0
sd_a <- 0.5

# number of MPs (min: 1)
n_mp <- 100

# number of parties (min: 2)
n_party <- 5

# obs per MP in random selection design (min: 2; max: n_party)
n_obs <- 2

# coarsen perceived positions into an 11pt scale
coarse <- TRUE

# rng seed
seed <- 123456


## Housekeeping: streamline and save user inputs ----

n <- list(
  mp = max(1, n_mp), 
  party = max(2, n_party), 
  obs = min(max(2, n_obs), n_party)
)
mean <- setNames(mget(ls(pattern = "mean_")), nm = c("a", "b"))
sd <- setNames(mget(ls(pattern = "sd_")), nm = c("a", "b", "e"))

rm(list = ls(pattern = "^n_|^mean_|^sd_"))
save(list = ls(), file = "user-inputs.RData")



### Simulate data ----

## Simulate complete data set ----

source("01-simulate-data.R")


## Apply survey design ----

source("02-apply-design.R")


## Apply alternative design: n_obs per MP at random ----

source("03-apply-random.R")



### Estimate parameters ----

source("04-estimate-parameters.R")



### Evaluate results ----

## Compare estimation results (predictions) graphically ----

source("05-plot-predictions.R")


## Mean absolute error: shift and stretch parameters ----

source("06-compute-mae.R")

print(mae)
