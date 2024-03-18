# frozen_string_literal: true

# Represents a knight piece
class Knight
  attr_accessor :unmoved
  attr_reader :code, :color, :type

  def valid_move?(from, to)
    row_abs_diff = (to[0] - from[0]).abs
    col_abs_diff = (to[1] - from[1]).abs
    (row_abs_diff == 1 && col_abs_diff == 2) || (row_abs_diff == 2 && col_abs_diff == 1)
  end

  def path(*)
    []
  end

  def adjacent_squares(from)
    result = {}
    symbol_combinations.each do |symbols|
      2.times do |i|
        2.times do |j|
          next if i == j

          row = from[0].send(symbols[0], i + 1)
          col = from[1].send(symbols[1], j + 1)
          result[[row, col]] = [] if row.between?(0, 7) && col.between?(0, 7)
        end
      end
    end
    result
  end

  def symbol_combinations
    arr = %i[+ -]
    arr.product(arr)
  end

  private

  attr_writer :code, :color, :type

  def initialize(color)
    self.color = color
    self.type = "knight"
    self.code = color == "white" ? "\u2658" : "\u265E"
  end
end
