# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

namespace :db do
  desc "Populate the database with authors and books for V1"
  task populate_authors_and_books: :environment do
    # Number of authors and books to create
    number_of_authors = 100
    books_per_author = 10

    puts "Creating #{number_of_authors} authors and #{number_of_authors * books_per_author} books..."

    number_of_authors.times do |_|
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

  desc "Add a new author to existing books for V2"
  task add_author_to_books: :environment do
    max_numb_book_authors = 5
    max_author_id = Author.maximum(:id)

    Book.all.each do |book|
      numb_authors = rand(1..max_numb_book_authors)
      author_ids = (1..max_author_id).to_a.sample(numb_authors)

      # Check if the author is already in the book
      author_ids -= book.author_ids

      author_ids.each do |author_id|
        book.authors << Author.find(author_id)
      end
    end
  end
end