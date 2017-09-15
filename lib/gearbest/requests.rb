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
          _instanse = Object.const_get(class_name)
          _instanse.new(@config)
        else
          super
        end
      end
    end

    class Gateway
      def initialize(params={})
        configure(params)
      end

      def configure(config=false)
        @config = config || @config
      end

      def request(method_name, params)
        _params = {
          api_key: @config[:api_key], time: DateTime.now().to_time.to_i
        }
        params = _params.merge(params)
        params.merge!(add_signature(params))

        RestClient.get(api_endpoint(method_name), { params: params })
      end

      def api_endpoint(method_name)
        url_path = self.class.name.split('::').last.downcase

        "#{@config[:api_url]}/#{url_path}/#{method_name}"
      end

      # strtoupper(md5(appSecretbar2baz3foo1appSecret));
      def add_signature(params)
        sign_string = params.sort.map(&:join).join

        sign = Digest::MD5.hexdigest(
          @config[:api_secret] + sign_string + @config[:api_secret]
        ).upcase

        params.merge({sign: sign})
      end
    end
  end
end
