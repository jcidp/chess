# frozen_string_literal: true

require "./lib/piece/rook"

describe Rook do
  subject(:test_rook) { described_class.new("white") }

  describe "#valid_move?" do
    it "returns true from 2,2 to 2,0" do
      from = [2, 2]
      to = [2, 0]
      result = test_rook.valid_move?(from, to)
      expect(result).to be true
    end

    it "returns true from 7,5 to 1,5" do
      from = [7, 5]
      to = [1, 5]
      result = test_rook.valid_move?(from, to)
      expect(result).to be true
    end

    it "returns false from 0,1 to 1,2" do
      from = [0, 1]
      to = [1, 2]
      result = test_rook.valid_move?(from, to)
      expect(result).to be false
    end
  end

  describe "#path" do
    context "when moving from 3,0 to 3,7" do
      it "returns the correct horizontal path" do
        from = [3, 0]
        to = [3, 7]
        result = test_rook.path(from, to)
        expect(result).to eql([[3, 1], [3, 2], [3, 3], [3, 4], [3, 5], [3, 6]])
      end
    end

    context "when moving from 7,5 to 0,5" do
      it "returns the correct vertical path" do
        from = [7, 5]
        to = [0, 5]
        result = test_rook.path(from, to)
        expect(result).to eql([[6, 5], [5, 5], [4, 5], [3, 5], [2, 5], [1, 5]])
      end
    end

    context "when moving from 4,6 to 4,5" do
      it "returns an empty path" do
        from = [4, 6]
        to = [4, 5]
        result = test_rook.path(from, to)
        expect(result).to eql([])
      end
    end
  end
end
