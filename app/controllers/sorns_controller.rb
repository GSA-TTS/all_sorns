class SornsController < ApplicationController
  before_action :set_sorn, only: [:show, :edit, :update, :destroy]

  # GET /sorns
  # GET /sorns.json
  def index
    if params[:search]
      redirect_to sorns_path if params[:search] == ''
      @sorns = Sorn.search_by_all(params[:search]).includes(:agency)
      @count = @sorns.count
      @sorns = @sorns.page params[:page]
    else
      @sorns = Sorn.all.includes(:agency)
      @count = @sorns.count
      @sorns = @sorns.page params[:page]
    end
  end

  # GET /sorns/1
  # GET /sorns/1.json
  def show
  end

  # GET /sorns/new
  def new
    @sorn = Sorn.new
  end

  # GET /sorns/1/edit
  def edit
  end

  # POST /sorns
  # POST /sorns.json
  def create
    @sorn = Sorn.new(sorn_params)

    respond_to do |format|
      if @sorn.save
        format.html { redirect_to @sorn, notice: 'Sorn was successfully created.' }
        format.json { render :show, status: :created, location: @sorn }
      else
        format.html { render :new }
        format.json { render json: @sorn.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sorns/1
  # PATCH/PUT /sorns/1.json
  def update
    respond_to do |format|
      if @sorn.update(sorn_params)
        format.html { redirect_to @sorn, notice: 'Sorn was successfully updated.' }
        format.json { render :show, status: :ok, location: @sorn }
      else
        format.html { render :edit }
        format.json { render json: @sorn.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sorns/1
  # DELETE /sorns/1.json
  def destroy
    @sorn.destroy
    respond_to do |format|
      format.html { redirect_to sorns_url, notice: 'Sorn was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sorn
      @sorn = Sorn.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sorn_params
      params.require(:sorn).permit(:agency_id, :system_name, :sorn_number, :authority, :categories_of_record, :search)
    end
end
