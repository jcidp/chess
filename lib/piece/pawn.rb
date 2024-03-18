# frozen_string_literal: true

# Represents a Pawn piece
class Pawn
  attr_accessor :unmoved
  attr_reader :code, :color, :type

  def valid_move?(from, to)
    row_diff = to[0] - from[0]
    row_abs_diff = row_diff.abs
    col_abs_diff = (to[1] - from[1]).abs
    direction = row_diff.positive? ? "white" : "black"
    col_abs_diff.zero? && direction == color && (row_abs_diff == 1 || (row_abs_diff == 2 && unmoved))
  end

  def valid_take?(from, to)
    row_diff = to[0] - from[0]
    row_abs_diff = row_diff.abs
    col_abs_diff = (to[1] - from[1]).abs
    direction = row_diff.positive? ? "white" : "black"
    row_abs_diff == 1 && col_abs_diff == 1 && direction == color
  end

  def path(from, to)
    row_diff = to[0] - from[0]
    if row_diff.abs == 2
      row_sign = row_diff.positive? ? :+ : :-
      return [[from[0].send(row_sign, 1), from[1]]]
    end
    []
  end

  def adjacent_squares(from)
    row, col = from
    sign = color == "white" ? :+ : :-
    hash = {}
    [1, 2].each do |num|
      square = [row.send(sign, num), col]
      hash[square] = [square] if num == 1
      hash[square] = [[row.send(sign, 1), col], square] if num == 2 && unmoved
    end
    hash
  end

  private

  attr_writer :code, :color, :type

  def initialize(color)
    self.color = color
    self.type = "pawn"
    self.code = color == "white" ? "\u2659" : "\u265F"
    self.unmoved = true
  end
end
