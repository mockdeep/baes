# frozen_string_literal: true

# module to encapsulate shell commands
module Baes::Helpers::Commands
  # run command and raise error on failure
  def run_or_raise(command)
    stdout, stderr, status = Open3.capture3(command)

    unless status.success?
      output.puts(stderr)

      raise Baes::Git::GitError, "failed to run '#{command}'"
    end

    stdout.strip
  end

  # run command and return status
  def run_returning_status(command)
    stdout, stderr, status = Open3.capture3(command)

    output.puts(stdout)
    output.puts(stderr) unless stderr.empty?

    status
  end
end
