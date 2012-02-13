class MyActor {
  is_actor

  def initialize: @value
  def do_it {
    @value println
    Thread sleep: 1
    'done
  }

  def spawn_linked {
    MyActor new_link: @value
  }

  supervise_as: 'my_uber_actor
}


a = MyActor new: "hello, world"
# future send
f = a @ do_it
f value inspect println

# spawn linked actor instance
b = a spawn_linked
# async send, returns nil immediately
b @@ do_it

c = MyActor new: "Sync send"
# Synchronous ("normal") message send
b do_it