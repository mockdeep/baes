# frozen_string_literal: true

RSpec.describe Baes::Actions::Run do
  def stub3(command, stdout: "", stderr: "", success: true)
    status = instance_double(Process::Status, success?: success)
    result = [stdout, stderr, status]
    expect(Open3).to receive(:capture3).with(command).and_return(result)
  end

  describe ".call" do
    it "loads configuration" do
      expect { described_class.call(["-h"]) }
        .to raise_error(SystemExit)
        .and output(/prints this help/).to_configured_output
    end

    it "displays help when no arguments are given" do
      expect { described_class.call([]) }
        .to raise_error(SystemExit)
        .and output(/prints this help/).to_configured_output
    end

    it "bisects when given the bisect command" do
      FakeGit.branch_names = ["main", "my_branch_1"]
      FakeGit.current_branch_name = "my_branch_1"
      stub3("foo", success: false)

      described_class.call(["bisect", "foo"])

      expect(FakeGit.current_branch_name).to eq("my_branch_1")
    end

    it "rebases branches when given the rebase command" do
      FakeGit.branch_names = ["main", "my_branch"]

      described_class.call(["rebase"])

      expect(FakeGit.rebases).to eq([["my_branch", "main"]])
    end

    it "cleans when given the clean command" do
      FakeGit.branch_names = ["main", "my_branch"]

      described_class.call(["clean"])

      expect(FakeGit.gc_called).to be(true)
    end

    it "raises an error when given an invalid command" do
      expect { described_class.call(["foo"]) }
        .to raise_error(SystemExit)
        .and output("Invalid command [\"foo\"]\n").to_stderr
    end
  end
end
