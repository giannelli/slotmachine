## https://adv-r.hadley.nz/names-values.html

devtools::install_github("hadley/sloop")
devtools::install_github("hadley/emo")

install.packages("bookdown")
install.packages("sessioninfo")
install.packages("desc")

setwd("/home/dev/Rdev/adv-r")
bookdown::render_book("index.Rmd", output_format = "bookdown::pdf_book")

devtools::install_github("r-lib/lobstr")
library(lobstr)


x <- c(1,2,3)
y <- x
obj_addr(x)
obj_addr(y)

# x gets copied
x[1] <- 4
obj_addr(x)
obj_addr(y)

# x gets copied
x <- c(3,2,1)
obj_addr(x)
obj_addr(y)

# Exercise 2.2.2
a <- 1:10
b <- a
c <- b
d <- 1:10
obj_addr(a)
obj_addr(b)
obj_addr(c)
obj_addr(d)

# > obj_addr(a)
# [1] "0x559e53c4c198"
# > obj_addr(b)
# [1] "0x559e53c4c198"
# > obj_addr(c)
# [1] "0x559e53c4c198"
# > obj_addr(d)
# [1] "0x559e54436cd0"

# a,b,c point to same memory location, d is a different memory location


obj_addr(mean)
obj_addr(base::mean)
obj_addr(get("mean"))
obj_addr(evalq(mean))
obj_addr(match.fun("mean"))
# > obj_addr(mean)
# [1] "0x559e522041d0"
# > obj_addr(base::mean)
# [1] "0x559e522041d0"
# > obj_addr(get("mean"))
# [1] "0x559e522041d0"
# > obj_addr(evalq(mean))
# [1] "0x559e522041d0"
# > obj_addr(match.fun("mean"))
# [1] "0x559e522041d0"

# See  ?read.csv
# check.names	

# See  ?make.names
make.names(c("_one", "2two", "three.3"))

# Vopy Om Modify
x <- c(1, 2, 3)
cat(tracemem(x), "\n")
y <- x

y[[3]] <- 4
x

untracemem(x)

#  2.3.2 Funtion Calls

f <- function(a) {
  a
}

x <- c(1, 2, 3)
cat(tracemem(x), "\n")
#> <0x13a05e8>

z <- f(x)
# there's no copy here!

untracemem(x)

obj_addr(x)
obj_addr(z)

f2 <- function(a) {
  a <- a * 2
  a
}

x <- c(1, 2, 3)
z <- f2(x)
obj_addr(x)
obj_addr(z)
x
z

# 2.3.3 Lists

l1 <- list(1,2,3)

l2 <- l1

l2[[3]] <-4

ref(l1, l2)


