# frozen_string_literal: true

# Represents a Bishop piece
class Bishop
  attr_accessor :unmoved
  attr_reader :code, :color, :type

  def valid_move?(from, to)
    row_abs_diff = (to[0] - from[0]).abs
    col_abs_diff = (to[1] - from[1]).abs
    row_abs_diff == col_abs_diff
  end

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

  private

  attr_writer :code, :color, :type

  def initialize(color)
    self.color = color
    self.type = "bishop"
    self.code = color == "white" ? "\u2657" : "\u265D"
  end
end
