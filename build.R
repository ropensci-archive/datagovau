library(devtools)
library(knitr)

knit(input = "README.Rmd", output = "README.md")

check("pkg")
document("pkg")
