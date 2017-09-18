require 'rest-client'
require 'json'

require 'gearbest/version'
require 'gearbest/errors'
require 'gearbest/response'
require 'gearbest/requests'

Dir[
    File.expand_path('../gearbest/requests/*.rb', __FILE__)
].each { |f|
  require f
}

module Gearbest
  module ClassMethods
    def new(config)
      configure(config)

      Gearbest::Requests::Class.new(@config)
    end

    def configure(config={})
      @config = {
        api_url: 'https://affiliate.gearbest.com/api',
        api_key: false,
        api_secret: false
      }.merge!(config)
    end
  end

  extend ClassMethods
end
