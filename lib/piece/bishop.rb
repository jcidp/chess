# frozen_string_literal: true

# Represents a Bishop piece
class Bishop
  attr_reader :code, :color, :type

  def valid_move?(from, to)
    row_abs_diff = (to[0] - from[0]).abs
    col_abs_diff = (to[1] - from[1]).abs
    row_abs_diff == col_abs_diff
  end

  private

  attr_writer :code, :color, :type

  def initialize(color)
    self.color = color
    self.type = "bishop"
    self.code = color == "white" ? "\u2657" : "\u265D"
  end
end
