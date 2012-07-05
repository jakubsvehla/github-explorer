class AddRegexpToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :regexp, :string
  end
end