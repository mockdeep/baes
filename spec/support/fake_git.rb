# frozen_string_literal: true

class FakeStatus
  attr_accessor :success

  def initialize(success:)
    self.success = success
  end

  def success?
    success
  end
end

module FakeGit
  ### GIT METHODS ###

  class << self
    def checkout(branch_name)
      self.current_branch_name = branch_name
    end

    def rebase(base_branch_name)
      rebases << [current_branch_name, base_branch_name]

      FakeStatus.new(success: next_success)
    end

    def branch_names(*)
      @branch_names ||= []
    end

    def rebase_skip
      FakeStatus.new(success: next_success)
    end

    def next_rebase_step
      rebase_index
    end

    def last_rebase_step
      rebases_successful.length
    end

    ### TEST METHODS ###

    def next_success
      if rebases_successful.any?
        self.rebase_index += 1
        rebases_successful[rebase_index - 1]
      else
        true
      end
    end

    def rebases
      @rebases ||= []
    end

    def rebase_index
      @rebase_index ||= 0
    end

    attr_reader :gc_called
    attr_writer :rebase_index, :branch_names, :rebases_successful
    attr_accessor :current_branch_name

    def rebases_successful
      @rebases_successful ||= []
    end

    def remote_prune(_); end

    def gc
      @gc_called = true
    end

    def delete_branches(branch_names); end

    def reset
      instance_variables.each do |ivar|
        remove_instance_variable(ivar)
      end
    end
  end
end

RSpec.configure do |config|
  config.before do
    Baes::Configuration.git = FakeGit
  end

  config.after do
    FakeGit.reset
  end
end
