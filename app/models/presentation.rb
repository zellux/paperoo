# == Schema Information
#
# Table name: presentations
#
#  id            :integer         not null, primary key
#  article_id    :integer
#  account_id    :integer
#  assigner_id   :integer
#  assigned_date :datetime
#  presented_on  :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

class Presentation < ActiveRecord::Base
  belongs_to :article
  belongs_to :account, :class_name => "Account"
  belongs_to :assigner, :class_name => "Account", :foreign_key => :assigner_id

  def self.next_meeting_day(date = nil)
    date = DateTime.now unless date
    # XXX hard coded, meeting happen on monday and thursday
    until date.monday? or date.thursday?
      date += 1.day
    end
    return date
  end

  def self.init_assignment(username)
    start_user = Account.where("username = ?", username).first
    position = start_user.presentation_position

    meeting_day = next_meeting_day
    largest_position = Account.largest_position
    largest_position.times do
      acc = Account.find(position)
      pres = Presentation.create!(account: acc,
                                  assigned_date: meeting_day)
      pres.save!
      position += 1
      position = 1 if position > largest_position
    end
  end
end
