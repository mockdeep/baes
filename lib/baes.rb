# frozen_string_literal: true

# namespace for all Baes code
module Baes; end

class Baes::Error < StandardError; end

require_relative "baes/configuration"
require_relative "baes/configuration/helpers"
require_relative "baes/helpers"

require_relative "baes/actions"
require_relative "baes/branch"
require_relative "baes/branch_collection"
require_relative "baes/git"
require_relative "baes/version"
