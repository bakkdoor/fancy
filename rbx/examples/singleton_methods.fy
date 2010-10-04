def self singleton_method {
  "in singleton_method" println
}

self singleton_method

arr = [1,2,3]

def arr foobar {
  self each: |x| {
    "foobar: " ++ x println
  }
}

arr foobar

def Array empty! {
  ["empty array ;)"]
}

Array empty! inspect println
