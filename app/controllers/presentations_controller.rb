class PresentationsController < ApplicationController
  # GET /presentations
  # GET /presentations.json
  def index
    page_id = params[:page] || 1
    if params[:presented]
      # Show all presentation
      @presentations = Presentation.where("presented_on not null").
        order('assigned_date desc').
        page(page_id)
    else
      # Show only not presented
      @presentations = Presentation.where("presented_on is null").
        order('assigned_date asc').
        page(page_id)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @presentations }
    end
  end

  # GET /presentations/1
  # GET /presentations/1.json
  def show
    @presentation = Presentation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @presentation }
    end
  end

  # GET /presentations/new
  # GET /presentations/new.json
  def new
    @presentation = Presentation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @presentation }
    end
  end

  # GET /presentations/1/edit
  def edit
    @presentation = Presentation.find(params[:id])
  end

  # POST /presentations
  # POST /presentations.json
  def create
    @presentation = Presentation.new(params[:presentation])
    presenthash = params[:presentation]

    article = Article.find_by_title(presenthash[:article_title])
    @presentation.article = article

    account = Account.where(:username => presenthash[:account_username]).first
    @presentation.account = account

    respond_to do |format|
      # Check for uniquess. Using ActiveModel validation doesn't allow null.
      if article == nil and presenthash[:article_title] != ''
        format.html { render action: "new", notice: 'Article not found.' }
        format.json { render json: @presentation.errors, status: :article_not_found, location: @presentation }
      elsif article and not Presentation.unique_article?(article)
        format.html { render action: "new", notice: 'Article already taken.' }
        format.json { render json: @presentation.errors, status: :article_taken, location: @presentation }
      elsif @presentation.save
        format.html { redirect_to @presentation, notice: 'Presentation was successfully created.' }
        format.json { render json: @presentation, status: :created, location: @presentation }
      else
        format.html { render action: "new", notice: @presentation.errors }
        format.json { render json: @presentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /presentations/1
  # PUT /presentations/1.json
  def update
    @presentation = Presentation.find(params[:id])
    presenthash = params[:presentation]

    respond_to do |format|
      article = Article.find_by_title(presenthash[:article_title])
      if article == nil
        format.html { render action: "edit", notice: "Article not found" }
        # TODO In page editing
        format.json { render status: :no_article}
      else
        # Check for uniqueness
        unless Presentation.unique_article?(article)
          format.html { render action: "edit", :notice => "Article already taken" }
          format.json { render json: @presentation, status: :created, location: @presentation }
        else
          presenthash[:article] = article
          if @presentation.update_attributes(params[:presentation])
            format.html { redirect_to @presentation, notice: 'Presentation was successfully updated.' }
            format.json { head :ok }
          else
            format.html { render action: "edit" }
            format.json { render json: @presentation.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end

  # DELETE /presentations/1
  # DELETE /presentations/1.json
  def destroy
    @presentation = Presentation.find(params[:id])
    @presentation.destroy

    respond_to do |format|
      format.html { redirect_to presentations_url }
      format.json { head :ok }
    end
  end

  def set_presented
    @presentation = Presentation.find(params[:id].to_i)

    # User account checking
    if current_account.username != @presentation.account.username
      format.html { redirect_to presentations_url, notice: "Can't set presented on for others presentation." }
      format.json { render :status => :no_permission}
      return
    end

    @presentation.update_attribute(:presented_on, DateTime.now)
    respond_to do |format|
      format.html { redirect_to presentations_url }
      format.json { head :ok }
    end
  end

  def new_round
    Presentation.new_round
  end

  def notify_upcoming
    Presentation.upcoming.each do |pres|
      begin
        PresentationMailer.notification(pres).deliver
        pres.notification_sent = true
        pres.save!

        respond_to do |format|
          format.json { head :ok }
        end
      rescue
        # Do nothing here
      end
    end
  end
end
