# frozen_string_literal: true

RSpec.describe Matchers::Rebase do
  describe "#failure_message" do
    it "returns a message when rebase already existed" do
      matcher = described_class.new("foo_branch").on("bar_branch")
      FakeGit.rebases << ["foo_branch", "bar_branch"]
      message = "branch 'foo_branch' was already rebased on 'bar_branch'"
      matcher.matches?(-> {})

      expect(matcher.failure_message).to eq(message)
    end

    it "returns a message when rebase doesn't exist afterwards" do
      matcher = described_class.new("foo_branch").on("bar_branch")
      message = "branch 'foo_branch' was not rebased on 'bar_branch'"
      matcher.matches?(-> {})

      expect(matcher.failure_message).to eq(message)
    end
  end

  describe "#failure_message_when_negated" do
    it "returns a message" do
      matcher = described_class.new("foo_branch")
      message = "expected not to rebase, but did"

      expect(matcher.failure_message_when_negated).to eq(message)
    end
  end
end
