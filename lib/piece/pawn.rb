# frozen_string_literal: true

# Represents a Pawn piece
class Pawn
  attr_accessor :unmoved
  attr_reader :code, :color, :type

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
