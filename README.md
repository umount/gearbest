## Information

This gems for Affiliate Gearbest Programm.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gearbest', git: 'https://github.com/umount/gearbest.git'
```

And then execute:

```shell
$ bundle
```

## Usage

Create gearbest instanse, use you API key and secret

```ruby
gearbest = Gearbest.new(api_key: 'xxxx', api_secret: 'xxxx')

# Get complited orders
response_orders = gearbest.orders.completed({
  start_date: Date.today.prev_month,
  end_date: Date.today.next_day,
  page: 1
})

# Get order by order number and created date
created_at = Date.parse('2017-09-14')
response = gearbest.orders.get_by_number({
  order_number: 'W1709140851570083',
  created_at: created_at
})

# Get list promotion products
response_list = gearbest.products.list_promotion({
  start_date: Date.today.prev_month,
  end_date: Date.today.next_day,
  currency: 'USD',
  lkid: '0',
  page: 1
})

# If you don't want get parsed response use endpoint request
http_response = gearbest.orders.api_endpoint('completed-orders').request({
  start_date: Date.today.prev_month,
  end_date: Date.today.next_day,
  page: 1
})
```
