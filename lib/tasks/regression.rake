namespace :test do
  desc "Run all Minitest and RSpec tests"
  task regression: :environment do
    puts "\nRunning Rails Minitest suite..."
    abort "Minitest failed!" unless system("bin/rails test")

    puts "\nRunning RSpec suite..."
    abort "RSpec failed!" unless system("bundle exec rspec")

    puts "\nAll regression tests passed!"
  end
end