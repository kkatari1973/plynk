
require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Alex Smith",
      email_address: "alex@example.com",
      password: "password",
      password_confirmation: "password"
    )

    sign_in_as(@user)
  end

  test "should display the user's profile" do
    get profile_path

    assert_response :success
    assert_select "h1", "Your Profile"
    assert_select "h2", "Alex Smith"
    assert_select "p", "alex@example.com"
  end

  test "should display friend and review counts" do
    friend = User.create!(
      name: "Sam Jones",
      email_address: "sam@example.com",
      password: "password",
      password_confirmation: "password"
    )

    Friendship.create!(
      user: @user,
      friend: friend,
      status: :accepted
    )

    category = Category.create!(
      name: "Books",
      slug: "books",
      active: true
    )

    item = Item.create!(
      category: category,
      title: "The Great Gatsby"
    )

    Review.create!(
      user: @user,
      item: item,
      rating: 5,
      body: "A great book!"
    )

    get profile_path

    assert_response :success
    assert_select ".profile-stats strong", text: "1", count: 2
  end

  test "should display the edit profile form" do
    get edit_profile_path

    assert_response :success
    assert_select "h1", "Edit Profile"
    assert_select "input[name='user[name]']"
    assert_select "input[name='user[email_address]']"
  end

  test "should update the user's profile" do
    patch profile_path, params: {
      user: {
        name: "Alex Johnson",
        email_address: "alex.johnson@example.com"
      }
    }

    assert_redirected_to profile_path

    @user.reload
    assert_equal "Alex Johnson", @user.name
    assert_equal "alex.johnson@example.com", @user.email_address
  end

  test "should not update profile with invalid information" do
    original_email = @user.email_address

    patch profile_path, params: {
      user: {
        name: "",
        email_address: "not-an-email"
      }
    }

    assert_response :unprocessable_entity

    @user.reload
    assert_equal "Alex Smith", @user.name
    assert_equal original_email, @user.email_address
  end

  test "should not allow a user to change admin status through profile update" do
    patch profile_path, params: {
      user: {
        name: "Alex Smith",
        admin: true
      }
    }

    @user.reload
    assert_not @user.admin?
  end

  private

  def sign_in_as(user)
    post session_path, params: {
      email_address: user.email_address,
      password: "password"
    }
  end
end
