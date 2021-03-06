# frozen_string_literal: true

RSpec.describe Baes::Configuration do
  include Baes::Configuration

  describe "#load_options" do
    it "displays the help and exits when given -h" do
      expect { load_options(["-h"]) }
        .to raise_error(SystemExit)

      expect(output.string).to include("prints this help")
    end

    it "enables auto_skip given --auto-skip" do
      load_options(["--auto-skip"])

      expect(Baes::Configuration.auto_skip?).to be(true)
    end
  end
end
