class ArticlesController < ApplicationController
	before_action :set_article, only: [:update, :show, :edit, :destroy]
	before_action :require_user, except: [:index, :show]
	before_action :require_same_user, only: [:edit, :update, :delete]

	def index
		@articles = Article.paginate(page: params[:page], per_page: 5)
	end
	def new
		@article = Article.new
	end
	def create
		#render plain: params[:article]	
			
		@article = Article.new(article_params)
		@article.user = current_usergit 		
		if @article.save
			flash[:success] = "Article was succesfully created"
			redirect_to article_path(@article)
		else
			render 'new'
		end		
	end

	def show
	end

	def edit
	end

	def update
		if @article.update(article_params)
			flash[:success] = "Article was succesfully updated"
			redirect_to article_path(@article)
		else
			render 'edit'
		end
	end

	def destroy
		@article.destroy
		flash[:danger] = "Article was succesfully deleted"
		redirect_to articles_path
	end

end

private
	def set_article
		@article = Article.find(params[:id])
	end
	def article_params
		params.require(:article).permit(:title, :description)
	end

	def require_same_user
		if current_user != @article.user and !current_user.admin?
			flash[:danger] = "You can only edit or delete your own articles"
			redirect_to root_path
		end
	end

