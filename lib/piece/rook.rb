# frozen_string_literal: true

# Represents a Rook piece
class Rook
  attr_reader :code, :color, :type

  def valid_move?(from, to)
    to[0] == from[0] || to[1] == from[1]
  end

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

  private

  attr_writer :code, :color, :type

  def initialize(color)
    self.color = color
    self.type = "rook"
    self.code = color == "white" ? "\u2656" : "\u265C"
  end
end
