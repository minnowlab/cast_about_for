# require_relative 'cast_about_for_setup'

# test_framework = defined?(MiniTest::Test) ? MiniTest::Test : MiniTest::Unit::TestCase

# class CastAboutForTest < test_framework
#   def setup
#     connection = ActiveRecord::Base.connection
#     cleaner = ->(source) {
#       ActiveRecord::Base.connection.execute "DELETE FROM #{source}"
#     }

#     if ActiveRecord::VERSION::MAJOR < 5
#       connection.tables.each(&cleaner)
#     else
#       connection.data_sources.each(&cleaner)
#     end

#     @tom = User.create(name: 'Tom', introduce: 'I am Tom.', sex: true, profession: 0, sign_in_count: 3, current_sign_in_at: '2016-07-06 16:19:00 +0800', created_at: "2016-07-05 16:19:00 +0800", weight: 100)
#     @jack = User.create(name: 'Jack', introduce: 'I am Jack.', sex: true, profession: 2, sign_in_count: 9, current_sign_in_at: '2016-06-09 16:19:00 +0800', created_at: "2016-06-08 16:19:00 +0800", weight: 83)
#     @amy = User.create(name: 'Amy', introduce: 'I am Amy.', sex: false, profession: 2, sign_in_count: 1, current_sign_in_at: '2016-07-06 12:10:00 +0800', created_at: "2016-07-05 12:10:00 +0800", weight: 122)
#     @tony = User.create(name: 'Tony', introduce: 'I am Tony.', sex: true, profession: 1, sign_in_count: 12, current_sign_in_at: '2015-09-16 13:29:00 +0800', created_at: "2015-09-15 13:29:00 +0800", weight: 170)
#     @yasmine = User.create(name: 'Yasmine', introduce: 'I am Yasmine.', sex: false, profession: 3, sign_in_count: 3, current_sign_in_at: '2016-02-16 19:13:00 +0800', created_at: "2016-02-15 19:13:00 +0800", weight: 147)
#     @alex = User.create(name: 'Alex', introduce: 'I am Alex.', sex: true, profession: 1, sign_in_count: 53, current_sign_in_at: '2016-07-07 13:09:00 +0800', created_at: "2016-07-06 13:09:00 +0800", weight: 109)
#     @james = User.create(name: 'James', introduce: 'I am James.', sex: true, profession: 3, sign_in_count: 3, current_sign_in_at: '2015-07-06 16:19:00 +0800', created_at: "2015-07-05 16:19:00 +0800", weight: 199)
#     @kevin = User.create(name: 'Kevin', introduce: 'I am Kevin.', sex: true, profession: 2, sign_in_count: 60, current_sign_in_at: '2016-07-08 23:23:00 +0800', created_at: "2016-07-07 23:23:00 +0800", weight: 108)
#     @zita = User.create(name: 'Zita', introduce: 'I am Zita.', sex: false, profession: 0, sign_in_count: 0, current_sign_in_at: '2015-01-01 12:00:00 +0800', created_at: "2014-12-31 12:00:00 +0800", weight: 139)
#     @zara = User.create(name: 'Zara', introduce: 'I am Zara.', sex: true, profession: 0, sign_in_count: 10, current_sign_in_at: '2016-04-06 04:03:00 +0800', created_at: "2016-04-05 04:03:00 +0800", weight: 230)
#   end

#   def test_cast_about_for_jsonapi_it_is_false
#     params = {
#       introduce: 'To'
#     }
#     assert_equal 2, User.cast_about_for(params, jsonapi: false).count
#   end

#   def test_cast_about_for_jsonapi_it_is_false_and_not_disploay_jsonapi_option
#     params = {
#       introduce: 'To'
#     }
#     assert_equal 2, User.cast_about_for(params).count
#   end

#   def test_cast_about_for_jsonapi_it_is_true
#     params = {
#       filter: {
#         name: 'Amy',
#         started_at: '2016-07-05 13:09:00',
#         before_at: '2016-07-09 13:09:00',
#         by_time: "current_sign_in_at"
#       }
#     }
#     assert_equal 1, User.cast_about_for(params, jsonapi: true).count
#   end

