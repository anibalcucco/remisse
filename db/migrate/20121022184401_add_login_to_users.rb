class AddLoginToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.column :login, :string
    end
  end
end
