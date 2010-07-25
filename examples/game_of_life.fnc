## Conway's Game of Life in Fancy :)

def class World {
  self read_write_slots: [:matrix];

  def World with_height: height and_width: width {
    World new: [height, width]
  }

  def initialize {
    # the offsets are the positions to check for neighbors relative to
    # each position (e.g. [-1,-1] points to the upper left neighbor of
    # each cell)
    @offsets = [[-1, -1], [-1, 0], [-1, 1],
                [0, -1],           [0, 1],
                [1, -1],  [1, 0],  [1, 1]]
  }

  def initialize: size {
    "Initialize a World with a given size ([height, width]).";

    self initialize;
    height = size[0];
    width = size[1];
    @last_alive = [];
    @matrix = Array new: height;
    height times: |i| {
      @matrix at: i put: (Array new: width with: 0)
    }
  }

  def [] index {
    "Return the row for a given index.";
    @matrix[index]
  }

  def simulate: amount_generations {
    "Simulate the World for a given amount of iterations (generations).";

    self display: 0;
    amount_generations times: |i| {
      System sleep: 500; # sleep 500 ms
      self simulate;
      self display: (i + 1)
    }
  }

  def display {
    "Display the World (print on Screen).";

    @matrix each: |row| {
      row each: |entry| {
        (entry == 0) if_true: {
          "  " print
        } else: {
          ". " print
        }
      };
      "" println
    }
  }

  def display: iteration {
    "Display the World (print on Screen) with the current iteration count.";

    Console clear;
    "Generation: " ++ iteration println;
    self display
  }

  def was_alive?: pos {
    "Indicates, if a cell ([row,column]) was alive in the last generation.";

    @last_alive[pos[0]] if_do: |row| {
      row[pos[1]] == 1
    }
  }

  def live: pos {
    "Sets the given cell ([row,column]) alive.;";
    (@matrix[pos[0]]) at: (pos[1]) put: 1
  }

  def die: pos {
    "Sets the given cell ([row,column]) dead.;";
    (@matrix[pos[0]]) at: (pos[1]) put: 0
  }

  def simulate {
    "Simulates the world one iteration.";

    @last_alive = @matrix map: |row| { row select_with_index: |c| { c == 1 } };
    @matrix each_with_index: |row i| {
      row each_with_index: |column j| {
        # check amount of neighbors
        n_neighbors = self neighbors_of: [i, j];
        self was_alive?: [i,j] . if_true: {
          (n_neighbors <= 1 or: (n_neighbors >= 4)) if_true: {
            self die: [i,j]
          } else: {
            self live: [i,j]
          }
        } else: {
          (n_neighbors == 3) if_true: {
            self live: [i,j]
          }
        }
      }
    }
  }

  def neighbors_of: pos {
    row = pos[0];
    column = pos[1];

    neighbors = @offsets map: |o| {
      @matrix[row + (o[0])] if_do: |r| {
        r[column + (o[1])]
      }
    };
    neighbors select: |x| { x != 0 } . size
  }
};

X = 1;
PULSAR = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, X, X, X, 0, 0, 0, X, X, X, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
          [0, 0, X, 0, 0, 0, 0, X, 0, X, 0, 0, 0, 0, X, 0],
          [0, 0, X, 0, 0, 0, 0, X, 0, X, 0, 0, 0, 0, X, 0],
          [0, 0, X, 0, 0, 0, 0, X, 0, X, 0, 0, 0, 0, X, 0],
          [0, 0, 0, 0, X, X, X, 0, 0, 0, X, X, X, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, X, X, X, 0, 0, 0, X, X, X, 0, 0, 0],
          [0, 0, X, 0, 0, 0, 0, X, 0, X, 0, 0, 0, 0, X, 0],
          [0, 0, X, 0, 0, 0, 0, X, 0, X, 0, 0, 0, 0, X, 0],
          [0, 0, X, 0, 0, 0, 0, X, 0, X, 0, 0, 0, 0, X, 0],
          [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, X, X, X, 0, 0, 0, X, X, X, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
          ];

w = World new;
w matrix: PULSAR;

w simulate: 20
