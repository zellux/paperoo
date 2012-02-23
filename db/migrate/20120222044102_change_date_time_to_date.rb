class ChangeDateTimeToDate < ActiveRecord::Migration
  def change
    change_column :presentations, :assigned_date, :date
    change_column :presentations, :presented_on, :date
  end
end
