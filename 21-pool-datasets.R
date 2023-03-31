## Pool/append all country data sets and write results
## Coarsen outcome variable to integer values (if necessary)


load("user-inputs.RData")

paths <-
  paste0("data-", c("complete", "design", "random"), "/%s.csv") |>
  lapply(\(.d) sprintf(fmt = .d, names(n$party))) |>
  setNames(nm = c("complete", "design", "random"))

dt_all <-
  paths |>
  lapply(\(.ps) do.call("rbind", args = lapply(.ps, read.csv)))

if (coarse)
  dt_all <- lapply(
    dt_all,
    \(.dt) {
      stdev <- sd(.dt$perceived)
      .dt$perceived <- round(.dt$perceived / stdev * 5/4) * 4/5 * stdev
      return(.dt)
    }
  )

paths |>
names() |>
lapply(
  \(.nm)
  dt_all[[.nm]] |>
  write.csv(file = sprintf(fmt = "data-%s.csv", .nm), row.names = FALSE)
) |>
invisible()

rm(list = ls())
