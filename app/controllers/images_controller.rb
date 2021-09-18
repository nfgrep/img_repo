require 'fuzzystringmatch'

class ImagesController < ApplicationController

    def index
        @images = Image.all
    end

    def show
        @image = Image.find(params[:id])
    end

    def new
        @image = Image.new
    end

    def create
        @image = Image.new(image_params)
        if @image.save
            redirect_to @image
        else
            render :new
        end
    end

    def destroy
        @image = Image.find(params[:id])
        @image.delete
        
        redirect_to root_path
    end

    def search
        # this wont scale but hey, I got 3 days left
        @jarow = FuzzyStringMatch::JaroWinkler.create( :native )
        @results = Array.new
        if params[:query]
            Image.all.each do |image|
                if @jarow.getDistance(image.title, params[:query]) > 0.5
                    @results.push(image)
                end
            end
        end
    end

    private
    def image_params
        params.require(:image).permit(:file, :title)
    end
end
