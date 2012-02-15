$: << (Rails.root + 'lib/admin')
require 'admin.rb'

namespace :admin do
  include Admin

  task :assign_position => :environment do |t, args|
    assign_position(Rails.root + 'db/position.yml')
  end

  task :assign_assistant => :environment do |t, args|
    assign_assistant(Rails.root + 'db/assistant.yml')
  end

  task :init_presentation, [:start_user] => :environment do |t, args|
    Presentation.init_assignment(args.start_user)
  end
end
