require "test_helper"

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = images(:img)
  end

  test "should get index" do
    get images_url
    assert_response :success
  end

  test "should get new" do
    get new_image_url
    assert_response :success
  end

  test "should create image" do
    # asserts that the number of images has increased after creation
    assert_difference('Image.count') do
      post images_url, params: { image: { title: "woah", file: fixture_file_upload("test.png", "image/png") } }
    end

    assert_redirected_to image_url(Image.last)
    assert_equal "test.png", Image.last.file.filename.to_s
  end

  test "should show image" do
    get image_url(@image)
    assert_response :success

    assert_select "img", src: url_for(@image.file.variant(resize_to_limit: [500, 500] ))
  end

end
