# frozen_string_literal: true

require "./lib/piece/knight"

describe Knight do
  subject(:test_knight) { described_class.new("white") }

  describe "#adjacent_squares" do
    context "when near a corner" do
      it "returns only valid squares" do
        square = [1, 1]
        result = test_knight.adjacent_squares(square)
        expect(result).to eql({ [3, 2] => [], [2, 3] => [], [0, 3] => [], [3, 0] => [] })
      end
    end

    context "when at the center" do
      it "returns only valid squares" do
        square = [4, 4]
        result = test_knight.adjacent_squares(square)
        expect(result).to eql({ [6, 5] => [], [5, 6] => [], [3, 6] => [], [2, 5] => [], [2, 3] => [], [3, 2] => [],
                                [5, 2] => [], [6, 3] => [] })
      end
    end
  end
end
