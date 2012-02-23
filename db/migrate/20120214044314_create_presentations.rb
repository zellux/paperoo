class CreatePresentations < ActiveRecord::Migration
  def change
    create_table :presentations do |t|
      t.references :article, :unique => true
      t.references :account
      t.integer :assigner_id

      t.datetime :assigned_date
      t.datetime :presented_on  # Actual present date

      t.timestamps
    end
  end
end
