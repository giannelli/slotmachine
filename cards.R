

library(readr)
deck <- read_csv("~/Rdev/R/HandsOn/deck.csv")
View(deck)

head(deck)


deck[,]
deck[1,1]
deck[1,2]
deck[1,2:3]
deck[c(1,13),2:3]
deck[1, c("face", "suit", "value")]
deck[1:10, c("face", "suit")]

deal <- function(cards) {
  cards[1,]
}

deal(deck)

shuffle <- function(cards) {
  random <- sample(1:52, size = 52)
  cards[random, ]
}

deck2 <- shuffle(deck)
deal(deck2)
deck2 <- shuffle(deck)
deal(deck2)
deck2 <- shuffle(deck)
deal(deck2)
deck2 <- shuffle(deck)
deal(deck2)
deck2 <- shuffle(deck)
deal(deck2)
deck2 <- shuffle(deck)
deal(deck2)


lst <- list(numbers = c(1, 2), logical = TRUE, strings = c("a", "b", "c"))
lst

lst[1]
#sum(lst[1])
sum(lst$numbers)
sum(lst[[1]])

deck2 <- deck
deck2$new <- 1:52
head(deck2)
deck2$new <- NULL
head(deck2)


aces <- deck2[c(13, 26, 39, 52), ]
aces
typeof(aces)
class(aces)
deck

library(pryr)
parenvs(all = TRUE)

as.environment("package:stats")
globalenv()
baseenv()
emptyenv()
parent.env(globalenv())
parent.env(parent.env(globalenv()))
parent.env(parent.env(parent.env(globalenv())))
parent.env(parent.env(parent.env(parent.env(globalenv()))))
parent.env(parent.env(parent.env(parent.env(parent.env(globalenv())))))
parent.env(parent.env(parent.env(parent.env(parent.env(parent.env(globalenv()))))))
#  and so on ....!


ls(emptyenv())
ls(globalenv())

head(globalenv()$deck, 3)
assign("new", "Hello Global", envir = globalenv())
new
globalenv()$new


environment()

show_env <- function(){
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}
show_env()

environment(show_env)
environment(parenvs)

foo <- "take me to your runtime"
show_env <- function(x = foo){
  a <- 1
  b <- 2
  c <- 3
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}
show_env()
foo <- NULL
show_env()

show_env <- function(x = "default foo"){
  a <- 1
  b <- 2
  c <- 3
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}

show_env()

deal <- function() {
  deck[1, ]
}
environment(deal)
deal()
deal()
deal()
DECK <-deck
 
 deal <- function() {
   card <- deck[1, ]
   assign("deck", deck[-1, ], envir = globalenv())
   card
 }

 deal()
 deal()
 deal()

 shuffle <- function(cards) {
   random <- sample(1:52, size = 52)
   cards[random, ]
 } 

 head(deck, 3)
 a <- shuffle(deck)
 head(deck, 3)
 head(a, 3)
 
shuffle <- function(){
   random <- sample(1:52, size = 52)
   assign("deck", DECK[random, ], envir = globalenv())
 }
shuffle()
nrow(deck)
deal()
deal()
deal()
nrow(deck)

# clean up
deck <- read_csv("~/Rdev/R/HandsOn/deck.csv")

setup <- function(deck) {
  DECK <- deck
  DEAL <- function() {
    card <- deck[1, ]
    assign("deck", deck[-1, ], envir = parent.env(environment()))
    card
  }
  SHUFFLE <- function(){
    random <- sample(1:52, size = 52)
    assign("deck", DECK[random, ], envir = parent.env(environment()))
  }
  
  list(deal = DEAL, shuffle = SHUFFLE)
}

cards <-setup(deck)

deal <-cards$deal
shuffle <- cards$shuffle
deal
shuffle

head(deck)
deal()
deal()
deal()
head(deck)
shuffle()
head(deck)
deal()
deal()
deal()
head(deck)

cards

shuffle()
for (i in 1:25){
  print(deal())
}
typeof(cards)
names(cards)

get_symbols <- function() {
  wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  sample(wheel, size = 3, replace = TRUE,
         prob = c(0.03, 0.03, 0.06, 0.1, 0.25, 0.01, 0.52))
}

for (i in 1:25){
  print(get_symbols())
}

payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25, "B" = 10, "C" = 10, "0" = 0)
payouts["DD"]
unname(payouts["DD"])

score <- function(symbols) {
  # identify case
  same <- symbols[1] == symbols[2] && symbols[2] == symbols[3]
  bars <- symbols %in% c("B", "BB", "BBB")
  
  # get prize
  if (same) {
    payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25,
                 "B" = 10, "C" = 10, "0" = 0)
    prize <- unname(payouts[symbols[1]])
  } else if (all(bars)) {
    prize <-5
  } else {
    cherries <- sum(symbols == "C")
    prize <- c(0, 2, 5)[cherries + 1]
  }
  
  # adjust for diamonds
  diamonds <- sum(symbols == "DD")
  prize <- prize * 2 ^ diamonds
  prize 
}

play <- function() {
  symbols <- get_symbols()
  structure(score(symbols), symbols = symbols, class = "slots")
}
play()


for (i in 1:10){
  print(play())
}


levels(DECK) <- c("level 1", "level 2", "level 3")
attributes(DECK)

one_play <- play()
one_play
attributes(one_play)
attr(one_play, "symbols") <- c("B", "0", "B")
attributes(one_play)
one_play


slot_display <- function(prize){
  # extract symbols
  symbols <- attr(prize, "symbols")
  # collapse symbols into single string
  symbols <- paste(symbols, collapse = " ")
  # combine symbol with prize as a regular expression
  # \n is regular expression for new line (i.e. return or enter)
  string <- paste(symbols, " - $", prize, "\n", sep = "")
  # display regular expression in console without quotes
  cat(string)
}

slot_display(one_play)

for (i in 1:100){
  slot_display(play())
}

# Generic methods
num <- 1000000000
print(num)
class(num) <- c("POSIXct", "POSIXt")
print(num)


print
print.POSIXct
print.factor

methods(print)

class(one_play) <- "slots"
one_play

args(print)
print.slots <- function(x, ...) {
  cat("I'm using the print.slots method")
}
print(one_play)
one_play
rm(print.slots)

print.slots <- function(x, ...) {
  slot_display(x)
}
print(one_play)

play1 <- play()
