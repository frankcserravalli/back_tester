class IndicesController < ApplicationController
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
