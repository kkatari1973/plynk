require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ProfilesHelper. For example:
#
# describe ProfilesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ProfilesHelper, type: :helper do
  describe "#profile_member_since" do
    it "formats the user's join date as month and year" do
      user = build(:user, created_at: Time.zone.local(2024, 3, 15))

      expect(helper.profile_member_since(user)).to eq("March 2024")
    end
  end
end
