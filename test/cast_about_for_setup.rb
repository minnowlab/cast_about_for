
ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

ActiveRecord::Base.connection.create_table :users do |t|
  t.string :name
  t.string :introduce
  t.boolean :sex
  t.integer :profession
  t.integer :sign_in_count, default: 0
  t.datetime :current_sign_in_at
end

ActiveRecord::Base.connection.create_table :admins do |t|
  t.string :name
  t.string :introduce
  t.boolean :sex
  t.integer :profession
  t.integer :sign_in_count, default: 0
  t.datetime :current_sign_in_at

end