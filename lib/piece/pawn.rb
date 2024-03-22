# frozen_string_literal: true

require_relative "../piece"

# Represents a Pawn piece
class Pawn < Piece
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

  def initialize(color)
    super
    self.type = "pawn"
    self.code = color == "white" ? "\u2659" : "\u265F"
  end
end
