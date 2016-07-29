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
  @products = Product.cast_about_for(params, jsonapi: true)
end
```

Want to count records? Simple:

```ruby
  Product.cast_about_for(params, jsonapi: true).count
```

## cast_about_for_params Configure

### Equal

If you want to use a column query the SQL look like `SELECT "products".* FROM "products" WHERE (name = 'iPhone')`, you can pass it as an option:

``` ruby
# params = {name: 'iPhone'}
# User.cast_about_for(params, jsonapi: false)

class Product < ActiveRecord::Base
  cast_about_for_params equal: ['name']

  # ...
end
```

### Like

If you want to use a column query the SQL look like `SELECT "products".* FROM "products" WHERE (introduce LIKE '%To%')`, you can pass it as an option:

``` ruby
# params = {introduce: 'To'}
# User.cast_about_for(params, jsonapi: false)

class Product < ActiveRecord::Base
  cast_about_for_params like: ['introduce']

  # ...
end
```

### After

If you want to use a column query the SQL look like `SELECT "products".* FROM "products" WHERE (production_date >= '2016-07-05 13:09:00')`, you can pass it as an option:

``` ruby
# params = {started_at: '2016-07-05 13:09:00'}
# User.cast_about_for(params, jsonapi: false)

class Product < ActiveRecord::Base
  cast_about_for_params after: { production_date: "started_at" }

  # ...
end
```

### Before

If you want to use a column query the SQL look like `SELECT "products".* FROM "products" WHERE (production_date <= '2016-07-05 13:09:00')`, you can pass it as an option:

``` ruby
# params = {before_at: '2016-07-05 13:09:00'}
# User.cast_about_for(params, jsonapi: false)

class Product < ActiveRecord::Base
  cast_about_for_params before: { production_date: "before_at" }

  # ...
end
```

### Enum

If you have a column use enum, you can pass it as an option:

``` ruby
# params = {category: "food"}
# User.cast_about_for(params, jsonapi: false)

class Product < ActiveRecord::Base
  enum category: {food: 0}
  cast_about_for_params enum: ['category']

  # ...
end
```

## Advanced Usage

### JSON API

If you are using `JSON API`, you can set in the `#cast_about_for`: 

```ruby
  Product.cast_about_for(params, jsonapi: true) # JSON API
  Product.cast_about_for(params, jsonapi: false) # or not
```

### Custom Query by Block

```ruby
  Product.cast_about_for(params, jsonapi: true) do |product|
    product.where(name: 'hello')
    next product
  end
```

## Collaborators

ByStar is actively maintained by Ryan Biggs (radar) and Johnny Shields (johnnyshields)

Thank you to the following people:

* The creators of the [by_star](https://github.com/radar/by_star) gem


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

