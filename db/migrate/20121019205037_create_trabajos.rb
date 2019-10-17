class CreateTrabajos < ActiveRecord::Migration[5.2]
  def change
    create_table(:trabajos) do |t|
      t.date :fecha
      t.references :auto
      t.boolean :pagado
      t.string :monto

      t.timestamps
    end
  end
end
