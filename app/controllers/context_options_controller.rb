class ContextOptionsController < ApplicationController
  # GET /context_options
  # GET /context_options.json
  def index
    @context_options = ContextOption.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @context_options }
    end
  end

  # GET /context_options/1
  # GET /context_options/1.json
  def show
    @context_option = ContextOption.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @context_option }
    end
  end

  # GET /context_options/new
  # GET /context_options/new.json
  def new
    @context_option = ContextOption.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @context_option }
    end
  end

  # GET /context_options/1/edit
  def edit
    @context_option = ContextOption.find(params[:id])
  end

  # POST /context_options
  # POST /context_options.json
  def create
    @context_option = ContextOption.new(params[:context_option])

    respond_to do |format|
      if @context_option.save
        format.html { redirect_to @context_option, notice: 'Context option was successfully created.' }
        format.json { render json: @context_option, status: :created, location: @context_option }
      else
        format.html { render action: "new" }
        format.json { render json: @context_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /context_options/1
  # PUT /context_options/1.json
  def update
    @context_option = ContextOption.find(params[:id])

    respond_to do |format|
      if @context_option.update_attributes(params[:context_option])
        format.html { redirect_to @context_option, notice: 'Context option was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @context_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /context_options/1
  # DELETE /context_options/1.json
  def destroy
    @context_option = ContextOption.find(params[:id])
    @context_option.destroy

    respond_to do |format|
      format.html { redirect_to context_options_url }
      format.json { head :no_content }
    end
  end
end
