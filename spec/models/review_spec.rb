
require "rails_helper"

RSpec.describe Review, type: :model do
  describe ".visible_to" do
    let!(:alice) { create(:user, name: "Alice") }
    let!(:bob) { create(:user, name: "Bob") }
    let!(:charlie) { create(:user, name: "Charlie") }
    let!(:david) { create(:user, name: "David") }
    let!(:eve) { create(:user, name: "Eve") }
    let!(:frank) { create(:user, name: "Frank") }

    let!(:item) { create(:item) }

    before do
      # Alice initiated an accepted friendship with Bob.
      create(
        :friendship,
        user: alice,
        friend: bob,
        status: "accepted"
      )

      # Charlie initiated an accepted friendship with Alice.
      create(
        :friendship,
        user: charlie,
        friend: alice,
        status: "accepted"
      )

      # Alice sent David a pending request.
      create(
        :friendship,
        user: alice,
        friend: david,
        status: "pending"
      )

      # Eve sent Alice a pending request.
      create(
        :friendship,
        user: eve,
        friend: alice,
        status: "pending"
      )

      # Alice and Frank have a declined friendship.
      create(
        :friendship,
        user: alice,
        friend: frank,
        status: "declined"
      )
    end

    let!(:alice_review) do
      create(:review, user: alice, item: item,
             body: "Alice's review")
    end

    let!(:bob_review) do
      create(:review, user: bob, item: item,
             body: "Bob's review")
    end

    let!(:charlie_review) do
      create(:review, user: charlie, item: item,
             body: "Charlie's review")
    end

    let!(:david_review) do
      create(:review, user: david, item: item,
             body: "David's review")
    end

    let!(:eve_review) do
      create(:review, user: eve, item: item,
             body: "Eve's review")
    end

    let!(:frank_review) do
      create(:review, user: frank, item: item,
             body: "Frank's review")
    end

    subject(:visible_reviews) do
      described_class.visible_to(alice)
    end

    it "includes the user's own reviews" do
      expect(visible_reviews).to include(alice_review)
    end

    it "includes reviews from accepted friends initiated by the user" do
      expect(visible_reviews).to include(bob_review)
    end

    it "includes reviews from accepted friends who initiated the request" do
      expect(visible_reviews).to include(charlie_review)
    end

    it "excludes reviews from outgoing pending requests" do
      expect(visible_reviews).not_to include(david_review)
    end

    it "excludes reviews from incoming pending requests" do
      expect(visible_reviews).not_to include(eve_review)
    end

    it "excludes reviews from declined friendships" do
      expect(visible_reviews).not_to include(frank_review)
    end

    it "does not return duplicate reviews" do
      expect(visible_reviews.count).to eq(
        visible_reviews.distinct.count
      )
    end
  end
end
