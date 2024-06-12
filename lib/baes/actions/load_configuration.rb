# frozen_string_literal: true

require "optparse"

# callable module to load configuration
module Baes::Actions::LoadConfiguration
  class << self
    # loads options, typically passed via the command line
    def call(options)
      parser = OptionParser.new

      configure_help(parser)

      parser.parse(options)
    end

    private

    def configure_help(parser)
      parser.on("-h", "--help", "prints this help") do
        Baes::Configuration.output.puts(parser)
        exit
      end
    end
  end
end
