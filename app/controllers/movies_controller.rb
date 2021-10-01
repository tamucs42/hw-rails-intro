class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @movies = Movie.all
      @all_ratings = ['G','PG','PG-13','R']
      
      # Update curr session
      if params.has_key?(:order) or params.has_key?(:ratings)
        session[:order] = params[:order]
        session[:ratings] = params[:ratings]
      end
      
      # Update checkbox ratings
      if params.has_key?(:ratings)
        selected_ratings = params[:ratings].keys()
      else
        selected_ratings = @all_ratings
      end
      
      # Sort asc by movie title or release date from app/views/movies/index.html.erb
      #if params.has_key?(:order)
        #redirect_to movies_path
      #end
      if params[:order] == 'date'
        @movies = Movie.where(rating: selected_ratings).order(:release_date)
        #@release_date_header = 'hilite p-3 mb-2 bg-warning text-dark'
      elsif params[:order] == 'title'
        @movies = Movie.where(rating: selected_ratings).order(:title)
        #@title_header = 'hilite p-3 mb-2 bg-warning text-dark'
      elsif !params.has_key?(:ratings) and !session.has_key?(:ratings) #brand new session, show all movies
        @movies = Movie.all.where(rating: selected_ratings)
      else
        @movies = Movie.where(rating: selected_ratings)
      end
        
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end