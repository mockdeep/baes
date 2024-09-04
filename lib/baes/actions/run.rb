# frozen_string_literal: true

# top-level class to parse options and run the command
module Baes::Actions::Run
  class << self
    # parse options and execute command
    def call(options)
      case options.first
      when "bisect"
        Baes::Actions::Bisect.call(options[1..].join(" "))
      when "rebase"
        Baes::Actions::LoadRebaseConfiguration.call(options)

        Baes::Actions::Rebase.call
      when nil
        Baes::Actions::LoadConfiguration.call(["-h"])
      when /^-/
        Baes::Actions::LoadConfiguration.call(options)
      else
        abort("Invalid command #{options.inspect}")
      end
    end
  end
end
