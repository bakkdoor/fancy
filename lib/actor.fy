class Actor {
  @@actor_pool = nil
  @@pool_size = 10

  def Actor pool_size: size {
    @@pool_size = size
  }

  def Actor spawn_actors {
    @@actor_pool = (0..@@pool_size) map: {
      Actor spawn: {
        loop: {
          sender = nil
          try {
            type, msg, sender = Actor receive
            receiver, msg, params = msg
            match type {
              case 'async ->
                receiver receive_message: msg with_params: params
              case 'future ->
                val = receiver receive_message: msg with_params: params
                sender completed: val
            }
          } catch Exception => e {
            { sender failed: e } if: sender
          }
        }
      }
    }
  }

  def Actor pool {
    @@actor_pool
  }

  def Actor[receiver] {
    @@actor_pool if_nil: { Actor spawn_actors }
    id = receiver object_id % (@@actor_pool size)
    @@actor_pool[id]
  }
}