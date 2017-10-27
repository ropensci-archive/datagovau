context("get_resource")

test_that("Works on particular resource", {
  wyndham_catdog_registry_id <-
    "eef6a84b-ad44-446f-9cf9-fb5d135e3123"

  # Known not to have header file
  wyndham_catdog_registry <-
    get_resource(id = wyndham_catdog_registry_id,
                 # will be passed to fread
                 header = FALSE)
  # Use sort so that (Cat, Dog) = (Dog, Cat)
  expect_equal(sort(unique(wyndham_catdog_registry[["V1"]])),
               c("Cat", "Dog"))
})
