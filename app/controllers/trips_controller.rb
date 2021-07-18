class TripsController < ApplicationController
  before_action :require_login
  # skip_before_action :require_login, only: [:index]

  def new
    @trip = Trip.new
    @trains = Train.all.map { |train| [train.name, train.id] }
  end

  def create
    puts "NOW IN CREATE"
    @trip = Trip.new(train_id: trip_params[:train_id], user_id: session[:user_id], date: trip_params[:date])
    @trains = Train.all.map { |train| [train.name, train.id] }
    puts "TRIP > #{Trip.find_by(train_id: @trip.train_id, user_id: @trip.user_id, date: @trip.date)}"
    if (Trip.find_by(train_id: @trip.train_id, user_id: @trip.user_id, date: @trip.date))
      @trip.errors.add(:base, "Duplicate trip! Another trip for same date & train already exists!")
      render :new
    else
      @schedule = Schedule.find_by(train_id: @trip.train_id, date: @trip.date)
      puts "Schedule nil? > #{@schedule.nil?}"
      if @schedule.nil?
        if @trip.valid?
          @trip.save
          Schedule.create(train_id: @trip.train_id, date: @trip.date, capacity: 99)
          redirect_to trips_path
        else
          render :new
        end
      else
        if @schedule.capacity > 1
          if @trip.valid?
            @trip.save
            @schedule.update(capacity: @schedule.capacity - 1)
            redirect_to trips_path
          else
            render :new
          end
        else
          @trip.errors.add(:base, "No seats available on the train!")
          render :new
        end
      end
    end
  end

  def edit
    @trip = Trip.find_by(id: params[:id])
    @trains = Train.all.map { |train| [train.name, train.id] }
    @schedule = Schedule.find_by(train_id: @trip.train.id, date: @trip.date)
    if (@trip.user.id != session[:user_id])
      @schedule.update(capacity: @schedule.capacity + 1)
    else
    end
  end

  def update
    @trip = Trip.find_by(id: params[:id])
    @schedule = Schedule.find_by(train_id: @trip.train_id, date: @trip.date)
    if (@trip.user.id == session[:user_id])
      @trip.update(train_id: trip_params[:train_id], date: trip_params[:date])
      @schedule = Schedule.find_by(train_id: @trip.train_id, date: @trip.date)
      if @schedule.nil?
        Schedule.create(train_id: @trip.train_id, date: @trip.date, capacity: 99)
      else
        @schedule.update(capacity: @schedule.capacity - 1)
      end
      redirect_to trips_path
    else
    end
  end

  def destroy
    @trip = Trip.find_by(id: params[:id])
    if (@trip.user.id == session[:user_id])
      Trip.delete(params[:id])
      @schedule = Schedule.find_by(train_id: @trip.train.id, date: @trip.date)
      @schedule.update(capacity: @trip.train.capacity + 1)
      redirect_to trips_path
    else
      @trip.errors.add(:user_id, "Sorry, you cannot delete other users' trips!")
    end
  end

  def index
    if is_admin
      @trips = Trip.all
    else
      if params[:train_id]
        @trips = Trip.train_trips(params[:train_id])
      else
        @trips = Trip.user_trips(session[:user_id])
      end
    end
  end

  def show
    @trip = Trip.find_by(id: params[:id])
    if @trip.nil?
      @trip = Trip.new
      @trip.errors.add(:id, "Trip #{params[:id]} not found!")
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:train_id, :date)
  end

  def require_login
    return head(:forbidden) unless session.include? :user_id
  end

  def is_admin
    session.include? :user_id && session[:username] == "admin"
  end
end
