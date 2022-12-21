# frozen_string_literal: true

RSpec.describe Baes::Actions::LoadConfiguration, "#call" do
  it "displays the help and exits when given -h" do
    expect { described_class.call(["-h"]) }
      .to raise_error(SystemExit)

    expect(Baes::Configuration.output.string).to include("prints this help")
  end

  it "enables auto_skip given --auto-skip" do
    described_class.call(["--auto-skip"])

    expect(Baes::Configuration.auto_skip?).to be(true)
  end

  it "configures ignored branches given --ignore" do
    described_class.call(["--ignore", "branch_a,branch_b"])

    expected_branches = ["branch_a", "branch_b"]
    expect(Baes::Configuration.ignored_branch_names).to eq(expected_branches)
  end
end
