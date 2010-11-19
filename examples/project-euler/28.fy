# Problem 28
# What is the sum of the numbers on the diagonals in a 1001 by 1001 spiral
# formed in the same way?

# Starting with the number 1 and moving to the right in a clockwise
# direction a 5 by 5 spiral is formed as follows:
#
# 21 22 23 24 25
# 20  7  8  9 10
# 19  6  1  2 11
# 18  5  4  3 12
# 17 16 15 14 13
#
# It can be verified that the sum of the numbers on the diagonals is 101.

taille = 1001
pas = taille - 1
number = taille ** 2
coins = 1
sum = number

{ pas > 0 } while_true: {
  number = number - pas
  sum = sum + number
  if: (coins == 4) then: {
    coins = 1
    pas = pas - 2
  } else: {
    coins = coins + 1
  }
}

"The sum of the numbers of the diagonals of the matrix is: " ++ sum println
