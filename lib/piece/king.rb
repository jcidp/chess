# frozen_string_literal: true

# Represents a King piece
class King
  attr_accessor :unmoved
  attr_reader :code, :color, :type

  def path(*)
    []
  end

  def adjacent_squares(from)
    result = {}
    delta_combinations.each do |deltas|
      next if deltas == [0, 0]

      row = from[0] + deltas[0]
      col = from[1] + deltas[1]
      to = [row, col]
      result[to] = [] if row.between?(0, 7) && col.between?(0, 7)
    end
    result
  end

  def delta_combinations
    arr = [1, 0, -1]
    arr.product(arr)
  end

  private

  attr_writer :code, :color, :type

  def initialize(color)
    self.color = color
    self.type = "king"
    self.code = color == "white" ? "\u2654" : "\u265A"
  end
end
