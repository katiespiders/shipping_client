class AddDimensionsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :dimensions, :integer, array: true
  end
end
