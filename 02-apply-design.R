## Select observations according to survey design

## Each MP reports own party + PM party or 2nd party position.

## Implementation: 
## 1. PM and 2nd party are center left and right, resp.
## 2. Design induces two types of MP measurements
##    - type1: measurements of PM and 2nd party
##    - type2: measurements of PM and one other (not 2nd) party 
##    By construction, type1 will be much more frequent, 
##    including all MPs from largest and 2nd largest parties.
##    => Implemented via the assumption that proportion of  
##       type1 MPs is 4 / (n$party + 2)


load("user-inputs.RData")
data_complete <- read.csv("data-complete.csv")


## Assigning PM and 2nd status ---

dt <- data_complete
med_party <- median(seq_len(n$party))
pm_2nd <- c(ceiling(med_party), floor(med_party)) + c(-1, 1)
dt$party[dt$party %in% pm_2nd] <- c("PM", "2nd")


## Identifying and selecting types ----

prop_type1 <- 4 / (n$party + 2)

n$type1 <- ceiling(prop_type1 * n$mp)
n$type2 <- n$mp - n$type1
n$other <- n$party - 2

type1 <- seq(from = 1, to = n$type1)
dt_type1 <- dt[(dt$mp %in% type1) & (dt$party %in% c("PM", "2nd")), ]

data_design <- dt_type1

if (n$type2 > 0) {
  
  type2 <- seq(from = n$type1 + 1, to = n$mp)
  dt_type2_pm_obs <- dt[(dt$mp %in% type2) & (dt$party == "PM"), ]

  data_design <- rbind(data_design, dt_type2_pm_obs)

}

if (n$other > 0) {

  dt_type2_other_obs <- dt[(dt$mp %in% type2) & (! dt$party %in% c("PM", "2nd")), ]
  
  # sampling other parties at random
  random_select <- 
    rep(c(TRUE, FALSE), times = c(1, n$other - 1)) |>
    list() |>
    rep(times = n$type2) |>
    lapply(sample, size = n$other) |>
    unlist()

    data_design <- rbind(data_design, dt_type2_other_obs[random_select, ])
  
}


rm(list = ls(pattern = "^dt|type[[:digit:]]$"), "med_party", "pm_2nd")

write.csv(data_design, "data-design.csv", row.names = FALSE)

