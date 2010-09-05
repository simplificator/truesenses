module Truesenses
  class SMSGateway
    RESPONSE_FORMAT = /(\d{2}) (.*)/
    SUCCESS = 1
    HTTP_BASE = 'http://www.truesenses.com/cgi-bin/smsgateway.cgi'
    HTTPS_BASE = 'https://secure.simmcomm.ch/cgi-bin/smsgateway.cgi'
    include HTTParty

    attr_reader :config
    def initialize(config)
      @config = config
    end

    def credits_left
      raise "not yet implemented"
      post_request({'CMD' => 'CHECKCREDITS'})
    end

    def send_text_message(message, receipient)
      get_request({
        'CMD' => 'SENDMESSAGE',
        'NUMBER' => receipient,
        'MESSAGE' => message
      })
    end




    private

    def get_request(options = {})
      parse_response!(SMSGateway.get(base_url, :query => options.merge(default_options)))
    end

    def post_request(options = {})
      parse_response!(SMSGateway.post(base_url, :query => options.merge(default_options)))
    end

    def parse_response!(response)
      parsed = RESPONSE_FORMAT.match(response)
      code, message = parsed[1].to_i, parsed[2]
      if code == SUCCESS
        message
      else
        raise SMSGatewayError.new(code, message)
      end
    end


    def default_options
      default_options = {
        'ACCOUNT' => self.config.username,
        'PASSWORD' => self.config.password
      }
    end


    def base_url
      self.config.protocol == :http ? HTTP_BASE : HTTPS_BASE
    end
  end
end