require 'open3'
require 'English'

module Baes::Git
  def self.checkout(branch_name)
    print `git checkout #{branch_name}`

    raise "failed to rebase on #{branch_name}" if !$CHILD_STATUS.success?
  end

  def self.rebase(branch_name)
    stdout, stderr, status = Open3.capture3("git rebase #{branch_name}")

    puts stdout
    puts stderr unless stderr.empty?

    status
  end

  def self.branch_names
    result = `git branch`

    raise "failed to get branches" if !$CHILD_STATUS.success?

    result.lines.map { |line| line.sub(/^\*/, '').strip }
  end

  def self.rebase_skip
    print `git rebase --skip`

    $CHILD_STATUS
  end

  def self.next_rebase_step
    File.read('./.git/rebase-apply/next').strip
  end

  def self.last_rebase_step
    File.read('./.git/rebase-apply/last').strip
  end

end
