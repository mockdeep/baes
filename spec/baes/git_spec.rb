# frozen_string_literal: true

RSpec.describe Baes::Git do
  include Baes::Configuration

  def stub3(command, stdout: "", stderr: "", success: true)
    status = instance_double(Process::Status, success?: success)
    result = [stdout, stderr, status]
    expect(Open3).to receive(:capture3).with(command).and_return(result)
  end

  describe "#checkout" do
    it "prints stdout" do
      stub3("git checkout my_branch", stdout: "out")

      described_class.checkout("my_branch")

      expect(output.string).to eq("out\n")
    end

    it "prints stderr when present" do
      stub3("git checkout my_branch", stdout: "out", stderr: "error")

      described_class.checkout("my_branch")

      expect(output.string).to eq("out\nerror\n")
    end

    it "raises an error when command is not successful" do
      stub3("git checkout my_branch", success: false)

      expect { described_class.checkout("my_branch") }
        .to raise_error("failed to rebase on 'my_branch'")
    end
  end

  describe "#rebase" do
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

  describe "#branch_names" do
    it "prints stderr when present" do
      stub3("git branch", stdout: "out", stderr: "error")

      described_class.branch_names

      expect(output.string).to eq("error\n")
    end

    it "raises an error when status is not success" do
      stub3("git branch", success: false)

      expect { described_class.branch_names }
        .to raise_error("failed to get branches")
    end

    it "returns the list of branches from stdout" do
      stub3("git branch", stdout: "* main\n  branch_1\n  branch_2")

      result = described_class.branch_names

      expect(result).to eq(["main", "branch_1", "branch_2"])
    end
  end

  describe "#rebase_skip" do
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

  describe "#next_rebase_step" do
    it "returns the contents of the next rebase file" do
      path = "./.git/rebase-apply/next"
      expect(File).to receive(:read).with(path).and_return("42\n")

      expect(described_class.next_rebase_step).to eq(42)
    end
  end

  describe "#last_rebase_step" do
    it "returns the contents of the last rebase file" do
      path = "./.git/rebase-apply/last"
      expect(File).to receive(:read).with(path).and_return("51\n")

      expect(described_class.last_rebase_step).to eq(51)
    end
  end
end
