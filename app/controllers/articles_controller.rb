class ArticlesController < TripResourceController

  def index
    authorize @trip, :show?
    @articles = @trip.articles.reverse
  end

  def show
    authorize @trip, :show?
    @article = @trip.articles.find(params[:id])
  end

  def new
    authorize @trip, :update?
    @article = @trip.articles.build
  end

  def create
    authorize @trip, :update?
    @article = @trip.articles.build(article_params)

    if @article.save
      #flash[:notice] = I18n.t 'trip_article_created'
      redirect_to [@trip, @article]
    else
      #flash[:alert] = I18n.t 'trip_article_not_created'
      render 'new'
    end
  end

  def edit
    authorize @trip, :update?
    @article = @trip.articles.find(params[:id])
  end

  def update
    authorize @trip, :update?
    @article = @trip.articles.find(params[:id])

    if @article.update(article_params)
      #flash[:notice] = I18n.t 'trip_article_updated'
      redirect_to [@trip, @article]
    else
      #flash[:alert] = I18n.t 'trip_article_not_updated'
      render 'new'
    end
  end

  def destroy
    authorize @trip, :update?
    @article = @trip.articles.find(params[:id])

    @article.destroy
    flash[:notice] = I18n.t 'trip_article_destroyed'
    redirect_to trip_articles_path(@trip)
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :public)
  end
end
