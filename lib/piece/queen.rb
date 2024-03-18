# frozen_string_literal: true

# Represents a Queen piece
class Queen
  attr_accessor :unmoved
  attr_reader :code, :color, :type

  def valid_move?(from, to)
    row_abs_diff = (to[0] - from[0]).abs
    col_abs_diff = (to[1] - from[1]).abs
    row_abs_diff == col_abs_diff || row_abs_diff.zero? || col_abs_diff.zero?
  end

  def path(from, to)
    result = []
    row_sign, col_sign, fixed_row, fixed_col = signs_and_fixed(from, to)
    current_square = from.dup
    while current_square != to
      current_square[0] = current_square[0].send(row_sign, 1) unless fixed_row
      current_square[1] = current_square[1].send(col_sign, 1) unless fixed_col
      result << current_square.dup unless current_square == to
    end
    result
  end

  private

  attr_writer :code, :color, :type

  def initialize(color)
    self.color = color
    self.type = "queen"
    self.code = color == "white" ? "\u2655" : "\u265B"
  end

  def signs_and_fixed(from, to)
    row_diff = to[0] - from[0]
    col_diff = to[1] - from[1]
    row_sign = row_diff.positive? ? :+ : :-
    col_sign = col_diff.positive? ? :+ : :-
    fixed_row = row_diff.zero?
    fixed_col = col_diff.zero?
    [row_sign, col_sign, fixed_row, fixed_col]
  end
end
