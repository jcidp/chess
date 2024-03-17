# frozen_string_literal: true

# Build and control the board for the game
class Board
  private

  attr_accessor :board

  def initialize
    reset_board
    show_board
  end

  def reset_board
    self.board = Array.new(8) do |row|
      case row
      when 0 then ["\u2656", "\u2658", "\u2657", "\u2655", "\u2654", "\u2657", "\u2658", "\u2656"]
      when 1 then ["\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659"]
      when 6 then ["\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F"]
      when 7 then ["\u265C", "\u265E", "\u265D", "\u265B", "\u265A", "\u265D", "\u265E", "\u265C"]
      else Array.new(8)
      end
    end
  end

  # rubocop:disable Metrics/AbcSize

  def show_board
    puts "  #{'-' * 33}"
    7.downto(0) do |row|
      puts(8.times.reduce("#{row + 1} |") do |str, col|
        char = board.dig(row, col)
        "#{str} #{char ? char.encode('utf-8') : ' '} |"
      end)
      puts "  |#{'---|' * 8}" unless row.zero?
    end
    puts "  #{'-' * 33}"
    puts(8.times.reduce("   ") { |str, col| "#{str} #{(col + 97).chr}  " })
  end

  # rubocop:enable Metrics/AbcSize
end

Board.new
