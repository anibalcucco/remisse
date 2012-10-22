class AddLoginToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.column :login, :string
    end
  end
end
