# frozen_string_literal: true

# Represents a Rook piece
class Rook
  attr_reader :code, :color, :type

  def valid_move?(from, to)
  end

  def path(from, to)
  end

  private

  attr_writer :code, :color, :type

  def initialize(color)
    self.color = color
    self.type = "rook"
    self.code = color == "white" ? "\u2656" : "\u265C"
  end
end
