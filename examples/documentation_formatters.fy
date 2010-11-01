# documentation_formatters.fy
# Example of fancy's documentation formatters

foo = Object new

Fancy Documentation for: foo is: """
## Fancy documentation.

 It should be possible to set documentation for any _arbitray object_.
 Doing so will expose it on the API documents.
 This can be useful for constants, or singleton objects.

## Fancy Documentation formatters

 Fancy you to create custom documentation formatters,
 thus, allowing you to display an object document in a well
 formatted way for different environments, eg. when using the
 interactive REPL you may want *ANSI* _colored_ output, or maybe
 we create a tool to generate MAN(1) pages, and fdoc tool
 to generate HTML API docs.

"""

Fancy Documentation for: foo . format: 'markdown . println

