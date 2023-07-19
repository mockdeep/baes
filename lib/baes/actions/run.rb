# frozen_string_literal: true

# top-level class to parse options and run the command
module Baes::Actions::Run
  # parse options and execute command
  def self.call(options)
    Baes::Actions::LoadConfiguration.call(options)

    Baes::Actions::Rebase.call
  end
end
