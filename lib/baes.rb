# frozen_string_literal: true

module Baes
  class Error < StandardError; end
  # Your code goes here...
end

require_relative "baes/branch"
require_relative "baes/rebaser"
require_relative "baes/tree_builder"
require_relative "baes/version"
