class UrgenciaController < ApplicationController
  before_action :set_urgencium, only: %i[ show edit update destroy ]
  before_action :authenticate_admin

  # GET /urgencia or /urgencia.json
  def index
    @urgencia = Urgencium.all
  end

  # GET /urgencia/1 or /urgencia/1.json
  def show
  end

  # GET /urgencia/new
  def new
    @urgencium = Urgencium.new
  end

  # GET /urgencia/1/edit
  def edit
  end

  # POST /urgencia or /urgencia.json
  def create
    @urgencium = Urgencium.new(urgencium_params)

    respond_to do |format|
      if @urgencium.save
        format.html { redirect_to urgencium_url(@urgencium), notice: "Urgencia creada exitosamente." }
        format.json { render :show, status: :created, location: @urgencium }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @urgencium.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /urgencia/1 or /urgencia/1.json
  def update
    respond_to do |format|
      if @urgencium.update(urgencium_params)
        format.html { redirect_to urgencium_url(@urgencium), notice: "Urgencia editada exitosamente." }
        format.json { render :show, status: :ok, location: @urgencium }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @urgencium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /urgencia/1 or /urgencia/1.json
  def destroy
    @urgencium.destroy!

    respond_to do |format|
      format.html { redirect_to urgencia_url, notice: "Urgencia ha sido eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_urgencium
      @urgencium = Urgencium.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def urgencium_params
      params.require(:urgencium).permit(:name)
    end
end
