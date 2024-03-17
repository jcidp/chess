# frozen_string_literal: true

# Represents a King piece
class King
  attr_reader :code, :color, :type

  def valid_move?(from, to)
  end

  def path(from, to)
  end

  private

  attr_writer :code, :color, :type

  def initialize(color)
    self.color = color
    self.type = "king"
    self.code = color == "white" ? "\u2654" : "\u265A"
  end
end
