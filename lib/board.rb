# frozen_string_literal: true

require "./lib/piece/knight"
require "./lib/piece/bishop"
require "./lib/piece/rook"
require "./lib/piece/queen"
require "./lib/piece/king"
require "./lib/piece/pawn"

# Build and control the board for the game
class Board
  def reset
    self.board = Array.new(8) do |row|
      case row
      when 0 then [Rook.new("white"), Knight.new("white"), Bishop.new("white"), Queen.new("white"), King.new("white"),
                   Bishop.new("white"), Knight.new("white"), Rook.new("white")]
      when 1 then Array.new(8) { Pawn.new("white") }
      when 6 then Array.new(8) { Pawn.new("black") }
      when 7 then [Rook.new("black"), Knight.new("black"), Bishop.new("black"), Queen.new("black"), King.new("black"),
                   Bishop.new("black"), Knight.new("black"), Rook.new("black")]
      else Array.new(8)
      end
    end
  end

  # Assumes it receives arrays with 2 digits between 0-7
  def move_piece(from, to)
    piece = board.dig(from[0], from[1])
    target = board.dig(to[0], to[1])
    # See what makes sense to return here
    return false unless valid_move?(piece, target) && piece.valid_move?(from, to) && clear_path?(piece.path(from, to))

    change_square(from, nil)
    change_square(to, piece)
  end

  # rubocop:disable Metrics/AbcSize

  def display
    puts "  #{'-' * 33}"
    7.downto(0) do |row|
      puts(8.times.reduce("#{row + 1} |") do |str, col|
        square = board.dig(row, col)
        "#{str} #{square ? square.code.encode('utf-8') : ' '} |"
      end)
      puts "  |#{'---|' * 8}" unless row.zero?
    end
    puts "  #{'-' * 33}"
    puts(8.times.reduce("   ") { |str, col| "#{str} #{(col + 97).chr}  " })
  end

  # rubocop:enable Metrics/AbcSize

  private

  attr_accessor :board

  def initialize
    reset
  end

  def valid_move?(piece, target)
    return false if piece.nil?

    target.nil? || piece.color != target.color
  end

  def change_square(square, value)
    board[square[0]][square[1]] = value
  end

  def clear_path?(path)
    path.all? { |square| board[square[0]][square[1]].nil? }
  end
end

board = Board.new
board.display
board.move_piece([0, 1], [2, 2])
board.display
board.move_piece([0, 6], [2, 7])
board.move_piece([2, 7], [3, 5])
board.display
board.move_piece([2, 2], [4, 3])
board.move_piece([7, 6], [5, 5])
board.display
board.move_piece([4, 3], [3, 5])
board.move_piece([4, 3], [4, 4])
board.display
board.move_piece([4, 3], [5, 5])
board.display
board.move_piece([0, 2], [1, 3])
board.move_piece([0, 2], [5, 7])
board.display
board.move_piece([7, 5], [5, 7])
board.display
