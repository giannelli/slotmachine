devtools::install_github("hadley/sloop")
devtools::install_github("hadley/emo")

install.packages("bookdown")
install.packages("sessioninfo")
install.packages("desc")

setwd("/home/dev/Rdev/adv-r")
bookdown::render_book("index.Rmd", output_format = "bookdown::pdf_book")

