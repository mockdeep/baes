require 'open3'
require 'English'

module Baes::Git
  def self.checkout(branch_name)
    stdout, stderr, status = Open3.capture3("git checkout #{branch_name}")

    puts stdout
    puts stderr if !stderr.empty?

    raise "failed to rebase on #{branch_name}" if !status.success?
  end

  def self.rebase(branch_name)
    stdout, stderr, status = Open3.capture3("git rebase #{branch_name}")

    puts stdout
    puts stderr if !stderr.empty?

    status
  end

  def self.branch_names
    stdout, stderr, status = Open3.capture3("git branch")

    puts stderr if !stderr.empty?

    raise "failed to get branches" if !status.success?

    stdout.lines.map { |line| line.sub(/^\*/, '').strip }
  end

  def self.rebase_skip
    stdout, stderr, status = Open3.capture3("git rebase --skip")

    puts stdout
    puts stderr if !stderr.empty?

    status
  end

  def self.next_rebase_step
    File.read('./.git/rebase-apply/next').strip
  end

  def self.last_rebase_step
    File.read('./.git/rebase-apply/last').strip
  end

end
