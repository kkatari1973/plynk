
require "rails_helper"

RSpec.describe User, type: :model do
  describe "#accepted_friends" do
    let!(:alice) { create(:user, name: "Alice") }
    let!(:bob) { create(:user, name: "Bob") }
    let!(:charlie) { create(:user, name: "Charlie") }
    let!(:david) { create(:user, name: "David") }

    before do
      # Accepted friendship
      create(
        :friendship,
        user: alice,
        friend: bob,
        status: "accepted"
      )

      # Pending friendship
      create(
        :friendship,
        user: alice,
        friend: charlie,
        status: "pending"
      )
    end

    it "includes accepted friends" do
      expect(alice.accepted_friends).to include(bob)
    end

    it "excludes pending friends" do
      expect(alice.accepted_friends).not_to include(charlie)
    end

    it "excludes users with no friendship" do
      expect(alice.accepted_friends).not_to include(david)
    end

    it "does not include the user themselves" do
      expect(alice.accepted_friends).not_to include(alice)
    end

    it "does not include duplicate friends" do
      expect(alice.accepted_friends.to_a.uniq)
        .to eq(alice.accepted_friends.to_a)
    end
  end
end
