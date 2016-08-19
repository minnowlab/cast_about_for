def connect!
  ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
end

def setup!
  connect!
  {
    'users' => 'name VARCHAR(32), introduce VARCHAR(32), sex BOOLEAN, profession INTEGER, sign_in_count INTEGER DEFAULT 0, current_sign_in_at DATETIME',
    'admins' => 'name VARCHAR(32), introduce VARCHAR(32), sex BOOLEAN, profession INTEGER, sign_in_count INTEGER DEFAULT 0, current_sign_in_at DATETIME'
  }.each do |table_name, columns_as_sql_string|
    ActiveRecord::Base.connection.execute "CREATE TABLE #{table_name} (id INTEGER NOT NULL PRIMARY KEY, #{columns_as_sql_string})"
  end
end

setup!