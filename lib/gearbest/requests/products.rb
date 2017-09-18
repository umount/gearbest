module Gearbest
  module Requests
    class Products < Gearbest::Requests::Gateway
      def list_promotion_products(params)
        Gearbest::Response.parse_request do
          request('list-promotion-products', params)
        end
      end
    end
  end
end