#   def test_cast_about_for_equal_search
#     params = { name: "Tom" }
#     assert_equal 1, User.cast_about_for(params).count
#   end

#   def test_cast_about_for_like_search
#     params = { introduce: "To" }
#     assert_equal 2, User.cast_about_for(params).count
#   end

#   def test_cast_about_for_before_search_with_current_sign_in_at
#     params = { before_at: "2016-07-01", by_time: "current_sign_in_at" }
#     assert_equal 6, User.cast_about_for(params).count
#   end

#   def test_cast_about_for_after_search_with_current_sign_in_at
#     params = { started_at: "2016-07-01", by_time: "current_sign_in_at" }
#     assert_equal 4, User.cast_about_for(params).count    
#   end

#   def test_cast_about_for_before_search_with_created_at
#     params = { before_at: "2015-01-01", by_time: "created_at" }
#     assert_equal 1, User.cast_about_for(params).count
#   end

#   def test_cast_about_for_after_search_with_created_at
#     params = { started_at: "2015-01-01", by_time: "created_at" }
#     assert_equal 9, User.cast_about_for(params).count    
#   end

#   def test_cast_about_for_after_search_in_default_by_time_is_created_at
#     params1 = { started_at: "2015-01-01", by_time: "" }
#     params2 = { started_at: "2015-01-01"}
#     assert_equal 9, User.cast_about_for(params1).count
#     assert_equal 9, User.cast_about_for(params2).count
#   end

#   def test_cast_about_for_enum_search
#     params = {
#       profession: "other_profession"
#     }
#     assert_equal 3, User.cast_about_for(params).count
#   end

#   def test_cast_about_for_block_search
#     params = {
#       profession: "other_profession"
#     }

#     users = User.cast_about_for params do |seach_model|
#       seach_model = seach_model.where(name: 'Zita')
#       next seach_model
#     end
#     assert_equal 1, users.count
#   end

#   def test_the_reloation_and_find_poster_which_the_comments_include_the_details_point
#     tom_post = Post.create(title: "tom post", details: "this is tom post", user: @tom)
#     tom_extra_post = Post.create(title: "tom post extra", details: "this is tom post", user: @tom)
#     jack_post = Post.create(title: "jack post", details: "this is jack post", user: @jack)
#     jack_extra_post = Post.create(title: "jack post extra", details: "this is jack post", user: @jack)
#     amy_post = Post.create(title: "amy post", details: "this is amy post", user: @amy)
#     amy_extra_post = Post.create(title: "amy post extra", details: "this is amy post", user: @amy)
#     Comment.create(details: "tom comment", user: @tom, post: jack_post)
#     Comment.create(details: "tom comment", user: @tom, post: jack_extra_post)
#     Comment.create(details: "tom comment point", user: @tom, post: amy_post)
#     Comment.create(details: "tom comment", user: @tom, post: amy_extra_post)
#     Comment.create(details: "jack comment", user: @jack, post: tom_post)
#     Comment.create(details: "jack comment", user: @jack, post: tom_extra_post)
#     Comment.create(details: "jack comment", user: @jack, post: amy_post)
#     Comment.create(details: "jack comment", user: @jack, post: amy_extra_post)
#     Comment.create(details: "amy comment point", user: @amy, post: jack_post)
#     Comment.create(details: "amy comment", user: @amy, post: jack_extra_post)
#     Comment.create(details: "amy comment", user: @amy, post: tom_post)
#     Comment.create(details: "amy comment", user: @amy, post: tom_extra_post)

#     users = User.cast_about_for({}) do |seach_model|
#       seach_model = seach_model.joins(posts: :comments).where('comments.details LIKE ?', "%point%")
#     end
#     assert_equal 2, users.count
#   end

#   def test_user_weight_range_with_comparison_key
#     params = {weight_min: 100, weight_max: 200}
#     assert_equal 8, User.cast_about_for(params).count
#   end
# end
