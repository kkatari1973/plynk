class Item < ApplicationRecord
  belongs_to :category
  has_many :reviews, dependent: :destroy

  validates :title, presence: true

  store_accessor :details,
    :author,
    :director,
    :artist,
    :album,
    :venue,
    :address,
    :neighborhood,
    :cuisine,
    :genre,
    :release_year,
    :isbn

  def display_title
    title
  end

  def rating_summary_for(user)
    visible_reviews = Review.visible_to(user).where(item_id: id)

    {
      average: visible_reviews.average(:rating)&.to_f,
      count: visible_reviews.count
    }
  end
end
