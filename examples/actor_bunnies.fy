# Inspired by actors example at http://www.artima.com/weblogs/viewpost.jsp?thread=328540

class Bunny {
  def initialize: @id {
    self @@ hop
  }
  def hop {
    self ++ " " print
    self @@ hop
    Thread sleep: 0.5
  }
  def stop: respond_to {
    "Stopping #{self}" println
    die!
    respond_to @@ stopped
  }
  def to_s {
    "Bunny(#{@id})"
  }
}

@thread  = Thread current # save current Thread so it can be resumed񓩌
def self stopped {
  @amount = @amount - 1
  { @thread run } if: (@amount == 0)
}

@amount = 10
bunnies = (0..@amount) map: |i| { Bunny new: i }
Console readln: "\n\nPress ENTER to stop bunnies\n\n"
bunnies each: |b| { b @@ stop: self }
Thread stop # wait to be resumed when all bunnies are killed