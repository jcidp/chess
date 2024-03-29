# frozen_string_literal: true

require_relative "../piece"

# Represents a Bishop piece
class Bishop < Piece
  def path(from, to)
    result = []
    row_sign = (to[0] - from[0]).positive? ? :+ : :-
    col_sign = (to[1] - from[1]).positive? ? :+ : :-
    current_square = from.dup
    while current_square != to
      current_square[0] = current_square[0].send(row_sign, 1)
      current_square[1] = current_square[1].send(col_sign, 1)
      result << current_square.dup unless current_square == to
    end
    result
  end

  def adjacent_squares(from)
    result = {}
    symbol_combinations.each do |symbols|
      row, col = from
      while row.between?(0, 7) && col.between?(0, 7)
        row = row.send(symbols[0], 1)
        col = col.send(symbols[1], 1)
        to = [row, col]
        result[to] = path(from, to) if row.between?(0, 7) && col.between?(0, 7)
      end
    end
    result
  end

  def symbol_combinations
    arr = %i[+ -]
    arr.product(arr)
  end

  private

  def initialize(color)
    super
    self.type = "bishop"
    self.code = color == "white" ? "\u2657" : "\u265D"
  end
end
