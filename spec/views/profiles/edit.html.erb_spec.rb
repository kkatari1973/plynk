require 'rails_helper'

RSpec.describe "profiles/edit.html.erb", type: :view do
  it "renders the profile fields and save action" do
    assign(:user, build(:user, name: "Alex Smith", email_address: "alex@example.com"))

    render

    expect(rendered).to include("Edit Profile")
    assert_select "form[action='#{profile_path}'][method='post']"
    assert_select "input[name='user[name]'][value='Alex Smith']"
    assert_select "input[name='user[email_address]'][value='alex@example.com']"
    assert_select "input[type='submit'][value='Save Changes']"
    assert_select "a[href='#{profile_path}']", text: "Cancel"
  end
end
