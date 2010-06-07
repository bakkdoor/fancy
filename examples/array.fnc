# some array example code

# create an array
arr = [1,2,3,4,5,6];

# print each element squared
arr each: |x| {
  x squared println
};

# display each element with its index in the array
arr each_with_index: |x i| {
  "Index " ++ i ++ " -> " ++ x println
};

# print the array of squared elements
arr map: :squared . inspect println;

# print the array of doubled elements
arr map: :doubled . inspect println;

# print array of all elements smaller than 4
arr select: |x| { x < 4 } . inspect println;

# print array of all elements that are not smaller than 4
arr reject: |x| { x < 4 } . inspect println;

# prints: [5, 6]
arr take_while: |x| { x < 5 } . inspect println;

"testing reduce:with: " print;
arr reduce: |acc x| { acc * x } with: 1 . println; # same as: 1*1*2*3*4*5*6

"testing any?: " print;
arr any?: |x| { x > 3 } . println; # prints: true

"testing all?: " print;
arr all?: |x| { x < 7 } . println; # prints: true

"testing from:to: " print;
arr [[3,5]] . inspect println; # prints: [4, 5, 6]

# some other handy methods
"testing size: " print;
arr size println; # prints: 6

"testing to_s: " print;
arr to_s println; # prints: 123456

"testing inspect: " print;
arr inspect println # prints: [1, 2, 3, 4, 5, 6] : Array
