class CreateIncomes < ActiveRecord::Migration[7.1]

  def change
    create_table :incomes do |t|
      t.references :customer, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :source, null: false

      t.timestamps
    end
  end

end
