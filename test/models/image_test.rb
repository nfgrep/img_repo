# frozen_string_literal: true
require "test_helper"

class ImageTest < ActiveSupport::TestCase
  test "image size too large" do
    image = Image.new
    image.file.attach(io: File.open("test/fixtures/files/large.png"), filename: "large.png", content_type: "image/png")
    assert_not image.valid?
    assert_not_empty image.errors[:file]
  end

  test "image has no title" do
    image = Image.new
    assert_not image.valid?
    assert_not_empty image.errors[:title]
  end

  test "image has no file" do
    image = Image.new
    assert_not image.valid?
    assert_not_empty image.errors[:file]
  end

  test "image incorrect mime type" do
    image = Image.new
    image.file.attach(io: File.open("test/fixtures/files/test.pdf"), filename: "test.pdf",
      content_type: "application/pdf")
    assert_not image.valid?
    assert_not_empty image.errors[:file]
  end

  test "image size not number" do
    image = Image.new
    resized = image.get_size("ff")
    assert_equal resized, image.file
  end
end
