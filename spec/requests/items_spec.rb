
require "rails_helper"

RSpec.describe "Item detail pages", type: :request do

  let!(:alice) { create(:user, name: "Alice") }
  let!(:bob)   { create(:user, name: "Bob") }
  let!(:charlie) { create(:user, name: "Charlie") }

  let!(:category) { create(:category, name: "Books") }

  let!(:item) do
    create(:item, title: "The Great Gatsby", category: category)
  end

  # Alice and Bob are accepted friends.
  before do
    create(
      :friendship,
      user: alice,
      friend: bob,
      status: "accepted"
    )
  end

  # Reviews from all three users.
  let!(:alice_review) do
    create(
      :review,
      user: alice,
      item: item,
      body: "Alice's private review"
    )
  end

  let!(:bob_review) do
    create(
      :review,
      user: bob,
      item: item,
      body: "Bob's friend review"
    )
  end

  let!(:charlie_review) do
    create(
      :review,
      user: charlie,
      item: item,
      body: "Charlie's hidden review"
    )
  end

  # Sign in using the Rails authentication session.
  def sign_in(user)
    post session_path, params: {
      email_address: user.email_address,
      password: "password123"
    }
  end

  describe "GET /items/:id" do

    context "when Alice is signed in" do
      before do
        sign_in(alice)
        get item_path(item)
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:ok)
      end

      it "displays the item details" do
        expect(response.body).to include("The Great Gatsby")
        expect(response.body).to include("Books")
      end

      it "shows Alice's own review" do
        expect(response.body).to include("Alice&#39;s private review")
      end

      it "shows reviews from accepted friends" do
        expect(response.body).to include("Bob&#39;s friend review")
      end

      it "does not show reviews from non-friends" do
        expect(response.body).not_to include("Charlie's hidden review")
      end
    end

    context "when Charlie is signed in" do
      before do
        sign_in(charlie)
        get item_path(item)
      end

      it "shows Charlie's own review" do
        expect(response.body).to include("Charlie&#39;s hidden review")
      end

      it "does not show Alice's review" do
        expect(response.body).not_to include("Alice's private review")
      end

      it "does not show Bob's review" do
        expect(response.body).not_to include("Bob's friend review")
      end
    end

    context "when an item has no reviews visible to Alice" do
      let!(:hidden_item) do
        create(
          :item,
          title: "Hidden Book",
          category: category
        )
      end

      before do
        create(
          :review,
          user: charlie,
          item: hidden_item,
          body: "Only Charlie can see this"
        )

        sign_in(alice)
        get item_path(hidden_item)
      end

      it "returns a 404 response" do
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the friendship is pending" do
      let!(:david) { create(:user, name: "David") }

      before do
        create(
          :friendship,
          user: alice,
          friend: david,
          status: "pending"
        )

        create(
          :review,
          user: david,
          item: item,
          body: "David's pending friend review"
        )

        sign_in(alice)
        get item_path(item)
      end

      it "does not show reviews from pending friends" do
        expect(response.body).not_to include(
        "David's pending friend review"
        )
      end
    end

  end
end
