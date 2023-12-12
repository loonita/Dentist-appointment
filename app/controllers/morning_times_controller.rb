class MorningTimesController < ApplicationController
  before_action :set_morning_time, only: %i[ show edit update destroy ]
  before_action :authenticate_admin

  # GET /morning_times or /morning_times.json
  def index
    @morning_times = MorningTime.all
  end

  # GET /morning_times/1 or /morning_times/1.json
  def show
  end

  # GET /morning_times/new
  def new
    @morning_time = MorningTime.new
  end

  # GET /morning_times/1/edit
  def edit
  end

  # POST /morning_times or /morning_times.json
  def create
    @morning_time = MorningTime.new(morning_time_params)

    respond_to do |format|
      if @morning_time.save
        format.html { redirect_to morning_time_url(@morning_time), notice: "Morning time was successfully created." }
        format.json { render :show, status: :created, location: @morning_time }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @morning_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /morning_times/1 or /morning_times/1.json
  def update
    respond_to do |format|
      if @morning_time.update(morning_time_params)
        format.html { redirect_to morning_time_url(@morning_time), notice: "Morning time was successfully updated." }
        format.json { render :show, status: :ok, location: @morning_time }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @morning_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /morning_times/1 or /morning_times/1.json
  def destroy
    @morning_time.destroy!

    respond_to do |format|
      format.html { redirect_to morning_times_url, notice: "Morning time was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_morning_time
      @morning_time = MorningTime.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def morning_time_params
      params.require(:morning_time).permit(:m_time)
    end
end
