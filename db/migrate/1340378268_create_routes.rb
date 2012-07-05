class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :method
      t.string :name
      t.references :category
    end
    add_index :routes, :category_id
  end
end