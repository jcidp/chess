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
    return false unless legal_move?(piece, target, from, to) # See what makes sense to return here

    piece.unmoved = false if piece.unmoved
    # In game logic, check if piece is pawn and if row is the other side to ask user promote input
    change_square(from, nil)
    change_square(to, piece)
    update_en_passant(piece, from, to)
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

  attr_accessor :board, :en_passant

  def initialize
    reset
    self.en_passant = { color: nil, square: nil }
  end

  def legal_move?(piece, target, from, to)
    valid_move?(piece, target) && piece.valid_move?(from, to) && clear_path?(piece.path(from, to)) ||
      piece.type == "pawn" && valid_pawn_take?(piece, target, to) && piece.valid_take?(from, to)
  end

  def valid_move?(piece, target)
    return false if piece.nil?

    target.nil? || piece.color != target.color
  end

  def valid_pawn_take?(piece, target, to)
    if to == en_passant[:square] && en_passant[:color] != piece.color
      take_en_passant(piece.color, to)
      return true
    end
    !target.nil? && target.color != piece.color
  end

  def change_square(square, value)
    board[square[0]][square[1]] = value
  end

  def clear_path?(path)
    path.all? { |square| board[square[0]][square[1]].nil? }
  end

  def update_en_passant(piece, from, to)
    row_diff = to[0] - from[0]
    return self.en_passant = { color: nil, square: nil } unless row_diff.abs == 2 && piece.type == "pawn"

    sign = row_diff.positive? ? :+ : :-
    square = [from[0].send(sign, 1), from[1]]
    self.en_passant = { color: piece.color, square: square }
  end

  def take_en_passant(taking_color, to)
    sign = taking_color == "white" ? :- : :+
    taken_row = to[0].send(sign, 1)
    change_square([taken_row, to[1]], nil)
  end
end

board = Board.new
board.display
board.move_piece([6, 2], [4, 2])
board.display
board.move_piece([4, 2], [3, 2])
board.display
board.move_piece([1, 3], [3, 3])
board.display
board.move_piece([1, 2], [2, 3])
board.display
board.move_piece([3, 2], [2, 3])
board.display
