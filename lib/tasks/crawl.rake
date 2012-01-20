$: << (Rails.root + 'lib/crawler')
require 'crawler.rb'

namespace :crawl do
  include Crawler
  # filter = lambda { |e| e[/SOSP .*/] && e != "SOSP '09" && e != "SOSP '11" }
  # keywords = %w(OSDI ASPLOS CCS SOSP ISCA MICRO HPCA NSDI PLDI PPoPP MobiCom PACT VEE)
  keywords = %w(EuroSys)
  filter = lambda { |e| keywords.any? { |k| e[/^#{k} .*/] } }

  task :show => :environment do
    update_conferences(filter, false)
  end

  task :update => :environment do
    update_conferences(filter, true)
  end

  task :import => :environment do
    import_conferences(filter)
  end
end
