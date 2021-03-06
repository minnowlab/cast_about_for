require_relative 'test_helper'
require 'cast_about_for'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

ActiveRecord::Base.connection.create_table :users do |t|
  t.string :name
  t.string :introduce
  t.boolean :sex
  t.integer :profession
  t.integer :weight
  t.integer :sign_in_count, default: 0
  t.datetime :current_sign_in_at
  t.datetime :created_at
  t.integer :company_group_id
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
  t.integer :admin_id
  t.datetime :created_at
  t.datetime :updated_at
  t.datetime :published_at
end

ActiveRecord::Base.connection.create_table :company_groups do |t|
  t.string :name
  t.text :details
  t.datetime :created_at
  t.datetime :updated_at
end

class CompanyGroup < ActiveRecord::Base
  has_many :users
end

class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  belongs_to :company_group
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
    enum: ['profession'],
    comparison: [{"weight >= ?" => "weight_min"}, {"weight <= ?" => "weight_max"}],
    joins: [company_group: [like: {name: :company_group_name}]]
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
  belongs_to :admin
  has_many :comments
  cast_about_for_params(
    like: ['title', 'details'], 
    after: [{field: "created_field", time: "after_created_time"}, {field: "published_field", time: "after_published_time"}],
    before: [{field: "created_field", time: "before_created_time"}, {field: "published_field", time: "before_published_time"}],
    includes: [:user, :comments]
  )
end

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  cast_about_for_params(
    like: ['details'], 
    after: [{time: "after_time"}, {field: {exact: "updated_at"}, time: "previous"}], 
    before: [{time: "before_time"}, {field: {exact: "updated_at"}, time: "latter"}],
    # joins: [{post: ["title LIKE ?", :title]}]
    joins: [{post: [like: [{title: :title}, {details: :det}]]}, {user: [equal: :name]}, {{post: :admin} => [like: {name: :admin_name}]}]
  )
end