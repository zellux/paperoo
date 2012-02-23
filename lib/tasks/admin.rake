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
    if args[:start_user] == nil
      puts "Please specify the first presenter's user name like this:"
      puts "\trake admin:init_presentation[who]"
    else
      Presentation.init_round(args[:start_user])
    end
  end

  task :new_presentation_round => :environment do |t, args|
    Presentation.new_round
  end
end
