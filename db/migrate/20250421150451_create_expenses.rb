class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.decimal :amount, precision: 6, scale: 2
      t.datetime :received_at

      t.timestamps
    end
  end
end
