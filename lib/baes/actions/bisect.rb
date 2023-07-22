# frozen_string_literal: true

# class that will attempt to locate the first branch in the current chain that
# fails with a given command
module Baes::Actions::Bisect
  class << self
    include Baes::Configuration::Helpers

    # run the command and return the first branch that fails
    def call(command_args)
      output.puts("searching for branch that fails command: `#{command_args}`")
      branches = generate_branches
      root_branch = find_root_branch(branches)
      Baes::Actions::BuildTree.call(branches, root_branch: root_branch)

      current_branch_name = git.current_branch_name
      current_branch =
        branches.find { |branch| branch.name == current_branch_name }

      _, _, status = Open3.capture3(command_args)

      if status.success?
        raise ArgumentError, "command must fail to find failure"
      end

      fail_branch =
        find_failing_branch(root_branch, current_branch, command_args)

      git.checkout(fail_branch.name)
      output.puts("first failing branch: #{fail_branch.name}")
    end

    private

    def generate_branches
      git.branch_names.map do |branch_name|
        Baes::Branch.new(branch_name)
      end
    end

    def find_root_branch(branches)
      if root_name
        branches.find { |branch| branch.name == root_name }
      else
        branches.find { |branch| ["main", "master"].include?(branch.name) }
      end
    end

    def find_failing_branch(success_branch, fail_branch, command_args)
      next_branch = find_middle_branch(success_branch, fail_branch)

      return fail_branch if next_branch == fail_branch || next_branch.nil?

      git.checkout(next_branch.name)
      _, _, status = Open3.capture3(command_args)

      if status.success?
        output.puts("branch #{next_branch.name} succeeded with command `#{command_args}`")
        find_failing_branch(next_branch, fail_branch, command_args)
      else
        output.puts("branch #{next_branch.name} failed with command `#{command_args}`")
        find_failing_branch(success_branch, next_branch, command_args)
      end
    end

    def find_middle_branch(success_branch, fail_branch)
      end_number = fail_branch.number
      start_number = success_branch.number

      child_branch =
        success_branch.children.find do |next_child_branch|
          next_child_branch.base_name == fail_branch.base_name
        end

      start_number ||= child_branch.number

      middle_number = (start_number + end_number) / 2

      next_branch = child_branch

      while next_branch.number < middle_number
        next_branch =
          next_branch.children.find do |next_child_branch|
            next_child_branch.base_name == fail_branch.base_name
          end
      end

      next_branch
    end
  end
end
