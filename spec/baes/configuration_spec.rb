# frozen_string_literal: true

RSpec.describe Baes::Configuration do
  describe ".root_name" do
    it "returns the root branch name when set" do
      described_class.root_name = "moon"

      expect(described_class.root_name).to eq("moon")
    end

    it "defaults to 'main' when present" do
      FakeGit.branch_names = ["main", "master"]

      expect(described_class.root_name).to eq("main")
    end

    it "defaults to 'master' when 'main' is not present" do
      FakeGit.branch_names = ["master"]

      expect(described_class.root_name).to eq("master")
    end

    it "raises a GitError when neither 'main' nor 'master' are present" do
      FakeGit.branch_names = ["moon"]

      expect { described_class.root_name }.to raise_error(Baes::Git::GitError)
    end
  end

  describe ".auto_skip?" do
    it "defaults to false" do
      expect(described_class.auto_skip?).to be(false)
    end
  end
end
