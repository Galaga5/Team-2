class DaysController < ApplicationController
  
  #SCHEMA
  # t.date     "date"
  # t.integer  "number_of_pickups"
  # t.datetime "created_at",        null: false
  # t.datetime "updated_at",        null: false
  # t.string   "status"
  
  # Use this action to show all the days on schedule1 screen.
  def index
    @days = Day.all
    render 'day/schedule1.html.erb'
  end
  
  # Use show action to show a day and all of its coresponding scheduled pickups
  def show
    @day = Day.find(params[:id])
  end
  
  def new
    @START_YEAR = Time.new.year #The current year
    @NUM_YEARS_TO_DISPLAY = 5
    @day = Day.new
    
    render 'day/schedule2.html.erb'
  end
  
  # /schedule/schedule3
  def schedule3
    render 'day/schedule3.html.erb'
  end
  
  # Use this action to return all of the days when called from ajax. Used by 
  #   the calendar only.
  def all
     @days = Day.all
     respond_to do |format|
      format.json { render json: @days }
    end
  end
  
  # Use this action to create a new day from an ajax call made by the calendar.
  #   The calendar will pass a date only and then we will give the number of
  #   pickups 0, created at and updated at to right now, and set the record to
  #   active.
  def create
    if Day.find_by_date(params[:date])
      respond_to do |format|
        # Set up friednly forwarding to ask if they would like to view that day
        format.json { render json: "Sorry, that day is already marked as a pickup day."}
      end
    else
      @day = Day.new(day_params)
      @day.number_of_pickups = 0
      @day.status = "active"
      @day.created_at = Time.zone.now
      @day.updated_at = Time.zone.now
      respond_to do |format|
        if @day.save
          format.json { render json: @day}
        else
          format.json { render json: @day.errors}
        end
      end
    end
  end
  
  # Update :number_of_pickups, :updated_at, :status
  def update
    # Set the updated at and maybe the status
    @day = Day.find(params[:id])
    if @day.update_attributes(day_params)
      redirect_to @day
    else
      render 'edit'
    end
  end
  
  private
    # Make sure we only accept params we want
    def day_params
      params.permit(:date, :number_of_pickups, :status)  
    end
end
