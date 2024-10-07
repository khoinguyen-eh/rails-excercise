class BooksController < ApplicationController
  before_action :set_book, only: %i[ show update destroy ]

  # GET /books
  def index
    @books = Book.all

    render json: @books
  end

  # GET /books/1
  def show
    render json: @book
  end

  # POST /books
  def create
    @book = Book.new(book_params)

    if @book.save
      render json: @book, status: :created, location: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /books/1
  def update
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
    books = Book.where(author_id: params[:author_id])
    render json: books
  rescue
    render json: { error: "Author not found" }, status: :not_found
  end

  def top_rated
    amount = params[:amount] || 10
    min_score = params[:min_score] || 4

    books = Book.where("rating >= ?", min_score).limit(amount)

    render json: books
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:isbn, :name, :author_id, :publish_date, :genre, :rating, :desc)
    end
end
