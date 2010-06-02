{ Directory create: "tmp/" } unless: $ Directory exists?: "tmp/";

# let's create an object with metadata attached to it
f = File open: "tmp/metadata" modes: [:write];
# set the metadata for f
f %M: <[:downloaded_from => "http://www.fancy-lang.org", :important => true]>;
# retrieve the metadata for f and print it
"File: '" ++ (f filename) ++ "' downloaded from: " ++ (f %M [:downloaded_from]) println
