# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Create the initial Recs categories

categories = [
  {
    name: "Restaurants",
    slug: "restaurants",
    description: "Restaurants, cafes, and places to eat"
  },
  {
    name: "Books",
    slug: "books",
    description: "Books worth reading"
  },
  {
    name: "Movies",
    slug: "movies",
    description: "Movies worth watching"
  },
  {
    name: "Music",
    slug: "music",
    description: "Albums, artists, and songs"
  },
  {
    name: "Live Theater",
    slug: "live-theater",
    description: "Plays, musicals, and live performances"
  }
]

categories.each do |attributes|
  category = Category.find_or_initialize_by(slug: attributes[:slug])
  category.update!(attributes.merge(active: true))
end

puts "Created categories"

# Create sample items

restaurants = Category.find_by!(slug: "restaurants")
books       = Category.find_by!(slug: "books")
movies      = Category.find_by!(slug: "movies")
music       = Category.find_by!(slug: "music")
theater     = Category.find_by!(slug: "live-theater")

sample_items = [
  {
    category: restaurants,
    title: "The Friendly Toast",
    creator: nil,
    description: "A popular brunch spot",
    details: { cuisine: "American", neighborhood: "Back Bay" }
  },
  {
    category: books,
    title: "The Alchemist",
    creator: "Paulo Coelho",
    description: "A philosophical novel",
    details: { author: "Paulo Coelho" }
  },
  {
    category: movies,
    title: "The Shawshank Redemption",
    creator: "Frank Darabont",
    description: "A drama about hope and friendship",
    details: { director: "Frank Darabont", release_year: 1994 }
  },
  {
    category: music,
    title: "Kind of Blue",
    creator: "Miles Davis",
    description: "A landmark jazz album",
    details: { artist: "Miles Davis", genre: "Jazz" }
  },
  {
    category: theater,
    title: "Hamilton",
    creator: "Lin-Manuel Miranda",
    description: "A musical about American history",
    details: { venue: "Richard Rodgers Theatre" }
  }
]

items = sample_items.map do |attributes|
  item = Item.find_or_initialize_by(
    category: attributes[:category],
    title: attributes[:title]
  )

  item.update!(attributes.except(:category).merge(category: attributes[:category]))
  item
end

puts "Created sample items"

# Create sample reviews for every existing user.
# This makes the reviews visible to each user on their own homepage.

User.find_each do |user|
  items.each_with_index do |item, index|
    review = Review.find_or_initialize_by(user: user, item: item)

    review.update!(
      rating: [5, 4, 5, 5, 4][index],
      body: [
        "A great place to visit. Definitely worth trying!",
        "An excellent book. I really enjoyed reading it.",
        "A fantastic movie. Highly recommended.",
        "A wonderful album that I keep coming back to.",
        "An entertaining performance. I would recommend it."
      ][index]
    )
  end
end

puts "Created sample reviews"
puts "Recs seed data complete!"
