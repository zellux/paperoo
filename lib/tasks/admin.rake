$: << (Rails.root + 'lib/admin')
require 'admin.rb'

namespace :admin do
  include Admin

  task :assign_position, [:position_file] => :environment do |t, args|
    assign_position(args.position_file)
  end

  task :assign_assistant, [:assistant_file] => :environment do |t, args|
    assign_assistant(args.assistant_file)
  end
end
