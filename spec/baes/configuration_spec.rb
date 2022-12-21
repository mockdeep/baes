# frozen_string_literal: true

RSpec.describe Baes::Configuration do
  describe ".auto_skip?" do
    it "defaults to false" do
      expect(described_class.auto_skip?).to be(false)
    end
  end
end
