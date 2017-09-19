require 'spec_helper'

describe 'Gearbest API' do
  let(:gearbest) {
    Gearbest.new(
      api_key: Settings.gearbest.api_key,
      api_secret: Settings.gearbest.api_secret
    )
  }

  it 'initial configuration' do
    expect(gearbest.configure).to include(:api_key, :api_secret)

    expect(gearbest.configure[:api_key]).to eq(Settings.gearbest.api_key)
    expect(gearbest.configure[:api_secret]).to eq(
      Settings.gearbest.api_secret
    )
  end

  it 'autoload requests class' do
    expect(gearbest.orders.configure).to include(:api_key, :api_secret)
    expect(gearbest.products.configure).to include(:api_key, :api_secret)
  end

  it 'completed-orders requests' do
    response = gearbest.orders.completed({
      start_date: Date.today.prev_month,
      end_date: Date.today.next_day,
      page: 1
    })

    expect(response['total_results']).to be > 0
  end

  it 'completed-orders bad requests' do
    expect {
      gearbest.orders.completed_orders({
        start_date: Date.today.prev_month,
        end_date: Date.today.next_day,
        page: -1
      })
    }.to raise_error(Gearbest::Errors::BadRequest)
  end

  it 'get order by number' do
    created_at = Date.parse('2017-09-14')
    response = gearbest.orders.get_by_order({
      order_number: 'W1709140851570083',
      created_at: created_at
    })

    expect(response).to eq(1)
  end

  it 'get order not found by number and wrong' do
    expect {
      response = gearbest.orders.get_by_order({
        order_number: 'W1709140851570083'
      })
    }.to raise_error(Gearbest::Errors::NotFound)
  end

  it 'list-promotion-products requests' do
    response = gearbest.products.list_promotion({
      start_date: Date.today.prev_month,
      end_date: Date.today.next_day,
      currency: 'USD',
      lkid: Settings.gearbest.lkid,
      page: 1
    })

    expect(response['total_results']).to be > 0
  end
end
