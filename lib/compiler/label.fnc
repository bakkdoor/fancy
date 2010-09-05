def class Rubinius {
  ##
  # Jump label for the branch instructions. The use scenarios for labels:
  #   1. Used and then set
  #        g.gif label
  #        ...
  #        label.set!
  #   2. Set and then used
  #        label.set!
  #        ...
  #        g.git label
  #   3. 1, 2
  #
  # Many labels are only used once. This class employs two small
  # optimizations. First, for the case where a label is used once then set,
  # the label merely records the point it was used and updates that location
  # to the concrete IP when the label is set. In the case where the label is
  # used multiple times, it records each location and updates them to an IP
  # when the label is set. In both cases, once the label is set, each use
  # after that updates the instruction stream with a concrete IP at the
  # point the label is used. This avoids the need to ever record all the
  # labels or search through the stream later to change symbolic labels into
  # concrete IP's.

  def class Label {
    self read_write_slots: ['position];
    self read_slots: ['used, 'basic_block];
    # TODO: translate this:
    # alias_method 'used?, 'used

    def initialize: generator {
      @generator   = generator;
      @basic_block = generator new_basic_block;
      @position    = nil;
      @used        = nil;
      @location    = nil;
      @locations   = nil
    }

    def set! {
      @position = @generator ip;
      @locations if_do: {
        @locations each: |x| { @generator stream at: x put: @position }
      } else: {
        @location if_do: {
          @generator stream at: @location put: @position
        }
      };

      @generator current_block add_edge: @basic_block;
      @generator current_block close;
      @generator current_block: @basic_block;
      @basic_block open
    }

    def used_at: ip {
      @position if_do: {
        @generator stream at: ip put: @position
      } else: {
        @location not if_do: {
          @location = ip
        } else: {
          @locations if_do: {
            @locations << ip
          } else: {
            @locations = [@location, ip]
          }
        }
      };
      @used = true
    }
  }
}
