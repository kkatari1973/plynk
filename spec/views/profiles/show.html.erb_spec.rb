require 'rails_helper'

RSpec.describe "profiles/show.html.erb", type: :view do
  it "renders the user details and profile statistics" do
    user = build(:user, name: "Alex Smith", email_address: "alex@example.com",
                        created_at: Time.zone.local(2024, 3, 15))
    assign(:user, user)
    assign(:friends_count, 3)
    assign(:reviews_count, 2)

    render

    expect(rendered).to include("Your Profile", "Alex Smith", "alex@example.com")
    expect(rendered).to include("Member since March 2024")
    assert_select ".profile-stats strong", text: "3", count: 1
    assert_select ".profile-stats strong", text: "2", count: 1
    assert_select "a[href='#{edit_profile_path}']", text: "Edit Profile"
  end
end
