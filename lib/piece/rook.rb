# frozen_string_literal: true

require_relative "../piece"

# Represents a Rook piece
class Rook < Piece
  def path(from, to)
    result = []
    row_sign = (to[0] - from[0]).positive? ? :+ : :-
    col_sign = (to[1] - from[1]).positive? ? :+ : :-
    direction = to[0] == from[0] ? "col" : "row"
    current_square = from.dup
    while current_square != to
      current_square[0] = current_square[0].send(row_sign, 1) if direction == "row"
      current_square[1] = current_square[1].send(col_sign, 1) if direction == "col"
      result << current_square.dup unless current_square == to
    end
    result
  end

  def adjacent_squares(from)
    result = {}
    %i[+ -].each do |symbol|
      %w[row col].each do |direction|
        row, col = from
        while row.between?(0, 7) && col.between?(0, 7)
          row = row.send(symbol, 1) if direction == "row"
          col = col.send(symbol, 1) if direction == "col"
          to = [row, col]
          result[to] = path(from, to) if row.between?(0, 7) && col.between?(0, 7)
        end
      end
    end
    result
  end

  private

  def initialize(color)
    super
    self.type = "rook"
    self.code = color == "white" ? "\u2656" : "\u265C"
  end
end
