require "utf8/validator/version"

module Utf8
  class Validator
    def initialize(app, options={})
      @app = app
    end

    def call(env)
      if valid_utf8?(env["PATH_INFO"])
        app.call(env)
      else
        return [400, {}, []]
      end
    end

    private

    def valid_utf8?(path)
      path.encode('UTF-8', 'ASCII-8BIT')
      true
    rescue Encoding::UndefinedConversionError
      false
    end

    attr_accessor :app
  end
end
