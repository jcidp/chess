# frozen_string_literal: true

# Represents a Queen piece
class Queen
  attr_reader :code, :color, :type

  def valid_move?(from, to)
  end

  def path(from, to)
  end

  private

  attr_writer :code, :color, :type

  def initialize(color)
    self.color = color
    self.type = "queen"
    self.code = color == "white" ? "\u2655" : "\u265B"
  end
end
