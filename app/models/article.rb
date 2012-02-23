# == Schema Information
#
# Table name: articles
#
#  id            :integer(4)      not null, primary key
#  title         :string(255)
#  abstract      :text
#  conference_id :integer(4)
#  year          :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  page_start    :integer(4)
#  page_end      :integer(4)
#  pageview      :integer(4)      default(0)
#

require 'bibtex'

class Article < ActiveRecord::Base
  paginates_per 20

  belongs_to :conference, :counter_cache => :articles_count
  has_many :author_lines, :dependent => :destroy
  has_many :authors, :through => :author_lines, :order => 'author_lines.position'
  has_many :likes, :as => :likeable
  has_many :comments, :as => :commentable
  has_one  :presentation

  validates :conference, :presence => true
  # validates :author_lines, :presence => true

  attr_accessor :author_list

  def presenter
    presentation ? presentation.account.username : ''
  end

  def self.create_from_bibtex(bibtex, optional={})
    hash = hash_from_bibtex(bibtex).merge(optional)
    return nil if hash['author_list'].blank?
    article = Article.create(hash.except('author_list'))
    article.author_list = hash['author_list']
    article.save
    article
  end

  def self.create_from_endnote(bibtex, optional={})
    hash = hash_from_endnote(bibtex).merge(optional)
    return nil if hash['author_list'].blank?
    article = Article.create(hash.except('author_list'))
    article.author_list = hash['author_list']
    article.save
    article
  end

  def self.hash_from_bibtex(bibtex)
    bib = BibTeX.parse(bibtex)[0]
    hash = {
      'title' => bib[:title].to_s,
      'year' => bib[:year].to_i,
    }
    authors = extract_authors(bib[:author].to_s)
    hash.merge!({
        'author_list' => authors.join('|')
      }) if authors
    if bib[:pages]
      n1, n2 = bib[:pages].split('--').map(&:to_i)
      hash.merge!({
          'page_start' => n1,
          'page_end' => n2
        })
    end
    hash
  end

  def self.hash_from_endnote(endnote)
    authors = []
    hash = {}
    endnote.each_line do |l|
      t, v = l.split(' ', 2)
      if t == '%A'
        authors << HTMLEntities.new.decode(v)
      elsif t == '%P'
        hash['page_start'], hash['page_end'] = v.split('-').map(&:to_i)
      elsif t == '%D'
        hash['year'] = v
      elsif t == '%T'
        hash['title'] = v
      end
    end
    unless authors.blank?
      hash['author_list'] = authors.join('|')
    end
    hash
  end

  def self.create_from_format(format, data)
    if format == 'bibtex'
      create_from_bibtex(data)
    elsif format == 'endnote'
      create_from_endnote(data)
    else
      raise "Not supported format #{format}"
    end
  end

  def self.extract_authors(raw)
    raw.gsub!(/[^\w\ \.\,]/, '')
    if raw[/ and /]
      raw.split(' and ').map { |e| e.split(',').reverse.map(&:strip).join(' ') }
    elsif raw[/,/]
      splitted = raw.split(',')
      if splitted.count == 2
        # Single name case
        [splitted.reverse.map(&:strip).join(' ')]
      else
        splitted.map { |e| e.strip.sub(',', '') }
      end
    else
      nil
    end
  end

  def self.find_by_title(title)
    title ? article = Article.where("title = ?", title.chomp + "\n").first : nil
  end

  def author_list
    if self.authors.nil?
      ''
    else
      self.authors.map(&:name).join('|')
    end
  end

  def author_list=(raw)
    self.authors.clear
    raw.split('|').map(&:strip).each_with_index do |e, i|
      next if e.blank?
      author = Author.find_or_create_by_name(e)
      # self.author_lines.build({ :author_id => author.id, :position => i })
      AuthorLine.create(:author_id => author.id, :article_id => self.id, :position => i)
    end
    self.authors.reload
  end
end
