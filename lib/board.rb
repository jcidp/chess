# frozen_string_literal: true

require "./lib/piece/knight"
require "./lib/piece/bishop"
require "./lib/piece/rook"
require "./lib/piece/queen"
require "./lib/piece/king"
require "./lib/piece/pawn"

# Build and control the board for the game
class Board
  attr_accessor :winner

  def reset
    reset_board
    self.winner = nil
  end

  def move(color, from, to)
    if ["O-O", "O-O-O"].include?(from)
      castle(color, from)
    else
      move_piece(color, from, to)
    end
  end

  # Assumes it receives arrays with 2 digits between 0-7
  def move_piece(color, from, to)
    piece = board.dig(from[0], from[1])
    return false unless piece && piece.color == color && legal_move?(piece, from, to)

    piece.unmoved = false if piece.unmoved
    # In game logic, check if piece is pawn and if row is the other side to ask user promote input
    change_square(board, from, nil)
    change_square(board, to, piece)
    take_en_passant(board, piece.color, to) if to == en_passant[:square] && en_passant[:color] != piece.color
    update_en_passant(piece, from, to)
    true
  end

  def check?(attacked_color)
    board_check?(board, attacked_color)
  end

  def game_over?(attacked_color)
    attacking_color = attacked_color == "white" ? "black" : "white"
    check = check?(attacked_color)
    if check && mate?(attacked_color)
      self.winner = attacking_color
    elsif check
      puts "Check!"
    elsif stalemate?(attacked_color)
      self.winner = "tie"
    end
  end

  def mate?(attacked_color)
    king_square = find_king(board, attacked_color)
    attacker_color = attacked_color == "white" ? "black" : "white"
    attackers = checking_squares(attacker_color, king_square)
    attackers.length.positive? &&
      attackers.any? { |attacker_square| !mate_preventable?(attacked_color, attacker_square, king_square) }
  end

  def stalemate?(playing_color)
    board.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        next if piece.nil? || piece.color != playing_color

        return false if can_move?(piece, [i, j])
      end
    end
    true
  end

  def castle(color, type)
    row = color == "white" ? 0 : 7
    col, king_col, rook_col = type == "O-O" ? [7, 6, 5] : [0, 2, 3] # col, sign = type == "O-O" ? [7, :-] : [0, :+]
    king = board.dig(row, 4)
    rook = board.dig(row, col)
    return false unless valid_castle?(color, row, col, king, rook)

    king.unmoved = false
    rook.unmoved = false
    self.en_passant = { color: nil, square: nil }
    change_square(board, [row, 4], nil)
    change_square(board, [row, col], nil)
    change_square(board, [row, king_col], king)
    change_square(board, [row, rook_col], rook)
  end

  def valid_castle?(color, row, col, king, rook)
    return false unless king&.unmoved && rook&.unmoved && !check?(color)

    sign = col == 7 ? :+ : :-
    ((col - 4).abs - 1).times.all? do |i|
      square_col = 4.send(sign, i + 1)
      square_empty = board.dig(row, square_col).nil?
      if i == 2
        square_empty
      else
        square_empty && !self_check?([row, 4], [row, square_col])
      end
    end
  end

  def promote(square)
    square
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

  def reset_board
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

  def legal_move?(piece, from, to)
    valid_adjacent_squares(board, piece, from).keys.include?(to) && !self_check?(from, to)
  end

  def valid_adjacent_squares(used_board, piece, from)
    valid_squares = clean_adjacent_list(used_board, piece, from)
    return valid_squares.merge(pawn_takes(used_board, piece, from)) if piece.type == "pawn"

    valid_squares
  end

  def clean_adjacent_list(used_board, piece, from)
    piece.adjacent_squares(from).filter do |to, path|
      target = used_board.dig(to[0], to[1])
      (target.nil? || target.color != piece.color) && clear_path?(used_board, path)
    end
  end

  def pawn_takes(used_board, pawn, from)
    sign = pawn.color == "white" ? :+ : :-
    takes = {}
    row = from[0].send(sign, 1)
    %i[+ -].each do |col_symbol|
      col = from[1].send(col_symbol, 1)
      take_option = used_board.dig(row, col) || en_passant[:square]
      take_color = en_passant[:color] || take_option&.color
      takes[[row, col]] = [] if take_option && take_color != pawn.color
    end
    takes
  end

  def board_check?(used_board, attacked_color)
    attacked_king_position = find_king(used_board, attacked_color)
    used_board.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        return true if piece && piece.color != attacked_color &&
                       valid_adjacent_squares(used_board, piece, [i, j]).keys.include?(attacked_king_position)
      end
    end
    false
  end

  def self_check?(from, to)
    fake_board = board_deep_copy
    from_row, from_col = from
    piece = fake_board.dig(from_row, from_col)
    change_square(fake_board, from, nil)
    change_square(fake_board, to, piece)
    board_check?(fake_board, piece.color)
  end

  def change_square(used_board, square, value)
    used_board[square[0]][square[1]] = value
  end

  def clear_path?(used_board, path)
    path.all? { |square| used_board[square[0]][square[1]].nil? }
  end

  def update_en_passant(piece, from, to)
    row_diff = to[0] - from[0]
    return self.en_passant = { color: nil, square: nil } unless row_diff.abs == 2 && piece.type == "pawn"

    sign = row_diff.positive? ? :+ : :-
    square = [from[0].send(sign, 1), from[1]]
    self.en_passant = { color: piece.color, square: square }
  end

  def take_en_passant(used_board, taking_color, to)
    sign = taking_color == "white" ? :- : :+
    taken_row = to[0].send(sign, 1)
    change_square(used_board, [taken_row, to[1]], nil)
  end

  def find_king(used_board, color)
    used_board.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        return [i, j] if piece&.type == "king" && piece&.color == color
      end
    end
  end

  def board_deep_copy
    copy = []
    board.each do |row|
      copy << row.dup
    end
    copy
  end

  def checking_squares(attacker_color, attacked_king_position)
    squares = []
    board.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        next unless piece && piece.color == attacker_color

        from = [i, j]
        moves = valid_adjacent_squares(board, piece, from).keys
        squares << from if moves.include?(attacked_king_position) && !self_check?(from, attacked_king_position)
      end
    end
    squares
  end

  def mate_preventable?(attacked_color, attacker_square, king_square)
    king_row, king_col = king_square
    king = board.dig(king_row, king_col)
    attacker_row, attacker_col = attacker_square
    attacker_path = board.dig(attacker_row, attacker_col).path(attacker_square, king_square)
    can_move?(king, king_square) || can_take?(attacker_square, attacked_color) ||
      can_block?(attacker_path, attacked_color)
  end

  def can_move?(piece, from)
    moves = valid_adjacent_squares(board, piece, from).keys
    moves.any? { |move| !self_check?(from, move) }
  end

  def can_take?(attacker_square, attacked_color)
    board.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        next unless piece && piece.color == attacked_color

        from = [i, j]
        moves = valid_adjacent_squares(board, piece, from).keys
        return true if moves.include?(attacker_square) && !self_check?(from, attacker_square)
      end
    end
    false
  end

  def can_block?(attacker_path, attacked_color)
    board.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        next unless piece && piece.color == attacked_color

        from = [i, j]
        moves = valid_adjacent_squares(board, piece, from).keys
        blocks = moves & attacker_path
        return true if blocks.any? { |move| !self_check?(from, move) }
      end
    end
    false
  end
end

# board = Board.new
# board.display
# board.move_piece([6, 2], [4, 2])
# board.display
# board.move_piece([4, 2], [3, 2])
# board.display
# board.move_piece([1, 3], [3, 3])
# board.display
# board.move_piece([1, 2], [2, 3])
# board.display
# board.move_piece([3, 2], [2, 3])
# board.display
