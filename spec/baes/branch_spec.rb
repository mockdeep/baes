# frozen_string_literal: true

RSpec.describe Baes::Branch do
  include Baes::Configuration::Helpers

  describe "#rebase" do
    it "rebases on the other branch" do
      branch = described_class.new("my_branch")
      other_branch = described_class.new("other_branch")

      expect { branch.rebase(other_branch) }
        .to rebase("my_branch").on("other_branch")
    end

    context "when rebase is not successful" do
      it "continues the skip up to the last commit when auto skip" do
        branch = described_class.new("my_branch")
        other_branch = described_class.new("other_branch")
        FakeGit.rebases_successful = [false, false, true]
        Baes::Configuration.auto_skip = true
        input.puts("y\n")
        input.rewind

        expect { branch.rebase(other_branch) }
          .to rebase("my_branch").on("other_branch")
      end

      it "aborts when the user enters anything else" do
        branch = described_class.new("my_branch")
        other_branch = described_class.new("other_branch")
        FakeGit.rebases_successful = [false, false, true]
        input.puts("boohoo\n")
        input.rewind

        message =
          "failed to rebase, please resolve manually and then re-run baes"
        expect { branch.rebase(other_branch) }
          .to raise_error(SystemExit, message)
      end
    end
  end
end
