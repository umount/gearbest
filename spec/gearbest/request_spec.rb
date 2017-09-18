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
    response = gearbest.orders.completed_orders({
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

  it 'list-promotion-products requests' do
    response = gearbest.products.list_promotion_products({
      start_date: Date.today.prev_month,
      end_date: Date.today.next_day,
      currency: 'USD',
      lkid: Settings.gearbest.lkid,
      page: 1
    })

    expect(response['total_results']).to be > 0
  end
end
