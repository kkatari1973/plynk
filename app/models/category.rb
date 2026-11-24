class Category < ApplicationRecord
    has_many :items, dependent: :restrict_with_error

    validates :name, presence: true
    validates :slug, presence: true, uniqueness: true

    scope :active, -> {
        where(active: true).order(:name)
    }
end
