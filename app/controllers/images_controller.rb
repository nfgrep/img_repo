class ImagesController < ApplicationController
    
    # GET
    def index
        @images = Image.all
    end

    # GET
    def show
        @image = Image.find(params[:id])
    end

    # GET
    def new
        @image = Image.new
    end

    # POST
    def create
        @image = Image.new(image_params)
        if @image.save
            redirect_to @image
        else
            render :new
        end
    end

    # DELETE
    def destroy
        @image = Image.find(params[:id])
        @image.file.purge_later
        @image.destroy
        redirect_to root_path
    end

    private
    def image_params
        params.require(:image).permit(:file, :title)
    end
end
