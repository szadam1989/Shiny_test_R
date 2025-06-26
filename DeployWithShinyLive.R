library("shinylive")
library("httpuv")
library("usethis")
library("webr")
getwd()
setwd("D:/R/Projects")
shinylive::export("Shiny_test", "site")
httpuv::runStaticServer("site")
setwd("D:/R/Projects/Shiny_test")
usethis::use_github_action(url="https://github.com/posit-dev/r-shinylive/blob/actions-v1/examples/deploy-app.yaml")


