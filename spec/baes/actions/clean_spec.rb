# frozen_string_literal: true

RSpec.describe Baes::Actions::Clean do
  describe "#call" do
    it "calls git maintenance" do
      FakeGit.branch_names = ["main", "my_branch"]

      described_class.call

      expect(FakeGit.maintenance_called).to be(true)
    end

    it "does not delete branches checked out in other worktrees" do
      FakeGit.branch_names = ["main", "my_branch", "worktree_branch"]
      FakeGit.worktree_branch_names = ["worktree_branch"]

      expect(FakeGit).to receive(:delete_branches).with(["my_branch"])

      described_class.call
    end
  end
end
