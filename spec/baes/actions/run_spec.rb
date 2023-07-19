# frozen_string_literal: true

RSpec.describe Baes::Actions::Run do
  describe ".call" do
    it "loads configuration" do
      FakeGit.branch_names = ["main", "my_branch"]
      options = ["--dry-run"]

      described_class.call(options)

      expect(Baes::Configuration.dry_run?).to be(true)
    end

    it "rebases branches" do
      FakeGit.branch_names = ["main", "my_branch"]

      described_class.call([])

      expect(FakeGit.rebases).to eq([["my_branch", "main"]])
    end
  end
end
