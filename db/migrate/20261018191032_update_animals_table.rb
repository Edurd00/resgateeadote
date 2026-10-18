class UpdateAnimalsTable < ActiveRecord::Migration[7.1]
  def up
    change_table :animals do |t|
      t.integer :species
      t.string :age
      t.integer :sex
      t.integer :size
      t.text :temperament
      t.text :health_status
      t.integer :status, default: 0
      t.text :description
      t.string :city
      t.string :state
      t.references :user, foreign_key: true
    end
  end

  def down
    change_table :animals do |t|
      t.remove :species, :age, :sex, :size, :temperament, :health_status, :status, :description, :city, :state
      t.remove_references :user
    end
  end
end
