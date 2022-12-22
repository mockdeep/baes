# frozen_string_literal: true

RSpec.describe Baes::Actions::Rebase do
  describe "#call" do
    it "rebases branches on main" do
      FakeGit.branch_names = ["main", "my_branch"]

      expect { described_class.call([]) }
        .to rebase("my_branch").on("main")
    end

    it "rebases branches on master" do
      FakeGit.branch_names = ["master", "my_branch"]

      expect { described_class.call([]) }
        .to rebase("my_branch").on("master")
    end

    it "rebases chained branches" do
      FakeGit.branch_names = ["main", "my_branch_1", "my_branch_2"]

      expect { described_class.call([]) }
        .to rebase("my_branch_1").on("main")
        .and(rebase("my_branch_2").on("my_branch_1"))
    end

    context "when --dry-run" do
      it "prints the branch chain" do
        FakeGit.branch_names = ["main", "my_branch_1", "my_branch_2"]
        output = StringIO.new
        Baes::Configuration.output = output

        described_class.call(["--dry-run"])

        expected_output = <<~TEXT
          main
            my_branch_1
              my_branch_2
        TEXT

        expect(output.string).to eq(expected_output)
      end

      it "does not rebase branches" do
        FakeGit.branch_names = ["main", "my_branch_1", "my_branch_2"]

        expect { described_class.call(["--dry-run"]) }
          .not_to(rebase("my_branch_1").on("main"))
      end
    end

    it "uses a given base branch" do
      FakeGit.branch_names = ["staging", "my_branch_1", "my_branch_2"]

      expect { described_class.call(["--root", "staging"]) }
        .to rebase("my_branch_1").on("staging")
        .and(rebase("my_branch_2").on("my_branch_1"))
    end
  end
end
