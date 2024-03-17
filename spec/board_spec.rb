# frozen_string_literal: true

require "./lib/board"

describe Board do
  subject(:test_board) { Board.new }
  describe "#reset_board" do
    context "when creating a new board" do
      # TODO
    end
  end

  describe "#clear_path?" do
    it "returns true on path full of nils" do
      path = [[2, 2], [3, 3], [4, 4]]
      result = test_board.send(:clear_path?, path)
      expect(result).to be true
    end

    it "returns true on empty path" do
      path = []
      result = test_board.send(:clear_path?, path)
      expect(result).to be true
    end

    it "returns false on path with piece" do
      path = [[1, 2]]
      result = test_board.send(:clear_path?, path)
      expect(result).to be false
    end
  end
end
