{ Directory create: "tmp/" } unless: $ Directory exists?: "tmp/";

# let's create an object with metadata attached to it
f = File open: "tmp/metadata" modes: [:write];
# set the metadata for f
f meta: <[:downloaded_from => "http://www.fancy-lang.org", :important => true]>;
# retrieve the metadata for f and print it
"File: '" ++ (f filename) ++ "' downloaded from: " ++ (f meta [:downloaded_from]) println;

f close;
File delete: "tmp/metadata";
Directory delete: "tmp/"
