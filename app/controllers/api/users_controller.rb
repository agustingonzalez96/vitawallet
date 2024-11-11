class Api::UsersController < ApplicationController
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index 
    @users = User.all
    render json: @users.to_json(:except => [:created_at, :updated_at]) , status: :ok
  end

  def show
  begin
    @user = User.find(params[:id])
    render json: @user.slice(:nombre, :balance_usd, :balance_btc), status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end
end

  private
  
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit!
  end

end