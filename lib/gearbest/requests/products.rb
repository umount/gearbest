module Gearbest
  module Requests
    class Products
      include Gearbest::Requests::InstanceModule

      def list_promotion(params)
        api_endpoint 'list-promotion-products'

        response(params)
      end
    end
  end
end
