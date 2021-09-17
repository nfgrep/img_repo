require "test_helper"

class ImageTest < ActiveSupport::TestCase
  
  test "image size too large" do
    image = Image.new()
    image.file.attach io: File.open("test/fixtures/files/large.jpg"), filename: "large.png", content_type: "image/jpg"
    assert_not image.valid?
    assert_not_empty image.errors[:file]
  end

  test "image has no title" do 
    image = Image.new()
    assert_not image.valid?
    assert_not_empty image.errors[:title]
  end

  test "image has no file" do
    image = Image.new()
    assert_not image.valid?
    assert_not_empty image.errors[:file]
  end

end
