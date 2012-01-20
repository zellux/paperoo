class RenameProceedingToConference < ActiveRecord::Migration
  def up
    rename_table :proceedings, :conferences
  end

  def down
    rename_table :conferences, :proceedings
  end
end
