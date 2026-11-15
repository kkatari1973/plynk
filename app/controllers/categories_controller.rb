class CategoriesController < ApplicationController
  def index
    @categories = Category.active
                          .left_joins(:items)
                          .select("categories.*, COUNT(items.id) AS items_count")
                          .group("categories.id")
  end

  def show
    @category = Category.find_by!(slug: params[:id])

    @reviews = Review.visible_to(Current.user)
                     .joins(:item)
                     .where(items: { category_id: @category.id })
                     .includes(:user, item: :category)
                     .newest_first
  end
end