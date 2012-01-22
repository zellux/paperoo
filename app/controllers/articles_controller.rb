class ArticlesController < ApplicationController
  before_filter :authenticate_account!, :except => [:index, :show, :autocomplete_article_title]
  before_filter :update_page_view, :only=> [:show]
  autocomplete :article, :title, :full => true

  protect_from_forgery :except => :upload

  # GET /articles
  # GET /articles.json
  def index
    page_id = params[:page] || 1
    @articles = Article.order('comments_count desc').page(page_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  def upload
    file = CarrierwaveStringIO.new(params[:qqfile], request.raw_post)
    if params[:type] == 'endnote'
      hash = Article.hash_from_endnote(file.read())
    elsif params[:type] == 'bibtex'
      hash = Article.hash_from_bibtex(file.read())
    end

    respond_to do |format|
      format.json { render json: hash }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id])
    if current_account
      @like = @article.likes.where(:account_id => current_account).first
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(params[:article].except(:author_list))
    if @article.save
      @article.author_list = params[:article][:author_list]
      success = @article.save
    else
      success = false
    end

    respond_to do |format|
      if success
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
    logger.debug @article.errors.inspect
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :ok }
    end
  end

  def toggle_like
    @article = Article.find(params[:id])
    like = @article.likes.where(:account_id => current_account).first
    if like.nil?
      @article.likes.create(:likeable_id => params[:id], :likeable_type => self.class.to_s, :account_id => current_account.id)
      status = 'liked'
    else
      like.destroy
      status = 'unliked'
    end

    respond_to do |format|
      format.json { render json: { 'status' => status } }
    end
  end

  protected

  def update_page_view
    Article.update_counters params[:id], :pageview => 1
  end
end
