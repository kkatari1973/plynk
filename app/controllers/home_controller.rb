class HomeController < ApplicationController
  def index
    @categories = Category.active
    @reviews = Review.visible_to(Current.user)
                     .includes(:user, item: :category)
                     .newest_first
                     .limit(50)
  end
end