class AddTitleToImages < ActiveRecord::Migration[6.1]
  def change
    add_column :images, :title, :string
  end
end
