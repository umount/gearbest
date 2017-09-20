module Gearbest
  module Requests
    class Orders < Gearbest::Requests::Gateway
      def completed(params)
        Gearbest::Response.parse_request do
          request('completed-orders', params)
        end
      end

      def get_by_number(params)
        if !params.is_a?(Hash) || !params.key?(:order_number)
          raise Gearbest::Errors::BadRequest.new(
            "1002 / Invalid Arguments: id invalid"
          )
        end

        if params.key?(:created_at)
          created_at = params[:created_at].is_a?(Date) ?
            params[:created_at] : Date.parse(params[:created_at])
        else
          created_at = Date.today
        end

        page = 1
        begin
          response = completed({
            start_date: created_at, end_date: created_at, page: page
          })
          order = response['items'].find {|item|
            item['order_number'] == params[:order_number]
          }
          total_pages = response['total_pages']; page += 1
        end until (page > total_pages) || order

        raise Gearbest::Errors::NotFound.new(
          "Items #{params[:order_number]} created_at #{created_at} not found"
        ) if !order

        order
      end
    end
  end
end
