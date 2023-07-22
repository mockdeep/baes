# frozen_string_literal: true

RSpec.describe Baes::Actions::Bisect do
  include Baes::Configuration::Helpers

  def stub3(command, stdout: "", stderr: "", success: true)
    status = instance_double(Process::Status, success?: success)
    result = [stdout, stderr, status]
    expect(Open3).to receive(:capture3).with(command).and_return(result)
  end

  it "raises an error when command does not fail" do
    FakeGit.branch_names = ["main", "my_branch_1", "my_branch_2"]
    stub3(["echo 'foo'"])

    expect { described_class.call(["echo 'foo'"]) }
      .to raise_error(ArgumentError, "command must fail to find failure")
  end

  it "checks out the first failing branch" do
    FakeGit.branch_names = ["main", "my_branch_1", "my_branch_2"]
    FakeGit.current_branch_name = "my_branch_2"
    stub3(["echo 'foo'"], success: false)
    stub3(["echo 'foo'"], success: false)

    described_class.call(["echo 'foo'"])

    expect(FakeGit.current_branch_name).to eq("my_branch_1")
  end

  it "prints the first failing branch" do
    FakeGit.branch_names = ["main", "my_branch_1", "my_branch_2"]
    FakeGit.current_branch_name = "my_branch_2"
    stub3(["echo 'foo'"], success: false)
    stub3(["echo 'foo'"], success: false)

    described_class.call(["echo 'foo'"])

    expect(output.string).to include("first failing branch: my_branch_1\n")
  end

  it "uses the configured root branch" do
    FakeGit.branch_names = ["main", "my_branch_1", "my_branch_2"]
    FakeGit.current_branch_name = "my_branch_2"
    Baes::Configuration.root_name = "main"
    stub3(["echo 'foo'"], success: false)
    stub3(["echo 'foo'"], success: false)

    described_class.call(["echo 'foo'"])
  end

  it "checks out the failed branch" do
    FakeGit.branch_names = ["main", "my_branch_1", "my_branch_2"]
    FakeGit.current_branch_name = "my_branch_2"
    stub3(["echo 'foo'"], success: false)
    stub3(["echo 'foo'"], success: true)

    described_class.call(["echo 'foo'"])

    expect(FakeGit.current_branch_name).to eq("my_branch_2")
  end

  it "jumps forward when current branch is success" do
    FakeGit.branch_names = ["main", "my_branch_1", "my_branch_2", "my_branch_3"]
    FakeGit.current_branch_name = "my_branch_3"
    stub3(["echo 'foo'"], success: false)
    stub3(["echo 'foo'"], success: true)

    described_class.call(["echo 'foo'"])

    expect(FakeGit.current_branch_name).to eq("my_branch_3")
  end
end
