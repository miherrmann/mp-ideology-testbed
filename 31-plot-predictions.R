## Plot data and regression lines

## For each MP:
## 1. True and perceived positions
## 2. True regression line: translation true to perceived positions
## 3. No-pooling estimate of regression line
## 4. Partial-pooling estimate of regression line


load("user-inputs.RData")


## Make plot inputs ----

dt_est <- merge(
  x = read.csv(sprintf(fmt = "data-%s.csv", data)),
  y = read.csv("ab-estimates.csv"),
  by = "mp",
  all.y = TRUE
)

x_range <- range(dt_est$true)
y_range <- range(dt_est$perceived)


## Plot ----

pdf("model-comparison.pdf", width = 10, height = 20)
par(mfrow = c(10, 5))

dt_est |>
split(f = ~ mp) |>
lapply(
  \(.mp) {
    plot(
      x_range,
      y_range,
      type = "n",
      main = unique(.mp$mp),
      xlab = "true",
      ylab = "perceived"
    )
    points(
      x = .mp$true,
      y = .mp$perceived,
      pch = 16,
      col = ifelse(.mp$party == "PM", "red", "black")
    )
    abline(coef = unique(.mp[, c("shift", "stretch")]))
    abline(coef = unique(.mp[, c("m1_shift", "m1_stretch")]), lty = 3)
    abline(coef = unique(.mp[, c("m2_shift", "m2_stretch")]), lty = 2)
  }
) |>
invisible()

dev.off()

rm(list = ls())
