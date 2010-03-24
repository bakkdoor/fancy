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
arr select: |x| { x < 4 } . println;
arr reject: |x| { x < 4 } . println;
arr take_while: |x| { x < 5 } . println


