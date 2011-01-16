class MatchData {
   def at: idx {
     ruby: '[] args: [idx]
   }

   def [] idx {
     at: idx
   }
}