# frozen_string_literal: true

require "./lib/piece/bishop"

describe Bishop do
  subject(:test_bishop) { described_class.new("white") }

  describe "#valid_move?" do
    it "returns true from 0,2 to 5,7" do
      from = [0, 2]
      to = [5, 7]
      result = test_bishop.valid_move?(from, to)
      expect(result).to be true
    end

    it "returns true from 7,5 to 6,4" do
      from = [7, 5]
      to = [6, 4]
      result = test_bishop.valid_move?(from, to)
      expect(result).to be true
    end

    it "returns false from 0,1 to 1,1" do
      from = [0, 1]
      to = [1, 1]
      result = test_bishop.valid_move?(from, to)
      expect(result).to be false
    end
  end

  describe "#path" do
    context "when moving from 0,2 to 5,7" do
      it "returns the correct path" do
        from = [0, 2]
        to = [5, 7]
        result = test_bishop.path(from, to)
        expect(result).to eql([[1, 3], [2, 4], [3, 5], [4, 6]])
      end
    end

    context "when moving from 7,5 to 6,4" do
      it "returns an empty path" do
        from = [7, 5]
        to = [6, 4]
        result = test_bishop.path(from, to)
        expect(result).to eql([])
      end
    end

    context "when moving from 7,2 to 4,5" do
      it "returns the correct path" do
        from = [7, 2]
        to = [4, 5]
        result = test_bishop.path(from, to)
        expect(result).to eql([[6, 3], [5, 4]])
      end
    end
  end
end
