
# Hands-On Programming with R
# Chapter 9 : Loops
die <- c(1, 2, 3, 4, 5, 6)

rolls <- expand.grid(die, die)
rolls


rolls$value <- rolls$Var1 + rolls$Var2
head(rolls, 3)

prob <- c("1" = 1/8, "2" = 1/8, "3" = 1/8, "4" = 1/8, "5" = 1/8, "6" = 3/8)
prob

rolls$Var1

prob[rolls$Var1]

rolls$prob1 <- prob[rolls$Var1]
head(rolls, 3)

rolls$prob2 <- prob[rolls$Var2]
head(rolls, 3)

rolls$prob <- rolls$prob1 * rolls$prob2
head(rolls, 3)

sum(rolls$value * rolls$prob)


## Expecte slot machine values
wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")

combos <- expand.grid(wheel, wheel, wheel, stringsAsFactors = FALSE)
head(combos)

get_symbols <- function() {
  wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  sample(wheel, size = 3, replace = TRUE, prob = c(0.03, 0.03, 0.06, 0.1, 0.25, 0.01, 0.52))
}

prob <- c("DD" = 0.03, "7" = 0.03, "BBB" = 0.06, "BB" = 0.1, "B" = 0.25, "C" = 0.01, "0" = 0.52)
prob

combos$prob1 <- prob[combos$Var1]
combos$prob2 <- prob[combos$Var2]
combos$prob3 <- prob[combos$Var3]
head(combos, 3)

combos$prob <- combos$prob1 * combos$prob2 * combos$prob3
head(combos, 3)

# Check
sum(combos$prob)


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
symbols <- c(combos[1, 1], combos[1, 2], combos[1, 3])
score(symbols)


combos$prize <- NA
head(combos, 3)

for (i in 1:nrow(combos)) {
  symbols <- c(combos[i, 1], combos[i, 2], combos[i, 3])
  combos$prize[i] <- score(symbols)
}
head(combos, 3)

# Payout rate of slot machine - expected value
sum(combos$prize * combos$prob)
# Only pay out 54 cents in the dollar!

#  But we haven't taken into account diamonds



# New score to cater for diamonds
score <- function(symbols) {
  diamonds <- sum(symbols == "DD")
  cherries <- sum(symbols == "C")
  # identify case
  # since diamonds are wild, only nondiamonds
  # matter for three of a kind and all bars
  slots <- symbols[symbols != "DD"]
  same <- length(unique(slots)) == 1
  bars <- slots %in% c("B", "BB", "BBB")
  # assign prize
  if (diamonds == 3) {
    prize <- 100
  } else if (same) {
    payouts <- c("7" = 80, "BBB" = 40, "BB" = 25,
                 "B" = 10, "C" = 10, "0" = 0)
    prize <- unname(payouts[slots[1]])
  } else if (all(bars)) {
    prize <- 5
  } else if (cherries > 0) {
    # diamonds count as cherries
    # so long as there is one real cherry
    prize <- c(0, 2, 5)[cherries + diamonds + 1]
  } else {
    prize <- 0
  }
  # double for each diamond
  prize * 2^diamonds
}


for (i in 1:nrow(combos)) {
  symbols <- c(combos[i, 1], combos[i, 2], combos[i, 3])
  combos$prize[i] <- score(symbols)
}
sum(combos$prize * combos$prob)


## Undertstanding  score - pick DD DD BBB

symbols <- c(combos[99, 1], combos[99, 2], combos[99, 3])
symbols

diamonds <- sum(symbols == "DD")
diamonds
cherries <- sum(symbols == "C")
cherries
# identify case
# since diamonds are wild, only nondiamonds
# matter for three of a kind and all bars
slots <- symbols[symbols != "DD"]
slots
same <- length(unique(slots)) == 1
same
bars <- slots %in% c("B", "BB", "BBB")
bars
# assign prize
payouts <- c("7" = 80, "BBB" = 40, "BB" = 25,
               "B" = 10, "C" = 10, "0" = 0)
payouts
slots[1]
prize <- unname(payouts[slots[1]])
prize
# double for each diamond
prize * 2^diamonds
## end understanding


get_symbols <- function() {
  wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  sample(wheel, size = 3, replace = TRUE,
         prob = c(0.03, 0.03, 0.06, 0.1, 0.25, 0.01, 0.52))
}


play <- function() {
  symbols <- get_symbols()
  structure(score(symbols), symbols = symbols, class = "slots")
}


plays_till_broke <- function(start_with) {
  cash <- start_with
  n <- 0
  while (cash > 0) {
    prize <- play()
#    print(prize)
    cash <- cash - 1 + prize
    n <- n + 1
  }
  n
}
for (i in 1:10) {
  print(plays_till_broke(100))
}


plays_till_broke2 <- function(start_with) {
  cash <- start_with
  n <- 0
  repeat {
    cash <- cash - 1 + play()
    n <- n + 1
    if (cash <= 0) {
      break
    }
  }
  n
}
plays_till_broke2(100)
for (i in 1:10) {
  print(plays_till_broke2(100))
}
