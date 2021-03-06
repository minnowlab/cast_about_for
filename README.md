# CastAboutFor

CastAboutFor allows you easily and reliably query ActiveRecord.

## Installation

Install this gem by adding this to your Gemfile:

```ruby
gem 'cast_about_for'
```

Then run:

``` shell
bundle install
```

Updating is as simple as `bundle update cast_about_for`.

## Usage

### Setting the Query Column

First, you must set some query colums in your model using the `cast_about_for_params` macro:

``` ruby
class Product < ActiveRecord::Base
  cast_about_for_params equal: ['name', 'sex']

  # ...
end
```

### Start the Query:

You can always use the `#cast_about_for` class method to query: 

``` ruby
def index
  @products = Product.cast_about_for(params)
end
```

Want to count records? Simple:

```ruby
  Product.cast_about_for(params).count
```

## cast_about_for_params Configure

### Equal

If you want to use a column query the SQL look like `SELECT "products".* FROM "products" WHERE (name = 'iPhone')`, you can pass it as an option:

``` ruby
# params = {name: 'iPhone'}
# Product.cast_about_for(params)

class Product < ActiveRecord::Base
  cast_about_for_params equal: ['name']

  # ...
end
```
Or you want to alias of the `name` argument in `params`

``` ruby
# params = { nick_name: "iPhone"}
# Product.cast_about_for(params)

class Product < ActiveRecord::Base
  cast_about_for_params equal: [{name: "nick_name"}]

  # ...
end
```

And you have other alias arguments , you can do it like below.

``` ruby
# params = { nick_name: "iPhone", info: "sales", price: "600"}
# Product.cast_about_for(params)

class Product < ActiveRecord::Base
  cast_about_for_params equal: [{name: "nick_name"}, {information: "info"}, price]

  # ...
end
```


### Like

If you want to use a column query the SQL look like `SELECT "products".* FROM "products" WHERE (introduce LIKE '%To%')`, you can pass it as an option:

``` ruby
# params = {introduce: 'To'}
# Product.cast_about_for(params)

class Product < ActiveRecord::Base
  cast_about_for_params like: ['introduce']

  # ...
end
```

Suck as `Equal`. If you want alias of `introduce` argument, you can

``` ruby
class Product < ActiveRecord::Base
  cast_about_for_params like: [{introduce: 'intr'}]

  # ...
end
```
### After

If you want to use a column query the SQL look like `SELECT "products".* FROM "products" WHERE (production_date >= '2016-07-05 13:09:00')`, you can pass it as an option:

``` ruby
# params = {production_started_at: '2016-07-05 13:09:00', by_time: 'production_date'}
# Product.cast_about_for(params)

class Product < ActiveRecord::Base
  cast_about_for_params after: { field: 'by_time', time: "production_started_at" }

  # ...
end
```
In addition, if your `params` not include `by_time` option. Like `params = {production_started_at: '2016-07-05 13:09:00'}`, the query column will be set the default column `created_at`.

If you want to use multiple column query the SQL look like `SELECT "products".* FROM "products" WHERE (production_date >= '2016-07-05 13:09:00') AND (created_at >= '2016-07-04')`, you can do it like this:

``` ruby
# params = {production_started_at: '2016-07-05 13:09:00', by_time: 'production_date', create_field: 'created_at', production_created_at: '2016-07-04'}
# Product.cast_about_for(params)

class Product < ActiveRecord::Base
  cast_about_for_params after: [{field: 'by_time', time: "production_started_at"}, { field: 'create_field', time: "production_created_at"}]

  # ...
end
```
If you want more columns to query, you can code it like this pattern: `cast_about_for_params after: [{field: 'by_time', time: "production_started_at"}, { field: 'create_field', time: "production_created_at"}, {field: '..', time: '..'}, {...}, ...]`

If you want to set the field exact column you can do it like this:

``` ruby
# params = {production_started_at: '2016-07-05 13:09:00'}
# Product.cast_about_for(params) # The SQL: `SELECT "products".* FROM "products" WHERE (production_date >= '2016-07-05 13:09:00')`

class Product < ActiveRecord::Base
  cast_about_for_params after: [{field: {exact: "production_date"}, time: "production_started_at"}]

  # ...
end
```


### Before

Just like the above `After`.
If you want to use a column query the SQL look like `SELECT "products".* FROM "products" WHERE (production_date <= '2016-07-05 13:09:00')`, you can pass it as an option:

``` ruby
# params = {production_ended_at: '2016-07-05 13:09:00', by_time: 'production_date'}
# Product.cast_about_for(params)

class Product < ActiveRecord::Base
  cast_about_for_params before: {field: 'by_time', time: 'production_ended_at'}

  # ...
end
```
In addition, if your `params` not include `by_time` option. Like `params = {production_ended_at: '2016-07-05 13:09:00'}`, the query column will be set the default column `created_at`.

If you want to use multiple column query the SQL look like `SELECT "products".* FROM "products" WHERE (production_date <= '2016-07-05 13:09:00') AND (created_at <= '2016-07-04')`, you can do it like this:

``` ruby
# params = {production_ended_at: '2016-07-05 13:09:00', by_time: 'production_date', create_field: 'created_at', production_created_at: '2016-07-04'}
# Product.cast_about_for(params)

class Product < ActiveRecord::Base
  cast_about_for_params after: [{field: 'by_time', time: "production_ended_at"}, { field: 'create_field', time: "production_created_at"}]

  # ...
end
```
If you want more columns to query, you can code it like this pattern: `cast_about_for_params after: [{field: 'by_time', time: "production_ended_at"}, { field: 'create_field', time: "production_created_at"}, {field: '..', time: '..'}, {...}, ...]`

If you want to set the field exact column you can do it like this:

