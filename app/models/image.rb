# frozen_string_literal: true
require 'fuzzystringmatch'

class Image < ApplicationRecord
  has_one_attached(:file)

  validates :title, presence: true, length: { minimum: 3, maximum: 30 }
  validates :file, presence: true

  validate :file_smallerthan_2m
  validate :file_correct_mimetype

  ACCEPTED_MIME_TYPE = Set['image/png', 'image/jpeg']

  def self.search(query)
    results = []

    # GC, dont fail me now
    @fuzzymatcher = FuzzyStringMatch::JaroWinkler.create(:native)

    # this probably wont scale
    Image.all.each do |image|
      results.push(image) if @fuzzymatcher.getDistance(image.title, query) > 0.4 # 0.4 should be a var
    end
    results
  end

  # not a good name
  def get_size(size)
    size.to_i != 0 ? file.variant(resize_to_fit: [size, size]) : file
  end

  private

  def file_smallerthan_2m
    return unless file.attached?
    if file.byte_size > 2.megabytes
      errors.add(:file, 'size larger than 2M maximum')
    end
  end

  def file_correct_mimetype
    return unless file.attached?
    unless ACCEPTED_MIME_TYPE.include?(file.content_type)
      errors.add(:file, "incorrect mime type: #{file.content_type}")
    end
  end
end
