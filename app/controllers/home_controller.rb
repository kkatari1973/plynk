
class HomeController < ApplicationController
  def index
    @categories = Category.active
    @selected_category = Category.find_by(slug: params[:category])

    @reviews = Review.visible_to(Current.user)
                     .includes(:user, item: :category)
                     .newest_first

    # Filter reviews by selected category
    if @selected_category
      @reviews = @reviews.joins(:item)
                         .where(items: { category_id: @selected_category.id })
    end

    # Limit results after filtering
    @reviews = @reviews.limit(50)
  end
end
