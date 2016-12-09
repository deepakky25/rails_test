class AddImgnameToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :imgname, :string
  end
end
