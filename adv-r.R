## https://adv-r.hadley.nz/names-values.html

# devtools::install_github("hadley/sloop")
# devtools::install_github("hadley/emo")
# 
# install.packages("bookdown")
# install.packages("sessioninfo")
# install.packages("desc")
# 
# setwd("/home/dev/Rdev/adv-r")
# bookdown::render_book("index.Rmd", output_format = "bookdown::pdf_book")
# 
# devtools::install_github("r-lib/lobstr")
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

# 2.3.4 Data Frames

d1 <- data.frame(x = c(1, 5, 6), y = c(2, 4, 3))
d1

d2 <- d1

ref(d1, d2)
# > ref(d1, d2)
# █ [1:0x559f7e2408a8] <data.frame> 
#   ├─x = [2:0x559f7e44c198] <dbl> 
#   └─y = [3:0x559f7e44b6a8] <dbl> 
#   
#   [1:0x559f7e2408a8] 

d2[, 2] <- d2[, 2] * 2
ref(d1, d2)
# > ref(d1, d2)
# █ [1:0x559f7e2408a8] <data.frame> 
#   ├─x = [2:0x559f7e44c198] <dbl> 
#   └─y = [3:0x559f7e44b6a8] <dbl> 
#   
#   █ [4:0x559f7e56e928] <data.frame> 
#   ├─x = [2:0x559f7e44c198] 
# └─y = [5:0x559f7ddf7248] <dbl> 

d3 <- d1
ref(d1,d3)
# > ref(d1,d3)
# █ [1:0x559f7e2408a8] <data.frame> 
#   ├─x = [2:0x559f7e44c198] <dbl> 
#   └─y = [3:0x559f7e44b6a8] <dbl> 
#   
#   [1:0x559f7e2408a8] 
ref(d1,d2)
# > ref(d1,d2)
# █ [1:0x559f7e2408a8] <data.frame> 
#   ├─x = [2:0x559f7e44c198] <dbl> 
#   └─y = [3:0x559f7e44b6a8] <dbl> 
#   
#   █ [4:0x559f7e56e928] <data.frame> 
#   ├─x = [2:0x559f7e44c198] 
# └─y = [5:0x559f7ddf7248] <dbl> 


d3[1,] <- d3[1,] * 3
ref(d1,d3)
# █ [1:0x559f7e2408a8] <data.frame> 
#   ├─x = [2:0x559f7e44c198] <dbl> 
#   └─y = [3:0x559f7e44b6a8] <dbl> 
#   
#   █ [4:0x559f7e6292c8] <data.frame> 
#   ├─x = [5:0x559f7ee95308] <dbl> 
#   └─y = [6:0x559f7ee95358] <dbl> 
ref(d1,d2)
# █ [1:0x559f7e2408a8] <data.frame> 
#   ├─x = [2:0x559f7e44c198] <dbl> 
#   └─y = [3:0x559f7e44b6a8] <dbl> 
#   
#   █ [4:0x559f7e56e928] <data.frame> 
#   ├─x = [2:0x559f7e44c198] 
# └─y = [5:0x559f7ddf7248] <dbl>
ref(d2,d3)
# █ [1:0x559f7e56e928] <data.frame> 
#   ├─x = [2:0x559f7e44c198] <dbl> 
#   └─y = [3:0x559f7ddf7248] <dbl> 
#   
#   █ [4:0x559f7e6292c8] <data.frame> 
#   ├─x = [5:0x559f7ee95308] <dbl> 
#   └─y = [6:0x559f7ee95358] <dbl> 


x <- c("a", "a", "abc", "d")
ref(x)
ref(x, character = TRUE)
y <- c("a", "a", "abc", "def")
ref(x, y, character = TRUE)
# █ [1:0x559f7e1f0048] <chr> 
#   ├─[2:0x559f7a164730] <string: "a"> 
#   ├─[2:0x559f7a164730] 
# ├─[3:0x559f7e2dd630] <string: "abc"> 
#   └─[4:0x559f7a62c1d8] <string: "d"> 
#   
#   █ [5:0x559f7e19fb18] <chr> 
#   ├─[2:0x559f7a164730] 
# ├─[2:0x559f7a164730] 
# ├─[3:0x559f7e2dd630] 
# └─[6:0x559f7a77c3e8] <string: "def"> 

