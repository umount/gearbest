module Gearbest
  module Response
    module ClassMethods
      def parse_request(&request)
        begin
          response = request.call
        rescue => error
          Gearbest::Errors::Internal.new(error)
        end

        if response.code == 200
          fetch_data(response)
        else
          raise Gearbest::Errors::ExternalServiceUnavailable.new(
            "#{response.code} / #{response.body}"
          )
        end
      end

      def fetch_data(response)
        _response = JSON.parse(response.body)

        if _response['error_no'].to_i == 0
          _response['data'].any? ? _response['data'] : JSON.parse({
            total_results: 0, total_pages: 0, items: []
          }.to_json)
        else
          raise Gearbest::Errors::BadRequest.new(
            "#{_response['error_no']} / #{_response['msg']}"
          )
        end
      end
    end

    extend ClassMethods
  end
end
