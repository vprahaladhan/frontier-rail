class TrainsController < ApplicationController
  before_action :require_admin
  skip_before_action :require_admin, only: [:index, :show]

  def new
    @train = Train.new
  end

  def create
    @train = Train.create(train_params)
    redirect_to trains_path
  end

  def edit
    @train = Train.find_by(id: params[:id])
  end

  def update
    @train = Train.find_by(id: params[:id])
    Train.update(train_params)
    redirect_to trains_path
  end

  def destroy
    Train.delete(params[:id])
    redirect_to trains_path
  end

  def index
    @trains = Train.all
  end

  def show
    @train = Train.find_by(id: params[:id])
    if @train.nil?
      @train = Train.new
      @train.errors.add(:id, "Train with ID: #{params[:id]} not found!");
      puts "Train errors >> #{@train.errors[:id]}"
    end
  end

  private

  def train_params
    params.require(:train).permit(:name, :from, :to, :capacity)
  end

  def require_admin
    return head(:forbidden) unless !session[:user_id].nil? && session[:username] == 'admin'
  end
end