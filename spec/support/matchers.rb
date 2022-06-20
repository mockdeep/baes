# frozen_string_literal: true

module Matchers
  def rebase(branch_name)
    Matchers::Rebase.new(branch_name)
  end
end

require_relative "matchers/rebase"
