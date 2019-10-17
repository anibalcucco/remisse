class CreateAutos < ActiveRecord::Migration[5.2]
  def change
    create_table :autos do |t|
      t.string :nombre
      t.string :oblea

      t.timestamps
    end
  end
end
