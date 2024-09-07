# frozen_string_literal: true

RSpec.describe Baes::Actions::Clean do
  describe "#call" do
    it "calls git gc" do
      FakeGit.branch_names = ["main", "my_branch"]

      described_class.call

      expect(FakeGit.gc_called).to be(true)
    end
  end
end
