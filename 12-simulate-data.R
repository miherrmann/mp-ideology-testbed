## Simulate Monte Carlo data

## 1. True party positions
##    - roughly equal number of parties to the left and right of zero
##    - parties should get sparser toward ends of spectrum
##    => Implemented via standard normal distribution folded about zero: abs()
##    - all parties >0.1 units apart (realism and avoiding extreme estimates)
##    => Implemented via delta
## 2. Country means of shift and stretch parameters
## 3. MPs' true shift and stretch parameters
## 4. MPs' perception errors
## 5. MPs' perceived (i.e., measured) party positions
##    - 11-pt scale from -5 to 5
##    - 99.99% of perceived positions should be within +/-4 standard deviations
##    => Implemented via rescaling and rounding; then scaling back to [-4, 4]
##       so that (coarsened) y is on the same scale as a, b, and e


## Initialize simulation ----

rm(list = ls())

load("user-inputs.RData")

set.seed(seed)


## Simulate quantities ----

for (country in names(n$party)) {

  n_p <- n$party[country]


  # True party positions

  delta <- 0

  while (delta < 0.1) {

    x <-
      suppressWarnings(abs(rnorm(n_p)) * sample(c(-1, 1), size = 2)) |>
      sort() |>
      rep(times = n$mp)

    delta <- min(abs(diff(x)))

  }


  # Country-specific deviations: shift and stretch parameters

  a_dev <- rnorm(n = 1, mean = 0, sd$a_country)
  b_dev <- rnorm(n = 1, mean = 0, sd$b_country)


  # MPs' true shift and stretch parameters

  a <- rep(rnorm(n$mp, mean$a + a_dev, sd$a), each = n_p)
  b <- rep(rnorm(n$mp, mean$b + b_dev, sd$b), each = n_p)


  # MPs' perception errors

  e <- rnorm(n = n$mp * n_p, sd = sd$e)


  # MPs' perceived/measured party positions

  y <- a + b * x + e

  if (coarse) {

    sd_y <- sd(y)
    y <- round(y / sd_y * 5/4) * 4/5 * sd_y

  }


  # Write data set: all observations

  data_complete <- data.frame(
    country = country,
    mp = factor(rep(seq_len(n$mp), each = n_p)),
    party = seq_len(n_p),
    perceived = y,
    true = x,
    shift = a,
    stretch = b,
    shift_country = a_dev,
    stretch_country = b_dev
  )

  data_complete$mp <- with(data_complete, paste(mp, country, sep = "_"))

  write.csv(
    data_complete,
    file = sprintf(fmt = "data-complete/%s.csv", country),
    row.names = FALSE
  )

}

rm(list = ls())
