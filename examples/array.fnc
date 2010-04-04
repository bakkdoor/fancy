# -*- coding: undecided -*-
# some array example code

arr = [1,2,3,4,5,6];
arr each: |x| {
  x squared println
};

arr each_with_index: |x, i| {
  "Index " ++ i ++ " -> " ++ x println
};

arr map: |x| { x * x } . println;
arr map: |x| { x + x } . println;
arr select: |x| { x < 4 } . println;
arr reject: |x| { x < 4 } . println;
arr take_while: |x| { x < 5 } . println;

"testing reduce:with: " print;
arr reduce: |acc, x| { acc * x } with: 1 . println; # same as: 1*1*2*3*4*5*6

"testing any?: " print;
arr any?: |x| { x > 3 } . println;

"testing all?: " print;
arr all?: |x| { x < 7 } . println;

"testing from:to: " print;
arr from: 3 to: 5 . println;

# some other handy methods
"testing size: " print;
arr size println;

"testing to_s: " print;
arr to_s println;

"testing inspect: " print;
arr inspect println;
nil inspect println
