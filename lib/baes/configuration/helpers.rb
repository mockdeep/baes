# frozen_string_literal: true

# helper methods for accessing configuration
module Baes::Configuration::Helpers
  # return the configured git wrapper
  def git
    Baes::Configuration.git
  end

  # return the configured input
  def input
    Baes::Configuration.input
  end

  # return the configured output
  def output
    Baes::Configuration.output
  end

  # return the configured root name if given
  def root_name
    Baes::Configuration.root_name
  end

  # return the configured ignored branch names
  def ignored_branch_names
    Baes::Configuration.ignored_branch_names
  end

  # return whether dry run has been enabled
  def dry_run?
    Baes::Configuration.dry_run?
  end
end
