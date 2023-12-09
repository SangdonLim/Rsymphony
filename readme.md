# Introduction

This is a modified version of Rsymphony that attempts to set solver flags to
help making its solutions reproducible.

Below is an example case where Rsymphony 0.1.33 does not yield reproducible
solutions (tested in R 4.3.2 on Windows 11 with SYMPHONY headers in Rtools 4.3):

```
library(Rsymphony)
packageVersion("Rsymphony")
library(TestDesign) # 1.5.1
packageVersion("TestDesign")

cfg <- createShadowTestConfig(
  item_selection = list(
    method = "GFI",
    target_value = 7
  ),
  MIP = list(
    solver = "Rsymphony"
  ),
  exposure_control = list(
    method = "NONE"
  )
)

administered_i <- list()

for (i in 1:10) {

  message(i)

  set.seed(1)
  true_theta <- rnorm(5)
  true_theta <- round(true_theta, 12)
  
  t1 <- Sys.time()
  o <- Shadow(cfg, constraints_reading, true_theta = true_theta)
  t2 <- Sys.time()
  
  message(sprintf("%.1fs", t2 - t1))
  
  oo <- lapply(
    o@output,
    function(x) {
      x@administered_item_index
    }
  )
  oo <- unlist(oo)

  administered_i[[i]] <- oo

}

administered_i <- do.call(rbind, administered_i)
n_unique_values <- apply(administered_i, 2, function(x) length(unique(x)))
sum(n_unique_values != 1)

# Rsymphony 0.1.33 (the unmodified version)
# 141
# Rsymphony 0.1.33.9000 (this repo version)
# 0
```
