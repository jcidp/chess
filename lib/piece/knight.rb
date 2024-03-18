# frozen_string_literal: true

# Represents a knight piece
class Knight
  attr_accessor :unmoved
  attr_reader :code, :color, :type

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
