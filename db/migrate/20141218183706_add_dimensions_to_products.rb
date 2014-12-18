class AddDimensionsToProducts < ActiveRecord::Migration
  def change
    remove_column :products, :dimensions
    add_column :products, :dimensions, :integer, array: true
  end
end
