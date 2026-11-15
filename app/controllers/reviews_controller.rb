
class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :require_review_owner, only: [:edit, :update, :destroy]

  def index
    @reviews = Review.visible_to(Current.user)
                     .includes(:user, item: :category)
                     .newest_first
  end

  def show
    unless @review.readable_by?(Current.user)
      head :forbidden
    end
  end

  def new
    @review = Review.new
    @categories = Category.active
    @selected_category = Category.find_by(slug: params[:category])
  end

  def create
    @review = Review.new(review_params.except(
      :category_id,
      :item_title,
      :item_creator,
      :item_description
    ))

    @review.user = Current.user
    @categories = Category.active

    category = Category.active.find_by(id: review_params[:category_id])

    unless category
      @review.errors.add(:base, "Please choose an active category.")
      @selected_category = nil
      return render :new, status: :unprocessable_entity
    end

    item = Item.find_or_initialize_by(
      category: category,
      title: review_params[:item_title].to_s.strip
    )

    item.assign_attributes(
      creator: review_params[:item_creator],
      description: review_params[:item_description]
    )

    @selected_category = category

    ActiveRecord::Base.transaction do
      item.save!
      @review.item = item
      @review.save!
    end

    redirect_to category_path(category.slug),
                notice: "Your recommendation has been added!"

  rescue ActiveRecord::RecordInvalid => error
    @review.errors.add(:base, error.record.errors.full_messages.to_sentence)
    render :new, status: :unprocessable_entity
  end

  def edit
    @categories = Category.active
  end

  def update
    if @review.update(review_params.except(:category_id, :item_title,
                                           :item_creator, :item_description))
      redirect_to review_path(@review),
                  notice: "Review updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    redirect_to root_path, notice: "Review deleted."
  end

  private

  def set_review
    @review = Review.visible_to(Current.user).find(params[:id])
  end

  def require_review_owner
    return if @review.user_id == Current.user.id

    head :forbidden
  end

  def review_params
    params.require(:recommendation).permit(
      :category_id,
      :item_title,
      :item_creator,
      :item_description,
      :rating,
      :body
    )
  end
end
