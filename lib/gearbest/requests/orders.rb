module Gearbest
  module Requests
    class Orders < Gearbest::Requests::Gateway
      def completed_orders(params)
        request('completed-orders', params)
      end

      def get_orders(params)
        request('get-orders', params)
      end
    end
  end
end