``` ruby
# params = {production_ended_at: '2016-07-05 13:09:00'}
# Product.cast_about_for(params) # The SQL: `SELECT "products".* FROM "products" WHERE (production_date <= '2016-07-05 13:09:00')`

class Product < ActiveRecord::Base
  cast_about_for_params after: [{field: {exact: "production_date"}, time: "production_ended_at"}]

  # ...
end
```

### Enum

If you have a column use enum, you can pass it as an option:

``` ruby
# params = {category: "food"}
# Product.cast_about_for(params)

class Product < ActiveRecord::Base
  enum category: {food: 0}
  cast_about_for_params enum: ['category']

  # ...
end
```

Suck as `Equal`. If you want alias of `category` argument, you can

``` ruby
# params = {other_name: "food"}
# Product.cast_about_for(params)

class Product < ActiveRecord::Base
  cast_about_for_params enum: [{category: 'other_name'}]

  # ...
end
```

### Comparison
If you want to compare a column, the sql like this: The SQL: `SELECT "products".* FROM "products" WHERE (weight >= '100' AND weight <= '1000')`
you can do it like this:
```ruby
# params = {weight_min: 100, weight_max: 1000}
# Product.cast_about_for(params)

class Product < ActiveRecord::Base
  cast_about_for_params comparison: [{"weight >= ?" => "weight_min"}, {"weight <= ?" => "weight_max"}]

end
```

###Includes
If you want to `includes` other models, you can do it like this
```ruby
class Product < ActiveRecord::Base
  cast_about_for_params includes: [:user, :items]

#This will make `product` include `user` and `items` automatically
#Like:  Product.includes(:user, :items)
end

```
###Joins

If you want to join a model you can do it like this:

```ruby
Example 1 

class Product <  ActiveRecord::Base
  cast_about_for_params joins: [{user: [equal: :name]}]
  
end

# params = {name: "user"}
# Product.cast_about_for(params)
# It will be generates like this: Product.joins(:user).where("users.name = ?", "user")
# The sql would like this: `SELECT "products".* FROM "products" INNER JOIN "users" ON "users"."id" = "products"."user_id" WHERE (users.name = 'user')`

If you want to query the condition of "LIKE", do it like this

class Product <  ActiveRecord::Base
  cast_about_for_params joins: [{user: [like: :name]}]
  
end
Then the sql would be like this:  `SELECT "products".* FROM "products" INNER JOIN "users" ON "users"."id" = "products"."user_id" WHERE (users.name Like 'user')`


--------
Example 2
If you want to nickname the `name` of the params like: 
# params = {user_name: "user"}
# Product.cast_about_for(params)

class Product <  ActiveRecord::Base
  cast_about_for_params joins: [{user: [equal: {name: :user_name}]}]
  
end

# Also will generates like this: Product.joins(:user).where("users.name = ?", "user") 
# The sql would like this: `SELECT "products".* FROM "products" INNER JOIN "users" ON "users"."id" = "products"."user_id" WHERE (users.name = 'user')`

--------
Example 3
If multiple user columns that you want to query, you can do it like this:
# params = {name: "user", age: 18}
# Product.cast_about_for(params)

class Product <  ActiveRecord::Base
  cast_about_for_params joins: [{user: [equal: [:name, :age]}]
  
end
# Also will generates like this: Product.joins(:user).where("users.name = ? AND users.age = ?", "user", "18") 
# The sql would like this: `SELECT "products".* FROM "products" INNER JOIN "users" ON "users"."id" = "products"."user_id" WHERE (users.name = 'user' AND users.age = 18)`


If you want to nickname the params:
# params = {user_name: "user", user_age: 18}
# Product.cast_about_for(params)
class Product <  ActiveRecord::Base
  cast_about_for_params joins: [{user: [equal: [{name: :user_name}, {age: :user_age}]}]
  
end

--------
Example 4
You can use the `equal` and `like` at the same time:
class Product <  ActiveRecord::Base
  cast_about_for_params joins: [{user: [equal: :age], [like: :name]}]
  
end

`OR`
class Product <  ActiveRecord::Base
  cast_about_for_params joins: [{user: [equal: [:age, :height]], [like: [:name, :roles]]}]
  
end

--------
Example 5
Nested joins:

Now, I have `product` `user` `company` models, 

class Product <  ActiveRecord::Base
  belongs_to :user
end

class User <  ActiveRecord::Base
  belongs_to :company
  has_many :products
end

class Company <  ActiveRecord::Base
  has_many :user
end

I have company `name`, and now I want to query the products through the user who belong to the company, so I can do it like this:

class Product <  ActiveRecord::Base
  cast_about_for_params joins: [{{user: :company} => [like: {name: :company_name}]}]
  
end
# params = {company_name: "Teo"}
# Product.cast_about_for(params)
# The sql would like this:  SELECT "products".* FROM "products" INNER JOIN "users" ON "users"."id" = "products"."user_id" INNER JOIN "companies" ON "companies"."id" = "users"."company_id" WHERE (companies.name LIKE 'Teo')

```


## Advanced Usage

### JSON API

If you are using `JSON API`, you can set in the `#cast_about_for`: 

```ruby
  Product.cast_about_for(params, jsonapi: true) # JSON API
```

### Custom Query by Block
If want to find products where belong to some people, you can do it like:

```ruby
  params = { user_name: 'hello', age: 20 }

  Product.cast_about_for(params, jsonapi: true) do |products, cast_params|
    products = products.joins(:user).where("users.name Like ?", "%#{cast_params[:user_name]}%") if cast_params[:user_name].present?
    products = products.joins(:user).where("users.age = ?", cast_params[:age]) if cast_params[:age].present?
  end
```

## Collaborators

Thank you to the following people:

* The creators of the [by_star](https://github.com/radar/by_star) gem


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

