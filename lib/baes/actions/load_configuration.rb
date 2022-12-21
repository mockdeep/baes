# frozen_string_literal: true

# callable module to load configuration
module Baes::Actions::LoadConfiguration
  class << self
    # loads options, typically passed via the command line
    def call(options)
      parser = OptionParser.new

      configure_dry_run(parser)
      configure_help(parser)
      configure_root_name(parser)
      configure_auto_skip(parser)
      configure_ignored_branches(parser)

      parser.parse(options)
    end

    private

    def configure_dry_run(parser)
      parser.on("--dry-run", "prints branch chain without rebasing") do
        Baes::Configuration.dry_run = true
      end
    end

    def configure_help(parser)
      parser.on("-h", "--help", "prints this help") do
        Baes::Configuration.output.puts(parser)
        exit
      end
    end

    def configure_root_name(parser)
      message = "specify a root branch to rebase on"
      parser.on("-r", "--root ROOT", message) do |root_name|
        Baes::Configuration.root_name = root_name
      end
    end

    def configure_auto_skip(parser)
      message = "automatically skip all but the most recent commit"
      parser.on("--auto-skip", message) do
        Baes::Configuration.auto_skip = true
      end
    end

    def configure_ignored_branches(parser)
      message = "don't rebase specified branches or their child branches"
      parser.on("--ignore BRANCH1,BRANCH2", Array, message) do |branches|
        Baes::Configuration.ignored_branch_names += branches
      end
    end
  end
end
