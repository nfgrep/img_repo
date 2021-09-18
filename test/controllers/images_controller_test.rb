require "test_helper"

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = images(:img)
  end

  test "should get index" do
    get images_url
    assert_response :success
  end

  test "should get search" do
    get search_images_path("test_query")
    assert_response :success
  end

  test "should create image" do
    assert_difference('Image.count') do
      post images_url, params: { title: "test!", file: fixture_file_upload("test.png", "image/png") }
    end
    assert_response :success
    assert_equal "test!", @response.parsed_body['title']
  end

  test "should redirect to image file" do
    get image_url(@image)
    assert_redirected_to url_for(@image.file)
  end

end
