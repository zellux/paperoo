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

  attr_accessible :article, :account, :assigned_date

  # Will report already taken even if null?
  #validates :article_id, :uniqueness => true
  validates :account_id, :presence => true

  # XXX Used in _form, is there better way to get nested model's field?
  def article_title
    article ? article.title.chomp : ''
  end

  def account_username
    account ? account.username : ''
  end

  def assign(assigner, presenter, article)
    self.account = presenter
    self.assigner = assigner
    self.article = article

    # Calculate presentation date according to the position of presenter
    position = presenter.presentation_position
  end

  def self.next_meeting_day(date = nil)
    date = DateTime.now unless date
    # XXX hard coded, meeting happen on monday and thursday
    until date.monday? or date.thursday?
      date += 1.day
    end
    return date
  end

  # This is only used when there's no presentation
  def self.init_round(username)
    start_user = Account.where("username = ?", username).first
    position = start_user.presentation_position
    new_round(position)
  end

  def self.new_round(start_position = nil)
    position = start_position || 1

    # XXX hard coded, 2 presenters each meeting
    latest_pres = order("assigned_date DESC").first
    if latest_pres
      latest_day = latest_pres.assigned_date
      # XXX find out how ActiveRecord supports SQL count
      latest_count = where("assigned_date = ?", latest_day).limit(2).all.size
      meeting_day = latest_count == 1 ?
        latest_day :
        next_meeting_day(latest_day + 1.day)
    else
      latest_count = 0
      meeting_day = next_meeting_day
    end

    largest_position = Account.largest_position
    largest_position.times do |i|
      acc = Account.where("presentation_position = ?", position).first
      pres = Presentation.create!(account: acc,
                                  assigned_date: meeting_day)
      position += 1
      position = 1 if position > largest_position

      # Tricky here. If latest_count is 1, we need to update meeting_day after
      # creating the first presentation
      if (latest_count + i) % 2 == 1
        meeting_day = next_meeting_day meeting_day + 1.day
      end
    end
  end

end
