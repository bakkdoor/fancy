# Don't print warnings and actor crash logs
Celluloid logger=(Fancy MessageSink new)

FancySpec describe: "Celluloid backed Actors" with: {
  it: "calls the trap_exit handler" when: {
    class MyActor {
      is_actor
      trap_exit: 'actor_failed:reason:
      read_slot: 'noticed_failure?

      def initialize: @noticed_failure? (false);

      def fail {
       "I'm failing!" raise!
      }

      def actor_failed: actor reason: reason {
        @noticed_failure? = reason message == "I'm failing!"
      }
    }

    a = MyActor new
    b = MyActor new
    b link: a
    a noticed_failure? is: false
    b @@ fail
    sleep: 0.1
    a noticed_failure? is: true
  }
}
