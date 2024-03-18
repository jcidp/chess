# frozen_string_literal: true

# Represents a King piece
class King
  attr_accessor :unmoved
  attr_reader :code, :color, :type

  def valid_move?(from, to)
    row_abs_diff = (to[0] - from[0]).abs
    col_abs_diff = (to[1] - from[1]).abs
    row_abs_diff.between?(0, 1) && col_abs_diff.between?(0, 1)
  end

  def path(*)
    []
  end

  private

  attr_writer :code, :color, :type

  def initialize(color)
    self.color = color
    self.type = "king"
    self.code = color == "white" ? "\u2654" : "\u265A"
  end
end
