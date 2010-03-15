x = { Console println: "Println from within block!" };
x call;

y = |x,y| { Console println: $ x + y };
y call: [2, 3]
