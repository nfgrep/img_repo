class Image < ApplicationRecord
    include Searchable

    has_one_attached :file

    validates :title, presence: true, length: { minimum: 3, maximum: 30 }
    validates :file, presence: true

    validate :image_smallerthan_2M

    def image_smallerthan_2M

        return unless file.attached?

        if file.byte_size > 2.megabytes
            errors.add(:file, "size larger than 2M maximum")
        end

    end
end
