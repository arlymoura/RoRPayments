class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.references :user, null: true, foreign_key: true
      t.string :name
      t.string :email
      t.string :external_id

      t.timestamps
    end
  end
end
