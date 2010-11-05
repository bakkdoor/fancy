class Docstring
  # Does Docstring transformations
  def self.transform(str)
    str.split("\n").map do |line|
      line.split.map do |word|
        word.gsub(/^@(\S+)@/, "<span data-class='\\1' class='selectable'>*\\1*</span>").gsub(/^@(\S+)$/, "**\\1**")
      end.join(" ")
    end.join("\n")
  end
end
