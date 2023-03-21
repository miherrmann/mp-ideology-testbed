## Collect, streamline and save user inputs

n <- list(
  mp = max(1, n_mp),
  party = setNames(sapply(n_party, max, 2), nm = letters[seq_along(n_party)]),
  obs = min(max(2, n_obs), min(n_party))
)

mean <- mget(ls(pattern = "mean_"))
mean <-
  mean |>
  setNames(nm = gsub(pattern = "mean_", replacement = "", names(mean)))

sd <- mget(ls(pattern = "sd_"))
sd <-
  sd |>
  setNames(nm = gsub(pattern = "sd_", replacement = "", names(sd)))

save(n, mean, sd, data, coarse, seed, file = "user-inputs.RData")

rm(list = ls(pattern = "mean_|sd_|n_"), data, coarse, seed)
