class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]
  before_action :check_authorization, only: %i[ update destroy ]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    old_password = params[:old_password]
    local_user_params = user_params

    if old_password ^ local_user_params[:password]
      render json: { error: 'Old password and new password must be provided' }, status: :unprocessable_entity
      return
    end

    if old_password && !@user.authenticate(old_password)
      render json: { error: 'Old password is incorrect' }, status: :unprocessable_entity
      return
    end

    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def login
    email = params[:email]
    password = params[:password]

    @user = User.find_by(email: email)

    unless @user&.authenticate(password)
      render json: { error: 'Invalid email or password' }, status: :unauthorized
      return
    end

    token = SecureRandom.hex(10)
    $redis.set("user_token:#{token}", @user.id.to_s)

    render json: { token: token }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :dob, :gender, :email, :password)
    end

    def current_user_id
      request.env['current_user_id']
    end

    def check_authorization
      return if current_user_id == @user.id

      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
end
