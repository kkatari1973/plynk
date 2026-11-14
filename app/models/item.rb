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
end
