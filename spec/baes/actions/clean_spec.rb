# frozen_string_literal: true

RSpec.describe Baes::Actions::Clean do
  describe "#call" do
    it "calls git maintenance" do
      FakeGit.branch_names = ["main", "my_branch"]

      described_class.call

      expect(FakeGit.maintenance_called).to be(true)
    end
  end
end
