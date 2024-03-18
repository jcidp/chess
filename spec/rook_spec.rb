# frozen_string_literal: true

require "./lib/piece/rook"

describe Rook do
  subject(:test_rook) { described_class.new("white") }

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

  describe "#adjacent_squares" do
    context "when at a corner" do
      it "returns only valid squares" do
        square = [7, 7]
        result = test_rook.adjacent_squares(square)
        expect(result).to eql({
                                [7, 6] => [],
                                [7, 5] => [[7, 6]],
                                [7, 4] => [[7, 6], [7, 5]],
                                [7, 3] => [[7, 6], [7, 5], [7, 4]],
                                [7, 2] => [[7, 6], [7, 5], [7, 4], [7, 3]],
                                [7, 1] => [[7, 6], [7, 5], [7, 4], [7, 3], [7, 2]],
                                [7, 0] => [[7, 6], [7, 5], [7, 4], [7, 3], [7, 2], [7, 1]],
                                [6, 7] => [],
                                [5, 7] => [[6, 7]],
                                [4, 7] => [[6, 7], [5, 7]],
                                [3, 7] => [[6, 7], [5, 7], [4, 7]],
                                [2, 7] => [[6, 7], [5, 7], [4, 7], [3, 7]],
                                [1, 7] => [[6, 7], [5, 7], [4, 7], [3, 7], [2, 7]],
                                [0, 7] => [[6, 7], [5, 7], [4, 7], [3, 7], [2, 7], [1, 7]]
                              })
      end
    end

    context "when at the center" do
      it "returns only valid squares" do
        square = [3, 4]
        result = test_rook.adjacent_squares(square)
        expect(result).to eql({
                                [4, 4] => [],
                                [5, 4] => [[4, 4]],
                                [6, 4] => [[4, 4], [5, 4]],
                                [7, 4] => [[4, 4], [5, 4], [6, 4]],
                                [3, 5] => [],
                                [3, 6] => [[3, 5]],
                                [3, 7] => [[3, 5], [3, 6]],
                                [2, 4] => [],
                                [1, 4] => [[2, 4]],
                                [0, 4] => [[2, 4], [1, 4]],
                                [3, 3] => [],
                                [3, 2] => [[3, 3]],
                                [3, 1] => [[3, 3], [3, 2]],
                                [3, 0] => [[3, 3], [3, 2], [3, 1]]
                              })
      end
    end
  end
end
