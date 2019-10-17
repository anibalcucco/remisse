class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""
      t.string :name

      t.timestamps
    end

    add_index :users, :email,                :unique => true
  end
end
