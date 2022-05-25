## Plot data and regression lines

## For each MP:
## 1. True and perceived positions
## 2. True regression line (i.e., translation from true to perceived positions)
## 3. No-pooling estimate of regression line
## 4. Partial-pooling estimate of regression line


load("user-inputs.RData")
dt <- read.csv(sprintf("data-%s.csv", data))
est <- read.csv("ab-estimates.csv")


## Make plot inputs ----

dt_est <- merge(dt, est, by = "mp", all.y = TRUE)

select <- c(  # probably not necessary -- consider deleting 
  "mp",
  "party",
  "true", 
  "perceived", 
  grep("shift|stretch", names(dt_est), value = TRUE)
)
dt_mp <- lapply(unique(dt_est$mp), \(.mp) dt_est[dt_est$mp == .mp, select])

x_range <- range(dt_est$true)
y_range <- range(dt_est$perceived)


## Plot ----

pdf("model-comparison.pdf", width = 10, height = 20)
par(mfrow = c(10, 5))

invisible(
  lapply(
    dt_mp, 
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
  )
)

dev.off()

rm(est, select, list = ls(pattern = "^dt|_range$"))
