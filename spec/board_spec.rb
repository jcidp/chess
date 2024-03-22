# frozen_string_literal: true

require "./lib/board"
require "./lib/piece/knight"
require "./lib/piece/bishop"
require "./lib/piece/rook"
require "./lib/piece/queen"
require "./lib/piece/king"
require "./lib/piece/pawn"

describe Board do
  subject(:test_board) { Board.new }
  describe "#reset_board" do
    context "when creating a new board" do
      # TODO
    end
  end

  describe "#move" do
    context "when trying to move an empty space" do
      it "doesn't change the board" do
        from = [2, 5]
        to = [4, 6]
        expect { test_board.move("white", from, to) }.not_to(change { test_board.instance_variable_get(:@board) })
      end
    end

    context "when opening a game" do
      it "a rook can't jump pieces" do
        from = [0, 0]
        to = [2, 0]
        expect { test_board.move("white", from, to) }.not_to(change { test_board.instance_variable_get(:@board) })
      end

      it "a knight can jump pieces" do
        from = [0, 6]
        to = [2, 5]
        expect { test_board.move("white", from, to) }.to(change { test_board.instance_variable_get(:@board) })
      end

      it "a knight can't move to a square occupied an ally" do
        from = [0, 6]
        to = [1, 4]
        expect { test_board.move("white", from, to) }.not_to(change { test_board.instance_variable_get(:@board) })
      end
    end
  end

  describe "#clear_path?" do
    it "returns true on path full of nils" do
      path = [[2, 2], [3, 3], [4, 4]]
      board = test_board.instance_variable_get(:@board)
      result = test_board.send(:clear_path?, board, path)
      expect(result).to be true
    end

    it "returns true on empty path" do
      path = []
      board = test_board.instance_variable_get(:@board)
      result = test_board.send(:clear_path?, board, path)
      expect(result).to be true
    end

    it "returns false on path with piece" do
      path = [[1, 2]]
      board = test_board.instance_variable_get(:@board)
      result = test_board.send(:clear_path?, board, path)
      expect(result).to be false
    end
  end

  describe "#stalemate?" do
    context "when there's a simple stalemate" do
      before do
        fake_board = Array.new(8) { Array.new(8) }
        fake_board[7][7] = King.new("black")
        fake_board[5][7] = King.new("white")
        fake_board[5][6] = Rook.new("white")
        test_board.instance_variable_set(:@board, fake_board)
      end

      it "returns true on black move" do
        result = test_board.send(:stalemate?, "black")
        expect(result).to be true
      end
    end

    context "when the game starts" do
      it "returns false" do
        result = test_board.send(:stalemate?, "white")
        expect(result).to be false
      end
    end
  end

  describe "#mate?" do
    context "when there's a simple checkmate" do
      before do
        fake_board = Array.new(8) { Array.new(8) }
        fake_board[7][7] = King.new("black")
        fake_board[5][7] = King.new("white")
        fake_board[7][4] = Rook.new("white")
        test_board.instance_variable_set(:@board, fake_board)
      end

      it "returns true" do
        result = test_board.send(:mate?, "black")
        expect(result).to be true
      end
    end

    context "when the king can move" do
      before do
        fake_board = Array.new(8) { Array.new(8) }
        fake_board[7][7] = King.new("black")
        fake_board[5][5] = King.new("white")
        fake_board[7][4] = Rook.new("white")
        test_board.instance_variable_set(:@board, fake_board)
      end

      it "returns false" do
        result = test_board.send(:mate?, "black")
        expect(result).to be false
      end
    end

    context "when player can take attacker" do
      before do
        fake_board = Array.new(8) { Array.new(8) }
        fake_board[7][7] = King.new("black")
        fake_board[5][7] = King.new("white")
        fake_board[7][4] = Rook.new("white")
        fake_board[6][2] = Knight.new("black")
        test_board.instance_variable_set(:@board, fake_board)
      end

      it "returns false" do
        result = test_board.send(:mate?, "black")
        expect(result).to be false
      end
    end

    context "when player can block check" do
      before do
        fake_board = Array.new(8) { Array.new(8) }
        fake_board[7][7] = King.new("black")
        fake_board[5][7] = King.new("white")
        fake_board[7][4] = Rook.new("white")
        fake_board[1][0] = Bishop.new("black")
        test_board.instance_variable_set(:@board, fake_board)
      end

      it "returns false" do
        result = test_board.send(:mate?, "black")
        expect(result).to be false
      end
    end

    context "when there's a simple checkmate caused by the unmoved piece of a double check" do
      before do
        fake_board = Array.new(8) { Array.new(8) }
        fake_board[7][7] = King.new("black")
        fake_board[5][7] = King.new("white")
        fake_board[7][4] = Rook.new("white")
        fake_board[6][2] = Knight.new("black")
        fake_board[0][0] = Bishop.new("white")
        test_board.instance_variable_set(:@board, fake_board)
      end

      it "returns true" do
        test_board.display
        result = test_board.send(:mate?, "black")
        expect(result).to be true
      end
    end
  end

  describe "#mate_preventable?" do
    context "when there's a simple checkmate caused by the unmoved piece of a double check" do
      before do
        fake_board = Array.new(8) { Array.new(8) }
        fake_board[7][7] = King.new("black")
        fake_board[5][7] = King.new("white")
        fake_board[7][4] = Rook.new("white")
        fake_board[6][2] = Knight.new("black")
        test_board.instance_variable_set(:@board, fake_board)
      end

      it "returns true" do
        result = test_board.send(:mate_preventable?, "black", [7, 4], [7, 7])
        expect(result).to be true
      end
    end
  end

  describe "#can_take?" do
    context "when attacker is takeable" do
      before do
        fake_board = Array.new(8) { Array.new(8) }
        fake_board[7][7] = King.new("black")
        fake_board[5][7] = King.new("white")
        fake_board[7][4] = Rook.new("white")
        fake_board[6][2] = Knight.new("black")
        test_board.instance_variable_set(:@board, fake_board)
      end

      it "returns true" do
        result = test_board.send(:can_take?, [7, 4], "black")
        expect(result).to be true
      end
    end
  end

  describe "#self_check?" do
    context "when king moves would cause check" do
      before do
        fake_board = Array.new(8) { Array.new(8) }
        fake_board[7][7] = King.new("black")
        fake_board[5][7] = King.new("white")
        fake_board[5][6] = Rook.new("white")
        test_board.instance_variable_set(:@board, fake_board)
      end

      it "king would check itself at 7, 6" do
        from = [7, 7]
        to = [7, 6]
        result = test_board.send(:self_check?, from, to)
        expect(result).to be true
      end

      it "king would check itself at 6, 6" do
        from = [7, 7]
        to = [6, 6]
        result = test_board.send(:self_check?, from, to)
        expect(result).to be true
      end

      it "king would check itself at 6, 7" do
        from = [7, 7]
        to = [6, 7]
        result = test_board.send(:self_check?, from, to)
        expect(result).to be true
      end
    end
  end
end
