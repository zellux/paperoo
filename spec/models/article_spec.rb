require 'spec_helper'

describe Article do
  describe 'extracting authors' do
    it 'should work with ACM bibtex format' do
      Article.extract_authors('Arnold, Jeff and Kaashoek, M. Frans').should == ['Jeff Arnold', 'M. Frans Kaashoek']
      Article.extract_authors('Zhang, Fengzhe and Chen, Jin and Chen, Haibo and Zang, Binyu').should == ['Fengzhe Zhang', 'Jin Chen', 'Haibo Chen', 'Binyu Zang']
    end

    it 'should handle single name correctly' do
      Article.extract_authors('Single, Name').should == ['Name Single']
    end

    it 'should convert non-alphabeta charatecters' do
      Article.extract_authors("Erlingsson, \\\'{U}lfar").should == ['Ulfar Erlingsson']
    end
  end

  describe 'author ordering' do
    it 'sorts authors based on position attribute' do
      article = Article.create!
      a1 = Author.create!
      a2 = Author.create!
      a3 = Author.create!
      AuthorLine.create!(:article_id => article.id, :author_id => a1.id, :position => 3)
      AuthorLine.create!(:article_id => article.id, :author_id => a2.id, :position => 1)
      AuthorLine.create!(:article_id => article.id, :author_id => a3.id, :position => 2)
      article.authors.should == [a2, a3, a1]
    end
  end
end
