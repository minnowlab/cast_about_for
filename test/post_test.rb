require_relative 'cast_about_for_setup'

test_framework = defined?(MiniTest::Test) ? MiniTest::Test : MiniTest::Unit::TestCase

class PostTest < test_framework
  def setup
    connection = ActiveRecord::Base.connection
    cleaner = ->(source) {
      ActiveRecord::Base.connection.execute "DELETE FROM #{source}"
    }

    if ActiveRecord::VERSION::MAJOR < 5
      connection.tables.each(&cleaner)
    else
      connection.data_sources.each(&cleaner)
    end

    Post.create(title: 'Tom', details: 'I am Tom.', created_at: '2016-07-06 16:19:00 +0800', published_at: '2016-07-07 16:19:00 +0800')
    Post.create(title: 'Jack', details: 'I am Jack.', created_at: '2016-07-06 16:19:00 +0800', published_at: '2016-07-08 16:19:00 +0800')
    Post.create(title: 'Amy', details: 'I am Amy.', created_at: '2016-07-06 12:10:00 +0800', published_at: '2016-07-08 16:19:00 +0800')
    Post.create(title: 'Tony', details: 'I am Tony.', created_at: '2016-07-06 13:29:00 +0800', published_at: '2016-07-09 16:19:00 +0800')
    Post.create(title: 'Yasmine', details: 'I am Yasmine.', created_at: '2016-07-06 19:13:00 +0800', published_at: '2016-07-09 16:19:00 +0800')
    Post.create(title: 'Alex', details: 'I am Alex.', created_at: '2016-07-06 13:09:00 +0800', published_at: '2016-07-09 16:19:00 +0800')
    Post.create(title: 'James', details: 'I am James.', created_at: '2016-08-06 16:19:00 +0800', published_at: '2016-08-07 16:19:00 +0800')
    Post.create(title: 'Kevin', details: 'I am Kevin.', created_at: '2016-08-06 23:23:00 +0800', published_at: '2016-08-07 16:19:00 +0800')
    Post.create(title: 'Zita', details: 'I am Zita.', created_at: '2016-08-06 12:00:00 +0800', published_at: '2016-08-08 16:19:00 +0800')
    Post.create(title: 'Zara', details: 'I am Zara.', created_at: '2016-08-06 04:03:00 +0800', published_at: '2016-08-09 16:19:00 +0800')
  end

end
