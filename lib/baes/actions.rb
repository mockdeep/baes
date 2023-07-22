# frozen_string_literal: true

# namespace for callable modules
module Baes::Actions; end

require_relative "actions/bisect"
require_relative "actions/build_tree"
require_relative "actions/load_configuration"
require_relative "actions/load_rebase_configuration"
require_relative "actions/rebase"
require_relative "actions/run"
