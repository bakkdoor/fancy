x = { Console println: "Println from within block!" };
x call;

y = |x,y| { Console println: $ x + y };
y call: [2, 3];

zahl = 0;
{ zahl <= 20 } while_true: {
  Console println: zahl;
  zahl = zahl + 1
}
