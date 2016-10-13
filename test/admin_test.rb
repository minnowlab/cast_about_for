# require_relative 'cast_about_for_setup'

# test_framework = defined?(MiniTest::Test) ? MiniTest::Test : MiniTest::Unit::TestCase

# class CastAboutForExtendTest < test_framework
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

#     @tom = Admin.create(name: 'Tom', introduce: 'I am Tom.', sex: true, profession: 0, sign_in_count: 3, current_sign_in_at: '2016-07-06 16:19:00 +0800')
#     @jack = Admin.create(name: 'Jack', introduce: 'I am Jack.', sex: true, profession: 2, sign_in_count: 9, current_sign_in_at: '2016-06-09 16:19:00 +0800')
#     @amy = Admin.create(name: 'Amy', introduce: 'I am Amy.', sex: false, profession: 2, sign_in_count: 1, current_sign_in_at: '2016-07-06 12:10:00 +0800')
#     @tony = Admin.create(name: 'Tony', introduce: 'I am Tony.', sex: true, profession: 1, sign_in_count: 12, current_sign_in_at: '2015-09-16 13:29:00 +0800')
#     @yasmine = Admin.create(name: 'Yasmine', introduce: 'I am Yasmine.', sex: false, profession: 3, sign_in_count: 3, current_sign_in_at: '2016-02-16 19:13:00 +0800')
#     @alex = Admin.create(name: 'Alex', introduce: 'I am Alex.', sex: true, profession: 1, sign_in_count: 53, current_sign_in_at: '2016-07-07 13:09:00 +0800')
#     @james = Admin.create(name: 'James', introduce: 'I am James.', sex: true, profession: 3, sign_in_count: 3, current_sign_in_at: '2015-07-06 16:19:00 +0800')
#     @kevin = Admin.create(name: 'Kevin', introduce: 'I am Kevin.', sex: true, profession: 2, sign_in_count: 60, current_sign_in_at: '2016-07-08 23:23:00 +0800')
#     @zita = Admin.create(name: 'Zita', introduce: 'I am Zita.', sex: false, profession: 0, sign_in_count: 0, current_sign_in_at: '2015-01-01 12:00:00 +0800')
#     @zara = Admin.create(name: 'Zara', introduce: 'I am Zara.', sex: true, profession: 0, sign_in_count: 10, current_sign_in_at: '2016-04-06 04:03:00 +0800')
#   end

#   def test_cast_about_for_jsonapi_it_is_false
#     params = {
#       info: 'To'
#     }
#     assert_equal 2, Admin.cast_about_for(params, jsonapi: false).count
#   end

#   def test_cast_about_for_jsonapi_it_is_false_and_not_disploay_jsonapi_option
#     params = {
#       info: 'To'
#     }
#     assert_equal 2, Admin.cast_about_for(params).count
#   end

#   def test_cast_about_for_jsonapi_it_is_true
#     params = {
#       filter: {
#         nick_name: 'Amy',
#         started_at: '2016-07-05 13:09:00',
#         before_at: '2016-07-09 13:09:00',
#         by_time: "current_sign_in_at"
#       }
#     }
#     assert_equal 1, Admin.cast_about_for(params, jsonapi: true).count
#   end

#   def test_cast_about_for_equal_search
#     params = { nick_name: "Tom" }
#     assert_equal 1, Admin.cast_about_for(params).count
#   end

#   def test_cast_about_for_like_search
#     params = { info: "To" }
#     assert_equal 2, Admin.cast_about_for(params).count
#   end

#   def test_cast_about_for_enum_search
#     params = {
#       pro: "other_profession"
#     }
#     assert_equal 3, Admin.cast_about_for(params).count
#   end

#   def test_cast_about_for_block_search
#     params = {
#       pro: "other_profession"
#     }

#     admins = Admin.cast_about_for params do |seach_model|
#       seach_model = seach_model.where(name: 'Zita')
#       next seach_model
#     end
#     assert_equal 1, admins.count
#   end
# end
