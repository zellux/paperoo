require 'nokogiri'

module Crawler
  def raw_data_path(conference, i, type)
    "#{Rails.root}/db/raw_data/#{conference.to_url}-#{i}.#{type}"
  end

  def crawl_acm_index(index_url, conference_id)
    agent = Mechanize.new { |agent|
      agent.user_agent_alias = 'Windows Mozilla'
    }

    pid = index_url[/id\=(\d+)\&/, 1]
    about_url = "http://dl.acm.org/tab_about.cfm?id=#{pid}&type=proceeding&parent_id=#{pid}"
    page = agent.get(about_url)
    links = page.links.select { |l| l.href[/citation/] }
    c = Conference.find(conference_id)
    puts "Crawling papers for #{c.title}"
    if File.exists?(raw_data_path(c.title, links.count - 1, 'bibtex'))
      puts "Already there, skipped"
      return
    end
    links.each_with_index do |l, i|
      if File.exists?(raw_data_path(c.title, i, 'bibtex'))
        next
      end
      url = "http://dl.acm.org/#{l.href}"
      body = agent.get(url).body
      url = "http://dl.acm.org/" + body[/'(exportformats.*endnotes)'/, 1]
      page = agent.get(url)
      endnote = page.parser.css('pre').first.content
      bib_url = "http://dl.acm.org/" + body[/'(exportformats.*bibtex)'/, 1]
      bib_page = agent.get(bib_url)
      bibtex = bib_page.parser.css('pre').first.content
      f = File.open(raw_data_path(c.title, i, 'endnote'), "w")
      f.write(endnote)
      f.close
      f = File.open(raw_data_path(c.title, i, 'bibtex'), "w")
      f.write(bibtex)
      f.close
      article = Article.create_from_endnote(endnote, { :conference_id => conference_id })
      next if article.nil?
      puts "Creating artitle #{article.title}"
      article.save
    end
  end

  def parse_acm_index(html)
    doc = Nokogiri::HTML.parse(html)
    proceedings = {}
    doc.css('ul li a').each do |a|
      title, fullname = a.content.split(':', 2)
      proceedings[title] = { 'fullname' => fullname, 'url' => a['href'] }
    end
    puts proceedings.to_yaml
  end

  def update_conferences(filter, change=false)
    conferences = YAML.load(File.open(Rails.root + 'db/acm_conferences.yml'))
    conferences.keys.select { |e| filter.call(e) }.each do |t|
      c = conferences[t]
      puts "#{t}: \t #{c['fullname']}"
      if change
        con = Conference.find_or_create_by_title(:title => t, :booktitle => c['fullname'])
        crawl_acm_index("http://dl.acm.org/#{c['url']}", con.id)
      end
    end
  end

  def import_conferences(filter)
    conferences = YAML.load(File.open(Rails.root + 'db/acm_conferences.yml'))
    conferences.keys.select { |e| filter.call(e) }.each do |t|
      c = conferences[t]
      if File.exists?(raw_data_path(t, 0, 'endnote'))
        puts "Importing papers for #{t}"
        con = Conference.find_or_create_by_title(:title => t, :booktitle => c['fullname'])
        i = 0
        while true do
          path = raw_data_path(t, i, 'endnote')
          break unless File.exists?(path)
          endnote = File.open(path).read
          article = Article.create_from_endnote(endnote, { :conference_id => con.id })
          i += 1
        end
      end
    end
  end
end
