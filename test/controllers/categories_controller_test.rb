
require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "should get index" do
    get categories_url
    assert_response :success
  end

  test "should get show" do
    get category_url(categories(:one).slug)
    assert_response :success
  end

  test "category count includes multiple visible reviews of the same item" do
    # Review one already exists in reviews.yml:
    # user one reviews item one.

    # Add a review from accepted friend user two
    # for that same item.
    Review.create!(
      user: users(:two),
      item: items(:one),
      rating: 4,
      body: "Friend's review"
    )

    get categories_url

    assert_response :success

    assert_select ".category-card" do |cards|
      books_card = cards.find do |card|
        card.at_css("h2")&.text&.strip == "Books"
      end

      assert books_card, "Expected to find Books category card"

      assert_equal "2 items",
                  books_card.at_css(".category-count").text.strip
    end
  end


  test "category count excludes reviews from non-accepted friends" do
    # User one already has a review for item one.
    # User two is already an accepted friend.

    Review.create!(
      user: users(:two),
      item: items(:one),
      rating: 4,
      body: "Accepted friend's review"
    )

    pending_user = User.create!(
      name: "Pending User",
      email_address: "pending@example.com",
      password: "password"
    )

    declined_user = User.create!(
      name: "Declined User",
      email_address: "declined@example.com",
      password: "password"
    )

    stranger = User.create!(
      name: "Stranger",
      email_address: "stranger@example.com",
      password: "password"
    )

    Friendship.create!(
      user: users(:one),
      friend: pending_user,
      status: :pending
    )

    Friendship.create!(
      user: users(:one),
      friend: declined_user,
      status: :declined
    )

    # Add reviews from all three users for the same Books item.
    [ pending_user, declined_user, stranger ].each do |user|
      Review.create!(
        user: user,
        item: items(:one),
        rating: 5,
        body: "Test review"
      )
    end

    get categories_url

    assert_response :success

    assert_select ".category-card" do |cards|
      books_card = cards.find do |card|
        card.at_css("h2")&.text&.strip == "Books"
      end

      assert books_card, "Expected to find Books category card"

      assert_equal "2 items",
                  books_card.at_css(".category-count").text.strip
    end
  end
end
