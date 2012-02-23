class AddArticleUniquenessInPresentation < ActiveRecord::Migration
  def change
    add_index :presentations, :article_id, :unique => true
  end
end
