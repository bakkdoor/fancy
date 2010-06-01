## Conway's Game of Life in Fancy :)

def class World {
  self read_write_slots: [:matrix];

  def World with_height: height and_width: width {
    World new: [height, width]
  }

  def initialize: size {
    height = size[0];
    width = size[1];
    @matrix = Array new: height;
    height times: |i| {
      @matrix at: i put: (Array new: width with: 0)
    }
  }

  def [] index {
    @matrix[index]
  }
  
  def simulate: amount_generations {
    amount_generations times: {
      System sleep: 500; # sleep 500 ms
      self simulate;
      self display
    }
  }

  def display {
    Console clear;
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

  def alive?: pos {
    (@matrix[pos[0]][pos[1]]) == 1
  }

  def dead?: pos {
    (@matrix[pos[0]][pos[1]]) == 0
  }
  
  def live: pos {
    (@matrix[pos[0]]) at: (pos[1]) put: 1
  }

  def die: pos {
    (@matrix[pos[0]]) at: (pos[1]) put: 0
  }

  def simulate {
    @matrix each_with_index: |row i| {
      row each_with_index: |column j| {
        # check amount of neighbors
        n_neighbors = self neighbors_of: [i, j];
        self alive?: [i,j] . if_true: {
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
    offsets = [[-1, -1], [-1, 0], [-1, 1],
               [0, -1], [0, 0], [0, 1],
               [1, -1], [1, 0], [1, 1]];
    
    neighbors = offsets map: |o| {
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

w display;
w simulate: 20
