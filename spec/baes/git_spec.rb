# frozen_string_literal: true

RSpec.describe Baes::Git do
  include Baes::Configuration::Helpers

  def stub3(command, stdout: "", stderr: "", success: true)
    status = instance_double(Process::Status, success?: success)
    result = [stdout, stderr, status]
    expect(Open3).to receive(:capture3).with(command).and_return(result)
  end

  def run_and_rescue
    yield
  rescue StandardError
    nil
  end

  describe ".checkout" do
    it "prints stdout" do
      stub3("git checkout my_branch", stdout: "out")

      described_class.checkout("my_branch")

      expect(output.string).to eq("out\n")
    end

    context "when command is not successful" do
      it "prints stdout and stderr" do
        stub3("git checkout my_branch", stderr: "error", success: false)

        run_and_rescue { described_class.checkout("my_branch") }

        expect(output.string).to eq("error\n")
      end

      it "raises an error" do
        stub3("git checkout my_branch", success: false)

        expect { described_class.checkout("my_branch") }
          .to raise_error("failed to run 'git checkout my_branch'")
      end
    end
  end

  describe ".rebase" do
    it "prints stdout" do
      stub3("git rebase my_branch", stdout: "out")

      described_class.rebase("my_branch")

      expect(output.string).to eq("out\n")
    end

    it "prints stderr when present" do
      stub3("git rebase my_branch", stdout: "out", stderr: "error")

      described_class.rebase("my_branch")

      expect(output.string).to eq("out\nerror\n")
    end

    it "returns the status" do
      stub3("git rebase my_branch", success: false)

      result = described_class.rebase("my_branch")

      expect(result).not_to be_success
    end
  end

  describe ".current_branch_name" do
    context "when command is not successful" do
      it "prints stderr" do
        command = "git rev-parse --abbrev-ref HEAD"
        stub3(command, stderr: "error", success: false)

        run_and_rescue { described_class.current_branch_name }

        expect(output.string).to eq("error\n")
      end

      it "raises an error" do
        stub3("git rev-parse --abbrev-ref HEAD", success: false)

        expect { described_class.current_branch_name }
          .to raise_error("failed to run 'git rev-parse --abbrev-ref HEAD'")
      end
    end

    it "returns the current branch name from stdout" do
      stub3("git rev-parse --abbrev-ref HEAD", stdout: "main")

      result = described_class.current_branch_name

      expect(result).to eq("main")
    end
  end

  describe ".branch_names" do
    context "when command is not successful" do
      it "prints stderr" do
        stub3("git branch", stderr: "error", success: false)

        run_and_rescue { described_class.branch_names }

        expect(output.string).to eq("error\n")
      end

      it "raises an error when status is not success" do
        stub3("git branch", success: false)

        expect { described_class.branch_names }
          .to raise_error("failed to run 'git branch'")
      end
    end

    it "returns the list of branches from stdout" do
      stub3("git branch", stdout: "* main\n  branch_1\n  branch_2")

      result = described_class.branch_names

      expect(result).to eq(["main", "branch_1", "branch_2"])
    end
  end

  describe ".rebase_skip" do
    it "prints stdout" do
      stub3("git rebase --skip", stdout: "out")

      described_class.rebase_skip

      expect(output.string).to eq("out\n")
    end

    it "prints stderr when present" do
      stub3("git rebase --skip", stdout: "out", stderr: "error")

      described_class.rebase_skip

      expect(output.string).to eq("out\nerror\n")
    end

    it "returns the status" do
      stub3("git rebase --skip", success: false)

      result = described_class.rebase_skip

      expect(result).not_to be_success
    end
  end

  describe ".next_rebase_step" do
    it "returns the contents of the next rebase file when rebase-apply" do
      path = "./.git/rebase-apply"
      expect(Dir).to receive(:exist?).with(path).and_return(true)
      expect(File).to receive(:read).with("#{path}/next").and_return("42\n")

      expect(described_class.next_rebase_step).to eq(42)
    end

    it "returns the contents of the next rebase file when rebase-merge" do
      apply_path = "./.git/rebase-apply"
      path = "./.git/rebase-merge/msgnum"
      expect(Dir).to receive(:exist?).with(apply_path).and_return(false)
      expect(File).to receive(:read).with(path).and_return("42\n")

      expect(described_class.next_rebase_step).to eq(42)
    end
  end

  describe ".remote_prune" do
    it "prints stdout" do
      stub3("git remote prune origin", stdout: "out")

      described_class.remote_prune("origin")

      expect(output.string).to eq("pruning remote branches for origin\nout\n")
    end

    it "does not print stdout when empty" do
      stub3("git remote prune origin", stdout: "")

      described_class.remote_prune("origin")

      expect(output.string).to eq("pruning remote branches for origin\n")
    end
  end

  describe ".gc" do
    it "prints stdout" do
      stub3("git gc --prune=now", stdout: "out")

      described_class.gc

      expect(output.string).to eq("garbage collecting\nout\n")
    end

    it "does not print stdout when empty" do
      stub3("git gc --prune=now", stdout: "")

      described_class.gc

      expect(output.string).to eq("garbage collecting\n")
    end
  end

  describe ".delete_branches" do
    it "prints stdout" do
      stub3("git branch -d branch1 branch2", stdout: "out")

      described_class.delete_branches(["branch1", "branch2"])

      expect(output.string).to eq("deleting branches: branch1, branch2\nout\n")
    end

    it "returns early when branch_names is empty" do
      expect(Open3).not_to receive(:capture3)

      described_class.delete_branches([])
    end
  end

  describe ".last_rebase_step" do
    it "returns the contents of the last rebase file when rebase-apply" do
      path = "./.git/rebase-apply"
      expect(Dir).to receive(:exist?).with(path).and_return(true)
      expect(File).to receive(:read).with("#{path}/last").and_return("51\n")

      expect(described_class.last_rebase_step).to eq(51)
    end

    it "returns the contents of the last rebase file when rebase-merge" do
      apply_path = "./.git/rebase-apply"
      path = "./.git/rebase-merge/end"
      expect(Dir).to receive(:exist?).with(apply_path).and_return(false)
      expect(File).to receive(:read).with(path).and_return("51\n")

      expect(described_class.last_rebase_step).to eq(51)
    end
  end
end
