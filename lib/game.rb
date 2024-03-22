# frozen_string_literal: true

require "yaml"
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
      return save_game if from == "save"
      return load_game if from == "load"

      valid = board.move(current_player, from, to)
    end
    board.display
    board.promote(promote_input, current_player) if board.promote_square
    next_player
    board.game_over?(current_player)
  end

  def player_input
    input = ""
    until /^[a-h][1-8] [a-h][1-8]$/.match(input) || ["O-O", "O-O-O", "save", "load"].include?(input)
      puts "Enter a valid move in format: a1 h8. Use O-O & O-O-O for castling."
      input = gets.chomp
    end
    input
  end

  def clean_move(move)
    return [move, nil] if ["O-O", "O-O-O", "save", "load"].include?(move)

    move.split(" ").map do |e|
      e.split("").each_with_index.map { |char, i| i.zero? ? char.ord - 97 : char.to_i - 1 }.reverse
    end
  end

  def promote_input
    input = ""
    until %w[q Q n N r R b B].include?(input)
      puts "You can promote your pawn!\nEnter the letter of the piece you want to promote your pawn to:\n
        q: Queen\nr: Rook\nb: Bishop\nn: Knight"
      input = gets.chomp
    end
    input
  end

  def next_player
    self.current_player = current_player == "white" ? "black" : "white"
  end

  def end_game(winner)
    return puts "Game saved" if winner == "save"

    puts winner == "tie" ? "It's a stalemate!" : "Checkmate!\n#{winner} won!"
  end

  def save_game
    File.open("my_save.yaml", "w") do |f|
      f.puts serialize
    end
    board.winner = "save"
  end

  def serialize
    {
      board: board.to_hash,
      current_player: current_player
    }.to_yaml
  end

  def load_game
    f = File.open("my_save.yaml")
    hash = YAML.safe_load(f, permitted_classes: [Symbol])
    board.load_board(hash[:board])
    self.current_player = hash[:current_player]
    board.display
  end
end

game = Game.new
game.play_game
