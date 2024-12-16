class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.string :external_id
      t.decimal :amount
      t.string :status
      t.string :payment_method
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
