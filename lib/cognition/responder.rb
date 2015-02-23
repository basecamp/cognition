require 'httparty'
module Cognition
  class Responder
    include HTTParty
    attr_reader :url

    def initialize(uri)
      @options = { timeout: 5 }
      @uri = uri
    end

    def reply(text)
      self.class.post(@uri, @options.merge(body: { content: text }))
    rescue Timeout::Error => e
      "Request to #{@uri} timed out."
    end
  end
end
