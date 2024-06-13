# frozen_string_literal: true

RSpec.describe Baes::Actions::BuildTree do
  describe "#call" do
    it "links branches to the root branch" do
      FakeGit.branch_names = ["main", "some_branch"]

      branches = described_class.call

      expect(branches.first.children.map(&:name)).to eq(["some_branch"])
    end

    it "links numbered branches to the previous number" do
      FakeGit.branch_names = ["main", "some_branch_1", "some_branch_2"]

      branches = described_class.call

      expect(branches[1].children.map(&:name)).to eq(["some_branch_2"])
    end

    it "links numbered branches to the root when no previous number" do
      FakeGit.branch_names = ["main", "some_branch_5"]

      branches = described_class.call

      expect(branches.first.children.map(&:name)).to eq(["some_branch_5"])
    end

    it "links numbered branches with leading zeros" do
      FakeGit.branch_names = ["main", "some_branch_09", "some_branch_10"]

      branches = described_class.call

      expect(branches[1].children.map(&:name)).to eq(["some_branch_10"])
    end

    it "links numbered branches when number of digits differs" do
      FakeGit.branch_names = ["main", "some_branch_9", "some_branch_10"]

      branches = described_class.call

      expect(branches[1].children.map(&:name)).to eq(["some_branch_10"])
    end

    it "raises an error when multiple branches have same index" do
      FakeGit.branch_names = ["main", "some_branch_9", "some_branch_09"]
      message = "duplicate branch index [\"some_branch_\", 9]"

      expect { described_class.call }.to raise_error(Baes::Error, message)
    end

    it "prunes ignored branches" do
      Baes::Configuration.ignored_branch_names = ["some_branch_10"]
      FakeGit.branch_names = ["main", "some_branch_9", "some_branch_10"]

      branches = described_class.call

      expect(branches.first.children.map(&:name)).to eq(["some_branch_9"])
      expect(branches[1].children).to be_empty
    end

    it "prunes descendant branches" do
      Baes::Configuration.ignored_branch_names = ["some_branch_9"]
      FakeGit.branch_names = ["main", "some_branch_9", "some_branch_10"]

      branches = described_class.call

      expect(branches.first.children).to be_empty
    end
  end
end
