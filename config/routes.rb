Rails.application.routes.draw do
  get 'books/top_rated', to: 'books#top_rated'
  resources :books
  resources :authors
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get 'authors/:author_id/books', to: 'books#index_by_author'
end
