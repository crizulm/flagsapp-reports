class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.integer :total_request
      t.integer :true_answer
      t.integer :false_answer
      t.integer :false_answer
      t.decimal :total_time
      t.string :flag

      t.timestamps
    end
  end
end
