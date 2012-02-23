class AddPositionAssistantToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :presentation_position, :integer
    add_column :accounts, :assistant_id, :integer
  end
end
