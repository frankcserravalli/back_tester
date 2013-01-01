class IndicesController < ApplicationController
  # GET /indices/:id/rankings
  def rankings
    @index = Index.find(params[:id])
    @returns = {}
    @securities = {}
    
    @index.securities.each do |s|
      @securities[s.ticker.upcase] = s
      @returns[s.ticker.upcase] =  s.return_for_ranking(params)
    end
    @returns.delete_if { |k, v| v.nil? }
    @returns = @returns.sort_by{|k,v| v.to_f}.reverse
  end
  
  def top_25
    @today = params[:date].to_date rescue Date.today
    @seven_days_ago = @today - 7.days
    @securities = {}
    
    @index = Index.find(params[:id])
    @returns = {}
    @index.securities.each do |s|
      @securities[s.ticker.upcase] = s
      @returns[s.ticker.upcase] =  s.return_for_ranking(:date => @today)
    end
    @returns.delete_if { |k, v| v.nil? }
    @returns = @returns.sort_by{|k,v| v.to_f}.reverse[0..24]
    
    
    @last_week = {}
    @index.securities.each do |s|
      @securities[s.ticker.upcase] = s unless @securities[s.ticker.upcase]
      @last_week[s.ticker.upcase] =  s.return_for_ranking(:date => @seven_days_ago)
    end
    @last_week.delete_if { |k, v| v.nil? }
    @last_week = @last_week.sort_by{|k,v| v.to_f}.reverse[0..24]
    
    @additions    = @returns.map{|k,v| k} - @last_week.map{|k,v| k }
    @subtractions = @last_week.map{|k,v| k} - @returns.map{|k,v| k }
  end
  
  # GET /indices
  # GET /indices.json
  def index
    @indices = Index.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @indices }
    end
  end

  # GET /indices/1
  # GET /indices/1.json
  def show
    @index = Index.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @index }
    end
  end

  # GET /indices/new
  # GET /indices/new.json
  def new
    @index = Index.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @index }
    end
  end

  # GET /indices/1/edit
  def edit
    @index = Index.find(params[:id])
  end

  # POST /indices
  # POST /indices.json
  def create
    @index = Index.new(params[:index])

    respond_to do |format|
      if @index.save
        format.html { redirect_to @index, notice: 'Index was successfully created.' }
        format.json { render json: @index, status: :created, location: @index }
      else
        format.html { render action: "new" }
        format.json { render json: @index.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /indices/1
  # PUT /indices/1.json
  def update
    @index = Index.find(params[:id])

    respond_to do |format|
      if @index.update_attributes(params[:index])
        format.html { redirect_to @index, notice: 'Index was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @index.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /indices/1
  # DELETE /indices/1.json
  def destroy
    @index = Index.find(params[:id])
    @index.destroy

    respond_to do |format|
      format.html { redirect_to indices_url }
      format.json { head :no_content }
    end
  end
end
