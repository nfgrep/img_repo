class ImagesController < ApplicationController

    def index
        @images = Image.all
        render json: @images
    end

    def show
        @image = Image.find(params[:id])
        render json: @image
    end

    def create
        @image = Image.create(image_params)
        render json: @image
    end

    def destroy
        @image = Image.find(params[:id])
        @image.delete
        @image.pur
        
        render json: @image
    end

    def search
        # this wont scale but hey, I got 3 days left
        # Image.search(params[:query])
    end

    private
    def image_params
        params.require(:image).permit(:file, :title)
    end

end
