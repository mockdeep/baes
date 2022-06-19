# frozen_string_literal: true

module Baes
  class Error < StandardError; end
  # Your code goes here...

  def self.git
    Baes::Git
  end
end

require_relative "baes/branch"
require_relative "baes/git"
require_relative "baes/rebaser"
require_relative "baes/tree_builder"
require_relative "baes/version"
