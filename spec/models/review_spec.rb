
require "rails_helper"

RSpec.describe Review, type: :model do
  describe ".visible_to" do
    let!(:alice) { create(:user, name: "Alice") }
    let!(:bob) { create(:user, name: "Bob") }
    let!(:charlie) { create(:user, name: "Charlie") }
    let!(:david) { create(:user, name: "David") }

    let!(:item) { create(:item) }

    before do
      # Alice and Bob are accepted friends.
      create(
        :friendship,
        user: alice,
        friend: bob,
        status: "accepted"
      )

      # Alice and Charlie have a pending friendship.
      create(
        :friendship,
        user: alice,
        friend: charlie,
        status: "pending"
      )
    end

    let!(:alice_review) do
      create(
        :review,
        user: alice,
        item: item,
        body: "Alice's review"
      )
    end

    let!(:bob_review) do
      create(
        :review,
        user: bob,
        item: item,
        body: "Bob's review"
      )
    end

    let!(:charlie_review) do
      create(
        :review,
        user: charlie,
        item: item,
        body: "Charlie's review"
      )
    end

    let!(:david_review) do
      create(
        :review,
        user: david,
        item: item,
        body: "David's review"
      )
    end

    subject(:visible_reviews) do
      described_class.visible_to(alice)
    end

    it "includes the user's own reviews" do
      expect(visible_reviews).to include(alice_review)
    end

    it "includes reviews from accepted friends" do
      expect(visible_reviews).to include(bob_review)
    end

    it "excludes reviews from pending friends" do
      expect(visible_reviews).not_to include(charlie_review)
    end

    it "excludes reviews from non-friends" do
      expect(visible_reviews).not_to include(david_review)
    end

    it "does not return duplicate reviews" do
      expect(visible_reviews.count)
        .to eq(visible_reviews.distinct.count)
    end
  end
end
