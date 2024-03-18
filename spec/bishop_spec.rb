# frozen_string_literal: true

require "./lib/piece/bishop"

describe Bishop do
  subject(:test_bishop) { described_class.new("white") }

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

  describe "#adjacent_squares" do
    context "when at a corner" do
      it "returns only valid squares" do
        square = [0, 0]
        result = test_bishop.adjacent_squares(square)
        expect(result).to eql({
                                [1, 1] => [],
                                [2, 2] => [[1, 1]],
                                [3, 3] => [[1, 1], [2, 2]],
                                [4, 4] => [[1, 1], [2, 2], [3, 3]],
                                [5, 5] => [[1, 1], [2, 2], [3, 3], [4, 4]],
                                [6, 6] => [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]],
                                [7, 7] => [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6]]
                              })
      end
    end

    context "when at the center" do
      it "returns only valid squares" do
        square = [4, 3]
        result = test_bishop.adjacent_squares(square)
        expect(result).to eql({
                                [5, 4] => [],
                                [6, 5] => [[5, 4]],
                                [7, 6] => [[5, 4], [6, 5]],
                                [5, 2] => [],
                                [6, 1] => [[5, 2]],
                                [7, 0] => [[5, 2], [6, 1]],
                                [3, 4] => [],
                                [2, 5] => [[3, 4]],
                                [1, 6] => [[3, 4], [2, 5]],
                                [0, 7] => [[3, 4], [2, 5], [1, 6]],
                                [3, 2] => [],
                                [2, 1] => [[3, 2]],
                                [1, 0] => [[3, 2], [2, 1]]
                              })
      end
    end
  end
end
