class AddSpamToComments < ActiveRecord::Migration
  def change
    add_column :comments, :spam, :int
  end
end
