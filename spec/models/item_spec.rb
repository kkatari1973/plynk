
require "rails_helper"

RSpec.describe Item, type: :model do
  describe "#rating_summary_for" do
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

    context "when the item has multiple reviews" do
      before do
        create(:review, user: alice, item: item, rating: 5)
        create(:review, user: bob, item: item, rating: 4)
        create(:review, user: charlie, item: item, rating: 1)
        create(:review, user: david, item: item, rating: 2)
      end

      it "calculates the average using only visible reviews" do
        summary = item.rating_summary_for(alice)

        expect(summary[:average]).to eq(4.5)
      end

      it "counts only visible reviews" do
        summary = item.rating_summary_for(alice)

        expect(summary[:count]).to eq(2)
      end

      it "does not include nonfriend ratings" do
        summary = item.rating_summary_for(alice)

        # Alice and Bob are the only visible reviewers.
        expect(summary[:average]).not_to eq(3.0)
      end
    end

    context "when the item has no reviews" do
      it "returns a nil average" do
        summary = item.rating_summary_for(alice)

        expect(summary[:average]).to be_nil
      end

      it "returns a count of zero" do
        summary = item.rating_summary_for(alice)

        expect(summary[:count]).to eq(0)
      end
    end

    context "when the user has only their own review" do
      before do
        create(:review, user: alice, item: item, rating: 3)
      end

      it "uses their own rating" do
        summary = item.rating_summary_for(alice)

        expect(summary[:average]).to eq(3.0)
        expect(summary[:count]).to eq(1)
      end
    end

    context "when the user has multiple friends with different ratings" do
      before do
        # Accept the existing request in the reverse-direction friendship
        # setup rather than creating a second row for the same pair.
        Friendship.find_by!(user: alice, friend: charlie).update!(status: "accepted")

        create(:review, user: alice, item: item, rating: 5)
        create(:review, user: bob, item: item, rating: 4)
        create(:review, user: charlie, item: item, rating: 3)
      end

      it "includes accepted friends regardless of who initiated friendship" do
        summary = item.rating_summary_for(alice)

        expect(summary[:average]).to eq(4.0)
        expect(summary[:count]).to eq(3)
      end
    end
  end
end
