class TripsController < ApplicationController
  def new
    @trip = Trip.new
    @trains = Train.all.map {|train| [train.name, train.id]}
  end

  def create
    puts "Params >> #{user_params}"
    @trip = Trip.create(train_id: user_params[:train_id], user_id: session[:user_id], date: user_params[:date])
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def index
    @trips = session[:username] == 'admin' ? Trip.all : Trip.my_trips
  end

  def show
    @trip = Trip.find_by(params[:id])
    if @trip.nil? then 
      @error = "Trip #{params[:id]} not found!"
    end
  end

  private

  def user_params
    params.require(:trip).permit(:train_id, :date)
  end
end
