## Pool/append all country data sets and write results


load("user-inputs.RData")

paths <-
  paste0("data-", c("complete", "design", "random"), "/%s.csv") |>
  lapply(\(.d) sprintf(fmt = .d, names(n$party))) |>
  setNames(nm = c("complete", "design", "random"))

paths |>
names() |>
lapply(
  \(.nm)
  do.call("rbind", args = lapply(paths[[.nm]], read.csv)) |>
  write.csv(file = sprintf("data-%s.csv", .nm), row.names = FALSE)
) |>
invisible()

rm(list = ls())
