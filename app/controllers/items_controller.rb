class ItemsController < ApplicationController
  def index
  end

  def show
    visible_reviews = Review.visible_to(Current.user)
    # Only show an item if the current user can see at least
    # one review associated with it.
    @item = Item.joins(:reviews)
                .merge(Review.visible_to(Current.user))
                .includes(:category)
                .find(params[:id])

    # Show only reviews this user is allowed to see.
    @reviews = @item.reviews
                    .visible_to(Current.user)
                    .includes(:user)
                    .newest_first

    @rating_summary = @item.rating_summary_for(Current.user)
  end

  def new
  end

  def edit
  end
end
