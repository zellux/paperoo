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

  def assign(assigner, presenter, article)
    self.account = presenter
    self.assigner = assigner
    self.article = article
    self.create_date = DateTime.now

    # Calculate presentation date according to the position of presenter
    position = presenter.presentation_position
  end

  def self.next_unassigned_date(account, position)
    last_present = where("account_id = ?", account.id).order("assigned_date DESC")
    return next_meeting_day unless latest_present

    largest_position = Account.largest_position
    if largest_position.odd?
    end
    #latest_pos = latest_present.account.presentation_position
    #delta = latest_pos < position ?
      #position - latest_pos :
      #largest_position - latest_pos + position

    #delta = delta / 2
  end

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
