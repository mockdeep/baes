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

  def self.checkout(branch_name)
    self.current_branch_name = branch_name
  end

  def self.rebase(base_branch_name)
    rebases << [current_branch_name, base_branch_name]

    success = rebases_successful.any? ? rebases_successful.shift : true
    FakeStatus.new(success: success)
  end

  def self.branch_names
    @branch_names
  end

  def self.rebase_skip
    FakeStatus.new(success: rebases_successful.shift)
  end

  def self.next_rebase_step; end

  def self.last_rebase_step; end

  ### TEST METHODS ###

  def self.rebases
    @rebases
  end

  def self.current_branch_name=(branch_name)
    @current_branch_name = branch_name
  end

  def self.current_branch_name
    @current_branch_name
  end

  def self.branch_names=(branch_names)
    @branch_names = branch_names
  end

  def self.rebases_successful
    @rebases_successful
  end

  def self.rebases_successful=(rebases_successful)
    @rebases_successful = rebases_successful
  end

  def self.reset
    @branch_names = ""
    @current_branch_name = nil
    @rebases = []
    @rebases_successful = []
  end
end

RSpec.configure do |config|
  config.before do
    Baes::Configuration.git = FakeGit
    FakeGit.reset
  end
end
