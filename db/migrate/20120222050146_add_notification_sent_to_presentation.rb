class AddNotificationSentToPresentation < ActiveRecord::Migration
  def change
    add_column :presentations, :notification_sent, :boolean
  end
end