# 2.3.6 Exercises

tracemem(1:10)
## Needs a name to track it with?
?tracemem
nums <- 1:10
typeof(nums)
is.vector(nums)
tracemem(nums)
untracemem(nums)

x <- c(1L, 2L, 3L)
is.vector(x)
tracemem(x)
x[[3]] <- 4
x
untracemem(x)

example("tracemem")

a <- 1:10
a
ref(a)
# [1:0x559f7f801aa8] <int> 

b <- list(a, a)
b
ref(a, b)
# [1:0x559f7f801aa8] <int> 
#   
#   █ [2:0x559f7e7787f8] <list> 
#   ├─[1:0x559f7f801aa8] 
# └─[1:0x559f7f801aa8] 

c <- list(b,a,1:10)
c
ref(a,b,c)

# [1:0x559f7f801aa8] <int> 
#   
#   █ [2:0x559f7e7787f8] <list> 
#   ├─[1:0x559f7f801aa8] 
# └─[1:0x559f7f801aa8] 
# 
# █ [3:0x559f804376d8] <list> 
#   ├─[2:0x559f7e7787f8] 
# ├─[1:0x559f7f801aa8] 
# └─[4:0x559f7f2014b0] <int> 


n <- 1:10
typeof(n)
class(n)
is.vector(n)
length(n)
# List of a vector of ints
x <- list(1:10)
typeof(x)
class(x)
ref(x)
# █ [1:0x559f7ef2d4e8] <list> 
#   └─[2:0x559f7f1e47b8] <int> 
is.vector(x)
length(x)
x[1]
x[[1]]

x[[2]] <- x
x[1]
x[2]
x
ref(x)
# █ [1:0x559f7eeedb28] <list> 
#   ├─[2:0x559f7f1e47b8] <int> 
#   └─█ [3:0x559f7ef2d4e8] <list> 
#   └─[2:0x559f7f1e47b8] 

y <- list(c(1:10))
y
x
y[1]
typeof(1:10)
## Penny dropped!
x[[1]][1]

## See train analogy in Hands-On Programming with R, page 75
#  x[[1]] selects the first item from the list - a vector of numbers 1 - 10
# x[[1]][1] will then pick the first number from this vecor, ie 1.

# 2.4 Object Size
obj_size(letters)
obj_size(ggplot2::diamonds)
# ?ggplot2::diamonds

x <- runif(1e6)
obj_size(x)
# 8,000,048 B

y <- list(x,x,x,x,x,x,x)
obj_size(y)
# 8,000,160 B


# Should be zero!
obj_size(y) - obj_size(x) - obj_size(list(NULL,NULL,NULL,NULL,NULL,NULL,NULL))


# 2.4.1 Exercises
# 1.
y <- rep(list(runif(1e4)), 100)
y
object.size(y)
obj_size(y)
?obj_size
ref(y)

y[[3]][1]
y[[99]][1]

# 2.
x <- list(mean, sd, var)
obj_size(x)


# 3.
?runif

# 2.5 Modify-in-place

v <- c(1,2,3)
tracemem(v)
v[[3]] <- 4

untracemem(v)


x <- data.frame(matrix(runif(5 * 1e4), ncol = 5))
medians <- vapply(x, median, numeric(1))
x
medians

cat(tracemem(x), "\n")
for (i in seq_along(medians)) {
  x[[i]] <- x[[i]] - medians[[i]]
}
untracemem(x)


y <- as.list(x)
cat(tracemem(y), "\n")

for (i in 1:5) {
  y[[i]] <- y[[i]] - medians[[i]]
}
untracemem(y)

# 2.5.2 Environments

e1 <- rlang::env(a=1, b= 2, c=3)
e2 <- e1

e1$c <- 4

e2$c

