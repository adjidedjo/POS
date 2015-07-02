class SalesCountersController < ApplicationController
  before_action :set_sales_counter, only: [:show, :edit, :update, :destroy]
  before_action :branches, only: [:new, :edit]
  before_action :set_controller, only: [:show, :index]

  # GET /sales_counters
  # GET /sales_counters.json
  def index
    @sales_counters = SalesCounter.all
  end

  # GET /sales_counters/1
  # GET /sales_counters/1.json
  def show
  end

  # GET /sales_counters/new
  def new
    @sales_counter = SalesCounter.new
  end

  # GET /sales_counters/1/edit
  def edit
  end

  # POST /sales_counters
  # POST /sales_counters.json
  def create
    @sales_counter = SalesCounter.new(sales_counter_params)

    respond_to do |format|
      if @sales_counter.save
        format.html { redirect_to @sales_counter, notice: 'Sales counter was successfully created.' }
        format.json { render :show, status: :created, location: @sales_counter }
      else
        format.html { render :new }
        format.json { render json: @sales_counter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales_counters/1
  # PATCH/PUT /sales_counters/1.json
  def update
    respond_to do |format|
      if @sales_counter.update(sales_counter_params)
        format.html { redirect_to @sales_counter, notice: 'Sales counter was successfully updated.' }
        format.json { render :show, status: :ok, location: @sales_counter }
      else
        format.html { render :edit }
        format.json { render json: @sales_counter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_counters/1
  # DELETE /sales_counters/1.json
  def destroy
    @sales_counter.destroy
    respond_to do |format|
      format.html { redirect_to sales_counters_url, notice: 'Sales counter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_controller
      @controller = current_user.role == 'controller'
    end
    
    def branches
      @branches = Branch.all
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_sales_counter
      @sales_counter = SalesCounter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sales_counter_params
      params.require(:sales_counter).permit(:nama, :nik, :email, :branch_id)
    end
end
