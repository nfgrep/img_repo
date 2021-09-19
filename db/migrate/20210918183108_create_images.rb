# frozen_string_literal: true
class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table(:images) do |t|
      t.string(:title)

      t.timestamps
    end
  end
end
