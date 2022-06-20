# frozen_string_literal: true

class Matchers::Rebase
  include RSpec::Matchers::Composable

  attr_accessor :branch_name, :base_branch_name, :original_rebases, :new_rebases

  def initialize(branch_name)
    self.branch_name = branch_name
  end

  def supports_block_expectations?
    true
  end

  def on(base_branch_name)
    self.base_branch_name = base_branch_name

    self
  end

  def matches?(event_proc)
    perform_change(event_proc)

    !originally_rebased? && newly_rebased?
  end

  def failure_message
    if originally_rebased?
      "branch '#{branch_name}' was already rebased on '#{base_branch_name}'"
    else
      "branch '#{branch_name}' was not rebased on '#{base_branch_name}'"
    end
  end

  def failure_message_when_negated
    "expected not to rebase, but did"
  end

  def perform_change(event_proc)
    self.original_rebases = FakeGit.rebases.dup

    event_proc.()

    self.new_rebases = FakeGit.rebases.dup
  end

  def originally_rebased?
    original_rebases.include?([branch_name, base_branch_name])
  end

  def newly_rebased?
    new_rebases.include?([branch_name, base_branch_name])
  end
end
