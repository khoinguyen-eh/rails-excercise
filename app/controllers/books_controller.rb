class BooksController < ApplicationController
  before_action :set_book, only: %i[ show update destroy ]

  # GET /books
  def index
    @books = Book.all

    render_books(@books)
  end

  # GET /books/1
  def show
    render_books(@book)
  end

  # POST /books
  def create
    @book = Book.new(book_params)
    update_authors(@book, params[:author_ids])

    if @book.save
      render json: @book, status: :created, location: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /books/1
  def update
    update_authors(@book, params[:author_ids])

    if @book.update(book_params)
      render json: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # DELETE /books/1
  def destroy
    @book.destroy
  end

  def index_by_author
    @books = Book.where(author_id: params[:author_id])

    render_books(@books)
  rescue
    render json: { error: "Author not found" }, status: :not_found
  end

  def top_rated
    amount = params[:amount] || 10
    min_score = params[:min_score] || 4

    @books = Book.where("rating >= ?", min_score).limit(amount)

    render_books(@books)
  end

  private

  def render_books(books)
    include_authors = params[:include_authors]

    if include_authors
      render json: books, include: [:authors], scope: { include_authors: include_authors }
    else
      render json: books
    end
  end

  def update_authors(book, author_ids)
    authors = author_ids.map { |id| Author.find(id) } if author_ids
    book.authors = authors
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Author not found" }, status: :not_found
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def book_params
    params.require(:book).permit(:isbn, :name, :publish_date, :genre, :rating, :desc)
  end
end
