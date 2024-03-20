# frozen_string_literal: true

require "./lib/board"

# Control game logic
class Game
  def play_game
    self.current_player = "white"
    board.reset
    board.display
    play_turn until board.winner
    end_game(board.winner)
  end

  private

  attr_accessor :board, :current_player

  def initialize
    self.board = Board.new
  end

  def play_turn
    puts "#{current_player} to move"
    valid = false
    until valid
      from, to = clean_move(player_input)
      valid = board.move(current_player, from, to)
    end
    board.display
    next_player
    board.game_over?(current_player)
  end

  def player_input
    input = ""
    until /^[a-h][1-8] [a-h][1-8]$/.match(input) || ["O-O", "O-O-O"].include?(input)
      puts "Enter a valid move in format: a1 h8. Use O-O & O-O-O for castling."
      input = gets.chomp
    end
    input
  end

  def clean_move(move)
    return [move, current_player] if ["O-O", "O-O-O"].include?(move)

    move.split(" ").map do |e|
      e.split("").each_with_index.map { |char, i| i.zero? ? char.ord - 97 : char.to_i - 1 }.reverse
    end
  end

  def next_player
    self.current_player = current_player == "white" ? "black" : "white"
  end

  def end_game(winner)
    puts "Checkmate!"
    puts winner == "tie" ? "It's a stalemate!" : "#{winner} won!"
  end
end

game = Game.new
game.play_game
