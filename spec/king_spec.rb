# frozen_string_literal: true

require "./lib/piece/king"

describe King do
  subject(:test_king) { described_class.new("white") }

  describe "#adjacent_squares" do
    context "when at a corner" do
      it "returns only valid squares" do
        square = [7, 0]
        result = test_king.adjacent_squares(square)
        expect(result).to eql({
                                [7, 1] => [],
                                [6, 1] => [],
                                [6, 0] => []
                              })
      end
    end

    context "when at the center" do
      it "returns only valid squares" do
        square = [4, 3]
        result = test_king.adjacent_squares(square)
        expect(result).to eql({
                                [5, 3] => [],
                                [5, 4] => [],
                                [4, 4] => [],
                                [3, 4] => [],
                                [3, 3] => [],
                                [3, 2] => [],
                                [4, 2] => [],
                                [5, 2] => []
                              })
      end
    end
  end
end
