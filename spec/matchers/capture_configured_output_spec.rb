# frozen_string_literal: true

RSpec.describe CaptureConfiguredOutput do
  describe ".name" do
    it "returns the name of the matcher" do
      expect(described_class.name).to eq("configured output")
    end
  end

  describe ".capture" do
    it "captures the output of a block" do
      output =
        described_class.capture(-> { Baes::Configuration.output.puts("foo") })

      expect(output).to eq("foo\n")
    end

    it "does not modify the original output stream" do
      described_class.capture(-> { Baes::Configuration.output.puts("foo") })

      expect(Baes::Configuration.output.string).to be_empty
    end

    it "restores the original output stream when an error occurs" do
      begin
        described_class.capture(-> { raise StandardError, "error" })
      rescue StandardError
        # noop
      end

      expect(Baes::Configuration.output.string).to be_empty
    end
  end
end
