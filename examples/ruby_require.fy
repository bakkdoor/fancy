# ruby_require.fy
# Example of Ruby code reusing and evaluation from inside fancy

require(__DIR__ + "/ruby_file")

obj = RubyClass new
obj ruby_method("foo", "bar")
