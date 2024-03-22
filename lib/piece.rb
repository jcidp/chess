# frozen_string_literal: true

require "yaml"

# A piece with basic functionlity
class Piece
  attr_accessor :unmoved
  attr_reader :code, :color, :type

  def path(*)
    []
  end

  def to_hash
    {
      type: type,
      color: color,
      unmoved: unmoved
    }
  end

  private

  attr_writer :code, :color, :type

  def initialize(color)
    self.color = color
    self.unmoved = true
  end
end
