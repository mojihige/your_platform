class MakeAllPreviousPagesPublished < ActiveRecord::Migration
  def up
    Page.connection.execute "update pages as p set p.published_at = p.created_at where true"
  end
  def down
  end
end
