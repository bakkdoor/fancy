# -*- coding: undecided -*-
# some array example code

arr = [1,2,3,4,5,6];
arr each: |x| {
  x squared println
};

arr each_with_index: |x, i| {
  "Index " print;
  i print;
  " -> " print;
  x println
};

arr map: |x| { x * x } . println;
arr map: |x| { x + x } . println;
arr select: |x| { x < 4 } . println;
arr reject: |x| { x < 4 } . println;
arr take_while: |x| { x < 5 } . println;
arr reduce: |acc, x| { acc * x } with: 1 . println; # same as: 1*1*2*3*4*5*6

# some other handy methods
arr size println;
arr to_s println;
arr inspect println;
nil inspect println;
{ "foo" println } inspect println
