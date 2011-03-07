class MatchData {
   ruby_alias: 'size

   def at: idx {
     ruby: '[] args: [idx]
   }

   def [] idx {
     at: idx
   }

   def to_a {
     arr = []
     self size times: |i| {
       arr << (at: i)
     }
     arr
   }
}