class CategoriesController < ApplicationController
  def index
    visible_user_ids = [ Current.user.id ] + Current.user.accepted_friends.ids

    @categories = Category.active
                          .left_joins(items: :reviews)
                          .select(
                            "categories.*, COUNT(DISTINCT CASE " \
                            "WHEN reviews.user_id IN (#{visible_user_ids.join(',')}) " \
                            "THEN reviews.id END) AS items_count"
                          )
                          .group("categories.id")
  end

  def show
    @category = Category.find_by!(slug: params[:id])

    @reviews = Review.visible_to(Current.user)
                     .joins(:item)
                     .where(items: { category_id: @category.id })
                     .includes(:user, item: :category)
                     .newest_first
                     .to_a

    @rating_summaries = @reviews.map(&:item).uniq(&:id).index_with do |item|
      item.rating_summary_for(Current.user)
    end
  end
end
