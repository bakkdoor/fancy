max           = 10
secret_number = max random
counter       = 1

loop: {
  guess = Console readln: "Guess a number between 0 and #{max}: " to_i
  if: (guess == secret_number) then: {
    "You got it! It took you #{counter} attempts." println
    break
  } else: {
    if: (guess < secret_number) then: {
      "That's too low. Try again." println
    } else: {
      "That's too high. Try again." println
    }
  }
  counter = counter + 1
}