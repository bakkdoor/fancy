# blocks.fy
# Examples of fancy code blocks

x = { Console println: "Println from within block!" }
x call # calls x and prints: "Println from within block!"

y = |x y| { Console println: $ x + y }
y call: [2, 3] # calls y and prints: 5

# prints numbers 0 to 20
num = 0
while: { num <= 20 } do: {
  Console println: num
  num = num + 1
}
