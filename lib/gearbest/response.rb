module Gearbest
  module Response
    module ClassMethods
      def parse_request(&request)
        begin
          response = request.call
        rescue => error
          Gearbest::Errors::Internal.new(error)
        end

        if response.is_a?(RestClient::Response)
          if response.code == 200
            fetch_data(response)
          else
            raise Gearbest::Errors::ExternalServiceUnavailable.new(
              "#{response.code} / #{response.body}"
            )
          end
        else
          raise Gearbest::Errors::ExternalServiceUnavailable.new(
            "WTF? #{response.inspect}"
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
          error_message = "#{_response['error_no']} / #{_response['msg']}"

          case _response['error_no']
          when 1003
            raise Gearbest::Errors::TooManyRequests.new(error_message)
          else
            raise Gearbest::Errors::BadRequest.new(error_message)
          end
        end
      end
    end

    extend ClassMethods
  end
end
