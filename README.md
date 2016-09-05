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

### Setting the Query Colum

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
## Advanced Usage

### JSON API

If you are using `JSON API`, you can set in the `#cast_about_for`: 

```ruby
  Product.cast_about_for(params, jsonapi: true) # JSON API
```

### Custom Query by Block

```ruby
  Product.cast_about_for(params, jsonapi: true) do |product|
    product.where(name: 'hello')
    next product
  end
```

## Collaborators

Thank you to the following people:

* The creators of the [by_star](https://github.com/radar/by_star) gem


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

