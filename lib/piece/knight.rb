# frozen_string_literal: true

# Represents a knight piece
class Knight
  attr_reader :code, :color, :type

  def valid_move?(from, to)
    row_abs_diff = (to[0] - from[0]).abs
    col_abs_diff = (to[1] - from[1]).abs
    (row_abs_diff == 1 && col_abs_diff == 2) || (row_abs_diff == 2 && col_abs_diff == 1)
  end

  def path(*)
    []
  end

  private

  attr_writer :code, :color, :type

  def initialize(color)
    self.color = color
    self.type = "knight"
    self.code = color == "white" ? "\u2658" : "\u265E"
  end
end
