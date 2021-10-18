# frozen_string_literal: true
class ImagesController < ApplicationController
  def index
    @images = Image.all
    render(json: @images)
  end

  def show
    @image = Image.find(params[:id])
    redirect_to(url_for(@image.get_size(params[:size])))
  end

  def create
    @image = Image.new(image_params)
    @image.save ? render(json: @image) : render(json: @image.errors)
  end

  def destroy
    @image = Image.find(params[:id])
    @image.file.purge_later
    @image.delete
    render(json: @image)
  end

  def search
    render(json: Image.search(params[:query]))
  end

  private

  def image_params
    params.require(:file)
    params.require(:title)
    params.permit(:file, :title)
  end
end
