class SornsController < ApplicationController
  before_action :set_sorn, only: [:show, :edit, :update, :destroy]

  # GET /sorns
  # GET /sorns.json
  def index(source)
    if params[:search]
      redirect_to request.path if params[:search] == ''
      @sorns = Sorn.where(data_source: source).search_by_all(params[:search]).order(:system_number).includes(:agency)
      @count = @sorns.where(data_source: source).count
      @sorns = @sorns.where(data_source: source).page params[:page]
    else
      @sorns = Sorn.where(data_source: source).order(:system_number).includes(:agency)
      @count = @sorns.where(data_source: source).count
      @sorns = @sorns.where(data_source: source).page params[:page]
    end
  end

  def table_everything
    index(:fedreg)
  end

  def table_important
    index(:fedreg)
  end

  def cards_everything
    index(:fedreg)
  end

  def cards_important
    index(:fedreg)
  end

  def systems
    index(:fedreg)
  end

  def bulk_table_everything
    index(:bulk)
  end

  def bulk_table_important
    index(:bulk)
  end

  def bulk_cards_everything
    index(:bulk)
  end

  def bulk_cards_important
    index(:bulk)
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
