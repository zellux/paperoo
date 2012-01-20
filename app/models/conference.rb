class Conference < ActiveRecord::Base
  paginates_per 20

  has_many :articles
end
