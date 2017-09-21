module Gearbest
  module Requests
    class Class
      def initialize(params={})
        configure(params)
      end

      def configure(config=false)
        @config = config || @config
      end

      def method_missing(method_name, *args, &block)
        class_path = method_name.capitalize
        class_name = "Gearbest::Requests::#{class_path}"

        if Object.const_defined?(class_name)
          _instanse = Object.const_get(class_name).new
          _instanse.config = @config
          _instanse
        else
          super
        end
      end
    end

    module InstanceModule
      mattr_accessor :config

      def response(params)
        Gearbest::Response.parse_request do
          request(params)
        end
      end

      def request(params)
        _params = {
          api_key: config[:api_key], time: DateTime.now().to_time.to_i
        }
        params = _params.merge(params)
        params.merge!(add_signature(params))

        RestClient.get(@api_url, { params: params })
      end

      def api_endpoint(path)
        url_path = self.class.name.split('::').last.downcase

        @api_url = "#{config[:api_url]}/#{url_path}/#{path}"

        self
      end

      # strtoupper(md5(appSecretbar2baz3foo1appSecret));
      def add_signature(params)
        sign_string = params.sort.map(&:join).join

        sign = Digest::MD5.hexdigest(
          config[:api_secret] + sign_string + config[:api_secret]
        ).upcase

        params.merge({sign: sign})
      end
    end
  end
end
