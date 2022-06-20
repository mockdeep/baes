# frozen_string_literal: true

RSpec.describe Baes::TreeBuilder do
  describe "#call" do
    it "links branches to the root branch" do
      branch1 = Baes::Branch.new("main")
      branch2 = Baes::Branch.new("some_branch")

      described_class.new.call([branch1, branch2], root_name: "main")

      expect(branch1.children).to eq([branch2])
    end

    it "links numbered branches to the previous number" do
      branch1 = Baes::Branch.new("main")
      branch2 = Baes::Branch.new("some_branch_1")
      branch3 = Baes::Branch.new("some_branch_2")

      described_class.new.call([branch1, branch2, branch3], root_name: "main")

      expect(branch2.children).to eq([branch3])
    end

    it "links numbered branches to the root when no previous number" do
      branch1 = Baes::Branch.new("main")
      branch2 = Baes::Branch.new("some_branch_5")

      described_class.new.call([branch1, branch2], root_name: "main")

      expect(branch1.children).to eq([branch2])
    end

    it "links numbered branches with leading zeros" do
      branch1 = Baes::Branch.new("main")
      branch2 = Baes::Branch.new("some_branch_09")
      branch3 = Baes::Branch.new("some_branch_10")

      described_class.new.call([branch1, branch2, branch3], root_name: "main")

      expect(branch2.children).to eq([branch3])
    end
  end
end