# http://bench.r-lib.org/
# devtools::install_github("r-lib/bench")



sub_median1 <- function(numcolumns = 5) {
  x <- data.frame(matrix(runif(5 * 1e4), ncol = numcolumns))
  medians <- vapply(x, median, numeric(1))
  for (i in seq_along(medians)) {
    x[[i]] <- x[[i]] - medians[[i]]
  }
}

sub_median2 <- function(numcolumns = 5) {
  x <- data.frame(matrix(runif(5 * 1e4), ncol = numcolumns))
  medians <- vapply(x, median, numeric(1))
  for (i in seq_along(medians)) {
    x[[i]] <- x[[i]] - medians[[i]]
  }
}

library(bench)
bnch1 <- bench::mark(sub_median1())
bnch1
bnch2 <- bench::mark(sub_median2())
bnch2

#?press
# Helper function to create a simple data.frame of the specified dimensions
create_df <- function(rows, cols) {
  as.data.frame(setNames(
    replicate(cols, runif(rows, 1, 1000), simplify = FALSE),
    rep_len(c("x", letters), cols)))
}

# Run 4 data sizes across 3 samples with 2 replicates (24 total benchmarks)
press(
  rows = c(1000, 10000),
  cols = c(10, 100),
  rep = 1:2,
  {
    dat <- create_df(rows, cols)
    bench::mark(
      min_time = .05,
      bracket = dat[dat$x > 500, ],
      which = dat[which(dat$x > 500), ],
      subset = subset(dat, x > 500)
    )
  }
)

press(
  cols = c(5, 10, 15, 20, 100, 1000),
  rep = 1:2,
  {
    bench::mark(
      sub_median1(cols)
    )
  }
)

press(
  cols = c(5, 10, 15, 20, 100, 1000),
  rep = 1:2,
  {
    bench::mark(
      sub_median2(cols)
    )
  }
)

mem_used()
gc()

####  3 Vectores  ################

# 3.2 Atomic Vectors
dbl_var <- c(1, 2.5, 4.5)
int_var <- c(1L, 6L, 10L)
lgl_var <- c(TRUE, FALSE)
chr_var <- c("these are", "some strings")

typeof(dbl_var)
typeof(int_var)
typeof(lgl_var)
typeof(chr_var)

str(c("a", 1))
# ?str
# str(x)

# Coercion
x <- c(FALSE, FALSE, TRUE)
as.numeric(x)
sum(x)
mean(x)

as.integer(c("1", "1.5", "a"))

# 3.2.4 Exercises

# 1.

# ?raw
xx <- raw(2)
xx
typeof(xx)
xx <- raw(123)
xx
typeof(xx)

# ?complex
c1 <- 0i ^ (-3:3)
c1

# 2. 
typeof(c(1, FALSE))
typeof(c("a", 1))
typeof(c(TRUE, 1L))

# 3. 

1 == "1"
-1 < FALSE
"one" < 2
"1" < 2
typeof(c("1", 2))

# 4.

typeof(c(TRUE, FALSE))
typeof(c(FALSE, NA_character_))
typeof(c(FALSE, NA))

# 5.
x <- c(1,2,3)
y <- c(1,2,"3")
z <- list(1, 2, 3)
# zz <- list(1, "2", 3) 
is.atomic(x)
is.atomic(y)
is.atomic(z)

is.numeric(x)
is.numeric(y)
is.numeric(z)

is.vector(x)
is.vector(y)
is.vector(z)


# 3.3.1  Getting and setting
a <- 1:3
attr(a, "x") <- "abcdef"
attr(a, "x")

attr(a, "y") <- 4:6
str(attributes(a))

a <- structure(
  1:3, 
  x = "abcdef",
  y = 4:6
)
str(attributes(a))

# 3.3.2 Names

# When creating it: 
x <- c(a = 1, b = 2, c = 3)
x

# By assigning names() to an existing vector:
x <- 1:3
names(x) <- c("a", "b", "c")
x

# Inline, with setNames():
x <- setNames(1:3, c("a", "b", "c"))
x

# 3.3.3 Dimensions

