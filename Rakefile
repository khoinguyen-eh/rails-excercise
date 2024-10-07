# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

namespace :db do
  desc "Populate the database with authors and books"
  task populate_authors_and_books: :environment do
    # Number of authors and books to create
    number_of_authors = 100
    books_per_author = 10

    puts "Creating #{number_of_authors} authors and #{number_of_authors * books_per_author} books..."

    number_of_authors.times do |i|
      author = Author.create!(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        dob: Faker::Date.birthday(min_age: 20, max_age: 80),
        gender: %w[male female other].sample
      )

      books_per_author.times do
        Book.create!(
          isbn: Faker::Code.isbn,
          name: Faker::Book.title,
          author: author,
          publish_date: Faker::Date.between(from: '1950-01-01', to: Date.today),
          genre: [Faker::Book.genre, Faker::Book.genre],
          rating: rand(1.0..5.0).round(2),
          desc: Faker::Lorem.paragraph(sentence_count: 5)
        )
      end
    end

    puts "Finished populating authors and books."
  end
end