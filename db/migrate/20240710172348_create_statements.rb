class CreateStatements < ActiveRecord::Migration[7.1]

  def change
    create_table :statements do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :ie_rating, default: "not_calculated", null: false
      t.decimal :disposable_income_amount, precision: 10, scale: 2

      t.timestamps
    end
  end

end
