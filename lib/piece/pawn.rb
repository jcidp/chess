# frozen_string_literal: true

# Represents a Pawn piece
class Pawn
  attr_reader :code, :color, :type

  def valid_move?(from, to)
  end

  def path(from, to)
  end

  private

  attr_writer :code, :color, :type

  def initialize(color)
    self.color = color
    self.type = "pawn"
    self.code = color == "white" ? "\u2659" : "\u265F"
  end
end
