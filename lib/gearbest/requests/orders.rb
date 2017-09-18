module Gearbest
  module Requests
    class Orders < Gearbest::Requests::Gateway
      def completed_orders(params)
        Gearbest::Response.parse_request do
          request('completed-orders', params)
        end
      end
    end
  end
end
