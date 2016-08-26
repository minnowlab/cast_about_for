require_relative 'test_helper'
require 'cast_about_for'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

ActiveRecord::Base.connection.create_table :users do |t|
  t.string :name
  t.string :introduce
  t.boolean :sex
  t.integer :profession
  t.integer :sign_in_count, default: 0
  t.datetime :current_sign_in_at
  t.datetime :created_at
end

ActiveRecord::Base.connection.create_table :admins do |t|
  t.string :name
  t.string :introduce
  t.boolean :sex
  t.integer :profession
  t.integer :sign_in_count, default: 0
  t.datetime :current_sign_in_at
  t.datetime :created_at
end

ActiveRecord::Base.connection.create_table :comments do |t|
  t.string :details
  t.integer :user_id  
  t.integer :post_id
  t.datetime :created_at
  t.datetime :updated_at
end

ActiveRecord::Base.connection.create_table :posts do |t|
  t.string :title
  t.text :details
  t.integer :user_id
  t.datetime :created_at
  t.datetime :updated_at
  t.datetime :published_at
end

class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  enum profession: {other_profession: 0, student: 1, worker: 2, teacher: 3}
  cast_about_for_params(
    equal: ['name', 'sex'], 
    like: ['introduce'], 
    after: { 
      field: "by_time", time: "started_at"
    }, 
    before: {
      field: "by_time", time: "before_at"
    },
    enum: ['profession']
  )
end

class Admin < ActiveRecord::Base
  enum profession: {other_profession: 0, student: 1, worker: 2, teacher: 3}
  cast_about_for_params(
    equal: [{ name: 'nick_name' }, { sex: 'se'}], 
    like: [{introduce: 'info'}], 
    after: { 
      field: "by_time", time: "started_at"
    }, 
    before: {
      field: "by_time", time: "before_at"
    },
    enum: [{profession: 'pro'}]
  )
end

class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  cast_about_for_params(
    like: ['title', 'details'], 
    after: { 
      field: "by_time", time: "created_at"
    }, 
    before: {
      field: "by_time", time: "created_at"
    }
  )
end

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  cast_about_for_params(
    like: ['details'], 
    after: {time: "after_time"}, 
    before: {time: "before_time"}
  )
end











