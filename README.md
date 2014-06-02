# ActsAsDaterange

This is home to the acts_as_daterange GEM.

It's useful for all models that have (optional) start date and end date (e.g. coupons, campaigns, orders, events, etc.)

Just add 'acts_as_daterange' to your ActiveRecord models and get useful validations, methods and scopes.

## Installation

Add this line to your application's Gemfile:

    gem 'acts_as_daterange'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_daterange

## Usage

Given an AR model, for example Coupon, with start_date and end_date fields:
```ruby
class Coupon < ActiveRecord::Base
  attr_accessible :start_date, :end_date
  acts_as_daterange
end

> @coupon = Coupon.create start_date: 3.hours.ago, end_date: 3.hours.from_now
```

methods:
```ruby
> @coupon.active_now?
> @coupon.started?
> @coupon.ended?
```

scopes:
```ruby
> Coupon.active_now
> Coupon.inactive_now
> Coupon.active_at Date.today
> Coupon.inactive_at 5.hours.ago
```

validations:
```ruby
> @coupon = Coupon.create start_date: 3.hours.from_now, end_date: 3.hours.ago
> @coupon.errors[:end_date]
=> must be after start_date
```

Notice that:
- start_date=nil means started? == true always
- and end_date=nil means that ended? == false always

```ruby
> Coupon.new.started?
=> true
> Coupon.new.ended?
=> false
```

You can also override the field names:
```ruby
acts_as_daterange :started_at, :ended_at
#  or
acts_as_daterange start_date: :started_at, end_date: :ended_at
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
