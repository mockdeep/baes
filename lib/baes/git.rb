# frozen_string_literal: true

require "open3"
require "English"

module Baes::Git
  extend Baes::Configuration

  def self.checkout(branch_name)
    stdout, stderr, status = Open3.capture3("git checkout #{branch_name}")

    output.puts(stdout)
    output.puts(stderr) unless stderr.empty?

    raise "failed to rebase on '#{branch_name}'" unless status.success?
  end

  def self.rebase(branch_name)
    stdout, stderr, status = Open3.capture3("git rebase #{branch_name}")

    output.puts(stdout)
    output.puts(stderr) unless stderr.empty?

    status
  end

  def self.branch_names
    stdout, stderr, status = Open3.capture3("git branch")

    output.puts(stderr) unless stderr.empty?

    raise "failed to get branches" unless status.success?

    stdout.lines.map { |line| line.sub(/^\*/, "").strip }
  end

  def self.rebase_skip
    stdout, stderr, status = Open3.capture3("git rebase --skip")

    output.puts(stdout)
    output.puts(stderr) unless stderr.empty?

    status
  end

  def self.next_rebase_step
    File.read("./.git/rebase-apply/next").strip
  end

  def self.last_rebase_step
    File.read("./.git/rebase-apply/last").strip
  end
end
