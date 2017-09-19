module Gearbest
  module Requests
    class Products < Gearbest::Requests::Gateway
      def list_promotion(params)
        Gearbest::Response.parse_request do
          request('list-promotion-products', params)
        end
      end
    end
  end
end
