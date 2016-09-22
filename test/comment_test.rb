require_relative 'cast_about_for_setup'

test_framework = defined?(MiniTest::Test) ? MiniTest::Test : MiniTest::Unit::TestCase

class CommentTest < test_framework
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

    post_tom = Post.create(title: 'Tom', details: 'I am Tom.')
    post_jack = Post.create(title: 'Jack', details: 'I am Jack')

    Comment.create(details: 'I am Tom.', post: post_tom, created_at: Time.parse('2016-01-06 16:19:00 +0800'), updated_at: Time.parse('2016-01-07 16:19:00 +0800'))
    Comment.create(details: 'I am Jack.', post: post_jack, created_at: Time.parse('2016-02-07 16:19:00 +0800'), updated_at: Time.parse('2016-02-08 16:19:00 +0800'))
    Comment.create(details: 'I am Amy.', created_at: Time.parse('2016-03-08 12:10:00 +0800'), updated_at: Time.parse('2016-03-09 12:10:00 +0800'))
    Comment.create(details: 'I am Tony.', created_at: Time.parse('2016-04-09 13:29:00 +0800'), updated_at: Time.parse('2016-04-10 13:29:00 +0800'))
    Comment.create(details: 'I am Yasmine.', created_at: Time.parse('2016-05-10 19:13:00 +0800'), updated_at: Time.parse('2016-05-11 19:13:00 +0800'))
    Comment.create(details: 'I am Alex.', created_at: Time.parse('2016-06-09 13:09:00 +0800'), updated_at: Time.parse('2016-06-10 13:09:00 +0800'))
    Comment.create(details: 'I am James.', created_at: Time.parse('2016-07-01 16:19:00 +0800'), updated_at: Time.parse('2016-07-02 16:19:00 +0800'))
    Comment.create(details: 'I am Kevin.', created_at: Time.parse('2016-08-03 23:23:00 +0800'), updated_at: Time.parse('2016-08-04 23:23:00 +0800'))
    Comment.create(details: 'I am Zita.', created_at: Time.parse('2016-09-04 12:00:00 +0800'), updated_at: Time.parse('2016-09-05 12:00:00 +0800'))
    Comment.create(details: 'I am Zara.', created_at: Time.parse('2016-09-05 04:03:00 +0800'), updated_at: Time.parse('2016-09-06 04:03:00 +0800'))
  end

  def test_before_and_after_function_if_field_not_present_and_the_default_column_is_created_at
    params = {after_time: '2016-03-01', before_time: '2016-09-01'}
    assert_equal 6, Comment.cast_about_for(params).count
  end

  def test_before_and_after_function_set_the_exact_field_of_updated_at
    params = {after_time: '2016-03-01', before_time: '2016-09-01', previous: "2016-04-08", latter: "2016-06-11"}
    assert_equal 3, Comment.cast_about_for(params).count
  end

  def test_the_block_function
    params = { title: "Tom", details: "To" }
    comments = Comment.cast_about_for(params) do |comments, cast_params|
      comments = comments.joins(:post).where("posts.title Like ?", "%#{cast_params[:title]}%")  if cast_params[:title].present?
      comments.joins(:post).where("posts.details Like ?", "%#{cast_params[:details]}%") if cast_params[:details].present?
    end
    assert_equal 1, comments.count
  end

end
