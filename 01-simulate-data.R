## Simulate Monte Carlo data

## 1. True party positions
##    - roughly equal number of parties to the left and right of zero
##    - parties should get sparser toward the ends of spectrum
##    => Implemented via standard normal distribution folded about zero, i.e. abs()
##    - all parties >0.1 units apart (realism and avoiding extreme estimates)
##    => Implemented via delta
## 2. MPs' true shift and stretch parameters
## 3. MPs' perception errors
## 4. MPs' perceived party positions
##    - 11-pt scale from -5 to 5
##    - 99.99% of perceived positions should be within +/-4 std dev
##    => Implemented via rescaling and rounding; then scaling back to -4 to 4 so
##       that (coarsened) y is on the same scale as a, b, and e


load("user-inputs.RData")


## Initialize simulation ----

set.seed(seed)


## True party positions ----

delta <- 0

while (delta < 0.1) {
  
  x <- suppressWarnings(abs(rnorm(n$party)) * sample(c(-1, 1), size = 2)) |> 
    sort() |>
    rep(times = n$mp)

  delta <- min(abs(diff(x)))

}

## True shift and stretch parameters ----

a <- rep(rnorm(n$mp, mean$a, sd$a), each = n$party)
b <- rep(rnorm(n$mp, mean$b, sd$b), each = n$party)


## Perception errors ----

e <- rnorm(n$mp * n$party, sd = sd$e)


## Perceived and measured party positions ----

y <- a + b * x + e

if (coarse) {

  sd_y <- sd(y)
  y <- round(y / sd_y * 5/4) * 4/5 * sd_y

}


## Simulated data: all observations ----

data_complete <- data.frame(
  mp = factor(rep(seq_len(n$mp), each = n$party)),
  party = seq_len(n$party),
  perceived = y, 
  true = x,
  shift = a,
  stretch = b
)

rm(delta, x, a, b, e, y)

write.csv(data_complete, "data-complete.csv", row.names = FALSE)
