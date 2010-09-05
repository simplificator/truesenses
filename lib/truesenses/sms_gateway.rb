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

    def send_text_message(message, receipient)
      response = SMSGateway.get(base_url, :query => {
        'CMD' => 'SENDMESSAGE',
        'ACCOUNT' => self.config.username,
        'PASSWORD' => self.config.password,
        'NUMBER' => receipient,
        'MESSAGE' => message
      })
      parsed = RESPONSE_FORMAT.match(response)
      code, message = parsed[1].to_i, parsed[2]
      if code == SUCCESS
        message
      else
        raise SMSGatewayError.new(code, message)
      end
    end


    private

    def base_url
      self.config.protocol == :http ? HTTP_BASE : HTTPS_BASE
    end
  end
end